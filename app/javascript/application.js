// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Import Rails UJS for handling DELETE links and other helpers
import Rails from "@rails/ujs"

// Start Rails UJS
Rails.start()
