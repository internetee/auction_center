module Common
  module StaticNotice
    class Component < ViewComponent::Base
      attr_accessor :current_user

      def initialize(current_user:)
        super()

        @current_user = current_user
      end

      def banned_banner
        return unless current_user&.current_bans

        domains, valid_until = current_user&.current_bans
        message = ban_error_message(domains, valid_until)
        return unless message

        content_tag(:div, class: 'c-toast js-toast c-toast--error') do
          content_tag(:div, class: 'c-toast__content') do
            concat(content_tag(:p, message))
            concat(content_tag(:p, violation_message(domains.size))) if eligible_violations_present?(domains:)
          end
        end
      end

      def invalid_data_banner
        return unless session['user.invalid_user_data']

        if current_user.not_phone_number_confirmed_unique?
          content_tag(:div, class: 'c-toast js-toast c-toast--error') do
            content_tag(:div, t('already_confirmed'), class: 'c-toast__content')
          end
        else
          content_tag(:div, class: 'c-toast js-toast c-toast--error') do
            content_tag(:div, t('users.invalid_user_data'), class: 'c-toast__content')
          end
        end
      end

      def start_of_procedure = Rails.configuration.customization[:start_of_procedure]

      def end_of_procdure = Rails.configuration.customization[:end_of_procedure]

      private

      def ban_error_message(domains, valid_until)
        if current_user&.completely_banned?
          t('auctions.banned_completely', valid_until: valid_until.to_date,
                                          ban_number_of_strikes: Setting.find_by(
                                            code: 'ban_number_of_strikes'
                                          ).retrieve)
        else
          I18n.t('auctions.banned', domain_names: domains.join(', '))
        end
      end

      def violation_message(domains_count)
        link = Setting.find_by(code: 'violations_count_regulations_link').retrieve
        t('auctions.violation_message_html', violations_count_regulations_link: link,
                                             violations_count: domains_count,
                                             ban_number_of_strikes: Setting.find_by(
                                               code: 'ban_number_of_strikes'
                                             ).retrieve)
      end

      def eligible_violations_present?(domains: nil)
        num_of_strikes = Setting.find_by(code: 'ban_number_of_strikes').retrieve
        return true if domains && domains.size < num_of_strikes

        false
      end
    end
  end
end
