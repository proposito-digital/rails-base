// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "preline"

document.addEventListener("turbo:load", () => {
  if (window.HSStaticMethods) {
    window.HSStaticMethods.autoInit()
  }
})
