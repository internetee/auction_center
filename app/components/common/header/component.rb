module Common
  module Header
    class Component < ApplicationViewComponent
      include Devise::Controllers::Helpers

      attr_reader :notifications

      def initialize(notifications:)
        super()

        @notifications = notifications
      end

      def languages
        languages = { et: 'Est', en: 'Eng' }

        l = languages.map do |lang, desc|
          content_tag('li') do
            content_tag('a', desc, href: locale_path(locale: lang), method: :put, data: { "turbo-method": 'put' })
          end
        end

        safe_join(l)
      end

      def regular_menu_list
        menu = current_user&.roles&.include?(User::ADMINISTATOR_ROLE) ? admin_menu_list_items : regular_menu_list_items

        m = menu.map do |item|
          content_tag('li') do
            content_tag('a', item[:name], href: item[:path], style: active_class(item[:path]))
          end
        end

        safe_join(m)
      end

      def current_language
        I18n.locale == :et ? 'Est' : 'Eng'
      end

      def active_class(link_path)
        current_page?(link_path) ? 'text-decoration: underline;' : ''
      end

      private

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def admin_menu_list_items
        [{ name: t(:auctions_name), path: admin_auctions_path },
         { name: t(:results_name), path: admin_results_path },
         { name: t(:finished_auctions), path: admin_finished_auctions_index_path },
         { name: t(:billing_profiles_name), path: admin_billing_profiles_path },
         { name: t(:users_name), path: admin_users_path },
         { name: t(:bans_name), path: admin_bans_path },
         { name: t(:invoices_name), path: admin_invoices_path },
         { name: t(:jobs_name), path: admin_jobs_path },
         { name: t(:settings_name), path: admin_settings_path },
         { name: t(:paid_deposits_name), path: admin_paid_deposits_path },
         { name: t(:statistics_name), path: admin_statistics_path }]
      end

      def regular_menu_list_items
        items = [{ name: t(:auctions_name), path: auctions_path },
                 { name: t(:my_invoices), path: invoices_path },
                 { name: t(:my_offers), path: offers_path },
                 { name: t(:my_wishlist), path: wishlist_items_path }]

        items.insert(1, { name: t(:profile), path: user_path(current_user&.uuid) }) if user_signed_in?
        items
      end
    end
  end
end
