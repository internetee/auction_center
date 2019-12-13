namespace :data_migrations do
  desc 'Migrate settings to updated structure'
  task 'migrate_settings_to_updated_structure' => :environment do
    boolean_settings = [:require_phone_confirmation]
    integer_settings = %i[auction_minimum_offer payment_term registration_term
                          ban_length ban_number_of_strikes
                          invoice_reminder_in_days wishlist_size domain_registration_reminder]
    string_settings = %i[auction_currency default_country invoice_issuer check_api_url check_sms_url
                         check_tara_url auction_duration auctions_start_at]
    hash_settings = %i[violations_count_regulations_link terms_and_conditions_link]
    arr_settings = [:wishlist_supported_domain_extensions]

    integer_setting = ApplicationSettingFormat.find_or_initialize_by(data_type: 'integer')
    string_setting = ApplicationSettingFormat.find_or_initialize_by(data_type: 'string')
    boolean_setting = ApplicationSettingFormat.find_or_initialize_by(data_type: 'boolean')
    hash_setting = ApplicationSettingFormat.find_or_initialize_by(data_type: 'hash')
    arr_setting = ApplicationSettingFormat.find_or_initialize_by(data_type: 'array')

    boolean_values = {}
    integer_values = {}
    string_values = {}
    hash_values = {}
    arr_values = {}

    Setting.all.each do |stng|
      prop = ApplicationSetting.new
      prop.code = stng.code
      prop.description = stng.description
      prop.created_at = stng.created_at
      prop.updated_at = stng.updated_at
      prop.updated_by = stng.updated_by

      if boolean_settings.include? stng.code.to_sym
        prop.value = stng.value == 'true'
        prop.data_type = 'boolean'
        if prop.valid?
          boolean_values[prop.code] = prop.as_json(only: %w[description value created_at updated_at updated_by])
        else
          puts "#{prop.code} - #{prop.data_type} - not valid - #{prop.value} - #{prop.value.class}"
        end
      elsif integer_settings.include? stng.code.to_sym
        prop.value = stng.value.to_i
        prop.data_type = 'integer'
        if prop.valid?
          integer_values[prop.code] = prop.as_json(only: %w[description value created_at updated_at updated_by])
        else
          puts "#{prop.code} - #{prop.data_type} - not valid"
        end
      elsif string_settings.include? stng.code.to_sym
        prop.value = stng.value
        prop.data_type = 'string'
        if prop.valid?
          string_values[prop.code] = prop.as_json(only: %w[description value created_at updated_at updated_by])
        else
          puts "#{prop.code} - #{prop.data_type} - not valid"
        end
      elsif hash_settings.include? stng.code.to_sym
        prop.value = JSON.parse(stng.value).as_json
        prop.data_type = 'hash'
        puts "hash value = #{prop.value} - #{prop.value.class}"
        if prop.valid?
          hash_values[prop.code] = prop.as_json(only: %w[description value created_at updated_at updated_by])
        else
          puts "#{prop.code} - #{prop.data_type} - not valid"
        end
      elsif arr_settings.include? stng.code.to_sym
        prop.value = JSON.parse(stng.value).as_json
        prop.data_type = 'array'
        if prop.valid?
          arr_values[prop.code] = prop.as_json(only: %w[description value created_at updated_at updated_by])
        else
          puts "#{prop.code} - #{prop.data_type} - not valid"
        end
      else
        puts "No match for #{stng.code}"
      end
    end

    integer_setting.settings = integer_values.as_json
    string_setting.settings = string_values.as_json
    boolean_setting.settings = boolean_values.as_json
    hash_setting.settings = hash_values.as_json
    arr_setting.settings = arr_values.as_json

    puts 'Integer settings successfully saved!' if integer_setting.save
    puts 'String settings successfully saved!' if string_setting.save
    puts 'Boolean settings successfully saved!' if boolean_setting.save
    puts 'Hash settings successfully saved!' if hash_setting.save
    puts 'Array settings successfully saved!' if arr_setting.save
  end
end
