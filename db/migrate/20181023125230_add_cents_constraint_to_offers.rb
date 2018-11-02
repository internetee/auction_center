class AddCentsConstraintToOffers < ActiveRecord::Migration[5.2]
  def up
    sql = <<~SQL
      ALTER TABLE public.offers
      ADD CONSTRAINT offers_cents_are_positive
        CHECK (cents > 0);
    SQL

    execute(sql)
  end

  def down
    sql = <<~SQL
      ALTER TABLE public.offers DROP CONSTRAINT offers_cents_are_positive;
    SQL

    execute(sql)
  end
end
