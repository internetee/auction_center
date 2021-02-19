class RemoteViewPartial < ApplicationRecord
  validates :name, presence: true
  validates :locale, presence: true, uniqueness: { scope: :name }
  validates :content, presence: true
  before_validation :sanitize_content
  after_commit :clear_cache

  def sanitize_content
    self.content = sanitize
  end

  def sanitize
    tags = %w[footer nav div ul li i strong a h3 img]
    attributes = %w[class title src href aria-hidden]

    ActionController::Base.helpers.sanitize(content,
                                            tags: tags,
                                            attributes: attributes)
  end

  def self.sanitized(name:, locale:)
    partial = Rails.cache.fetch("#{name}/#{locale}_partial", expires_in: 12.hours) do
      RemoteViewPartial.find_by(name: name, locale: locale)
    end
    partial.sanitize
  end

  def clear_cache
    Rails.cache.delete("#{name}/#{locale}_partial")
  end
end
