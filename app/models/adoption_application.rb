class AdoptionApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :user

  enum :status, {
    pending: "pending",
    under_review: "under_review",
    approved: "approved",
    rejected: "rejected",
    cancelled: "cancelled"
  }, default: "pending"

  validates :has_another_pet, inclusion: { in: [ true, false ] }
  validates :housing_type, presence: true
  validates :status, presence: true

  after_save :handle_status_change, if: :saved_change_to_status?

  # Trigger automated side-effects based on status updates
  def handle_status_change
    case status
    when "approved"
      process_approval
    when "rejected", "cancelled"
      process_rejection_or_cancellation
    end
  end

  # Updates pet to adopted and rejects other active applications
  def process_approval
    pet.update!(status: "adopted")

    auto_note = I18n.t("admin.adoption_applications.auto_notes.rejected_by_adoption")

    pet.adoption_applications
       .where(status: %w[pending under_review])
       .where.not(id: id)
       .find_each do |other_app|
         other_app.update!(
           status: "rejected",
           notes: [ other_app.notes, auto_note ].compact_blank.join("\n")
         )
       end
  end

  # Reverts pet status to available if no other active applications exist
  def process_rejection_or_cancellation
    has_other_active_apps = pet.adoption_applications
                               .where(status: %w[pending under_review approved])
                               .where.not(id: id)
                               .exists?

    unless has_other_active_apps
      pet.update!(status: "available")
    end
  end
end
