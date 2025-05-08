# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Specialties
specialties = [
  'Cardiology', 'Dermatology', 'Endocrinology', 'Gastroenterology', 
  'Neurology', 'Oncology', 'Pediatrics', 'Psychiatry', 'Radiology', 'Surgery'
]

specialties.each do |name|
  Specialty.find_or_create_by!(name: name)
end

# Create Admin User
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password'
  user.role = :admin
  user.first_name = 'Admin'
  user.last_name = 'User'
end

# Create Hospitals
hospitals = [
  { name: 'City General Hospital', address: '123 Main St, New York, NY 10001', contact_phone: '212-555-1000', email: 'info@citygeneral.com', website: 'www.citygeneral.com' },
  { name: 'Metropolitan Medical Center', address: '456 Park Ave, New York, NY 10022', contact_phone: '212-555-2000', email: 'info@metromedical.com', website: 'www.metromedical.com' },
  { name: 'Riverside Hospital', address: '789 Riverside Dr, New York, NY 10069', contact_phone: '212-555-3000', email: 'info@riverside.com', website: 'www.riverside.com' }
]

hospital_records = hospitals.map do |hospital|
  Hospital.find_or_create_by!(name: hospital[:name]) do |h|
    h.address = hospital[:address]
    h.contact_phone = hospital[:contact_phone]
    h.email = hospital[:email]
    h.website = hospital[:website]
  end
end

# Create Hospital Admin Users
hospital_admins = [
  { email: 'admin1@citygeneral.com', first_name: 'Hospital', last_name: 'Admin 1', hospital: hospital_records[0] },
  { email: 'admin2@metromedical.com', first_name: 'Hospital', last_name: 'Admin 2', hospital: hospital_records[1] },
  { email: 'admin3@riverside.com', first_name: 'Hospital', last_name: 'Admin 3', hospital: hospital_records[2] }
]

hospital_admins.each do |admin|
  User.find_or_create_by!(email: admin[:email]) do |user|
    user.password = 'password'
    user.role = :hospital_admin
    user.first_name = admin[:first_name]
    user.last_name = admin[:last_name]
  end
end

# Create Doctors
doctors = [
  { email: 'dr.smith@citygeneral.com', first_name: 'John', last_name: 'Smith', specialty: 'Cardiology', hospital: hospital_records[0], bio: 'Cardiologist with 15 years of experience', license_number: 'MD123456' },
  { email: 'dr.johnson@citygeneral.com', first_name: 'Sarah', last_name: 'Johnson', specialty: 'Pediatrics', hospital: hospital_records[0], bio: 'Pediatrician specializing in child development', license_number: 'MD654321' },
  { email: 'dr.williams@metromedical.com', first_name: 'Robert', last_name: 'Williams', specialty: 'Surgery', hospital: hospital_records[1], bio: 'General surgeon with expertise in minimally invasive procedures', license_number: 'MD789012' },
  { email: 'dr.brown@metromedical.com', first_name: 'Emily', last_name: 'Brown', specialty: 'Dermatology', hospital: hospital_records[1], bio: 'Dermatologist focusing on skin cancer prevention', license_number: 'MD210987' },
  { email: 'dr.davis@riverside.com', first_name: 'Michael', last_name: 'Davis', specialty: 'Neurology', hospital: hospital_records[2], bio: 'Neurologist with research interest in neurodegenerative diseases', license_number: 'MD543210' }
]

doctors.each do |doctor|
  user = User.find_or_create_by!(email: doctor[:email]) do |u|
    u.password = 'password'
    u.role = :doctor
    u.first_name = doctor[:first_name]
    u.last_name = doctor[:last_name]
  end

  specialty = Specialty.find_by!(name: doctor[:specialty])
  
  Doctor.find_or_create_by!(user: user) do |d|
    d.specialty = specialty
    d.hospital = doctor[:hospital]
    d.bio = doctor[:bio]
    d.license_number = doctor[:license_number]
  end
end

# Create Patient Users
users = [
  { email: 'patient1@example.com', first_name: 'Alice', last_name: 'Johnson' },
  { email: 'patient2@example.com', first_name: 'Bob', last_name: 'Williams' },
  { email: 'patient3@example.com', first_name: 'Charlie', last_name: 'Brown' }
]

users.each do |u|
  User.find_or_create_by!(email: u[:email]) do |user|
    user.password = 'password'
    user.role = :patient
    user.first_name = u[:first_name]
    user.last_name = u[:last_name]
  end
end

# Create Availabilities
Doctor.all.each do |doctor|
  next if doctor.availabilities.any?
  
  start_time = Time.current.beginning_of_week + 9.hours # Monday 9am
  end_time = start_time + 1.hour
  
  5.times do |day| # Monday to Friday
    8.times do |slot| # 8 slots per day
      Availability.create!(
        doctor: doctor,
        start_time: start_time + day.days + (slot * 1.hour),
        end_time: end_time + day.days + (slot * 1.hour)
      )
    end
  end
end

# Create Appointments
user = User.where(role: 'patient')
doctors = Doctor.all

10.times do |i|
  Appointment.create!(
    user: user.sample,
    doctor: doctors.sample,
    hospital: doctors.sample.hospital,
    appointment_date: Time.current + (i + 1).days + rand(9..17).hours,
    status: ['pending', 'confirmed', 'completed'].sample,
    notes: "Patient complaint: #{Faker::Lorem.sentence}"
  )
end

puts "Seed data created successfully!"