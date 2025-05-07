import { Controller } from "@hotwired/stimulus"
import L from 'leaflet'

export default class extends Controller {
  static values = {
    latitude: Number,
    longitude: Number,
    markers: Array
  }

  connect() {
    this.map = L.map(this.element).setView([this.latitudeValue, this.longitudeValue], 13)
    
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map)
    
    this.markersValue.forEach(marker => {
      L.marker([marker.latitude, marker.longitude])
        .addTo(this.map)
        .bindPopup(marker.popup)
    })
  }
}