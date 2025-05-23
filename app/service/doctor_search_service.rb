# app/services/doctor_search_service.rb
class DoctorSearchService
  def initialize(params)
    @specialty_id = params[:specialty_id]
    @location = params[:location]
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    @radius = params[:radius] || 10 # default 10 miles
  end

  def call
    doctors = Doctor.includes(:user, :specialty, :hospital)
    
    if @specialty_id.present?
      doctors = doctors.where(specialty_id: @specialty_id)
    end

    if @latitude.present? && @longitude.present?
      # Search using coordinates
      doctors = doctors.joins(:hospital).near([@latitude, @longitude], @radius)
    elsif @location.present?
      # Fallback to address-based search
      location_coords = Geocoder.coordinates(@location)
      if location_coords
        doctors = doctors.joins(:hospital).near(location_coords, @radius)
      end
    end

    doctors
  end
end