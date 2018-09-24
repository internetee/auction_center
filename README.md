# Auction center

[![Build Status](https://travis-ci.org/internetee/auction_center.svg?branch=master)](https://travis-ci.org/internetee/auction_center)
[![Code Climate](https://codeclimate.com/github/internetee/auction_center/badges/gpa.svg)](https://codeclimate.com/github/internetee/auction_center)
[![Test Coverage](https://codeclimate.com/github/internetee/auction_center/badges/coverage.svg)](https://codeclimate.com/github/internetee/auction_center/coverage)

Software for managing TLD domain auctions

## Setup

1. Run `bin/setup`
2. Configure database in `config/database.yml` according to your needs
3. Run `bundle exec rake db:setup`

## Default user account

By default, the application creates an administrator user account that should be used only to create new user accounts, and then deleted.

```
email: administrator@auction.test
password: password
```
