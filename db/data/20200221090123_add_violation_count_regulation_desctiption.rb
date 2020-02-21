class AddViolationCountRegulationDesctiption < ActiveRecord::Migration[6.0]
  def up
    Setting.transaction do
      violations_count_regulations_description = <<~TEXT.squish
        Link to ToC clause on user agreement termination, used in ban message banner.
        Must be parsable string containing hash of <locale>:<URL> elements.
        URL can be relative ('/public/terms_and_conditions.pdf')
        or absolute ('https://example.com/terms_and_conditions.pdf'). Relative URL must start with a
        forward slash.
        Default: "{\"en\":\"https://example.com#some_anchor\"}"
      TEXT
      value = "{\"en\":\"https://example.com#some_anchor\"}"

      setting = Setting.find_or_create_by(code: :violations_count_regulations_link)
      return if setting.value.present?

      setting.update(value: value,
                     description: violations_count_regulations_description,
                     value_format: 'hash')
      puts "Violation count regulation link setting updated"
    end
  end

  def down
  end
end
