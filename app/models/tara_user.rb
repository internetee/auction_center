class TaraUser
  attr_reader :raw_input

  def initialize(raw_input = {})
    @raw_input = raw_input
  end

  def unique_identifier
    raw_input['uid']
  end

  def identity_code
    unique_identifier.slice(2..-1)
  end

  def country_code
    unique_identifier.slice(0..1)
  end

  def given_names
    raw_input.dig('info', 'first_name')
  end

  def surname
    raw_input.dig('info', 'last_name')
  end

  def provider
    'tara'
  end
end
