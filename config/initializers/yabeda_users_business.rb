# frozen_string_literal: true

# Yabeda business metrics for user registration and email confirmation
# Tracks user registrations, email confirmations, and related failures

Yabeda.configure do
  group :user_business do
    counter :user_registrations_total,
      comment: "Total user registrations",
      tags: %i[provider]

    counter :user_confirmed_total,
      comment: "Users with confirmed email",
      tags: %i[provider]

    gauge :user_tara_unconfirmed_total,
      comment: "TARA users with unconfirmed email"

    counter :email_confirmation_resent_total,
      comment: "Resent email confirmation attempts"

    counter :email_confirmation_failures_total,
      comment: "Email confirmation sending failures",
      tags: %i[reason]
  end
end
