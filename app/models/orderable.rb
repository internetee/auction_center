# Class for generating ordering queries. Takes a model name, column and order direction.
# Checks if the model exists, if it has the requested order column and returns a ordering query.
# Accepts also a 'default' hash to return valid value in case the order is not valid.
class Orderable
  ORDERABLE_MODELS = %w[Auction Ban BillingProfile Invoice Result User].freeze
  ALLOWED_DIRECTIONS = ['desc', :desc, :DESC, 'DESC', 'asc', :asc, :ASC, 'ASC'].freeze

  include ActiveModel::Model

  attr_reader :model_name,
              :column,
              :direction,
              :default

  # Validations are required because these are exposed via HTTP query parameters
  # Theoretically, a user can enter url /auctions?order_by=some&order_direction=not_valid
  # And we should handle it gracefully, always returning some kind of collection.
  validate :model_is_orderable
  validate :column_exists_in_model
  validate :direction_is_valid

  # There are several caveats to this interface, it can produce a lot of invalid hashes
  # if used carelessly.
  #
  # 1. model_name, can be in snake_case or CamelCase.
  # 2. column_name must be a string, not a symbol
  # 3. Direction allows every permutation of String/Symbol of asc/ASC/desc/DESC.
  #    ApplicationRecord.order does the same thing.
  def initialize(model_name, column, direction, default = nil)
    @model_name = model_name
    @column = column
    @direction = direction
    @default = default
  end

  # Return model class if it is allowed to be ordered by or nil for everything else. Works
  # around uninitialized constant errors.
  def model
    singular_camel_case_model.constantize if ORDERABLE_MODELS.include?(singular_camel_case_model)
  end

  # Accepts either form:
  # "auction"
  # "Auction"
  # "auctions"
  # "Auctions"
  def singular_camel_case_model
    model_name&.singularize&.camelize
  end

  # Returning an array in all cases is useful for downstream interfaces.
  def model_columns
    if model
      model.column_names
    else
      []
    end
  end

  def model_is_orderable
    return if ORDERABLE_MODELS.include?(singular_camel_case_model)

    errors.add(:model, I18n.t('orderable.errors.not_orderable'))
  end

  def column_exists_in_model
    return unless model
    return unless column
    return if model_columns.include?(column)

    errors.add(:column, I18n.t('orderable.errors.not_orderable'))
  end

  def direction_is_valid
    return unless direction
    return if ALLOWED_DIRECTIONS.include?(direction)

    errors.add(:direction, I18n.t('order.errors.not_a_valid_order_direction'))
  end

  # This is the most important method in this class.
  # If valid ordering arguments are provided, return a string to chain into
  # ActiveRecord's query:
  # order = Orderable.new('Auction', 'domain_name', 'desc')
  # Auction.active.order(order.condition)
  #
  # If invalid, return the default value provided to .new or empty string.
  # The caller should know what is a valid order.
  def condition
    if valid?
      "#{model.table_name}.#{column} #{direction}"
    else
      default || ''
    end
  end
end
