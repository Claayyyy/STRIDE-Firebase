# --- 1. Initialize Map ---
output$TextMapping <- renderLeaflet({
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 5) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
    addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright",
               primaryLengthUnit = "kilometers",
               primaryAreaUnit = "sqmeters") %>%
    addLayersControl(baseGroups = c("Satellite", "Road Map"))
})

# --- OBSERVER FOR CLEAR FILTERS BUTTON ---
observeEvent(input$clear_qss_filters, {
  
  # Reset Region
  updatePickerInput(session, "qss_region", selected = character(0))
  
  # Reset Division
  updatePickerInput(session, "qss_division", selected = character(0))
  
  # Reset Legislative District
  updatePickerInput(session, "qss_legdist", selected = character(0))
  
  # Reset Municipality
  updatePickerInput(session, "qss_municipality", selected = character(0))
  
})

# --- 2. Update Picker Choices Dynamically ---

observeEvent(input$search_mode, {
  
  req(!is.null(input$search_mode)) 
  
  if (input$search_mode == FALSE) {
    # --- Switched TO "Simple" ---
    updateTextInput(session, "text_advanced", value = "")
    updatePickerInput(session, "qss_region", selected = character(0))
    updatePickerInput(session, "qss_division", selected = character(0))
    updatePickerInput(session, "qss_legdist", selected = character(0))
    updatePickerInput(session, "qss_municipality", selected = character(0))
    
  } else {
    # --- Switched TO "Advanced" ---
    # Clear the simple input
    updateTextInput(session, "text_simple", value = "")
    
    # --- ADD THIS: Force clear the pickers on entry to Advanced Mode ---
    # This ensures "ABRA" or other defaults are removed immediately
    updatePickerInput(session, "qss_region", selected = character(0))
    updatePickerInput(session, "qss_division", selected = character(0))
    updatePickerInput(session, "qss_legdist", selected = character(0))
    updatePickerInput(session, "qss_municipality", selected = character(0))
  }
}, ignoreNULL = TRUE, ignoreInit = TRUE)

# This creates a 'filtered_data' reactive that changes based on selections
filtered_data_react <- reactive({
  
  data <- uni # Start with the full dataset
  
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  if (!is.null(input$qss_division)) {
    data <- data %>% filter(Division %in% input$qss_division)
  }
  if (!is.null(input$qss_legdist)) {
    data <- data %>% filter(Legislative.District %in% input$qss_legdist)
  }
  
  return(data)
})

# Observe Region input
observeEvent(input$qss_region, {
  data <- uni 
  
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  
  # Update Division - FORCE CLEAR SELECTION
  updatePickerInput(
    session, "qss_division",
    choices = sort(unique(data$Division)),
    selected = character(0) # <--- CHANGED: Forces "Nothing Selected"
  )
  
  # Update LegDist - FORCE CLEAR SELECTION
  updatePickerInput(
    session, "qss_legdist",
    choices = sort(unique(data$Legislative.District)),
    selected = character(0) # <--- CHANGED
  )
  
  # Update Municipality - FORCE CLEAR SELECTION
  updatePickerInput(
    session, "qss_municipality",
    choices = sort(unique(data$Municipality)),
    selected = character(0) # <--- CHANGED
  )
}, ignoreNULL = FALSE, ignoreInit = TRUE)

# Observe Division input
observeEvent(input$qss_division, {
  data <- uni 
  
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  
  if (!is.null(input$qss_division)) {
    data <- data %>% filter(Division %in% input$qss_division)
  }
  
  # Update LegDist - FORCE CLEAR SELECTION
  updatePickerInput(
    session, "qss_legdist",
    choices = sort(unique(data$Legislative.District)),
    selected = character(0) # <--- CHANGED
  )
  
  # Update Municipality - FORCE CLEAR SELECTION
  updatePickerInput(
    session, "qss_municipality",
    choices = sort(unique(data$Municipality)),
    selected = character(0) # <--- CHANGED
  )
}, ignoreNULL = FALSE, ignoreInit = TRUE)

# Observe Legislative District input
observeEvent(input$qss_legdist, {
  data <- uni 
  
  if (!is.null(input$qss_region)) {
    data <- data %>% filter(Region %in% input$qss_region)
  }
  if (!is.null(input$qss_division)) {
    data <- data %>% filter(Division %in% input$qss_division)
  }
  
  if (!is.null(input$qss_legdist)) {
    data <- data %>% filter(Legislative.District %in% input$qss_legdist)
  }
  
  # Update Municipality - FORCE CLEAR SELECTION
  updatePickerInput(
    session, "qss_municipality",
    choices = sort(unique(data$Municipality)),
    selected = character(0) # <--- CHANGED
  )
}, ignoreNULL = FALSE, ignoreInit = TRUE)


# --- 3. Update Button State & Warning Message ---
observe({
  
  req(!is.null(input$search_mode)) 
  is_advanced_mode <- isTRUE(input$search_mode)
  
  # Check if any advanced search *pickers* are filled
  adv_pickers_filled <- !is.null(input$qss_region) || 
    !is.null(input$qss_division) || 
    !is.null(input$qss_legdist) || 
    !is.null(input$qss_municipality)
  
  can_run <- FALSE
  warning_msg <- ""
  
  if (is_advanced_mode) {
    # --- Advanced Mode Logic ---
    txt <- trimws(input$text_advanced) # Read from advanced input
    can_run <- (txt != "" || adv_pickers_filled)
    if (!can_run) {
      warning_msg <- "⚠ Please enter a school name or use advanced search filters."
    }
    
  } else {
    # --- Simple Mode Logic ---
    txt <- trimws(input$text_simple) # Read from simple input
    can_run <- (txt != "")
    if (!can_run) {
      warning_msg <- "⚠ Please enter a school name."
    }
  }
  
  # Enable/disable button
  shinyjs::toggleState("TextRun", condition = can_run)
  
  # Show or hide warning message
  output$text_warning_ui <- renderUI({
    if (!can_run) {
      tags$small(
        style = "color: red; font-style: italic;",
        warning_msg
      )
    } else {
      "" # Clear warning
    }
  })
})


# --- 4. Main Data Filtering (When "Show Selection" is clicked) ---
# --- MODIFIED: Changed from eventReactive to the "Snapshot" pattern ---

# 4a. Create a reactiveVal to store our data "snapshot"
# This val will ONLY be updated when input$TextRun is clicked.
data_snapshot <- reactiveVal(NULL)

# 4b. This observeEvent now does the filtering and PUSHES
#    the result into our data_snapshot()
observeEvent(input$TextRun, {
  
  is_advanced <- isTRUE(input$search_mode)
  
  # --- START: Robust Check ---
  Text_pattern <- "" 
  
  if (is_advanced) {
    if (!is.null(input$text_advanced) && !is.na(input$text_advanced) && input$text_advanced != "") {
      Text_pattern <- trimws(input$text_advanced)
    }
  } else {
    if (!is.null(input$text_simple) && !is.na(input$text_simple) && input$text_simple != "") {
      Text_pattern <- trimws(input$text_simple)
    }
  }
  # --- END: Robust Check ---
  
  filtered_data <- uni
  
  if (Text_pattern != "") {
    filtered_data <- filtered_data %>%
      filter(grepl(Text_pattern, as.character(School.Name), ignore.case = TRUE))
  }
  
  if (is_advanced) {
    
    sel_region <- input$qss_region
    sel_division <- input$qss_division
    sel_legdist <- input$qss_legdist
    sel_municipality <- input$qss_municipality
    
    if (!is.null(sel_region)) {
      filtered_data <- filtered_data %>% filter(Region %in% sel_region)
    }
    if (!is.null(sel_division)) {
      filtered_data <- filtered_data %>% filter(Division %in% sel_division)
    }
    if (!is.null(sel_legdist)) {
      filtered_data <- filtered_data %>% filter(Legislative.District %in% sel_legdist)
    }
    if (!is.null(sel_municipality)) {
      filtered_data <- filtered_data %>% filter(Municipality %in% sel_municipality)
    }
  } 
  
  # Arrange for a clean final table
  final_data <- filtered_data %>% arrange(Region, Division, Municipality, School.Name)
  
  # --- THIS IS THE KEY ---
  # Save the final data to our "snapshot"
  data_snapshot(final_data)
  
}, ignoreNULL = TRUE, ignoreInit = TRUE) # This should listen to the button click


# --- 5. Update Outputs after "Show Selection" is clicked ---
# --- MODIFIED: Now observes data_snapshot() AND removed DT render ---

# This observer will trigger when data_snapshot() (our data) is updated
observe({
  data <- data_snapshot() # <-- CHANGED
  
  # Add a check for the initial NULL state (before any search)
  if (is.null(data)) {
    # This clears the map when the app first loads
    output$text_warning_ui <- renderUI("")
    leafletProxy("TextMapping") %>%
      clearMarkers() %>%
      clearMarkerClusters()
    return()
  }
  
  # Handle no matching results
  if (nrow(data) == 0) {
    output$text_warning_ui <- renderUI({
      tags$small(
        style = "color: red; font-style: italic;",
        "⚠ No results found for the selected criteria."
      )
    })
    leafletProxy("TextMapping") %>%
      clearMarkers() %>%
      clearMarkerClusters()
    return()
  } else {
    # Clear any old warning
    output$text_warning_ui <- renderUI("") 
  }
  
  # --- Create leaflet labels ---
  values.comp <- paste(
    strong("SCHOOL INFORMATION"),
    "<br>School Name:", data$School.Name,
    "<br>School ID:", data$SchoolID
  ) %>% lapply(htmltools::HTML)
  
  # --- Update leaflet map ---
  leafletProxy("TextMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    flyToBounds(
      lng1 = min(data$Longitude), lat1 = min(data$Latitude),
      lng2 = max(data$Longitude), lat2 = max(data$Latitude)
    ) %>%
    addAwesomeMarkers(
      lng = data$Longitude,
      lat = data$Latitude,
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = "blue"
      ),
      label = values.comp,
      labelOptions = labelOptions(
        noHide = FALSE,
        textsize = "12px",
        direction = "top",
        fill = TRUE,
        style = list("border-color" = "rgba(0,0,0,0.5)")
      )
    )
})

# --- Render DataTable ---
# --- MODIFIED: A much more robust way to handle the initial NULL state ---
output$TextTable <- DT::renderDT(server = TRUE, {
  
  # Get the data from our snapshot
  data_from_snapshot <- data_snapshot()
  
  # 1. Check if the snapshot is NULL (on app startup)
  if (is.null(data_from_snapshot)) {
    
    # Create a blank data.frame with the *final* column names
    data_for_table <- data.frame(
      Region = character(0),
      Division = character(0),
      `Legislative.District` = character(0), # Use backticks for safety
      Municipality = character(0),
      School = character(0), # Final column name is "School"
      check.names = FALSE # Prevents R from changing the '.' in "Legislative.District"
    )
    
  } else {
    
    # 2. If we have data, process it
    data_for_table <- data_from_snapshot %>% 
      select(
        "Region", 
        "Division", 
        "Legislative.District", 
        "Municipality", 
        "School.Name" # Select the original column
      ) %>%
      rename("School" = "School.Name") # Rename it
  }
  
  # 3. Pass the prepared data (either blank or full) to datatable()
  datatable(
    data_for_table, 
    extension = 'Buttons',
    rownames = FALSE,
    selection = 'single', 
    options = list(
      scrollX = TRUE,
      pageLength = 10,
      columnDefs = list(list(className = 'dt-center', targets = "_all")),
      dom = 'lrtip'
    ),
    filter = "top"
  )
})

# --- 6. Handle Row Selection (Link Table to Map & Details) ---

# A. Create a Reactive Object for the selected row
# This defines 'qs_data()' which your detail tables below are waiting for.
# --- A. Reactive for Detail Tables (Data Source) ---
# This serves the detail tables (schooldetails_basic, etc.)
qs_data <- reactive({
  
  selected_row_index <- input$TextTable_rows_selected
  req(selected_row_index)
  
  # Get the data that was used to render the table
  table_data <- data_snapshot()
  req(nrow(table_data) > 0)
  
  # Return the specific row data
  return(table_data[selected_row_index, , drop = FALSE])
})

# B. Observe the Selection to Zoom the Map
# --- B. Observe the Selection to Zoom the Map ---
# --- B. Map Zoom Logic (Based on your working code) ---
observeEvent(input$TextTable_rows_selected, {
  
  selected_row_index <- input$TextTable_rows_selected
  req(selected_row_index)
  
  # Get the data that was used to render the table (your current source)
  table_data <- data_snapshot()
  
  # Robustness Check 1: Data exists
  req(nrow(table_data) >= selected_row_index)
  
  selected_row_data <- table_data[selected_row_index, ]
  
  # --- Data Type Conversion (Crucial Step) ---
  current_lat <- as.numeric(selected_row_data$Latitude)
  current_lng <- as.numeric(selected_row_data$Longitude)
  
  # Robustness Check 2: Coordinates are valid
  if (is.na(current_lng) || is.na(current_lat)) {
    # If using shinyjs, you can show a notification
    # showNotification("Selected school has no map coordinates.", type = "warning")
    return() 
  }
  
  # --- *** The Working Leaflet Command *** ---
  leafletProxy("TextMapping") %>% # Changed from "school_map"
    flyTo(
      lng = current_lng,
      lat = current_lat,
      zoom = 15, # Zoom level 15 is a good close-up
      options = leafletOptions(duration = 1)
    )
  
}, ignoreNULL = TRUE, ignoreInit = TRUE)

# --- 3. RENDER THE GRANULAR DETAIL TABLES (NO HEADERS) ---

# Helper function to bold content
make_bold <- function(df) {
  df[] <- lapply(df, function(x) paste0("<strong>", x, "</strong>"))
  return(df)
}

# 1. Basic Information
output$qs_basic <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("School Name", "School ID", "School Head", "Position", "Curricular Offering", "Typology"),
    Value = as.character(c(
      data$School.Name, data$SchoolID, data$School.Head.Name, data$SH.Position, data$Modified.COC, data$School.Size.Typology
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x) # <-- Added colnames = FALSE

output$qs_location <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("Region", "Division", "District", "Municipality","Barangay","Latitude","Longitude"),
    Value = as.character(c(
     data$Region, data$Division, data$District, data$Municipality,
      data$Barangay, data$Latitude, data$Longitude))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x) # <-- Added colnames = FALSE

# 2. Enrolment Profile
output$qs_enrolment <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Level = c("Kinder", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6",
              "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12", "Total Enrolment"),
    Count = as.character(c(
      data$Kinder, data$G1, data$G2, data$G3, data$G4, data$G5, data$G6,
      data$G7, data$G8, data$G9, data$G10, data$G11, data$G12, data$TotalEnrolment
    ))
  )
  df <- df[df$Count != "0" & !is.na(df$Count), ] 
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)

# 3. Teacher Inventory
output$qs_teachers <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("Elementary Teachers", "JHS Teachers", "SHS Teachers", "Total Teachers"),
    Value = as.character(c(
      data$ES.Teachers, data$JHS.Teachers, data$SHS.Teachers, data$TotalTeachers
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)

# 4. Teacher Needs (Shortage/Excess)
output$qs_teacher_needs <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("ES Shortage", "JHS Shortage", "SHS Shortage", "Total Shortage",
               "ES Excess", "JHS Excess", "SHS Excess", "Total Excess"),
    Value = as.character(c(
      data$ES.Shortage, data$JHS.Shortage, data$SHS.Shortage, data$Total.Shortage,
      data$ES.Excess, data$JHS.Excess, data$SHS.Excess, data$Total.Excess
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)

# 5. Classroom Inventory
output$qs_classrooms <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("Total Buildings", "Total Classrooms"),
    Value = as.character(c(
      data$Buildings, data$Instructional.Rooms.2023.2024
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)

# 6. Classroom Needs
output$qs_classroom_needs <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  buildable_val <- if(is.list(data$With_Buildable_space)) unlist(data$With_Buildable_space) else data$With_Buildable_space
  
  df <- data.frame(
    Metric = c("Classroom Requirement", "Estimated Shortage", "Major Repairs Needed", 
               "Shifting Schedule", "Buildable Space Available"),
    Value = as.character(c(
      data$Classroom.Requirement, data$Est.CS, data$Major.Repair.2023.2024,
      data$Shifting, buildable_val
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)

# 7. Utilities & Facilities
output$qs_utilities <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("Electricity Source", "Water Source", "Ownership Type", 
               "Total Seats", "Seats Shortage"),
    Value = as.character(c(
      data$ElectricitySource, data$WaterSource, data$OwnershipType,
      data$Total.Seats.2023.2024, data$Total.Seats.Shortage.2023.2024
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)

# 8. Non-Teaching Personnel
output$qs_ntp <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("AO II Deployment Status", "PDO I Deployment", "COS Status"),
    Value = as.character(c(
      data$Clustering.Status, data$PDOI_Deployment, data$Outlier.Status
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)

# 9. Specialization (JHS/SHS)
output$qs_specialization <- renderTable({
  data <- qs_data(); req(nrow(data) > 0)
  metric_labels <- c("English", "Mathematics", "Science", "Biological Sciences", 
                     "Physical Sciences", "General Education", "Araling Panlipunan", 
                     "TLE", "MAPEH", "Filipino", "ESP", "Agriculture", "ECE", "SPED")
  
  df <- if (!is.na(data$Modified.COC) && data$Modified.COC == "Purely ES") {
    data.frame(Metric = "Note", Value = "Specialization data is not applicable for Purely Elementary Schools.")
  } else {
    data.frame(
      Metric = metric_labels,
      Value = as.character(c(
        data$English, data$Mathematics, data$Science, data$Biological.Sciences,
        data$Physical.Sciences, data$General.Ed, data$Araling.Panlipunan,
        data$TLE, data$MAPEH, data$Filipino, data$ESP, data$Agriculture,
        data$ECE, data$SPED
      ))
    )
  }
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x)


# --- 7. HTML DOWNLOAD HANDLER (Final Version) ---
output$download_school_profile <- downloadHandler(
  filename = function() {
    req(qs_data())
    safe_name <- gsub("[^[:alnum:]]", "_", qs_data()$School.Name)
    paste0("STRIDE_Profile_", safe_name, "_", Sys.Date(), ".html") # <--- .html extension
  },
  
  content = function(file) {
    
    data <- qs_data()
    req(nrow(data) > 0)
    
    # 2. Helper Function (No sanitizer needed for HTML)
    create_filtered_table <- function(metrics, values) {
      df <- data.frame(
        Metric = metrics,
        Value = as.character(values), 
        stringsAsFactors = FALSE
      )
      df %>% 
        filter(!Value %in% c("0", "N/A", "-", "", NA, "NA", "0.0", "0.00")) %>% 
        filter(!is.na(Value))
    }
    
    # 3. Prepare Data Frames
    df_basic <- create_filtered_table(
      c("School Name", "School ID", "School Head", "Position", "Curricular Offering", "Typology", "Region", "Division", "District", "Municipality", "Barangay"),
      c(data$School.Name, data$SchoolID, data$School.Head.Name, data$SH.Position, data$Modified.COC, data$School.Size.Typology, data$Region, data$Division, data$District, data$Municipality, data$Barangay)
    )
    
    df_enrol <- create_filtered_table(
      c("Kinder", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12", "Total Enrolment"),
      c(data$Kinder, data$G1, data$G2, data$G3, data$G4, data$G5, data$G6, data$G7, data$G8, data$G9, data$G10, data$G11, data$G12, data$TotalEnrolment)
    )
    
    df_teachers <- create_filtered_table(
      c("Elementary Teachers", "JHS Teachers", "SHS Teachers", "Total Teachers", "ES Shortage", "JHS Shortage", "SHS Shortage", "Total Shortage", "ES Excess", "JHS Excess", "SHS Excess", "Total Excess"),
      c(data$ES.Teachers, data$JHS.Teachers, data$SHS.Teachers, data$TotalTeachers, data$ES.Shortage, data$JHS.Shortage, data$SHS.Shortage, data$Total.Shortage, data$ES.Excess, data$JHS.Excess, data$SHS.Excess, data$Total.Excess)
    )
    
    buildable_val <- if(is.list(data$With_Buildable_space)) unlist(data$With_Buildable_space) else data$With_Buildable_space
    df_infra <- create_filtered_table(
      c("Total Buildings", "Total Classrooms", "Classroom Requirement", "Estimated Shortage", "Major Repairs Needed", "Shifting Schedule", "Buildable Space Available", "Electricity Source", "Water Source", "Ownership Type", "Total Seats", "Seats Shortage"),
      c(data$Buildings, data$Instructional.Rooms.2023.2024, data$Classroom.Requirement, data$Est.CS, data$Major.Repair.2023.2024, data$Shifting, buildable_val, data$ElectricitySource, data$WaterSource, data$OwnershipType, data$Total.Seats.2023.2024, data$Total.Seats.Shortage.2023.2024)
    )
    
    df_spec <- create_filtered_table(
      c("English", "Mathematics", "Science", "Biological Sciences", "Physical Sciences", "General Education", "Araling Panlipunan", "TLE", "MAPEH", "Filipino", "ESP", "Agriculture", "ECE", "SPED"),
      c(data$English, data$Mathematics, data$Science, data$Biological.Sciences, data$Physical.Sciences, data$General.Ed, data$Araling.Panlipunan, data$TLE, data$MAPEH, data$Filipino, data$ESP, data$Agriculture, data$ECE, data$SPED)
    )
    
    # 4. Render Template
    tempReport <- file.path(tempdir(), "school_profile_template.Rmd")
    if (file.exists("school_profile_template.Rmd")) {
      file.copy("school_profile_template.Rmd", tempReport, overwrite = TRUE)
    } else {
      file.copy("www/school_profile_template.Rmd", tempReport, overwrite = TRUE)
    }
    
    params_list <- list(
      school_name = data$School.Name,
      df_basic = df_basic,
      df_enrol = df_enrol,
      df_teachers = df_teachers,
      df_infra = df_infra,
      df_spec = df_spec
    )
    
    rmarkdown::render(tempReport, output_file = file, params = params_list, envir = new.env(parent = globalenv()))
  }
)