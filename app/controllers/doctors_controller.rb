class DoctorsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @doctors = Doctor.includes(:user, :specialty, :hospital).all
  end
  
  def show
    @doctor = Doctor.includes(:user, :specialty, :hospital, :availabilities).find(params[:id])
    @markers = [
      {
        latitude: @doctor.hospital.latitude,
        longitude: @doctor.hospital.longitude,
        popup_html: render_to_string(partial: "map_popup", locals: { place: @doctor.hospital })
      }
    ]
  end
  
  def search
    @specialties = Specialty.all
    @doctors = DoctorSearchService.new(search_params).call if params[:location].present?
    
    if @doctors && params[:location].present?
      location_coords = Geocoder.coordinates(params[:location])
      @markers = @doctors.map do |doctor|
        {
          latitude: doctor.hospital.latitude,
          longitude: doctor.hospital.longitude,
          popup_html: render_to_string(partial: "map_popup", locals: { place: doctor.hospital })
        }
      end
      @center = { latitude: location_coords[0], longitude: location_coords[1] }
    end
  end
  
  private
  
  def search_params
    params.permit(:location, :specialty_id, :radius)
  end
end