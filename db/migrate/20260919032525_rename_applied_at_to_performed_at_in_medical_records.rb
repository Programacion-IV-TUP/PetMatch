class RenameAppliedAtToPerformedAtInMedicalRecords < ActiveRecord::Migration[8.1]
  def change
    rename_column :medical_records, :applied_at, :performed_at
  end
end
