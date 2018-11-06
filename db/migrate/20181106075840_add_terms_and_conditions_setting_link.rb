class AddTermsAndConditionsSettingLink < ActiveRecord::Migration[5.2]
  def up
    terms_and_conditions_description = <<~TEXT.squish
      Link to terms and conditions document. Can be relative ('/public/terms_and_conditions.pdf')
      or absolute ('https://example.com/terms_and_conditions.pdf'). Default is: https://example.com
    TEXT

    terms_and_conditions_setting = Setting.new(code: :terms_and_conditions_link,
                                               value: "https://example.com",
                                               description: terms_and_conditions_description)

    terms_and_conditions_setting.save
  end

  def down
    Setting.where(code: :terms_and_conditions_link).delete_all
  end
end
