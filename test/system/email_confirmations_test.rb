require 'application_system_test_case'

class EmailConfirmationsTest < ApplicationSystemTestCase
  def setup
    super

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator").
      to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})

    @original_wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 10
  end

  def teardown
    super

    Capybara.default_max_wait_time = @original_wait_time
  end

  def test_you_are_redirected_to_user_profile_after_confirmation
    visit new_user_path

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[mobile_phone]', with: '+48600100200')
    # select_from_dropdown('Poland', from: 'user[country_code]')
    select 'Poland', from: 'user[country_code]'

    check_checkbox('user[accepts_terms_and_conditions]')

    fill_in('user[surname]', with: 'Last Name')
    click_link_or_button('Sign up')

    assert(page.has_css?('div.alert', text: 'You need to confirm your email address to activate the account. We sent you an email with the activation link!'))
    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['new-user@auction.test'], last_email.to)

    url = last_email.body.match(%r{sessions/confirmation\?confirmation_token=[A-z0-9\-]+})

    visit(url)

    assert(page.has_css?('div.notice', text: 'Your email address has been successfully confirmed.'))
    assert_current_path(%r{users/[A-z0-9-]+})
  end

  def test_you_need_to_confirm_email_within_three_days
    visit new_user_path

    fill_in('user[email]', with: 'new-user@auction.test')
    fill_in('user[password]', with: 'password')
    fill_in('user[password_confirmation]', with: 'password')
    fill_in('user[given_names]', with: 'User with Multiple Names')
    fill_in('user[mobile_phone]', with: '+48600100200')
    # select_from_dropdown('Poland', from: 'user[country_code]')
    select 'Poland', from: 'user[country_code]'
    check_checkbox('user[accepts_terms_and_conditions]')

    fill_in('user[surname]', with: 'Last Name')
    click_link_or_button('Sign up')

    assert(page.has_css?('div.alert', text: 'You need to confirm your email address to activate the account. We sent you an email with the activation link!'))
    last_email = ActionMailer::Base.deliveries.last
    assert_equal('Confirmation instructions', last_email.subject)
    assert_equal(['new-user@auction.test'], last_email.to)

    user = User.find_by(email: 'new-user@auction.test')
    user.update!(confirmation_sent_at: Date.today - 10.days)

    url = last_email.body.match(%r{sessions/confirmation\?confirmation_token=[A-z0-9\-]+})
    visit(url)

    assert(page.has_text?('Email needs to be confirmed within 3 days, please request a new one'))
  end
end
