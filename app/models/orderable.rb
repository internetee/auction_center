# Class for generating ordering queries. Takes a model name, column and order direction.
# Checks if the model exists, if it has the requested order column and returns a ordering query.
# Accepts also a 'default' hash to return valid value in case the order is not valid.
class Orderable
  # An orderable class does not have to be an ActiveRecord, but it needs to implement the following
  # class methods:
  # column_names => Should return an array of strings.
  # table_name => Should return a string.
  ORDERABLE_CLASSES = %w[Auction ExtendedAuction Ban BillingProfile Invoice
                        Result User].freeze
  ALLOWED_DIRECTIONS = ['desc', :desc, :DESC, 'DESC', 'asc', :asc, :ASC, 'ASC'].freeze
  ALLOWED_NULLS = ['first', :first, :FIRST, 'FIRST', 'last', :last, :LAST, 'LAST'].freeze
  DEFAULT_NULLS_POSITION = 'LAST'.freeze

  include ActiveModel::Model

  attr_reader :model_name,
              :column,
              :direction,
              :default,
              :nulls

  # Validations are required because these are exposed via HTTP query parameters
  # Theoretically, a user can enter url /auctions?order_by=some&order_direction=not_valid
  # And we should handle it gracefully, always returning some kind of collection.
  validate :model_is_orderable
  validate :column_exists_in_model
  validate :direction_is_valid
  validate :nulls_are_valid

  # There are several caveats to this interface, it can produce a lot of invalid hashes
  # if used carelessly.
  #
  # 1. model_name, can be in snake_case or CamelCase.
  # 2. column_name must be a string, not a symbol
  # 3. The position of NULL values in the order. By default, nulls in postgres have higher value
  #    than anything else, but that is not how a user wants to see most data in the user interface.
  # 4. Direction allows every permutation of String/Symbol of asc/ASC/desc/DESC.
  #    ApplicationRecord.order does the same thing.
  def initialize(**args)
    @model_name = args[:model_name]
    @column = args[:column]
    @direction = args[:direction]
    @default = args[:default]
    @nulls = args[:nulls] || DEFAULT_NULLS_POSITION
  end

  # Return model class if it is allowed to be ordered by or nil for everything else. Works
  # around uninitialized constant errors.
  def model
    singular_camel_case_model.constantize if ORDERABLE_CLASSES.include?(singular_camel_case_model)
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
    return if ORDERABLE_CLASSES.include?(singular_camel_case_model)

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

  def nulls_are_valid
    return unless nulls
    return if ALLOWED_NULLS.include?(nulls)

    errors.add(:direction, I18n.t('order.errors.not_a_valid_null_position'))
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
      "#{model.table_name}.#{column} #{direction} NULLS #{nulls}"
    else
      default || ''
    end
  end
end
