# ==========================================================
# 28_login_page.R - SIMPLIFIED DEBUGGING VERSION
# ==========================================================

# NOTE: Inherits 'user_status', 'authenticated_user', 'f' from app.R

# --- 1. FORM VALIDATION ---
observe({
  req(user_status() == "authenticated") 
  
  required_inputs <- c("school_id", "school_head_contact", "school_head_email")
  
  all_filled <- all(sapply(required_inputs, function(id) {
    !is.null(input[[id]]) && input[[id]] != ""
  }))
  
  school_id_ok <- isTRUE(!is.na(as.numeric(input$school_id)) && nchar(as.character(input$school_id)) == 6)
  contact_ok <- isTRUE(!is.na(as.numeric(input$school_head_contact)) && nchar(as.character(input$school_head_contact)) == 11)
  
  contact_alt_ok <- isTRUE(is.null(input$school_head_contact_alt) || input$school_head_contact_alt == "" || 
                             (!is.na(as.numeric(input$school_head_contact_alt)) && nchar(as.character(input$school_head_contact_alt)) == 11))
  
  email_ok <- isTRUE(grepl("@deped.gov.ph", input$school_head_email))
  email_alt_ok <- isTRUE(is.null(input$school_head_email_alt) || input$school_head_email_alt == "" || grepl("@", input$school_head_email_alt))
  
  all_correct <- school_id_ok && contact_ok && contact_alt_ok && email_ok && email_alt_ok
  
  if (all_filled && all_correct) {
    shinyjs::enable("submit")
  } else {
    shinyjs::disable("submit")
  }
})

# --- 2. LOGIN UI HELPER ---
login_register_UI <- function(id) {
  ns <- NS(id)
  tagList(
    tags$script("Shiny.setInputValue('login_mode_active', true);"),
    div(class = "login-bg gradient-animated"), 
    tags$script(HTML("
      $(document).on('keyup', function(e) {
        if (e.key === 'Enter' || e.keyCode === 13) {
           var loginBtn = $('.btn-enter-login');
           if (loginBtn.length > 0 && loginBtn.is(':visible')) { loginBtn.click(); }
        }
      });
    ")),
    uiOutput(ns("auth_page")) 
  )
}

# --- 3. UI RENDERER ---
output$page_ui <- renderUI({
  if (user_status() == "authenticated") {
    return(NULL) 
  } else {
    session$sendCustomMessage("setLoginMode", "login")
    login_register_UI("auth")
  }
})

# --- 4. ROUTING LOGIC (SIMPLIFIED + DEBUGGING) ---
observeEvent(user_status(), {
  status <- user_status()
  
  # DEBUG: Log logic flow to R Console
  print("==========================================")
  print(paste("🔍 ROUTER CHECK | Status:", status))
  
  # SIMPLIFIED: We only check if status is 'authenticated'. We IGNORE who the user is.
  if (status == "authenticated") {
    
    print("✅ Condition Met: User is Authenticated. Forcing UI to Dashboard...")
    
    # 1. Force Loader to Hide
    session$sendCustomMessage("hideLoader", NULL)
    
    # 2. Tell script.js to unhide the body content
    print("➡️ Sending custom message: setLoginMode = dashboard")
    session$sendCustomMessage("setLoginMode", "dashboard")
    
    # 3. Handle Routing (UNIVERSAL - Applies to everyone for now)
    print("🟢 ROUTING: Showing mgmt_content for ALL authenticated users.")
    
    # DEBUG: Log to Browser Console to check if element exists
    shinyjs::runjs("console.log('🔍 JS DEBUG: Attempting to show #mgmt_content');")
    shinyjs::runjs("console.log('🔍 JS DEBUG: Does #mgmt_content exist?', $('#mgmt_content').length > 0 ? 'YES' : 'NO');")
    shinyjs::runjs("console.log('🔍 JS DEBUG: Current classes:', $('#mgmt_content').attr('class'));")
    
    # Attempt to show mgmt_content
    shinyjs::removeClass(id = "mgmt_content", class = "shinyjs-hide")
    shinyjs::show("mgmt_content")
    
    # Hide others just in case
    shinyjs::hide("data_input_content")
    shinyjs::hide("main_content")
    
    # DEBUG: Check visibility immediately after showing
    shinyjs::runjs("setTimeout(function(){ console.log('🔍 JS DEBUG (After Show): Is visible?', $('#mgmt_content').is(':visible')); }, 500);")
    
  } else {
    print("🔴 ROUTING: Logged out / Unauthenticated.")
    shinyjs::hide("data_input_content")
    shinyjs::hide("mgmt_content")
    shinyjs::hide("main_content")
  }
  print("==========================================")
})

# --- 5. LOGOUT LOGIC ---
observeEvent(input$`main_app-logout`, {
  req(f)
  f$sign_out()
  
  user_status("unauthenticated")
  authenticated_user(NULL)
  form_choice("login")
  
  showNotification("Logged out successfully.", type = "message")
})