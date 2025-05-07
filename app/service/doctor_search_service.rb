# app/services/doctor_search_service.rb
class DoctorSearchService
  def initialize(params)
    @specialty_id = params[:specialty_id]
    @location = params[:location]
    @radius = params[:radius] || 10 # default 10 miles
  end

  def call
    doctors = Doctor.includes(:user, :specialty, :hospital)
    
    if @specialty_id.present?
      doctors = doctors.where(specialty_id: @specialty_id)
    end

    if @location.present?
      location_coords = Geocoder.coordinates(@location)
      if location_coords
        doctors = doctors.joins(:hospital).near(location_coords, @radius)
      end
    end

    doctors
  end
end