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
