# Hide header/footer when not authenticated; show when authenticated
observe({
  # user_status is defined earlier in your server (values: "unauthenticated", "login", "register", "authenticated")
  if (isTRUE(user_status() == "authenticated")) {
    shinyjs::show("app_header")
    shinyjs::show("app_footer")
  } else {
    shinyjs::hide("app_header")
    shinyjs::hide("app_footer")
  }
})

observe({
  mode <- if (user_status() == "authenticated") "app" else "login"
  session$sendCustomMessage("setLoginMode", ifelse(mode == "login", "login", "app"))
})

