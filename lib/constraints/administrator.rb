module Constraints
  class Administrator
    def initialize; end

    def matches?(request)
      user = request.env['warden']&.user(:user)

      if user
        user.roles.include?(User::ADMINISTATOR_ROLE)
      else
        false
      end
    end
  end
end
