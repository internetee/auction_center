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

## Audits

Due to various regulatory requirements, all database tables are audited according to the following procedure:

1. Changes in `public.users` table are recorded into audit.users. Audit records `action` `old_value`, `new_value`, `recorded_at` time according to postgres time zone and `object_id` which corresponds to the primary key of data in `users`.
2. History of each object is visible in the UI for the administrator.
3. Audit data is never deleted, even if the original object is. For example, if you destroy user with id `123`, it's history can still be accessed under `/admin/users/123/versions`.

### Adding new database table to audits

1. Create a migration similar to [AuditUsersTable](db/migrate/20180921084531_audit_users_table.rb)
2. Create a new audit model like [Audit::User](app/models/audit/user.rb).
   Make sure to set self.table_name to `audit.your_table`
3. Add auditable concern to administrator routes:
   ```ruby
   namespace :admin, constraints: Constraints::Administrator.new do
     resources posts, concerns: [:auditable]
   end
   ```
