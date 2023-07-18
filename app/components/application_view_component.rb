class ApplicationViewComponent < ViewComponent::Base
  include ApplicationHelper
  # include HeroiconHelper
  include Turbo::FramesHelper
  include Pagy::Frontend

  class << self
    def component_name
      @component_name ||= name.sub(/::Component$/, '').underscore
    end
  end

  def component(name, ...)
    return super unless name.starts_with?('.')

    full_name = self.class.component_name + name.sub('.', '/')

    super(full_name, ...)
  end

  def company_name
    @company_name ||= 'Readify Lang'
  end
end
