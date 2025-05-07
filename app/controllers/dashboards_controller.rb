class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    case current_user.role
    when 'patient'
      patient_dashboard
    when 'doctor'
      doctor_dashboard
    when 'hospital_admin'
      hospital_admin_dashboard
    when 'admin'
      admin_dashboard
    end
  end
  
  private
  
  def patient_dashboard
    @upcoming_appointments = current_user.appointments_as_patient.upcoming
    @recent_appointments = current_user.appointments_as_patient.recent.limit(5)
    @appointments = current_user.appointments_as_patient
    render 'patient_dashboard'
  end
  
  def doctor_dashboard
    @upcoming_appointments = current_user.doctor.appointments.upcoming
    @recent_appointments = current_user.doctor.appointments.recent.limit(5)
    @available_slots = current_user.doctor.availabilities.future.count
    @appointments = current_user.doctor.appointments
    render 'doctor_dashboard'
  end
  
  def hospital_admin_dashboard
    @hospital = current_user.hospital
    @upcoming_appointments = @hospital.appointments.upcoming
    @recent_appointments = @hospital.appointments.recent.limit(5)
    @hospital_doctors = @hospital.doctors
    @appointments = @hospital.appointments
    render 'hospital_admin_dashboard'
  end
  
  def admin_dashboard
    @upcoming_appointments = Appointment.upcoming
    @recent_appointments = Appointment.recent.limit(5)
    @appointments = Appointment.all
    render 'admin_dashboard'
  end
end