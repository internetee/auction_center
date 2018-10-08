# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

administrator = User.create(given_names: 'Default', surname: 'Administrator',
                            email: 'administrator@auction.test', password: 'password',
                            password_confirmation: 'password', country_code: 'EE',
                            mobile_phone: '+37250060070', identity_code: '51007050118',
                            roles: [User::ADMINISTATOR_ROLE])
administrator.confirm
