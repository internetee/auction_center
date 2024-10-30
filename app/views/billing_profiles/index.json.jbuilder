json.array! @billing_profiles do |billing_profile|
  json.id billing_profile.uuid
  json.user_id billing_profile.user_id
  json.name billing_profile.name
  json.vat_code billing_profile.vat_code
  json.street billing_profile.street
  json.city billing_profile.city
  json.state billing_profile.state
  json.postal_code billing_profile.postal_code
  json.alpha_two_country_code billing_profile.alpha_two_country_code
end
