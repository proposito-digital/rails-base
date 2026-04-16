// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "preline"

const SIDEBAR_STORAGE_KEY = "admin.sidebar.minified"

const safeCall = (fn) => {
  try {
    fn()
  } catch (_error) {
    // Keep page interactions alive even if another Preline component fails.
  }
}

const readSidebarPreference = () => {
  try {
    return window.localStorage.getItem(SIDEBAR_STORAGE_KEY) === "1"
  } catch (_error) {
    return false
  }
}

const applySidebarPreference = (root = document) => {
  const scope = root && typeof root.querySelector === "function" ? root : document
  const minified = readSidebarPreference()

  const sidebar = scope.querySelector("#hs-application-sidebar")
  if (sidebar) {
    sidebar.classList.toggle("minified", minified)
    sidebar.classList.toggle("w-16", minified)
    sidebar.classList.toggle("w-64", !minified)

    const iconExpand = sidebar.querySelector('[data-sidebar-target="iconExpand"]')
    if (iconExpand) {
      iconExpand.classList.toggle("hidden", !minified)
    }

    const iconCollapse = sidebar.querySelector('[data-sidebar-target="iconCollapse"]')
    if (iconCollapse) {
      iconCollapse.classList.toggle("hidden", minified)
    }

    const toggleButton = sidebar.querySelector('[data-sidebar-target="toggleButton"]')
    if (toggleButton) {
      toggleButton.setAttribute("aria-expanded", String(!minified))
      toggleButton.setAttribute(
        "aria-label",
        minified ? "Expandir menu lateral" : "Recolher menu lateral"
      )
    }
  }

  const adminShell = scope.querySelector("#admin-shell")
  if (adminShell) {
    adminShell.classList.toggle("admin-shell-sidebar-minified", minified)
  }

  const body = root?.tagName === "BODY" ? root : scope.body || document.body
  if (body) {
    body.classList.toggle("hs-overlay-minified", minified)
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

const syncSidebarPreference = () => applySidebarPreference(document)

document.addEventListener("DOMContentLoaded", syncSidebarPreference)
document.addEventListener("turbo:load", syncSidebarPreference)
document.addEventListener("turbo:render", syncSidebarPreference)
document.addEventListener("turbo:before-render", (event) => {
  applySidebarPreference(event.detail.newBody)
})

document.addEventListener("DOMContentLoaded", initPreline)
document.addEventListener("turbo:load", initPreline)
document.addEventListener("turbo:render", initPreline)
document.addEventListener("turbo:frame-load", initPreline)

syncSidebarPreference()
initPreline()
