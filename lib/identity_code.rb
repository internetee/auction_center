require 'identity_code/estonia'

class IdentityCode
  attr_reader :country_code
  attr_reader :identity_code

  def initialize(country_code, identity_code)
    @country_code = country_code
    @identity_code = identity_code

    include_country_module
  end

  def include_country_module
    if country_code == 'EE'
        extend IdentityCode::Estonia
    end
  end

  def valid?
    true
  end
end
