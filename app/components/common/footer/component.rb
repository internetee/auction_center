module Common
  module Footer
    class Component < ApplicationViewComponent
      FOOTER_SOCIAL_KEYS = %i[facebook twitter youtube linkedin instagram spotify rss].freeze

      FOOTER_SOCIAL_ICONS = {
        'facebook' => 'fab fa-facebook-square',
        'twitter' => 'fab fa-twitter',
        'youtube' => 'fab fa-youtube-square',
        'linkedin' => 'fab fa-linkedin',
        'instagram' => 'fab fa-instagram',
        'spotify' => 'fab fa-spotify',
        'rss' => 'fas fa-rss-square'
      }.freeze

      SOCIAL_HOST_KEYS = {
        'facebook.com' => 'facebook',
        'twitter.com' => 'twitter',
        'x.com' => 'twitter',
        'linkedin.com' => 'linkedin',
        'youtube.com' => 'youtube',
        'instagram.com' => 'instagram',
        'spotify.com' => 'spotify',
        'open.spotify.com' => 'spotify'
      }.freeze

      # Voog may list these keys, but the app renders them separately (see FOOTER_INJECTED_LINKS).
      FOOTER_VOOG_SKIP_SLOTS = %i[
        cookie_settings cookies_on_internet_ee_webpage kupsised_internet_ee_lehel accessibility
        ligipaasetavus 2025 become_a_ee_elite_partner_2
      ].freeze

      # App-only links inserted after a Voog-mapped slot (not taken from Voog URLs/text).
      FOOTER_INJECTED_LINKS = [
        { key: :cookie_settings, after: :content_management_principles }
      ].freeze

      # Static column layout when Voog is disabled (order preserved).
      FOOTER_NAV_COLUMNS_FALLBACK = [
        {
          title_key: :help_and_info,
          links: %i[
            domain_regulation faq statistics dispute_committee
            data_protection_policy content_management_principles
          ]
        },
        {
          title_key: :registrars,
          links: %i[
            list_of_accredited_registrars
            terms_and_conditions_for_registrars
            partner_programme
          ]
        },
        {
          title_key: :estonian_internet,
          links: %i[
            contact_us management documents newsletter
            information_security_principles
          ]
        }
      ].freeze

      # App footer slots -> Voog path-derived keys (EN first, then ET). Inspect: voog_footer_available_link_keys
      FOOTER_LINK_VOOG_KEYS = {
        domain_regulation: %w[ee_domain_regulation ee_domeenireeglid],
        faq: %w[faq kkk],
        statistics: %w[statistics statistika],
        dispute_committee: %w[domain_disputes domeenivaidluste_komisjon],
        data_protection_policy: %w[
          eif_s_data_protection_policy
          eis_i_isikuandmete_kasutamise_alused
        ],
        cookie_settings: %w[cookie_settings kuupäeviku_seaded],
        content_management_principles: %w[
          principles_for_the_content_management_of_estonian_internet
          sisu_haldamise_pohimotted_eesti_internetis
        ],
        list_of_accredited_registrars: %w[accredited_registrars akrediteeritud_registripidajad],
        terms_and_conditions_for_registrars: %w[
          terms_and_conditions_for_becoming_a_registrar
          kuidas_saada_ee_akrediteeritud_registripidajaks
        ],
        partner_programme: %w[
          become_a_ee_elite_partner
          kuidas_saada_ee_elite_partneriks
        ],
        contact_us: %w[eif eis],
        management: %w[tasks_and_management ulesanded_juhatus_ja_noukogu],
        documents: %w[documents dokumendid],
        newsletter: %w[newsletter uudiskiri],
        information_security_principles: %w[
          information_security_principles
          infoturbe_pohimotted_eesti_interneti_sihtasutuses
        ]
      }.freeze

      def footer_link(key)
        footer_link_url(key)
      end

      def footer_link_url(key)
        key = key.to_sym
        return i18n_footer_link_url(key) || '#' if key == :cookie_settings

        voog_key = resolve_voog_footer_key(key)
        voog_footer_links_by_key[voog_key]&.dig('url') ||
          i18n_footer_link_url(key) ||
          '#'
      end

      def footer_link_label(key)
        key = key.to_s
        voog_key = resolve_voog_footer_key(key)
        i18n_footer_link_label(key).presence ||
          (voog_footer_enabled? && voog_footer_links_by_key[voog_key]&.dig('text').presence) ||
          key.tr('_', ' ').capitalize
      end

      def footer_navigation_columns
        columns = voog_footer_navigation_columns.presence || footer_navigation_columns_fallback
        inject_footer_special_links(columns)
      end

      def footer_social_column_title
        return t('common.footer.social_media') unless voog_footer_enabled?

        voog_social_column&.dig('name').presence || t('common.footer.social_media')
      end

      def footer_social_links
        voog_links = voog_social_links_from_structure
        if voog_links.present?
          return voog_links.filter_map { |link| build_footer_social_link(link) }
        end

        FOOTER_SOCIAL_KEYS.filter_map do |key|
          url = i18n_footer_link_url(key)
          next if url.blank?

          {
            key: key,
            url: url,
            title: footer_social_title(key),
            icon_class: footer_social_icon_class(key)
          }
        end
      end

      def footer_highlight_title
        voog_footer_structure&.dig('highlight', 'title').presence ||
          t('common.footer.copyright')
      end

      def footer_highlight_info
        info = voog_footer_structure&.dig('highlight', 'info')
        if info.present?
          sanitize(info, tags: %w[br])
        else
          safe_join(
            [t('common.footer.address'), t('common.footer.registration_code')],
            tag.br
          )
        end
      end

      def footer_email_href
        contact_url_for('email', type: 'email') || 'mailto:info@internet.ee'
      end

      def footer_email_text
        contact_text_for('email', type: 'email') || 'info@internet.ee'
      end

      def footer_phone_text
        contact = voog_footer_contacts.find { |c| c['type'] == 'phone' || c['key'].to_s.start_with?('phone') }
        contact&.dig('text').presence || '727 1000'
      end

      def footer_logo_url
        VoogFooter.configuration.site_url.presence || 'https://internet.ee'
      end

      def voog_footer_available_link_keys
        voog_footer_links_by_key.keys.sort
      end

      private

      def voog_footer_enabled?
        VoogFooter.configuration.enabled
      end

      def voog_footer_structure
        return @voog_footer_structure if defined?(@voog_footer_structure)

        @voog_footer_structure = if voog_footer_enabled?
                                  VoogFooter.structure&.dig(I18n.locale.to_s)
                                end
      end

      def voog_footer_links_by_key
        return @voog_footer_links_by_key if defined?(@voog_footer_links_by_key)

        @voog_footer_links_by_key = {}
        structure = voog_footer_structure
        return @voog_footer_links_by_key unless structure

        structure['columns']&.each do |column|
          column['links']&.each { |link| store_voog_link(link) }
          column['social_links']&.each { |link| store_voog_link(link) }
        end
        structure['highlight']&.fetch('contacts', [])&.each { |contact| store_voog_link(contact) }
        structure['extras']&.each { |extra| store_voog_link(extra) }
        @voog_footer_links_by_key
      end

      def store_voog_link(link)
        key = link['key']
        return if key.blank?

        @voog_footer_links_by_key[key] = link
      end

      def resolve_voog_footer_key(key)
        key_s = key.to_s
        return key_s if voog_footer_links_by_key.key?(key_s)

        aliases = FOOTER_LINK_VOOG_KEYS[key.to_sym]
        return key_s unless aliases

        aliases.find { |candidate| voog_footer_links_by_key.key?(candidate) } || key_s
      end

      def voog_footer_navigation_columns
        return [] unless voog_footer_structure

        voog_footer_structure['columns'].filter_map do |column|
          next if column['follow_us']

          links = column['links']&.filter_map { |link| build_footer_nav_link(link) }
          next if links.blank?

          {
            name: column['name'].presence,
            links: links
          }
        end
      end

      def footer_navigation_columns_fallback
        FOOTER_NAV_COLUMNS_FALLBACK.filter_map do |column|
          links = column[:links].filter_map { |key| build_footer_nav_link_from_slot(key) }
          next if links.blank?

          {
            name: t("common.footer.#{column[:title_key]}"),
            links: links
          }
        end
      end

      def inject_footer_special_links(columns)
        FOOTER_INJECTED_LINKS.each do |spec|
          inject_footer_nav_link(columns, spec[:key], after: spec[:after])
        end
        columns
      end

      def inject_footer_nav_link(columns, key, after:)
        link = build_footer_nav_link_from_slot(key)
        return columns unless link

        columns.each do |column|
          next if column[:links].any? { |entry| entry[:key] == key }

          anchor_index = column[:links].index { |entry| entry[:key] == after }
          next unless anchor_index

          column[:links].insert(anchor_index + 1, link)
          return columns
        end

        columns
      end

      def build_footer_nav_link_from_slot(key)
        url = footer_link_url(key)
        return nil if url.blank? || url == '#'

        {
          key: key,
          url: url,
          label: footer_link_label(key),
          html_options: footer_nav_link_html_options(key)
        }
      end

      def build_footer_nav_link(voog_link)
        voog_key = voog_link['key']
        return nil if voog_key.blank?

        app_slot = app_slot_for_voog_key(voog_key)
        return nil if footer_voog_skip_slot?(voog_key: voog_key, app_slot: app_slot)

        url = voog_link['url'].presence || footer_link_url(app_slot)
        return nil if url.blank? || url == '#'

        {
          key: app_slot,
          url: url,
          label: footer_nav_link_label(app_slot, voog_link),
          html_options: footer_nav_link_html_options(app_slot)
        }
      end

      def footer_nav_link_label(app_slot, voog_link)
        i18n_footer_link_label(app_slot.to_s).presence ||
          voog_link['text'].presence ||
          app_slot.to_s.tr('_', ' ').capitalize
      end

      def footer_nav_link_html_options(key)
        return cookie_settings_link_html_options if key.to_sym == :cookie_settings

        { target: '_blank', rel: 'noopener' }
      end

      def cookie_settings_link_html_options
        {
          target: '_blank',
          rel: 'noopener',
          title: footer_link_label(:cookie_settings),
          'data-cc': 'c-settings'
        }
      end

      def footer_voog_skip_slot?(voog_key: nil, app_slot: nil)
        slot = app_slot || app_slot_for_voog_key(voog_key)
        FOOTER_VOOG_SKIP_SLOTS.include?(slot)
      end

      def app_slot_for_voog_key(voog_key)
        key_s = voog_key.to_s
        FOOTER_LINK_VOOG_KEYS.each do |slot, aliases|
          return slot if aliases.include?(key_s)
        end

        return key_s.to_sym if i18n_footer_link_label(key_s).present? || i18n_footer_link_url(key_s).present?

        key_s.to_sym
      end

      def voog_social_column
        voog_footer_structure&.dig('columns')&.find { |column| column['follow_us'] }
      end

      def voog_social_links_from_structure
        voog_social_column&.dig('social_links')
      end

      def voog_footer_contacts
        voog_footer_structure&.dig('highlight', 'contacts') || []
      end

      def contact_url_for(key, type: nil)
        contact = voog_footer_contacts.find do |entry|
          entry['key'] == key || (type && entry['type'] == type)
        end
        contact&.dig('url')
      end

      def contact_text_for(key, type: nil)
        contact = voog_footer_contacts.find do |entry|
          entry['key'] == key || (type && entry['type'] == type)
        end
        contact&.dig('text').presence
      end

      def i18n_footer_link_url(key)
        t("common.footer.links.#{key}", default: nil).presence
      end

      def footer_social_title(key)
        footer_link_label(key)
      end

      def i18n_footer_link_label(key)
        t("common.footer.labels.#{key}", default: '').presence ||
          t("common.footer.social.#{key}", default: '').presence
      end

      def footer_social_icon_class(key)
        FOOTER_SOCIAL_ICONS.fetch(key.to_s, 'fas fa-external-link-alt')
      end

      def build_footer_social_link(link)
        url = link['url'].presence
        return nil if url.blank?

        key = social_key_for(link)&.to_sym
        return nil unless key

        {
          key: key,
          url: url,
          title: footer_social_title(key),
          icon_class: footer_social_icon_class(key)
        }
      end

      def social_key_for(link)
        icon_name = link.dig('icon', 'name').presence
        return icon_name if icon_name && FOOTER_SOCIAL_ICONS.key?(icon_name)

        host_key = social_key_from_url(link['url'])
        return host_key if host_key

        parsed_key = link['key'].to_s
        parsed_key if FOOTER_SOCIAL_ICONS.key?(parsed_key)
      end

      def social_key_from_url(url)
        host = URI.parse(url).host.to_s.sub(/\Awww\./, "").downcase
        return nil if host.empty?

        SOCIAL_HOST_KEYS.each do |domain, key|
          return key if host == domain || host.end_with?(".#{domain}")
        end

        nil
      rescue URI::InvalidURIError
        nil
      end
    end
  end
end
