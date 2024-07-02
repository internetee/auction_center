module Common
  module Footer
    class Component < ApplicationViewComponent
      def footer_link(key) = if I18n.locale == :et
                               et_footer_links[key]
                             else
                               en_footer_links[key]
                             end

      def et_footer_links
        {
          dispute_committee: 'https://www.internet.ee/domeenivaidlused/domeenivaidluste-komisjon',
          list_of_accredited_registrars: 'https://www.internet.ee/registripidaja/akrediteeritud-registripidajad',
          terms_and_conditions_for_registrars: 'https://www.internet.ee/registripidaja/kuidas-saada-ee-akrediteeritud-registripidajaks',
          partner_programme: 'https://www.internet.ee/registripidaja/kuidas-saada-ee-elite-partneriks'
        }
      end

      def en_footer_links
        {
          dispute_committee: 'https://www.internet.ee/domain-disputes/domain-disputes-committee',
          list_of_accredited_registrars: 'https://www.internet.ee/registrar-portal/accredited-registrars',
          terms_and_conditions_for_registrars: 'https://www.internet.ee/registrar-portal/terms-and-conditions-for-becoming-a-registrar',
          partner_programme: 'https://www.internet.ee/registrar-portal/become-a-ee-elite-partner'
        }
      end
    end
  end
end
