// app/javascript/controllers/geolocation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  detect(event) {
    event.preventDefault()
    
    const button = event.currentTarget
    button.disabled = true
    button.innerHTML = `
      <svg class="animate-spin h-5 w-5 text-blue-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    `
    
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => this.handleSuccess(position),
        (error) => this.handleError(error, button),
        { enableHighAccuracy: true, timeout: 10000 }
      )
    } else {
      this.handleError({ message: "Geolocation is not supported by this browser." }, button)
    }
  }

  handleSuccess(position) {
    const latitude = position.coords.latitude
    const longitude = position.coords.longitude
    
    // Reverse geocode to get address
    fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`)
      .then(response => response.json())
      .then(data => {
        let address = ''
        if (data.address) {
          if (data.address.road) address += `${data.address.road}, `
          if (data.address.city) address += `${data.address.city}, `
          if (data.address.state) address += `${data.address.state}, `
          if (data.address.country) address += `${data.address.country}`
        }
        
        if (address === '') {
          address = `${latitude.toFixed(4)}, ${longitude.toFixed(4)}`
        }
        
        this.inputTarget.value = address
        this.inputTarget.dispatchEvent(new Event('input'))
        
        // Re-enable the button
        const button = this.element.querySelector('[data-action="geolocation#detect"]')
        button.disabled = false
        button.innerHTML = `
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
          </svg>
        `
      })
      .catch(error => {
        this.handleError(error, button)
      })
  }

  handleError(error, button) {
    console.error("Geolocation error:", error)
    
    let message = "Unable to detect your location"
    if (error.message.includes("denied")) {
      message = "Location access was denied"
    } else if (error.message.includes("unavailable")) {
      message = "Location information is unavailable"
    } else if (error.message.includes("timeout")) {
      message = "Location request timed out"
    }
    
    // Show error message
    const errorElement = document.createElement('p')
    errorElement.className = 'mt-1 text-xs text-red-600'
    errorElement.textContent = message
    
    const container = this.inputTarget.parentElement
    const existingError = container.querySelector('.error-message')
    if (existingError) existingError.remove()
    
    errorElement.classList.add('error-message')
    container.appendChild(errorElement)
    
    // Re-enable the button
    if (button) {
      button.disabled = false
      button.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M5.05 4.05a7 7 0 119.9 9.9L10 18.9l-4.95-4.95a7 7 0 010-9.9zM10 11a2 2 0 100-4 2 2 0 000 4z" clip-rule="evenodd" />
        </svg>
      `
    }
  }
}