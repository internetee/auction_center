# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby on Rails 7.2 application for managing TLD domain auctions. The system handles English and blind auctions, user billing, payment processing, and integrates with external services for authentication (TARA) and billing (EIS billing, Directo).

## Common Development Commands

### Development Server
- `bin/dev` - Start development server with asset watchers (recommended)
- `bin/rails server` - Rails server only

### Testing
- `bin/rails test` - Run all tests (uses Minitest)
- `bin/rails test test/models/user_test.rb` - Run a single test file
- `bin/rails test test/models/user_test.rb:45` - Run test at specific line
- `COVERAGE=true bin/rails test` - Run tests with coverage
- `bin/rails test:system` - Run system tests

### Code Quality
- `bundle exec rubocop` - Run code linting
- `bundle exec rubocop -a` - Auto-fix linting issues
- `bundle exec brakeman` - Security scanning
- `bundle exec bundle-audit` - Dependency security audit

### Database
- `bin/rails db:migrate` - Run database migrations
- `bin/rails data:migrate` - Run data migrations (uses data_migrate gem)
- `bin/rails db:setup` - Create, migrate, and seed database
- `bin/rails console` - Interactive console for debugging

### Background Jobs
- `bin/delayed_job start` - Start background job worker (Delayed Job)
- `bin/rails jobs:work` - Alternative job worker command

### Assets
- `yarn build` - Build JavaScript assets (esbuild)
- `yarn build:css` - Build CSS assets (Sass)

## Architecture & Key Components

### Core Models
- `Auction` - Domain auctions (English/blind types)
- `User` - User accounts with TARA authentication
- `Offer` - Bids placed on auctions
- `Result` - Auction results and winner information
- `Invoice` - Billing and payment handling
- `BillingProfile` - User billing information

### Authentication & Authorization
- Uses Devise with TARA (Estonian ID authentication)
- CanCanCan for authorization with role-based permissions
- JWT tokens for API authentication

### Background Processing
- Delayed Job with PostgreSQL backend
- Key jobs: auction creation, invoice processing, email notifications, domain registration checks

### API Structure
- JSON API for auction listings at `/auctions`
- Health check API (documented in project Wiki)
- API controllers under `app/controllers/api/`

### Frontend Stack
- Hotwire (Turbo + Stimulus) for interactive features
- esbuild for JavaScript bundling
- Sass for CSS processing
- ViewComponent for reusable UI components

### Key Services
- `Registry::AuctionCreator` - Creates auctions from registry data
- `EisBilling::*` - Integration with external billing system
- `AutobiderService` - Automated bidding functionality
- `InvoiceCreator` - Invoice generation and processing

### Database Features
- Full audit trail for all tables (stored in `audit` schema)
- Database views for statistics and reports
- Constraints and validations at DB level

### Integrations
- **TARA** - Estonian national ID authentication
- **EIS Billing** - External billing and payment system
- **Directo** - Accounting system integration
- **Payment providers** - Swedbank, SEB, LHV bank links
- **WebPush** - Browser notifications

### Configuration
- Main config in `config/customization.yml`
- Settings stored in database (admin configurable)
- Feature flags via `Feature` model

### Testing Strategy
- Minitest with system tests using Cuprite (headless Chrome)
- SimpleCov for test coverage
- Fixtures for test data
- Spy gem for mocking

### Security Considerations
- Regular security audits with Brakeman and bundle-audit
- CSRF protection for all forms
- Content Security Policy configured
- Rate limiting on critical endpoints
- Input validation and sanitization

## Development Workflow

1. Use `bin/setup` for initial project setup
2. Run `bin/dev` for development with live asset reloading
3. Use `bin/rails console` for debugging and data exploration
4. Follow audit requirements - all DB changes are tracked
5. Test changes with `bin/rails test` before committing
6. Check code quality with `bundle exec rubocop`