class Hospital < ApplicationRecord
  has_many :doctors
  has_many :appointments
  has_many :hospital_admins, -> { where(role: 'hospital_admin') }, class_name: 'User'

  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }
end
