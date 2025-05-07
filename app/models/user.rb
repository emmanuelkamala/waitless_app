class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  #enum role: { patient: 'patient', doctor: 'doctor', hospital_admin: 'hospital_admin', admin: 'admin' }
  attribute :role, :string
  enum :role, %i[patient doctor hospital_admin admin]

  has_one :doctor, dependent: :destroy
  has_many :appointments_as_patient, class_name: 'Appointment', foreign_key: 'patient_id'
  has_many :appointments_as_doctor, through: :doctor, source: :appointments

  #validates :first_name, :last_name, presence: true
end
