class Pet < ApplicationRecord
  belongs_to :shelter
  belongs_to :breed

  has_many :medical_records, dependent: :destroy
  has_many :adoption_applications, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many_attached :photos

  enum :status, {
    available: "available",
    in_process: "in_process",
    adopted: "adopted"
  }, default: "available"

  validates :name, presence: true
  validates :gender, presence: true
  validates :age_months, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :size, presence: true
  validates :photos, content_type: [ "image/png", "image/jpeg", "image/webp" ], size: { less_than: 5.megabytes }, limit: { max: 5 }

  # Soft delete scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  # Search & Filter scopes
  scope :search_by_name, ->(query) { where("LOWER(name) LIKE ?", "%#{query.downcase}%") if query.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_active_status, ->(active_param) {
    case active_param
    when "true"  then active
    when "false" then inactive
    else all
    end
  }

  def deactivate!
    update!(active: false)
  end

  def activate!
    update!(active: true)
  end

  def age_years
    return 0 if age_months.blank?

    age_months / 12
  end

  def formatted_age
    return I18n.t("activerecord.attributes.pet/age.unknown") if age_months.blank?

    years = age_months / 12
    months = age_months % 12

    if years.positive? && months.positive?
      "#{years} #{I18n.t('activerecord.attributes.pet/age.years', count: years)} #{I18n.t('activerecord.attributes.pet/age.and')} #{months} #{I18n.t('activerecord.attributes.pet/age.months', count: months)}"
    elsif years.positive?
      "#{years} #{I18n.t('activerecord.attributes.pet/age.years', count: years)}"
    else
      "#{months} #{I18n.t('activerecord.attributes.pet/age.months', count: months)}"
    end
  end
end
