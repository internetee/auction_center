class Setting
  attr_reader :value,
    :description,
    :code

  def initialize(**keywords)
    @value = keywords[:value]
    @description = keywords[:description]
    @code = keywords[:code]
  end
end
