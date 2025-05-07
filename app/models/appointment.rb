class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :doctor
  belongs_to :hospital

  #enum status: { pending: 'pending', confirmed: 'confirmed', cancelled: 'cancelled', completed: 'completed' }
  attribute :status, :string
  enum :status, %i[pending confirmed cancelled completed]

  validates :appointment_date, presence: true

  scope :upcoming, -> { where('appointment_date >= ?', Time.current).order(appointment_date: :asc) }
  scope :recent, -> { where('appointment_date < ?', Time.current).order(appointment_date: :desc) }

end
