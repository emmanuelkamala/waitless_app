class Doctor < ApplicationRecord
  belongs_to :user
  belongs_to :specialty
  belongs_to :hospital
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy

  def full_name
    "#{user.first_name} #{user.last_name}"
  end
end
