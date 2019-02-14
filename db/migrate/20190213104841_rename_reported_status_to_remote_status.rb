class RenameReportedStatusToRemoteStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :results, :last_reported_status, :last_remote_status
  end
end
