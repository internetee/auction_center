# frozen_string_literal: true

# Yabeda Rails configuration for fine-tuning metrics collection
# This configures Apdex targets and custom buckets for request duration metrics

Yabeda::Rails.config.apdex_target = 0.5 # 500ms — target response time
Yabeda::Rails.config.buckets = [
  0.05, 0.1, 0.25, 0.5, 1, 2, 5
]

Yabeda::Rails.install!
