class SeedInterestCategoriesAndSetting < ActiveRecord::Migration[7.0]
  # Data migration so existing environments get the categories + toggle on
  # deploy (db:migrate). Fresh setups get the same via db/seeds.rb. Both are
  # idempotent. Schema-load (structure.sql) skips this — that path runs seeds.
  def up
    unless Setting.exists?(code: 'recommendation_interests_enabled')
      Setting.create(
        code: 'recommendation_interests_enabled',
        value: 'false',
        value_format: 'boolean',
        description: "When 'true', users see the auction-interests selection " \
                     "(prompt + form). Keep 'false' until interest categories are populated in admin."
      )
    end

    InterestCategory.seed_defaults!
  end

  def down
    Setting.where(code: 'recommendation_interests_enabled').delete_all
    InterestCategory.where(code: InterestCategory::DEFAULTS.map { |c| c[:code] }).delete_all
  end
end
