# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "preline", to: "preline.js", preload: true

pin_all_from "app/javascript/lib/", under: "lib"
pin_all_from "app/javascript/controllers", under: "controllers"
