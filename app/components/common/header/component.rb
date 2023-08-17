module Common
  module Header
    class Component < ApplicationViewComponent
      include Devise::Controllers::Helpers

      def languages
        l = %w[Est Eng].map do |lang|
          content_tag('li') do
            content_tag('a', lang, href: '#')
          end
        end

        safe_join(l)
      end
    end
  end
end
