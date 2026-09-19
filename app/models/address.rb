class Address < ApplicationRecord
  belongs_to :city

  has_many :shelters
  has_many :users

  validates :street, presence: true
  validates :number, presence: true

  def full_address
    parts = [ "#{street} #{number}" ]
    parts << "#{I18n.t('address.floor')} #{floor}" if floor.present?
    parts << "#{I18n.t('address.apartment')} #{apartment}" if apartment.present?
    parts << "#{I18n.t('address.zip_code')} #{zip_code}" if zip_code.present?

    parts.join(", ")
  end
end
