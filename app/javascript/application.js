// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "preline"

const safeCall = (fn) => {
  try {
    fn()
  } catch (_error) {
    // Keep page interactions alive even if another Preline component fails.
  }
}

const initPreline = () => {
  requestAnimationFrame(() => {
    safeCall(() => {
      if (typeof window.HSStaticMethods === "undefined") return
      window.HSStaticMethods.autoInit()
    })

    safeCall(() => {
      if (typeof window.HSDropdown === "undefined") return
      window.HSDropdown.autoInit()
    })
  })
}

document.addEventListener("DOMContentLoaded", initPreline)
document.addEventListener("turbo:load", initPreline)
document.addEventListener("turbo:render", initPreline)
document.addEventListener("turbo:frame-load", initPreline)

initPreline()
