class CreateDomainParticipateAuctions < ActiveRecord::Migration[6.1]
  def change
    create_table :domain_participate_auctions do |t|
      t.references :user
      t.references :auction

      t.timestamps
    end
  end
end
