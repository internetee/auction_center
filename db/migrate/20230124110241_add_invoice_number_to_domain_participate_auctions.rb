class AddInvoiceNumberToDomainParticipateAuctions < ActiveRecord::Migration[6.1]
  def change
    add_column :domain_participate_auctions, :invoice_number, :string
  end
end
