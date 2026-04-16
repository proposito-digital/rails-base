// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "preline"

const SIDEBAR_STORAGE_KEY = "admin.sidebar.minified"
const DESKTOP_MEDIA_QUERY = "(min-width: 1024px)"
const SIDEBAR_SELECTOR = "#hs-application-sidebar"
const SIDEBAR_TOGGLE_SELECTOR = "[data-sidebar-mobile-toggle]"
const MOBILE_SIDEBAR_OPEN_CLASS = "mobile-sidebar-open"
const MOBILE_BACKDROP_ID = "mobile-sidebar-backdrop"
const MOBILE_TRANSITION_MS = 300

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

const isDesktopViewport = () => window.matchMedia(DESKTOP_MEDIA_QUERY).matches

const getSidebarElement = (root = document) => {
  const scope = root && typeof root.querySelector === "function" ? root : document
  return scope.querySelector(SIDEBAR_SELECTOR) || document.querySelector(SIDEBAR_SELECTOR)
}

const getSidebarToggles = () => Array.from(document.querySelectorAll(SIDEBAR_TOGGLE_SELECTOR))

const setSidebarTogglesExpanded = (expanded) => {
  const expandedValue = String(expanded)

  getSidebarToggles().forEach((toggle) => {
    if (!toggle.hasAttribute("aria-expanded")) return
    toggle.setAttribute("aria-expanded", expandedValue)
  })
}

const ensureMobileBackdrop = () => {
  let backdrop = document.getElementById(MOBILE_BACKDROP_ID)
  if (backdrop) return backdrop

  backdrop = document.createElement("div")
  backdrop.id = MOBILE_BACKDROP_ID
  backdrop.className = "fixed inset-0 z-40 hidden bg-slate-900/50 opacity-0 transition-opacity duration-300 lg:hidden"
  backdrop.setAttribute("aria-hidden", "true")
  backdrop.addEventListener("click", () => closeMobileSidebar())

  document.body.appendChild(backdrop)
  return backdrop
}

const hideMobileBackdrop = ({ immediate = false } = {}) => {
  const backdrop = document.getElementById(MOBILE_BACKDROP_ID)
  if (!backdrop) return

  const finalize = () => {
    if (!backdrop.classList.contains("opacity-0")) return
    backdrop.classList.add("hidden")
  }

  if (immediate) {
    backdrop.classList.remove("opacity-100")
    backdrop.classList.add("opacity-0", "hidden")
    return
  }

  backdrop.classList.remove("opacity-100")
  backdrop.classList.add("opacity-0")
  window.setTimeout(finalize, MOBILE_TRANSITION_MS)
}

const showMobileBackdrop = () => {
  const backdrop = ensureMobileBackdrop()

  backdrop.classList.remove("hidden")
  requestAnimationFrame(() => {
    backdrop.classList.remove("opacity-0")
    backdrop.classList.add("opacity-100")
  })
}

const isMobileSidebarOpen = (sidebar = getSidebarElement()) => {
  return Boolean(sidebar && sidebar.classList.contains(MOBILE_SIDEBAR_OPEN_CLASS))
}

const openMobileSidebar = () => {
  const sidebar = getSidebarElement()
  if (!sidebar || isDesktopViewport()) return

  sidebar.classList.remove("hidden", "-translate-x-full")
  sidebar.classList.add("translate-x-0", MOBILE_SIDEBAR_OPEN_CLASS)

  document.body.classList.add("overflow-hidden")
  setSidebarTogglesExpanded(true)
  showMobileBackdrop()
}

const closeMobileSidebar = ({ immediate = false } = {}) => {
  const sidebar = getSidebarElement()
  if (!sidebar) return

  sidebar.classList.remove("translate-x-0", MOBILE_SIDEBAR_OPEN_CLASS)
  sidebar.classList.add("-translate-x-full")

  document.body.classList.remove("overflow-hidden")
  setSidebarTogglesExpanded(false)
  hideMobileBackdrop({ immediate })

  const finalize = () => {
    const currentSidebar = getSidebarElement()
    if (!currentSidebar) return
    if (isDesktopViewport()) return
    if (currentSidebar.classList.contains(MOBILE_SIDEBAR_OPEN_CLASS)) return

    currentSidebar.classList.add("hidden")
  }

  if (immediate) {
    finalize()
    return
  }

  window.setTimeout(finalize, MOBILE_TRANSITION_MS)
}

const toggleMobileSidebar = () => {
  if (isMobileSidebarOpen()) {
    closeMobileSidebar()
  } else {
    openMobileSidebar()
  }
}

const applySidebarPreference = (root = document) => {
  const scope = root && typeof root.querySelector === "function" ? root : document
  const minifiedPreference = readSidebarPreference()
  const desktop = isDesktopViewport()
  const shouldApplyMinifiedLayout = minifiedPreference && desktop

  const sidebar = getSidebarElement(scope)
  if (sidebar) {
    sidebar.classList.toggle("minified", shouldApplyMinifiedLayout)

    // Keep desktop width transitions responsive-aware to avoid fighting base mobile width classes.
    sidebar.classList.toggle("lg:w-16", shouldApplyMinifiedLayout)
    sidebar.classList.toggle("lg:w-64", desktop && !shouldApplyMinifiedLayout)
    sidebar.classList.remove("w-16", "w-64")

    if (!desktop) {
      sidebar.classList.remove("lg:w-16", "lg:w-64")
    }

    safeCall(() => {
      if (typeof window.HSOverlay === "undefined") return
      window.HSOverlay.minify(sidebar, shouldApplyMinifiedLayout)
    })

    const iconExpand = sidebar.querySelector('[data-sidebar-target="iconExpand"]')
    if (iconExpand) {
      iconExpand.classList.toggle("hidden", !minifiedPreference)
    }

    const iconCollapse = sidebar.querySelector('[data-sidebar-target="iconCollapse"]')
    if (iconCollapse) {
      iconCollapse.classList.toggle("hidden", minifiedPreference)
    }

    const toggleButton = sidebar.querySelector('[data-sidebar-target="toggleButton"]')
    if (toggleButton) {
      toggleButton.setAttribute("aria-expanded", String(!minifiedPreference))
      toggleButton.setAttribute(
        "aria-label",
        minifiedPreference ? "Expandir menu lateral" : "Recolher menu lateral"
      )
    }
  }

  const adminShell = scope.querySelector("#admin-shell")
  if (adminShell) {
    adminShell.classList.toggle("admin-shell-sidebar-minified", shouldApplyMinifiedLayout)
  }

  const body = root?.tagName === "BODY" ? root : scope.body || document.body
  if (body) {
    body.classList.toggle("hs-overlay-minified", shouldApplyMinifiedLayout)
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

document.addEventListener("turbo:before-cache", () => {
  closeMobileSidebar({ immediate: true })
})

document.addEventListener(
  "click",
  (event) => {
    if (isDesktopViewport()) return

    const target = event.target
    if (!(target instanceof Element)) return

    const toggle = target.closest(SIDEBAR_TOGGLE_SELECTOR)
    if (!toggle) return

    event.preventDefault()
    event.stopPropagation()
    event.stopImmediatePropagation()

    toggleMobileSidebar()
  },
  true
)

document.addEventListener("keydown", (event) => {
  if (event.key !== "Escape") return
  if (isDesktopViewport()) return

  closeMobileSidebar()
})

document.addEventListener(
  "click",
  (event) => {
    if (isDesktopViewport()) return

    const target = event.target
    if (!(target instanceof Element)) return

    const linkInsideSidebar = target.closest(`${SIDEBAR_SELECTOR} a`)
    if (!linkInsideSidebar) return

    closeMobileSidebar()
  },
  true
)

window.addEventListener("resize", () => {
  if (isDesktopViewport()) {
    closeMobileSidebar({ immediate: true })
  }
})

document.addEventListener("DOMContentLoaded", initPreline)
document.addEventListener("turbo:load", initPreline)
document.addEventListener("turbo:render", initPreline)
document.addEventListener("turbo:frame-load", initPreline)

syncSidebarPreference()
initPreline()
