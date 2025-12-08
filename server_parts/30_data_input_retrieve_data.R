# Data Input Fetch Data using School ID

# Run only once when the server starts

# ... (Your validate_numeric_input function goes here) ...
validate_numeric_input <- function(inputId, len) {
  
  
  # --- END OF AUTHENTICATION MODULE ---
  # ==========================================================
  
  
  
  
  
  # Reactive function to read the data (run once when server starts)
  observeEvent(TRUE, {
    # This reads the data and stores it in the reactiveVal
    tryCatch({
      # Use read_sheet to read the data, forcing it to character to match inputs
      data <- read_sheet(
        ss = SHEET_ID, 
        sheet = SHEET_NAME, 
        col_types = "c", # Read all columns as character to prevent type mismatch
        trim_ws = TRUE
      )
      school_data(data)
    }, error = function(e) {
      showModal(modalDialog(
        title = "Authentication Error",
        paste("Failed to read Google Sheet. Check Sheet ID, network, and permissions:", e$message),
        footer = modalButton("Close")
      ))
      # Stop execution if data cannot be loaded
      stop("Sheet read failed.")
    })
  }, once = TRUE) # Run only once when the server starts
  
  # ... (Your validate_numeric_input function goes here) ...
  validate_numeric_input <- function(inputId, len) {
    
    observeEvent(input[[inputId]], {
      
      # Get the value from the input. 
      val_str <- input[[inputId]]
      
      # --- FIX: Check for NULL, Empty String, OR NA ---
      # We must explicitly handle NA before nchar or grepl is called.
      if (is.null(val_str) || val_str == "" || is.na(val_str)) {
        shinyjs::removeClass(id = inputId, class = "input-error")
        return()
      }
      
      # 2. Check if the input contains ONLY digits.
      # We use isTRUE() as a safeguard, just in case grepl returns NA (though unlikely here)
      # is_all_digits will be TRUE or FALSE, never NA.
      is_all_digits <- isTRUE(grepl("^\\d+$", val_str))
      
      # 3. Check the exact character length.
      is_correct_length <- nchar(val_str) == len
      
      # The input is valid only if both conditions are TRUE.
      # R's '&&' is safe because is_all_digits is guaranteed TRUE/FALSE.
      is_valid <- is_all_digits && is_correct_length
      
      if (is_valid) {
        shinyjs::removeClass(id = inputId, class = "input-error")
      } else {
        shinyjs::addClass(id = inputId, class = "input-error")
      }
    }, ignoreNULL = FALSE) 
  }
  # ... (Your validation observers go here) ...
  validate_numeric_input(inputId = "school_id", len = 6)
  validate_numeric_input(inputId = "school_head_contact", len = 11)
  validate_numeric_input(inputId = "school_head_contact_alt", len = 11)
  
  # (Your email validation observers go here - they remain unchanged)
  observeEvent(input$school_head_email, {
    id_val <- input$school_head_email
    is_valid <- (id_val == "" || grepl("@deped.gov.ph", id_val))
    if (is_valid) { shinyjs::removeClass(id = "school_head_email", class = "input-error") } 
    else { shinyjs::addClass(id = "school_head_email", class = "input-error") }
  })
  
  observeEvent(input$school_head_email_alt, {
    id_val <- input$school_head_email_alt
    is_valid <- (id_val == "" || grepl("@", id_val))
    if (is_valid) { shinyjs::removeClass(id = "school_head_email_alt", class = "input-error") } 
    else { shinyjs::addClass(id = "school_head_email_alt", class = "input-error") }
  })
  
  # --- [UPDATED] List of all required input IDs for form data collection ---
  required_inputs <- c(
    # ... (Your required_inputs list remains the same) ...
    "school_id", "school_name", "school_head_gn", "school_head_mn", "school_head_ln",
    "school_head_position", "region", "division", "curricular_offering",
    "school_head_contact","school_head_contact_alt","school_head_email","school_head_email_alt",
    "g1", "g2", "g3", "g4", "g5", "g6", "g7", "g8", "g9", "g10", "g11", "g12",
    "org_g1", "org_g2", "org_g3", "org_g4", "org_g5", "org_g6",
    "org_g7", "org_g8", "org_g9", "org_g10", "org_g11", "org_g12",
    "teaching_elem", "teaching_jhs", "teaching_shs",
    "instructional_rooms_es", "instructional_rooms_jhs", "instructional_rooms_shs",
    "instructional_rooms_repair", "buildings", "buildings_repair",
    "laptops", "laptops_repair", "chairs", "chairs_repair", "desk", "desk_repair",
    "ecart", "ecart_repair", "toilet", "toilet_repair", "printer", "printer_repair",
    "tv", "tv_repair", "science_lab", "computer_lab", "tvl_lab",
    "english", "math", "science", "biological_science", "physical_science",
    "general_education", "araling_panlipunan", "tle", "mapeh", "filipino",
    "esp", "agriculture", "ece", "sped"
  )
  
  # --- Observer to enable/disable the submit button (This remains unchanged) ---
  # ... (Your observe({}) block for submit button logic remains the same) ...
  
  # --- Dynamic UI for Division based on Region selection (Requires 'df' to be defined) ---
  # Assuming 'df' is loaded elsewhere, this part remains unchanged.
  # output$division <- renderUI({ ... })
  
  # --- [REVISED] Observer to auto-load existing school records (From Google Sheet) ---
  observe({
    req(school_data()) # Require that the data has been loaded
    req(input$school_id)
    current_school_id <- debounce(reactive(input$school_id), 500)
    
    if (is.null(current_school_id()) || current_school_id() == "") return()
    
    data_df <- school_data()
    
    # 1. Find the matching row
    # Ensure School ID column is read correctly, assume it's "school_id"
    # We use tolower(names(data_df)) just in case the column name has different case
    match_row <- which(data_df[[tolower("school_id")]] == current_school_id())
    
    if (length(match_row) > 0) {
      # --- IF RECORD FOUND: Load the data ---
      showNotification("Existing school record loaded.", type = "message", duration = 3)
      record_details <- data_df[match_row[1], ] # Use the first match
      
      # 2. Update UI elements using the loaded row
      # Text Inputs
      updateTextInput(session, "school_name", value = record_details$school_name)
      updateTextInput(session, "school_head_gn", value = record_details$school_head_gn)
      updateTextInput(session, "school_head_mn", value = record_details$school_head_mn)
      updateTextInput(session, "school_head_ln", value = record_details$school_head_ln)
      updateTextInput(session, "school_head_contact", value = record_details$school_head_contact)
      updateTextInput(session, "school_head_contact_alt", value = record_details$school_head_contact_alt)
      updateTextInput(session, "school_head_email", value = record_details$school_head_email)
      updateTextInput(session, "school_head_email_alt", value = record_details$school_head_email_alt)
      
      # Select Inputs
      updateSelectInput(session, "school_head_position", selected = record_details$school_head_position)
      updateSelectInput(session, "region", selected = record_details$region)
      # Assuming division updates dynamically based on region, but we update it anyway
      updateSelectInput(session, "division", selected = record_details$division)
      updateSelectInput(session, "curricular_offering", selected = record_details$curricular_offering)
      
      # Numeric Inputs (Using lapply to be concise)
      numeric_ids <- c(
        paste0("g", 1:12), paste0("org_g", 1:12), 
        # ... (rest of your numeric IDs) ...
        "teaching_elem", "teaching_jhs", "teaching_shs",
        "instructional_rooms_es", "instructional_rooms_jhs", "instructional_rooms_shs", 
        "instructional_rooms_repair", "buildings", "buildings_repair",
        "laptops", "laptops_repair", "chairs", "chairs_repair", "desk", "desk_repair",
        "ecart", "ecart_repair", "toilet", "toilet_repair", "printer", "printer_repair",
        "tv", "tv_repair", "science_lab", "computer_lab", "tvl_lab",
        "english", "math", "science", "biological_science", "physical_science",
        "general_education", "araling_panlipunan", "tle", "mapeh", "filipino",
        "esp", "agriculture", "ece", "sped"
      )
      
      lapply(numeric_ids, function(id) {
        # Need to convert loaded value to numeric for updateNumericInput
        updateNumericInput(session, id, value = as.numeric(record_details[[tolower(id)]]))
      })
      
    } else {
      # --- IF NO RECORD FOUND: Clear all fields (same as your original logic) ---
      # ... (Your clear fields logic remains the same) ...
      showNotification("No matching record found. Starting new entry.", type = "warning", duration = 3)
      
      # Text Inputs
      updateTextInput(session, "school_name", value = "")
      updateTextInput(session, "school_head_gn", value = "")
      updateTextInput(session, "school_head_mn", value = "")
      updateTextInput(session, "school_head_ln", value = "")
      updateTextInput(session, "school_head_contact", value = "")
      updateTextInput(session, "school_head_contact_alt", value = "")
      updateTextInput(session, "school_head_email", value = "")
      updateTextInput(session, "school_head_email_alt", value = "")
      
      # Select Inputs (Reset to defaults/prompts)
      updateSelectInput(session, "school_head_position", selected = "School Principal I") 
      updateSelectInput(session, "region", selected = "--- Select a Region ---") # Use the prompt value from your UI
      updateSelectInput(session, "division", selected = NULL)
      updateSelectInput(session, "curricular_offering", selected = "--- Select a Curricular Offering ---") # Use the prompt value
      
      # Numeric Inputs: Clear all numeric fields by setting value = NA
      numeric_ids <- c(
        paste0("g", 1:12), paste0("org_g", 1:12), 
        "teaching_elem", "teaching_jhs", "teaching_shs",
        "instructional_rooms_es", "instructional_rooms_jhs", "instructional_rooms_shs", 
        "instructional_rooms_repair", "buildings", "buildings_repair",
        "laptops", "laptops_repair", "chairs", "chairs_repair", "desk", "desk_repair",
        "ecart", "ecart_repair", "toilet", "toilet_repair", "printer", "printer_repair",
        "tv", "tv_repair", "science_lab", "computer_lab", "tvl_lab",
        "english", "math", "science", "biological_science", "physical_science",
        "general_education", "araling_panlipunan", "tle", "mapeh", "filipino",
        "esp", "agriculture", "ece", "sped"
      )
      
      lapply(numeric_ids, function(id) {
        updateNumericInput(session, id, value = NA) 
      })
    }
  })
  
  
  
  # --- Observer to handle the "Start Over" button (remains unchanged) ---
  observeEvent(input$start_over, {
    session$reload()
  })
  
  
  observeEvent(input$submit, {
    
    # --- DEBUGGING STEP 0 (MOVED OUTSIDE TRY/CATCH) ---
    # If this notification shows, the observeEvent is definitely firing.
    showNotification("--- Submission Triggered! ---", duration = 5, type = "warning")
    
    # --- DEBUGGING STEP 1 (BREAKPOINT) ---
    # If the console stops here, the execution is successful up to this point.
    browser() # Press 'c' and Enter in the console to continue execution.
    
    # Use tryCatch to capture and display any errors during submission
    tryCatch({
      
      # Helper function to convert empty text/NA to a unified NA for sheet
      empty_to_na <- function(x) {
        if (is.character(x) && length(x) == 1 && x == "") {
          return(NA_character_)
        } else if (is.null(x) || is.na(x)) {
          return(NA)
        }
        return(x)
      }
      
      # --- CRITICAL PRE-CHECKS (Verify access to globals) ---
      if (!exists("SHEET_ID") || !exists("SHEET_NAME") || !is.function(school_data) || !exists("sheet_write")) {
        # This will now be caught by the tryCatch block if it runs
        stop("Fatal Error: One or more global dependencies (SHEET_ID, SHEET_NAME, school_data(), sheet_write/sheet_append functions) are missing or inaccessible.")
      }
      
      # Check if a record with the given school_id already exists in the local data
      data_df <- school_data()
      school_id_col <- tolower("school_id")
      
      match_row_index <- which(data_df[[school_id_col]] == input$school_id)
      record_exists <- length(match_row_index) > 0
      
      # Collect all form data into a data frame
      form_data_list <- lapply(required_inputs, function(id) {
        empty_to_na(input[[id]])
      })
      
      # Create the single-row data frame for submission
      new_data <- as.data.frame(form_data_list, stringsAsFactors = FALSE)
      names(new_data) <- required_inputs
      
      # Add a timestamp column (ensure column names match sheet headers)
      new_data$submission_timestamp <- as.character(Sys.time())
      
      if (record_exists) {
        # --- UPDATE existing record (Requires full sheet rewrite) ---
        showNotification(paste("Updating entry for", input$school_name), type = "message", duration = NULL)
        
        # 1. Update the local reactive data frame
        # Replace the row in the local data frame with the new data
        data_df[match_row_index[1], names(new_data)] <- new_data
        
        # 2. Write the entire modified data frame back to the sheet
        # Overwrites the existing sheet content entirely
        sheet_write(
          data = data_df, 
          ss = SHEET_ID, 
          sheet = SHEET_NAME
        )
        
      } else {
        # --- INSERT new record (Use sheet_append) ---
        showNotification(paste("New entry for", input$school_name, "submitted"), type = "message", duration = NULL)
        
        # 1. Append the new data to the sheet
        sheet_append(
          ss = SHEET_ID, 
          sheet = SHEET_NAME, 
          data = new_data
        )
        
        # 2. Update the local reactive data frame with the new row
        school_data(rbind(data_df, new_data))
      }
      
      # --- SUCCESS ACTIONS ---
      showNotification("Submission Complete!", type = "success", duration = 5)
      
      # Hide the form and show a thank you message after submission
      hide("form_container")
      show("thank_you_section")
      
    }, error = function(e) {
      # --- ERROR HANDLING ---
      error_message <- paste("Submission Failed! Details:", e$message)
      warning(error_message) # Log to console
      showNotification(error_message, type = "error", duration = NULL) # Show persistent notification
      
      # Re-enable the form if it was hidden
      show("form_container") 
    })
  })
  
  
  # --- Observer to handle the "Start Over" button (remains unchanged) ---
  observeEvent(input$start_over, {
    session$reload()
  })
  
}