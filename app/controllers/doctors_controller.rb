# app/controllers/doctors_controller.rb
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
    
    if params[:location].present?
      # If location is "current location" with coordinates
      if params[:location].match(/^-?\d+\.\d+,\s*-?\d+\.\d+$/)
        coordinates = params[:location].split(',').map(&:strip).map(&:to_f)
        @current_location = { latitude: coordinates[0], longitude: coordinates[1] }
      else
        # Geocode the address
        @current_location = Geocoder.coordinates(params[:location])
      end
      
      if @current_location
        @doctors = DoctorSearchService.new(search_params.merge(
          latitude: @current_location[0],
          longitude: @current_location[1]
        )).call
        
        @markers = @doctors.map do |doctor|
          {
            latitude: doctor.hospital.latitude,
            longitude: doctor.hospital.longitude,
            popup_html: render_to_string(partial: "map_popup", locals: { place: doctor.hospital })
          }
        end
        
        # Add current location marker
        @markers << {
          latitude: @current_location[0],
          longitude: @current_location[1],
          popup_html: "<div class='p-2'><strong>Your Location</strong><br>#{params[:location]}</div>",
          icon: { iconUrl: ActionController::Base.helpers.asset_path('current_location.png') }
        }
        
        @center = { latitude: @current_location[0], longitude: @current_location[1] }
      end
    end
    
    respond_to do |format|
      format.html
      format.json { render json: { doctors: @doctors, markers: @markers } }
    end
  end
  
  private
  
  def search_params
    params.permit(:location, :specialty_id, :radius)
  end
end