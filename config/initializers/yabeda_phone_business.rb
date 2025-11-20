# frozen_string_literal: true

# Yabeda business metrics for phone confirmation
# Tracks SMS sending, confirmation attempts, and related failures

Yabeda.configure do
  group :phone_business do
    counter :phone_confirmation_sms_sent_total,
      comment: "Sent SMS for phone confirmation"

    counter :phone_confirmation_sms_failures_total,
      comment: "SMS sending failures",
      tags: %i[exception_class]

    counter :phone_confirmation_attempts_total,
      comment: "Phone confirmation code verification attempts"

    counter :phone_confirmation_success_total,
      comment: "Successful phone confirmations"

    counter :phone_confirmation_invalid_code_total,
      comment: "Invalid confirmation code attempts"
  end
end
