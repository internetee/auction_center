module ApplicationHealthCheck
  class InternalCheck
    CHECK_NAMES = %w[default database email registry sms tara].freeze

    def run
      result = {}
      CHECK_NAMES.each do |check_name|
        check = OkComputer::Registry.fetch(check_name)
        check.run
        result[check_name] = { success: check.success?, message: check.message }
      end
      result
    end
  end
end
