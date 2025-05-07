class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :doctor
  belongs_to :hospital

  #enum status: { pending: 'pending', confirmed: 'confirmed', cancelled: 'cancelled', completed: 'completed' }
  attribute :status, :string
  enum :status, %i[pending confirmed cancelled completed]

  validates :appointment_date, presence: true
end
