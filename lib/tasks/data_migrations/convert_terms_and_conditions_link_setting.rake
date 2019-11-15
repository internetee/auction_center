namespace :data_migrations do
  task convert_terms_and_conditions_link_setting: :environment do

    Setting.transaction do
      setting = Setting.find_by(code: :terms_and_conditions_link)
      terms_and_conditions_description = <<~TEXT.squish
        Link to terms and conditions document. Must be single parsable hash of <locale>:<URL> elements.
        URL can be relative ('/public/terms_and_conditions.pdf') 
        or absolute ('https://example.com/terms_and_conditions.pdf'). Relative URL must start with a
        forward slash. Default is: "{\"en\":\"https://example.com\", \"et\":\"https://example.et\"}"
      TEXT
      value = "{\"en\":\"https://example.com\", \"et\":\"https://example.et\"}"
      setting.update(value: value,
                     description: terms_and_conditions_description)
    end

    puts "Terms and conditions setting updated"
  end
end
