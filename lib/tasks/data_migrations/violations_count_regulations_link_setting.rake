namespace :data_migrations do
  desc "Create violation count regulation link setting"
  task violations_count_regulations_link_setting: :environment do

    Setting.transaction do
      violations_count_regulations_description = <<~TEXT.squish
        Link to ToC clause on user agreement termination, used in ban message banner.
        Default: https://example.com#some_anchor .
        Must be single URL or hash of <locale>:<URL> elements.
        URL can be relative ('/public/terms_and_conditions.pdf') 
        or absolute ('https://example.com/terms_and_conditions.pdf'). Relative URL must start with a
        forward slash.
        Default: https://example.com#some_anchor
      TEXT

      violations_count_regulations_setting = Setting.new(code: :violations_count_regulations_link,
                                                         value: "https://example.com#some_anchor",
                                                         description: violations_count_regulations_description)

      violations_count_regulations_setting.save!
      puts "Violation count regulation link setting updated"
    end
  end
end
