class RemoveDescriptionFromDomainClassifications < ActiveRecord::Migration[7.0]
  # Description was originally added to back UI auction-card copy and to
  # feed the (later dropped) embedding text input. With keywords + tags
  # carrying both the UX and recommendation needs, we drop description
  # to save OpenAI tokens at classification time.
  def change
    remove_column :domain_classifications, :description, :text
    remove_column :domain_classifications, :description_locale, :string, default: 'en'
  end
end
