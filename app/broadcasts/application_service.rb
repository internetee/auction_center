# frozen_string_literal: true

class ApplicationService
  def self.call(...)
    new(...).call
  end

  def initialize(*_); end

  def call
    return unless @object.present? && @object.respond_to?(:errors)

    [@object.errors.none?, @object]
  end

  private

  def broadcast_later(channel, template, **params)
    Turbo::StreamsChannel.broadcast_render_to(
      channel,
      template: template,
      **params
    )
  end
end
