class AddEstonianVatRateToSettings < ActiveRecord::Migration[7.0]
  def up
    estonian_vat_rate_description = <<~TEXT.squish
      Default Estonian vat rate. Should be in decimal format like this: 0.2
    TEXT

    estonian_vat_rate_setting = Setting.new(code: :estonian_vat_rate,
                                                          value: '0.2',
                                                          description: estonian_vat_rate_description,
                                                          value_format: 'decimal')
    estonian_vat_rate_setting.save!
  end

  def down
    Setting.find_by(code: :estonian_vat_rate).delete
  end
end
