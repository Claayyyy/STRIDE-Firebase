# Authentication Module (Updated with Official Google Styling)

# ==========================================================
# --- AUTHENTICATION MODULE: FIREBASE LOGIN ---
# ==========================================================

authentication_server <- function(input, output, session, user_status, 
                                  authenticated_user, f) {
  ns <- session$ns
  
  # --- 1️⃣ MAIN AUTH PAGE UI ---
  output$auth_page <- renderUI({
    div(
      class = "login-container",
      div(
        class = "login-left",
        div(
          class = "login-text-box text-center",
          div(class = "login-left-logos", tags$img(src = "logo1.png", class = "left-logo")),
          h2(HTML('<img src="Stridelogo1.png" class="stride-logo-i" alt="I Logo">'), class = "stride-logo-text mt-3"),
          p(class = "slogan-mid", "Education in Motion!"),
          div(class = "slogan-bottom-row", span(class = "slogan-left", "Data Precision."), span(class = "slogan-right", "Smart Decision."))
        )
      ),
      div(
        class = "login-right",
        div(
          class = "login-card",
          p(class = "slogan-login-top", "Welcome to STRIDE!"),
          div(class = "slogan-login-bottom", span(class = "slogan-login-bottom", "Please enter your credentials.")),
          
          # Email/Pass Form
          textInput(ns("login_user"), NULL, placeholder = "Email"),
          tags$div(class = "input-group mb-2",
                   tags$input(id = ns("login_pass"), type = "password", class = "form-control", placeholder = "Password"),
                   tags$span(class = "input-group-text toggle-password", `data-target` = ns("login_pass"), HTML('<i class="fa fa-eye" aria-hidden="true"></i>'))
          ),
          
          # Main Sign In Button
          actionButton(ns("do_login"), "Sign In", class = "btn-login w-100 btn-enter-login"),
          
          # --- NEW: OFFICIAL GOOGLE SIGN-IN BUTTON ---
          div(
            style = "margin-top: 15px; margin-bottom: 15px;",
            actionButton(
              ns("google_login_btn"),
              label = HTML('
                <div style="display: flex; align-items: center; justify-content: center;">
                  <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" style="height: 20px; margin-right: 12px; display: block;">
                    <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path>
                    <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path>
                    <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path>
                    <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path>
                  </svg>
                  <span style="font-family: Roboto, arial, sans-serif; font-weight: 500;">Sign in with Google</span>
                </div>
              '),
              class = "btn w-100",
              # Styling: White background, subtle border, shadow, dark grey text
              style = "
                background-color: #ffffff; 
                color: #3c4043; 
                border: 1px solid #dadce0; 
                box-shadow: 0 1px 2px rgba(0,0,0,0.1); 
                transition: background-color .2s, box-shadow .2s;
              "
            ),
            # Add a hover effect script for the Google button specifically
            tags$script(HTML("
              $('#auth-google_login_btn').hover(
                function() { $(this).css({'background-color': '#f7f8f8', 'box-shadow': '0 1px 3px rgba(0,0,0,0.15)'}); },
                function() { $(this).css({'background-color': '#ffffff', 'box-shadow': '0 1px 2px rgba(0,0,0,0.1)'}); }
              );
            "))
          ),
          
          br(),
          actionLink(ns("btn_register"), "Create an account", class = "register-link"),
          br(),
          
          # Error Message Output
          uiOutput(ns("login_message")),
          br(),
          
          # Guest Button (Kept the same)
          div(class = "text-center mt-3",
              actionButton(ns("guest_mode_btn"), "Continue as Guest", class = "w-100 mt-3", 
                           style = "background-color: #e0a800; border-color: #e0a800; color: white; font-weight: 600;")
          ),
          
          div(class = "login-logos-bottom",
              tags$img(src = "logo2.png", class = "bottom-logo"),
              tags$img(src = "HROD LOGO1.png", class = "bottom-logo"),
              tags$img(src = "logo3.png", class = "bottom-logo")
          )
        )
      )
    )
  })
  
  # --- 2️⃣ EMAIL LOGIN LOGIC ---
  observeEvent(input$do_login, {
    req(input$login_user, input$login_pass)
    f$sign_in(input$login_user, input$login_pass)
  })
  
  # --- 3️⃣ GOOGLE LOGIN LOGIC ---
  observeEvent(input$google_login_btn, {
    session$sendCustomMessage("firebase-google-auth", "trigger")
  })
  
  # --- 4️⃣ GUEST MODE LOGIC ---
  observeEvent(input$guest_mode_btn, {
    guest_id <- "guest_user@stride"
    user_status("authenticated")
    authenticated_user(guest_id)
    session$sendCustomMessage("showLoader", "Entering Guest Mode...")
  })
}