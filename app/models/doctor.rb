class Doctor < ApplicationRecord
  belongs_to :user
  belongs_to :specialty
  belongs_to :hospital
end
