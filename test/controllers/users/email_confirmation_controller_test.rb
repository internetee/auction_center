# frozen_string_literal: true

require 'test_helper'

module Users
  class EmailConfirmationControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    include ActiveJob::TestHelper

    def setup
      @tara_user = users(:participant)
      @tara_user.update!(
        provider: User::TARA_PROVIDER,
        uid: 'EE12345678901',
        confirmed_at: nil,
        confirmation_sent_at: nil,
        email: 'tara_user@example.com',
        roles: ['participant']
      )
      sign_in @tara_user
      ActionMailer::Base.deliveries.clear
    end

    test 'should send confirmation email on first request' do
      perform_enqueued_jobs do
        post email_confirmation_users_path
      end

      assert_redirected_to user_path(@tara_user.uuid)

      @tara_user.reload
      assert_not_nil @tara_user.confirmation_sent_at
      assert_not_nil @tara_user.confirmation_token
    end

    test 'should block rapid resend attempts within 2 minutes' do
      perform_enqueued_jobs do
        post email_confirmation_users_path
      end

      first_sent_at = @tara_user.reload.confirmation_sent_at
      assert_not_nil first_sent_at

      post email_confirmation_users_path

      assert_redirected_to user_path(@tara_user.uuid)

      @tara_user.reload
      assert_equal first_sent_at.to_i, @tara_user.confirmation_sent_at.to_i
    end

    test 'should allow resend after cooldown period expires' do
      # Set confirmation_sent_at to 3 minutes ago (past the 2-minute limit)
      @tara_user.update_column(:confirmation_sent_at, 3.minutes.ago)

      perform_enqueued_jobs do
        post email_confirmation_users_path
      end

      assert_redirected_to user_path(@tara_user.uuid)

      @tara_user.reload
      assert @tara_user.confirmation_sent_at > 2.minutes.ago
    end

    test 'should show rate limit message with wait time' do
      post email_confirmation_users_path

      post email_confirmation_users_path

      assert_redirected_to user_path(@tara_user.uuid)
      assert_includes flash[:alert], I18n.t('datetime.prompts.minute', count: 2)
    end

    test 'should update confirmation_sent_at timestamp on successful send' do
      freeze_time = Time.current

      travel_to freeze_time do
        post email_confirmation_users_path

        @tara_user.reload
        assert_in_delta freeze_time.to_i, @tara_user.confirmation_sent_at.to_i, 2
      end
    end

    test 'should not send email when rate limited' do
      perform_enqueued_jobs do
        post email_confirmation_users_path
      end
      initial_sent_at = @tara_user.reload.confirmation_sent_at

      post email_confirmation_users_path

      @tara_user.reload
      assert_equal initial_sent_at.to_i, @tara_user.confirmation_sent_at.to_i
    end

    test 'should calculate correct wait time for rate limit message' do
      freeze_time = Time.current

      travel_to freeze_time do
        post email_confirmation_users_path
      end

      travel_to freeze_time + 1.minute do
        post email_confirmation_users_path

        assert_match(/1.*minute/i, flash[:alert])
      end
    end

    test 'should require authentication to send confirmation email' do
      sign_out @tara_user

      post email_confirmation_users_path

      assert_redirected_to new_user_session_path
    end

    test 'should work for regular users who update their email' do
      regular_user = users(:second_place_participant)
      regular_user.update!(
        provider: nil,
        mobile_phone: '+37255000003',
        confirmation_sent_at: nil
      )
      sign_out @tara_user
      sign_in regular_user

      perform_enqueued_jobs do
        post email_confirmation_users_path
      end

      assert_redirected_to user_path(regular_user.uuid)

      regular_user.reload
      assert_not_nil regular_user.confirmation_sent_at
    end
  end
end
