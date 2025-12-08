# ===========================================
# GUEST MODE MODULE
# ===========================================

observeEvent(input$guest_mode_btn, {
  showModal(modalDialog(
    title = "Guest Information",
    easyClose = FALSE,
    footer = tagList(
      modalButton("Cancel"),
      shinyjs::disabled(
        actionButton("submit_guest_info", "Continue", class = "btn btn-primary")
      )
    ),
    
    div(class = "centered-modal-content",
        
        textInput("guest_name", "Full Name"),
        
        # --- 💡 MODIFICATION ---
        textInput("guest_email", "Email Address", # Changed label
                  placeholder = "e.g., juan.delacruz@gmail.com"), # Changed placeholder
        # --- END MODIFICATION ---
        
        tags$small(id = "guest_email_msg", 
                   class = "guest-validation-msg"), 
        
        textInput("guest_org", "Organization / Affiliation"),
        
        radioButtons("guest_purpose_choice", "Purpose of Visit:",
                     choices = c("Academic research", 
                                 "Data reference for a report", 
                                 "Dashboard Exploring", 
                                 "Others"),
                     selected = character(0)),
        
        conditionalPanel(
          condition = "input.guest_purpose_choice == 'Others'",
          textAreaInput("guest_purpose_other", "Please specify your purpose:",
                        placeholder = "e.g., I am a stakeholder validating school data for...")
        ),
        
        tags$small(id = "guest_purpose_msg", 
                   class = "guest-validation-msg")
        
    ), 
    
    width = 500
  ))
})

# 💡 REVISED OBSERVER (v7): Validate guest form with NULL check
observe({
  
  # 1. Check Name
  name_ok <- !is.null(input$guest_name) && nzchar(trimws(input$guest_name))
  
  # 2. 💡 MODIFIED: Check Email
  email_val <- input$guest_email
  email_ok <- FALSE  # Default to FALSE
  email_msg <- ""    # Default to no message
  
  if (!is.null(email_val) && nzchar(trimws(email_val))) {
    # If the field is NOT empty, test it
    email_ok <- grepl("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", trimws(email_val))
    if (!email_ok) {
      email_msg <- "Please enter a valid email address."
    }
  }
  # If the field IS empty (NULL or ""), email_ok remains FALSE, and no error message is shown
  shinyjs::html("guest_email_msg", email_msg)
  
  # 3. Check Purpose
  purpose_choice <- input$guest_purpose_choice
  purpose_choice_ok <- !is.null(purpose_choice) && nzchar(purpose_choice)
  
  purpose_ok <- FALSE 
  purpose_msg <- ""    
  
  if (purpose_choice_ok) {
    if (purpose_choice == "Others") {
      purpose_other_val <- trimws(input$guest_purpose_other)
      purpose_length_ok <- nchar(purpose_other_val) >= 10
      purpose_has_vowels <- grepl("[aeiouy]", purpose_other_val, ignore.case = TRUE)
      
      purpose_ok <- purpose_length_ok && purpose_has_vowels
      
      if (!purpose_ok && nzchar(purpose_other_val)) {
        purpose_msg <- "Purpose must be at least 10 characters and include recognizable words (with vowels)."
      }
    } else {
      purpose_ok <- TRUE
    }
  }
  shinyjs::html("guest_purpose_msg", purpose_msg)
  
  # 4. Enable/disable button logic
  if (name_ok && purpose_ok && email_ok) {
    shinyjs::enable("submit_guest_info")
  } else {
    shinyjs::disable("submit_guest_info")
  }
})
# When guest info is submitted
# When guest info is submitted
observeEvent(input$submit_guest_info, {
  
  req(input$guest_name, input$guest_purpose_choice, input$guest_email)
  
  # --- 💡 MODIFICATION: Use the robust regex ---
  if (!grepl("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", trimws(input$guest_email))) {
    showNotification("Please enter a valid email address.", type = "error")
    return() # Stop
  }
  # --- END MODIFICATION ---
  
  # --- Final Purpose Logic ---
  final_purpose <- input$guest_purpose_choice
  
  if (final_purpose == "Others") {
    other_purpose_val <- trimws(input$guest_purpose_other)
    purpose_length_ok <- nchar(other_purpose_val) >= 10
    purpose_has_vowels <- grepl("[aeiouy]", other_purpose_val, ignore.case = TRUE)
    
    if (!(purpose_length_ok && purpose_has_vowels)) {
      showNotification("Please provide a valid purpose (min 10 chars, with vowels).", type = "error")
      return() # Stop
    }
    final_purpose <- other_purpose_val
  }
  
  # --- IP Address Capture ---
  ip_address <- session$request$HTTP_X_FORWARDED_FOR
  if (is.null(ip_address) || ip_address == "") {
    ip_address <- session$clientData$ip
  }
  if (!is.null(ip_address) && grepl(",", ip_address)) {
    ip_address <- strsplit(ip_address, ",")[[1]][1]
  }
  if (is.null(ip_address)) {
    ip_address <- "Not Available"
  }
  
  guest_entry <- tibble::tibble(
    Timestamp = as.character(Sys.time()),
    Name = input$guest_name,
    Email = input$guest_email, 
    Organization = input$guest_org,
    Purpose = final_purpose,
    IP_Address = ip_address
  )
  
  GUEST_SHEET_ID <- "https://docs.google.com/spreadsheets/d/1SvlP7gyfgmymo10hpstKyYs2N9jErCg5tqrmELboTRg/edit?gid=0#gid=0"
  
  tryCatch({
    googlesheets4::sheet_append(ss = GUEST_SHEET_ID, data = guest_entry)
    removeModal()
    showNotification("Guest record saved. Welcome!", type = "message")
    
    user_status("authenticated")
    authenticated_user("guest_user@stride") 
    
  }, error = function(e) {
    showNotification(paste("Error saving to sheet. Details:", e$message),
                     type = "error", duration = 10)
  })
})