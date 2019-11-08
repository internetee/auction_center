class IdentityCode
  module Estonia
    def valid?
      valid_length? && valid_century? && valid_birth_date? && valid_check_digit?
    end

    def invalid?
      !valid?
    end

    private

    def valid_century?
      century_code = identity_code[0].to_i
      [1, 2, 3, 4, 5, 6].include?(century_code)
    end

    def birth_date
      century_code = identity_code[0].to_i

      century = case century_code
                when 1..2 then 1800
                when 3..4 then 1900
                when 5..6 then 2000
                end

      year = century + identity_code[1..2].to_i
      month = identity_code[3..4].to_i
      day = identity_code[5..6].to_i

      [year, month, day]
    end

    def valid_check_digit?
      check_digit == identity_code[10].to_i
    end

    def check_digit
      scales = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1]
      checknum = combine_scale_with_number(scales, identity_code)

      if checknum == 10
        scales = [3, 4, 5, 6, 7, 8, 9, 1, 2, 3]
        checknum = combine_scale_with_number(scales, identity_code)

        checknum == 10 ? 0 : checknum
      else
        checknum
      end
    end

    def valid_birth_date?
      year, month, day = birth_date
      Date.valid_date?(year, month, day)
    end

    def valid_length?
      identity_code.length == 11
    end

    def combine_scale_with_number(scale, identity_code)
      scale.each_with_index.map do |scale_item, i|
        identity_code[i].to_i * scale_item
      end.reduce(0, :+) % 11
    end
  end
end
