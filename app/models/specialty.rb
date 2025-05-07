class Specialty < ApplicationRecord
  has_many :doctors, dependent: :destroy
end
