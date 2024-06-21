class AddOrganizationContactEmailToSettings < ActiveRecord::Migration[7.0]
  def up
    contact_organization_email_description = <<~TEXT.squish
      Default organization email
    TEXT

    contact_organization_email_value = 'info@internet.ee'
    contact_organization_email_setting = Setting.new(code: :contact_organization_email,
                                                    value: contact_organization_email_value,
                                                    description: contact_organization_email_description,
                                                    value_format: 'string')
    contact_organization_email_setting.save
  end

  def down
    Setting.where(code: :contact_organization_email).delete_all
  end
end
