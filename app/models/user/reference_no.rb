module User::ReferenceNo
  extend ActiveSupport::Concern

  included do
    before_save :assign_reference_no
  end

  def assign_reference_no
    return if roles.include?('administrator') || reference_no.present?

    reference_no = EisBilling::GetReferenceNumber.call(email:, owner: display_name)

    if reference_no.result?
      self.reference_no = reference_no.instance['reference_number']
      logs_reference_no_assignment(reference_no)
    else
      logs_error_during_reference_no_assignment(reference_no)
    end
  end

  private

  def logs_reference_no_assignment(reference_no)
    Rails.logger.info "Reference number #{reference_no.instance['reference_number']} assigned to user #{email}"
    return unless Rails.env.development?

    puts "Reference number #{reference_no.instance['reference_number']} assigned to user #{email}"
  end

  def logs_error_during_reference_no_assignment(reference_no)
    Rails.logger.info "Error: #{reference_no.errors}"
    return unless Rails.env.development?

    puts "Error: #{reference_no.errors}"
  end
end
