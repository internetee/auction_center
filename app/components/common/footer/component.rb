module Common
  module Footer
    class Component < ApplicationViewComponent
      def footer_link(key) = if I18n.locale == :et
                               et_footer_links[key]
                             else
                               en_footer_links[key]
                             end

      # rubocop:disable Metrics/MethodLength
      def et_footer_links
        {
          dispute_committee: 'https://www.internet.ee/domeenivaidlused/domeenivaidluste-komisjon',
          list_of_accredited_registrars: 'https://www.internet.ee/registripidaja/akrediteeritud-registripidajad',
          terms_and_conditions_for_registrars: 'https://www.internet.ee/registripidaja/kuidas-saada-ee-akrediteeritud-registripidajaks',
          partner_programme: 'https://www.internet.ee/registripidaja/kuidas-saada-ee-elite-partneriks',
          contact_us: 'https://www.internet.ee/eis',
          management: 'https://www.internet.ee/eis/ulesanded-juhatus-ja-noukogu',
          newsletter: 'https://www.internet.ee/eis/uudiskirjad',
          domain_regulation: 'https://www.internet.ee/domeenid/ee-domeenireeglid',
          faq: 'https://www.internet.ee/abi-ja-info/kkk',
          statistics: 'https://www.internet.ee/abi-ja-info/statistika'
        }
      end

      def en_footer_links
        {
          dispute_committee: 'https://www.internet.ee/domain-disputes/domain-disputes-committee',
          list_of_accredited_registrars: 'https://www.internet.ee/registrar-portal/accredited-registrars',
          terms_and_conditions_for_registrars: 'https://www.internet.ee/registrar-portal/terms-and-conditions-for-becoming-a-registrar',
          partner_programme: 'https://www.internet.ee/registrar-portal/become-a-ee-elite-partner',
          contact_us: 'https://www.internet.ee/eif',
          management: 'https://www.internet.ee/eif/tasks-and-management',
          newsletter: 'https://www.internet.ee/eif/newsletter',
          domain_regulation: 'https://internet.ee/domains/ee-domain-regulation',
          faq: 'https://internet.ee/help-and-info/faq',
          statistics: 'https://internet.ee/help-and-info/statistics'
        }
      end
    end
  end
end
