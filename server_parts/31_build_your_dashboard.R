# Build your Dashboard

# --- Drilldown State Management (UPDATED) ---
global_drill_state <- reactiveVal(list(
  level = "Region", 
  region = NULL,    
  division = NULL,
  municipality = NULL,         
  legislative_district = NULL, 
  
  # --- NEW FILTERS ADDED ---
  ownership_filter = NULL,
  electricity_filter = NULL,
  water_filter = NULL,
  buildable_filter = NULL, # <-- NEW: Filter for buildable space
  lms_filter = NULL,
  # --- END NEW FILTERS ---
  
  coc_filter = NULL,      
  typology_filter = NULL, 
  shifting_filter = NULL,
  outlier_filter = NULL,
  clustering_filter = NULL
))
global_trigger <- reactiveVal(0) 

# --- Observer Lifecycle Manager ---
drilldown_observers <- reactiveVal(list())

# --- *** NEW: Reactive to store SchoolID from map or table click *** ---
reactive_selected_school_id <- reactiveVal(NULL)

# --- NEW: Output to power conditionalPanel ---
# This exposes the current drill level to the UI for conditionalPanel
output$current_drill_level <- reactive({
  global_drill_state()$level
})
outputOptions(output, "current_drill_level", suspendWhenHidden = FALSE)


# --- *** NEW: Define Metric Choices for Plot Titles *** ---
# This must match the 'choices' in your 10_stride2_UI.R pickers
hr_metric_choices <- list(
  `School Information` = c("Number of Schools" = "Total.Schools",
                           "School Size Typology" = "School.Size.Typology", 
                           "Curricular Offering" = "Modified.COC",
                           "Shifting" = "Shifting"),
  `Teaching Data` = c("Number of Teachers" = "TotalTeachers", 
                      "Teacher Excess" = "Total.Excess", 
                      "Teacher Shortage" = "Total.Shortage"),
  `Non-teaching Data` = c("COS" = "Outlier.Status", 
                          "AOII Clustering Status" = "Clustering.Status"),
  `Enrolment Data` = c("Total Enrolment" = "TotalEnrolment", "Kinder" = "Kinder", 
                       "Grade 1" = "G1", "Grade 2" = "G2", "Grade 3" = "G3", 
                       "Grade 4" = "G4", "Grade 5" = "G5", "Grade 6" = "G6", 
                       "Grade 7" = "G7", "Grade 8" = "G8", 
                       "Grade 9" = "G9", "Grade 10" = "G10", 
                       "Grade 11" = "G11", "Grade 12" = "G12"),
  `Specialization Data` = c("English" = "English", "Mathematics" = "Mathematics", 
                            "Science" = "Science", 
                            "Biological Sciences" = "Biological.Sciences", 
                            "Physical Sciences" = "Physical.Sciences")
)

infra_metric_choices <- list(
  `Classroom` = c("Number of Classrooms" = "Instructional.Rooms.2023.2024",
                  "Classroom Requirement" =  "Classroom.Requirement",
                  "Last Mile School" = "LMS.School",
                  "Classroom Shortage" = "Classroom.Shortage",
                  "Number of Buildings" = "Buildings",
                  "Buildable Space" = "Buildable_Space", # --- This was your correct change
                  "Major Repairs Needed" = "Major.Repair.2023.2024"),
  `Facilities` = c("Seats Inventory" = "Total.Total.Seat",
                   "Seats Shortage" = "Total.Seats.Shortage"),
  # --- MOVED Resources to categorical ---
  `Resources` = c("Ownership Type" = "OwnershipType",
                  "Electricity Source" = "ElectricitySource",
                  "Water Source" = "WaterSource"
  ))

condition_metric_choices <- list(
  `Building Status` = c("Condemned (Building)" = "Building.Count_Condemned...For.Demolition",
                        "For Condemnation (Building)" = "Building.Count_For.Condemnation",
                        "For Completion (Building)" = "Building.Count_For.Completion",
                        "On-going Construction (Building)" = "Building.Count_On.going.Construction",
                        "Good Condition (Building)" = "Building.Count_Good.Condition",
                        "For Major Repairs (Building)" = "Building.Count_Needs.Major.Repair",
                        "For Minor Repairs (Building)" = "Building.Count_Needs.Minor.Repair"),
  `Classroom Status` = c("Condemned (Classroom)" = "Number.of.Rooms_Condemned...For.Demolition",
                         "For Condemnation (Classroom)" = "Number.of.Rooms_For.Condemnation",
                         "For Completion (Classroom)" = "Number.of.Rooms_For.Completion",
                         "On-going Construction (Classroom)" = "Number.of.Rooms_On.going.Construction",
                         "Good Condition (Classroom)" = "Number.of.Rooms_Good.Condition",
                         "For Major Repairs (Classroom)" = "Number.of.Rooms_Needs.Major.Repair",
                         "For Minor Repairs (Classroom)" = "Number.of.Rooms_Needs.Minor.Repair")
  
)

program_metric_choices <- list(
  "ALS/CLC" = c(
    "ALS/CLC (2024)" = "ALS.CLC_2024_Allocation"
  ),
  "Electrification" = c(
    "Electrification (2017)" = "ELECTRIFICATION.2017",
    "Electrification (2018)" = "ELECTRIFICATION.2018",
    "Electrification (2019)" = "ELECTRIFICATION.2019",
    "Electrification (2023)" = "ELECTRIFICATION.2023",
    "Electrification (2024)" = "ELECTRIFICATION.2024"
  ),
  "Gabaldon" = c(
    "Gabaldon (2020)" = "GABALDON.2020",
    "Gabaldon (2021)" = "GABALDON.2021",
    "Gabaldon (2022)" = "GABALDON.2022",
    "Gabaldon (2023)" = "GABALDON.2023",
    "Gabaldon (2024)" = "GABALDON.2024"
  ),
  "LibHub" = c(
    "LibHub (2024)" = "LibHub.2024"
  ),
  "LMS" = c(
    "LMS (2020)" = "LMS.2020",
    "LMS (2021)" = "LMS.2021",
    "LMS (2022)" = "LMS.2022",
    "LMS (2023)" = "LMS.2023",
    "LMS (2024)" = "LMS.2024"
  ),
  "NC" = c(
    "NC (2014)" = "NC.2014",
    "NC (2015)" = "NC.2015",
    "NC (2016)" = "NC.2016",
    "NC (2017)" = "NC.2017",
    "NC (2018)" = "NC.2018",
    "NC (2019)" = "NC.2019",
    "NC (2020)" = "NC.2020",
    "NC (2021)" = "NC.2021",
    "NC (2023)" = "NC.2023",
    "NC (2024)" = "NC.2024"
  ),
  "QRF" = c(
    "QRF (2019)" = "QRF.2019",
    "QRF (2020)" = "QRF.2020",
    "QRF (2021)" = "QRF.2021",
    "QRF (2022)" = "QRF.2022.REPLENISHMENT",
    "QRF (2023)" = "QRF.2023",
    "QRF (2024)" = "QRF.2024"
  ),
  "Repair" = c(
    "Repair (2020)" = "REPAIR.2020",
    "Repair (2021)" = "REPAIR.2021",
    "Repair (2022)" = "REPAIR.2022",
    "Repair (2023)" = "REPAIR.2023",
    "Repair (2024)" = "REPAIR.2024"
  ),
  "School Health Facilities" = c(
    "Health (2022)" = "SCHOOL.HEALTH.FACILITIES.2022",
    "Health (2024)" = "SCHOOL.HEALTH.FACILITIES.2024"
  ),
  "SPED/ILRC" = c(
    "SPED (2024)" = "SPED.ILRC.2024"
  )
)

# Combine and unlist to create a flat, named vector for lookups
metric_choices <- unlist(c(hr_metric_choices, infra_metric_choices, condition_metric_choices, program_metric_choices))

# --- *** MODIFIED (Change 1 of 3): Added "clean name" lookup vector *** ---
# This list combines all inner vectors, preserving their original, clean names
clean_metric_choices <- c(
  hr_metric_choices$`School Information`,
  hr_metric_choices$`Teaching Data`,
  hr_metric_choices$`Non-teaching Data`,
  hr_metric_choices$`Enrolment Data`,
  hr_metric_choices$`Specialization Data`,
  infra_metric_choices$Classroom,
  infra_metric_choices$Facilities,
  infra_metric_choices$Resources,
  condition_metric_choices$`Building Status`,
  condition_metric_choices$`Classroom Status`,
  program_metric_choices$`ALS/CLC`,
  program_metric_choices$Electrification,
  program_metric_choices$Gabaldon,
  program_metric_choices$LibHub,
  program_metric_choices$LMS,
  program_metric_choices$NC,
  program_metric_choices$QRF,
  program_metric_choices$Repair,
  program_metric_choices$`School Health Facilities`,
  program_metric_choices$`SPED/ILRC`
)


# --- *** NEW: COMBINED METRIC REACTIVE *** ---
all_selected_metrics <- reactive({
  hr_metrics <- input$Combined_HR_Toggles_Build
  infra_metrics <- input$Combined_Infra_Toggles_Build
  condition_metrics <- input$Combined_Conditions_Toggles_Build
  program_metrics <- input$Infra_Programs_Picker_Build # <-- RE-ADDED
  c(hr_metrics, infra_metrics, condition_metrics, program_metrics) # <-- RE-ADDED
})


# --- *** START: PRESET & PICKER SYNC LOGIC *** ---

# --- Define Metric Groups ---
teacher_metrics <- c("TotalTeachers", "Total.Shortage", "Total.Excess")
school_metrics <- c("Total.Schools","School.Size.Typology", "Modified.COC","Shifting") 
classroom_metrics <- c("Instructional.Rooms.2023.2024", "Classroom.Requirement","Classroom.Shortage","Buildable_Space")
enrolment_metrics <- c("G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12")
buildingcondition_metrics <- c("Building.Count_Condemned...For.Demolition","Building.Count_For.Completion",             
                               "Building.Count_For.Condemnation","Building.Count_Good.Condition",             
                               "Building.Count_Needs.Major.Repair","Building.Count_Needs.Minor.Repair",         
                               "Building.Count_On.going.Construction")
roomcondition_metrics <- c("Number.of.Rooms_Condemned...For.Demolition","Number.of.Rooms_For.Completion","Number.of.Rooms_For.Condemnation","Number.of.Rooms_Good.Condition","Number.of.Rooms_Needs.Major.Repair","Number.of.Rooms_Needs.Minor.Repair","Number.of.Rooms_On.going.Construction")

# --- Observer 1: Sync Pickers -> Toggles ---


# --- Observers 2-4: Sync Toggles -> Pickers (Add-only logic) ---

# --- Observers 2-5: Sync Toggles -> Pickers (UPDATED) ---

# --- Observers 2-5: Sync Toggles -> Pickers (UPDATED with Radio-Button Logic) ---

# Preset 1: Teacher Focus Toggle
observeEvent(input$preset_teacher, {
  
  if (input$preset_teacher == TRUE) {
    # --- 1. Turn off all other toggles ---
    updateAwesomeCheckbox(session, "preset_school", value = FALSE)
    updateAwesomeCheckbox(session, "preset_enrolment", value = FALSE)
    updateAwesomeCheckbox(session, "preset_classroom", value = FALSE)
    updateAwesomeCheckbox(session, "preset_buildingcondition", value = FALSE)
    updateAwesomeCheckbox(session, "preset_roomcondition", value = FALSE)
    
    # --- 2. Update Pickers (Set this one, clear others) ---
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = teacher_metrics)
    updatePickerInput(session, "Combined_Infra_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Conditions_Toggles_Build", selected = character(0))
    
  } else {
    # --- User toggled it OFF: Just remove these metrics ---
    current_selection <- isolate(input$Combined_HR_Toggles_Build)
    new_selection <- setdiff(current_selection, teacher_metrics)
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = new_selection)
  }
  
}, ignoreInit = TRUE)

# Preset 2: School Focus Toggle
observeEvent(input$preset_school, {
  
  if (input$preset_school == TRUE) {
    # --- 1. Turn off all other toggles ---
    updateAwesomeCheckbox(session, "preset_teacher", value = FALSE)
    updateAwesomeCheckbox(session, "preset_enrolment", value = FALSE)
    updateAwesomeCheckbox(session, "preset_classroom", value = FALSE)
    updateAwesomeCheckbox(session, "preset_buildingcondition", value = FALSE)
    updateAwesomeCheckbox(session, "preset_roomcondition", value = FALSE)
    
    # --- 2. Update Pickers (Set this one, clear others) ---
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = school_metrics)
    updatePickerInput(session, "Combined_Infra_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Conditions_Toggles_Build", selected = character(0))
    
  } else {
    # --- User toggled it OFF: Just remove these metrics ---
    current_selection <- isolate(input$Combined_HR_Toggles_Build)
    new_selection <- setdiff(current_selection, school_metrics)
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = new_selection)
  }
  
}, ignoreInit = TRUE)


# Preset 3: Infrastructure Focus Toggle
observeEvent(input$preset_classroom, {
  
  if (input$preset_classroom == TRUE) {
    # --- 1. Turn off all other toggles ---
    updateAwesomeCheckbox(session, "preset_teacher", value = FALSE)
    updateAwesomeCheckbox(session, "preset_school", value = FALSE)
    updateAwesomeCheckbox(session, "preset_enrolment", value = FALSE)
    updateAwesomeCheckbox(session, "preset_buildingcondition", value = FALSE)
    updateAwesomeCheckbox(session, "preset_roomcondition", value = FALSE)
    
    # --- 2. Update Pickers (Set this one, clear others) ---
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Infra_Toggles_Build", selected = classroom_metrics)
    updatePickerInput(session, "Combined_Conditions_Toggles_Build", selected = character(0))
    
  } else {
    # --- User toggled it OFF: Just remove these metrics ---
    current_selection <- isolate(input$Combined_Infra_Toggles_Build)
    new_selection <- setdiff(current_selection, classroom_metrics)
    updatePickerInput(session, "Combined_Infra_Toggles_Build", selected = new_selection)
  }
  
}, ignoreInit = TRUE)

# Preset 4: Enrolment Focus Toggle
observeEvent(input$preset_enrolment, {
  
  if (input$preset_enrolment == TRUE) {
    # --- 1. Turn off all other toggles ---
    updateAwesomeCheckbox(session, "preset_teacher", value = FALSE)
    updateAwesomeCheckbox(session, "preset_school", value = FALSE)
    updateAwesomeCheckbox(session, "preset_classroom", value = FALSE)
    updateAwesomeCheckbox(session, "preset_buildingcondition", value = FALSE)
    updateAwesomeCheckbox(session, "preset_roomcondition", value = FALSE)
    
    # --- 2. Update Pickers (Set this one, clear others) ---
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = enrolment_metrics)
    updatePickerInput(session, "Combined_Infra_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Conditions_Toggles_Build", selected = character(0))
    
  } else {
    # --- User toggled it OFF: Just remove these metrics ---
    current_selection <- isolate(input$Combined_HR_Toggles_Build)
    new_selection <- setdiff(current_selection, enrolment_metrics)
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = new_selection)
  }
  
}, ignoreInit = TRUE)

# Preset 5: Building Condition Focus Toggle
observeEvent(input$preset_buildingcondition, {
  
  if (input$preset_buildingcondition == TRUE) {
    # --- 1. Turn off all other toggles ---
    updateAwesomeCheckbox(session, "preset_teacher", value = FALSE)
    updateAwesomeCheckbox(session, "preset_school", value = FALSE)
    updateAwesomeCheckbox(session, "preset_enrolment", value = FALSE)
    updateAwesomeCheckbox(session, "preset_classroom", value = FALSE)
    updateAwesomeCheckbox(session, "preset_roomcondition", value = FALSE)
    
    # --- 2. Update Pickers (Set this one, clear others) ---
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Infra_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Conditions_Toggles_Build", selected = buildingcondition_metrics)
    
  } else {
    # --- User toggled it OFF: Just remove these metrics ---
    current_selection <- isolate(input$Combined_Conditions_Toggles_Build) 
    new_selection <- setdiff(current_selection, buildingcondition_metrics)
    updatePickerInput(session, "Combined_Conditions_Toggles_Toggles_Build", selected = new_selection)
  }
  
}, ignoreInit = TRUE)

# Preset 6: Room Condition Focus Toggle
observeEvent(input$preset_roomcondition, {
  
  if (input$preset_roomcondition == TRUE) {
    # --- 1. Turn off all other toggles ---
    updateAwesomeCheckbox(session, "preset_teacher", value = FALSE)
    updateAwesomeCheckbox(session, "preset_school", value = FALSE)
    updateAwesomeCheckbox(session, "preset_enrolment", value = FALSE)
    updateAwesomeCheckbox(session, "preset_classroom", value = FALSE)
    updateAwesomeCheckbox(session, "preset_buildingcondition", value = FALSE)
    
    # --- 2. Update Pickers (Set this one, clear others) ---
    updatePickerInput(session, "Combined_HR_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Infra_Toggles_Build", selected = character(0))
    updatePickerInput(session, "Combined_Conditions_Toggles_Build", selected = roomcondition_metrics)
    
  } else {
    # --- User toggled it OFF: Just remove these metrics ---
    current_selection <- isolate(input$Combined_Conditions_Toggles_Build) 
    new_selection <- setdiff(current_selection, roomcondition_metrics)
    updatePickerInput(session, "Combined_Conditions_Toggles_Build", selected = new_selection)
  }
  
}, ignoreInit = TRUE)

# --- *** END: PRESET & PICKER SYNC LOGIC *** ---


# --- *** UPDATED: Conditional UI for Data Explorer Tab *** ---
output$data_explorer_content <- renderUI({
  
  state <- global_drill_state()
  
  # Condition: No region is selected (user is at the top level)
  if (state$level == "Region") {
    
    # Render the instruction message
    tags$div(
      class = "d-flex align-items-center justify-content-center",
      style = "height: 60vh; padding: 20px;", 
      bslib::card(
        style = "max-width: 600px;", 
        bslib::card_body(
          h4("Data Explorer", class = "card-title"),
          p("Please go to the ", tags$b("Dashboard Visuals"), " tab and click on a bar in any graph to select a region."),
          p("The map and data table will appear here once you have drilled down into a specific area.")
        )
      )
    )
    
  } else {
    
    # Render the map/table/details UI
    tagList(
      
      # --- SECTION 1: Map and Table (SWAPPED) ---
      bslib::layout_columns(
        col_widths = c(6, 6), 
        
        # --- Column 1: Datatable (MOVED) ---
        bslib::card(
          full_screen = TRUE,
          bslib::card_header("Filtered Data (Click a row)"),
          bslib::card_body(
            DT::dataTableOutput("school_table")
          )
        ),
        
        # --- Column 2: Leaflet Map (MOVED) ---
        bslib::card(
          full_screen = TRUE,
          bslib::card_header("School Map (Click a school)"),
          bslib::card_body(
            leaflet::leafletOutput("school_map", height = "500px") 
          )
        )
      ), # End layout_columns
      
      # --- SECTION 2: School Details ---
      bslib::card(
        full_screen = TRUE,
        card_header(div(strong("School Details"),
                        tags$span(em("(Select a school from the table or map above)"),
                                  style = "font-size: 0.7em; color: grey;"
                        ))),
        card_body(
          uiOutput("build_dashboard_school_details_ui") 
        )
      )
    ) # End tagList
  } # End else
})


# --- Map & Table Server Logic ---
output$school_map <- leaflet::renderLeaflet({
  req(global_trigger() > 0)
  data_to_map_raw <- filtered_data() 
  req(nrow(data_to_map_raw) > 0)
  req("Latitude" %in% names(data_to_map_raw), "Longitude" %in% names(data_to_map_raw))
  
  data_to_map <- data_to_map_raw %>%
    mutate(
      TotalEnrolment = as.numeric(as.character(TotalEnrolment)),
      Instructional.Rooms.2023.2024 = as.numeric(as.character(Instructional.Rooms.2023.2024)),
      TotalTeachers = as.numeric(as.character(TotalTeachers))
    )
  
  leaflet(data_to_map) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
    addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>%
    fitBounds(
      lng1 = min(data_to_map$Longitude, na.rm = TRUE),
      lat1 = min(data_to_map$Latitude, na.rm = TRUE),
      lng2 = max(data_to_map$Longitude, na.rm = TRUE),
      lat2 = max(data_to_map$Latitude, na.rm = TRUE)
    ) %>%
    addMarkers(
      lng = ~Longitude,
      lat = ~Latitude,
      label = ~lapply(paste(
        "<strong>School:</strong>", htmltools::htmlEscape(School.Name),
        "<br/><strong>School ID:</strong>", htmltools::htmlEscape(SchoolID),
        "<br/><strong>Typology:</strong>", htmltools::htmlEscape(School.Size.Typology),
        "<br/><strong>Total Enrolment:</strong>", 
        ifelse(is.na(TotalEnrolment), "N/A", scales::comma(TotalEnrolment, accuracy = 1))
      ), htmltools::HTML),
      labelOptions = labelOptions(noHide = FALSE, direction = 'auto'),
      layerId = ~SchoolID, # --- IMPORTANT: This is the ID we use for clicks ---
      clusterOptions = markerClusterOptions() 
    ) %>% 
    addLayersControl(
      baseGroups = c("Satellite","Road Map"))
})

# --- school_table (Unchanged) ---
# --- school_table (UPDATED) ---
# --- school_table (UPDATED with All Columns & FixedColumns) ---
output$school_table <- DT::renderDataTable({
  req(global_trigger() > 0)
  
  # --- Use filtered_data() directly ---
  data_for_table_raw <- filtered_data() 
  
  # --- ROBUSTNESS: Handle empty data ---
  if (nrow(data_for_table_raw) == 0) {
    return(DT::datatable(
      data.frame(Message = "No data available for the current selection."),
      rownames = FALSE,
      options = list(paging = FALSE, searching = FALSE, info = FALSE)
    ))
  }
  
  # --- NEW: Re-order data to put key columns first for freezing ---
  # This ensures SchoolID and School.Name are the first two columns
  data_for_table <- data_for_table_raw %>%
    dplyr::select(SchoolID, School.Name, dplyr::everything())
  
  DT::datatable(
    data_for_table, # --- CHANGED: Use the full, re-ordered data ---
    selection = 'single', 
    rownames = FALSE,
    extensions = 'FixedColumns', # --- NEW: Add the FixedColumns extension ---
    options = list(
      pageLength = 10,
      scrollY = "400px", 
      scrollCollapse = TRUE,
      paging = TRUE,
      scrollX = TRUE, # --- NEW: Enable horizontal scrolling ---
      fixedColumns = list(leftColumns = 2) # --- NEW: Freeze the 2 left columns ---
    )
  )
})

# --- *** NEW: Observers for Map/Table Clicks *** ---

# --- Observer for Table Clicks (UPDATED) ---
# --- Observer for Table Clicks (UPDATED for robustness) ---
# --- Observer for Table Clicks (NEW ROBUST VERSION + DEBUGGING) ---
# --- Observer for Table Clicks (ROBUST FIX FOR DATA TYPES) ---
# --- Observer for Table Clicks (Using flyTo for robustness) ---
observeEvent(input$school_table_rows_selected, {
  
  selected_row_index <- input$school_table_rows_selected
  req(selected_row_index)
  
  # Get the data that was used to render the table
  table_data <- filtered_data() 
  
  # Robustness Check 1: Index is valid
  if (selected_row_index > nrow(table_data)) {
    showNotification("Error: Table index is out of bounds.", type = "error")
    return()
  }
  
  selected_row_data <- table_data[selected_row_index, ]
  
  # Set the reactive ID for school details
  reactive_selected_school_id(selected_row_data$SchoolID)
  
  # --- Data Type Conversion (Best Practice) ---
  current_lat <- as.numeric(selected_row_data$Latitude)
  current_lng <- as.numeric(selected_row_data$Longitude)
  
  # Robustness Check 2: Coordinates are valid
  if (is.na(current_lng) || is.na(current_lat)) {
    showNotification("Selected school has no map coordinates.", type = "warning")
    return()
  }
  
  # --- *** THE CHANGE: Use flyTo instead of setView *** ---
  leafletProxy("school_map", session) %>%
    flyTo(
      lng = current_lng,
      lat = current_lat,
      zoom = 15,
      options = leafletOptions(duration = 1) # Fly animation in 0.5 sec
    )
  
}, ignoreNULL = TRUE, ignoreInit = TRUE)

# --- Observer for Map Marker Clicks ---
observeEvent(input$school_map_marker_click, {
  clicked_marker <- input$school_map_marker_click
  req(clicked_marker$id) 
  reactive_selected_school_id(clicked_marker$id)
}, ignoreNULL = TRUE, ignoreInit = TRUE)

# --- Observer to clear selection on any data change ---
observeEvent(global_trigger(), {
  reactive_selected_school_id(NULL)
}, ignoreInit = TRUE)


# --- Back Button Logic (UPDATED) ---
# In 31_build_your_dashboard.R

# --- Back Button Logic (UPDATED to support two buttons) ---
output$back_button_ui <- renderUI({
  state <- global_drill_state() 
  
  # --- Logic for Button 1: Undo ---
  undo_button <- NULL # Start as NULL
  undo_button_label <- ""  
  show_undo_button <- FALSE 
  
  # (This is your existing logic, unchanged)
  if (!is.null(state$clustering_filter)) {
    label_text <- stringr::str_trunc(state$clustering_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$outlier_filter)) {
    label_text <- stringr::str_trunc(state$outlier_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$shifting_filter)) {
    label_text <- stringr::str_trunc(state$shifting_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$typology_filter)) {
    label_text <- stringr::str_trunc(state$typology_filter, 20) 
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$coc_filter)) {
    label_text <- stringr::str_trunc(state$coc_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$buildable_filter)) { # --- NEW ---
    label_text <- stringr::str_trunc(state$buildable_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$lms_filter)) { # --- NEW ---
    label_text <- stringr::str_trunc(state$lms_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$water_filter)) { 
    label_text <- stringr::str_trunc(state$water_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$electricity_filter)) { 
    label_text <- stringr::str_trunc(state$electricity_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (!is.null(state$ownership_filter)) { 
    label_text <- stringr::str_trunc(state$ownership_filter, 20)
    undo_button_label <- paste("Undo Filter:", label_text); show_undo_button <- TRUE
  } else if (state$level == "District") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  } else if (state$level == "Legislative.District") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  } else if (state$level == "Municipality") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  } else if (state$level == "Division") {
    undo_button_label <- "Undo Drilldown"; show_undo_button <- TRUE
  }
  
  if (show_undo_button) { 
    undo_button <- actionButton("back_button", undo_button_label, icon = icon("undo"), class = "btn-danger") 
  }
  
  # --- Logic for Button 2: Reset to Region (NEW) ---
  reset_button <- NULL # Start as NULL
  
  # Condition: Show only if level is "beyond Division"
  if (state$level %in% c("Municipality", "Legislative.District", "District")) {
    reset_button <- actionButton(
      "reset_to_region_button", 
      "Go back to Regional View", 
      icon = icon("home"), 
      class = "btn-warning" # Using warning to stand out
    )
  }
  
  # --- Return a tagList of both buttons ---
  # NULL buttons will not be rendered
  tagList(
    undo_button,
    reset_button
  )
})

# --- Back Button Observer (UPDATED) ---
observeEvent(input$back_button, {
  state <- isolate(global_drill_state()) 
  new_state <- state 
  
  # --- UPDATED: Added new filters to precedence list ---
  if (!is.null(state$clustering_filter)) {
    new_state$clustering_filter <- NULL
  } else if (!is.null(state$outlier_filter)) {
    new_state$outlier_filter <- NULL
  } else if (!is.null(state$shifting_filter)) {
    new_state$shifting_filter <- NULL
  } else if (!is.null(state$typology_filter)) {
    new_state$typology_filter <- NULL 
  } else if (!is.null(state$coc_filter)) {
    new_state$coc_filter <- NULL      
  } else if (!is.null(state$buildable_filter)) { # --- NEW ---
    new_state$buildable_filter <- NULL
  } else if (!is.null(state$lms_filter)) { # --- NEW ---
    new_state$lms_filter <- NULL
  } else if (!is.null(state$water_filter)) { 
    new_state$water_filter <- NULL
  } else if (!is.null(state$electricity_filter)) { 
    new_state$electricity_filter <- NULL
  } else if (!is.null(state$ownership_filter)) { 
    new_state$ownership_filter <- NULL
  } else if (state$level == "District") {
    new_state$level <- "Legislative.District"; new_state$legislative_district <- NULL 
  } else if (state$level == "Legislative.District") {
    new_state$level <- "Municipality"; new_state$municipality <- NULL
  } else if (state$level == "Municipality") {
    new_state$level <- "Division"; new_state$division <- NULL
  } else if (state$level == "Division") {
    new_state$level <- "Region"; new_state$region <- NULL
  }
  
  global_drill_state(new_state)
  global_trigger(global_trigger() + 1) 
})

# In 31_build_your_dashboard.R

# --- *** NEW: Reset to Region Button Observer *** ---
observeEvent(input$reset_to_region_button, {
  
  # Define the default (top-level) state
  # This is the same list you use to initialize global_drill_state
  default_state <- list(
    level = "Region", 
    region = NULL,    
    division = NULL,
    municipality = NULL,         
    legislative_district = NULL, 
    ownership_filter = NULL,
    electricity_filter = NULL,
    water_filter = NULL,
    buildable_filter = NULL, # <-- NEW
    lms_filter = NULL,
    coc_filter = NULL,      
    typology_filter = NULL, 
    shifting_filter = NULL,
    outlier_filter = NULL,
    clustering_filter = NULL
  )
  
  # Set the state back to default
  global_drill_state(default_state)
  
  # Increment the trigger to force all elements to update
  global_trigger(global_trigger() + 1) 
  
}, ignoreNULL = TRUE, ignoreInit = TRUE)
# --- *** END NEW OBSERVER *** ---


# --- *** START: FIXED DYNAMIC OBSERVER MANAGER *** ---
observe({
  
  # React to trigger to force re-creation
  global_trigger() 
  
  selected_metrics <- all_selected_metrics() 
  
  # Destroy old observers
  old_handles <- isolate(drilldown_observers())
  walk(old_handles, ~ .x$destroy()) 
  
  # Get the *current* trigger value ONCE
  current_trigger_val <- isolate(global_trigger())
  
  # --- Define dynamic categorical sources ONCE ---
  coc_source <- paste0("coc_pie_click_", current_trigger_val)
  typology_source <- paste0("typology_bar_click_", current_trigger_val)
  shifting_source <- paste0("shifting_bar_click_", current_trigger_val)
  outlier_source <- paste0("outlier_click_", current_trigger_val) 
  clustering_source <- paste0("clustering_click_", current_trigger_val)
  ownership_source <- paste0("ownership_click_", current_trigger_val)
  electricity_source <- paste0("electricity_click_", current_trigger_val)
  water_source <- paste0("water_click_", current_trigger_val)
  buildable_source <- paste0("buildable_click_", current_trigger_val) # <-- NEW
  lms_source <- paste0("lms_click_", current_trigger_val) # <-- NEW
  
  # --- Create a list to hold all new observer handles ---
  new_handles_list <- list()
  
  # --- Create Categorical Filter Observers (ONCE) ---
  
  new_handles_list$coc_observer <- observeEvent(event_data("plotly_click", source = coc_source), {
    d <- event_data("plotly_click", source = coc_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$coc_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$typology_observer <- observeEvent(event_data("plotly_click", source = typology_source), {
    d <- event_data("plotly_click", source = typology_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$typology_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$shifting_observer <- observeEvent(event_data("plotly_click", source = shifting_source), {
    d <- event_data("plotly_click", source = shifting_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$shifting_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$outlier_observer <- observeEvent(event_data("plotly_click", source = outlier_source), {
    d <- event_data("plotly_click", source = outlier_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$outlier_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$clustering_observer <- observeEvent(event_data("plotly_click", source = clustering_source), {
    d <- event_data("plotly_click", source = clustering_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$clustering_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$ownership_observer <- observeEvent(event_data("plotly_click", source = ownership_source), {
    d <- event_data("plotly_click", source = ownership_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$ownership_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$electricity_observer <- observeEvent(event_data("plotly_click", source = electricity_source), {
    d <- event_data("plotly_click", source = electricity_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$electricity_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$water_observer <- observeEvent(event_data("plotly_click", source = water_source), {
    d <- event_data("plotly_click", source = water_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$water_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  # --- NEW: Observer for Buildable Space ---
  new_handles_list$buildable_observer <- observeEvent(event_data("plotly_click", source = buildable_source), {
    d <- event_data("plotly_click", source = buildable_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$buildable_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  new_handles_list$lms_observer <- observeEvent(event_data("plotly_click", source = lms_source), {
    d <- event_data("plotly_click", source = lms_source); if (is.null(d$y)) return()
    state <- isolate(global_drill_state()); state$lms_filter <- d$y
    global_drill_state(state); global_trigger(global_trigger() + 1)
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  
  # --- Create Geographic Drilldown Observers (One per selected metric) ---
  geo_handles <- map(selected_metrics, ~{
    current_metric <- .x
    
    # Define the dynamic geographic source name
    current_metric_source <- paste0("plot_source_", current_metric, "_", current_trigger_val)
    
    # --- Geographic Drilldown Observer ---
    observeEvent(event_data("plotly_click", source = current_metric_source), { 
      state <- isolate(global_drill_state()); if (state$level == "District") return() 
      d <- event_data("plotly_click", source = current_metric_source); if (is.null(d$y)) return()
      
      new_state <- state 
      if (state$level == "Region") {
        new_state$level <- "Division"; new_state$region <- d$y
      } else if (state$level == "Division") {
        new_state$level <- "Municipality"; new_state$division <- d$y
      } else if (state$level == "Municipality") { 
        new_state$level <- "Legislative.District"; new_state$municipality <- d$y
      } else if (state$level == "Legislative.District") { 
        new_state$level <- "District"; new_state$legislative_district <- d$y
      }
      global_drill_state(new_state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
  })
  
  # --- Combine all handles and save them ---
  all_new_handles <- c(new_handles_list, geo_handles)
  drilldown_observers(all_new_handles)
  
})
# --- *** END: FIXED DYNAMIC OBSERVER MANAGER *** ---


# --- Reactive Data (filtered_data) (UPDATED) ---
filtered_data <- reactive({
  trigger <- global_trigger() 
  state <- global_drill_state()
  temp_data <- uni
  
  if (state$level == "Division") {
    req(state$region); temp_data <- temp_data %>% filter(Region == state$region)
  } else if (state$level == "Municipality") { 
    req(state$region, state$division); temp_data <- temp_data %>% filter(Region == state$region, Division == state$division)
  } else if (state$level == "Legislative.District") { 
    req(state$region, state$division, state$municipality); temp_data <- temp_data %>% filter(Region == state$region, Division == state$division, Municipality == state$municipality)
  } else if (state$level == "District") { 
    req(state$region, state$division, state$municipality, state$legislative_district); temp_data <- temp_data %>% filter(Region == state$region, Division == state$division, Municipality == state$municipality, Legislative.District == state$legislative_district)
  }
  
  # --- UPDATED: Added new filters ---
  if (!is.null(state$coc_filter)) { temp_data <- temp_data %>% filter(Modified.COC == state$coc_filter) }
  if (!is.null(state$typology_filter)) { temp_data <- temp_data %>% filter(School.Size.Typology == state$typology_filter) }
  if (!is.null(state$shifting_filter)) { temp_data <- temp_data %>% filter(Shifting == state$shifting_filter) }
  if (!is.null(state$outlier_filter)) { temp_data <- temp_data %>% filter(Outlier.Status == state$outlier_filter) }
  if (!is.null(state$clustering_filter)) { temp_data <- temp_data %>% filter(Clustering.Status == state$clustering_filter) }
  if (!is.null(state$ownership_filter)) { temp_data <- temp_data %>% filter(OwnershipType == state$ownership_filter) } 
  if (!is.null(state$electricity_filter)) { temp_data <- temp_data %>% filter(ElectricitySource == state$electricity_filter) } 
  if (!is.null(state$water_filter)) { temp_data <- temp_data %>% filter(WaterSource == state$water_filter) } 
  if (!is.null(state$buildable_filter)) { temp_data <- temp_data %>% filter(Buildable_Space == state$buildable_filter) } # <-- NEW
  
  temp_data
})

# In 31_build_your_dashboard.R

# ... (put this after your filtered_data reactive) ...

# --- *** NEW: Current Filter Text Display *** ---
# In 31_build_your_dashboard.R

# --- *** NEW: Current Filter Text Display (Corrected) *** ---
output$current_filter_text <- renderText({
  
  # Re-run whenever the state or trigger changes
  global_trigger()
  state <- global_drill_state()
  
  # Start with an empty vector
  filter_parts <- c()
  
  # Add geographic drilldown filters (only if not at the top "Region" level)
  if (state$level != "Region") {
    if (!is.null(state$region)) {
      filter_parts <- c(filter_parts, state$region) # No "Region:" prefix
    }
    if (!is.null(state$division)) {
      filter_parts <- c(filter_parts, state$division) # No "Division:" prefix
    }
    if (!is.null(state$municipality)) {
      filter_parts <- c(filter_parts, state$municipality) # No "Municipality:" prefix
    }
    if (!is.null(state$legislative_district)) {
      filter_parts <- c(filter_parts, state$legislative_district) # No "Leg. District:" prefix
    }
  }
  
  # Add all other categorical filters
  if (!is.null(state$coc_filter)) {
    filter_parts <- c(filter_parts, paste("Offering:", state$coc_filter))
  }
  if (!is.null(state$typology_filter)) {
    filter_parts <- c(filter_parts, paste("Typology:", state$typology_filter))
  }
  if (!is.null(state$shifting_filter)) {
    filter_parts <- c(filter_parts, paste("Shifting:", state$shifting_filter))
  }
  if (!is.null(state$ownership_filter)) {
    filter_parts <- c(filter_parts, paste("Ownership:", state$ownership_filter))
  }
  if (!is.null(state$electricity_filter)) {
    filter_parts <- c(filter_parts, paste("Electricity:", state$electricity_filter))
  }
  if (!is.null(state$water_filter)) {
    filter_parts <- c(filter_parts, paste("Water:", state$water_filter))
  }
  if (!is.null(state$buildable_filter)) { # <-- NEW
    filter_parts <- c(filter_parts, paste("Buildable Space:", state$buildable_filter))
  }
  if (!is.null(state$outlier_filter)) {
    filter_parts <- c(filter_parts, paste("Outlier:", state$outlier_filter))
  }
  if (!is.null(state$clustering_filter)) {
    filter_parts <- c(filter_parts, paste("Clustering:", state$clustering_filter))
  }
  
  # --- *** THIS IS THE FIX *** ---
  # Check if length is 0 (not 1)
  if (length(filter_parts) == 0 && state$level == "Region") {
    # If no filters and at top level
    final_text <- "Viewing All Regions"
  } else {
    # Otherwise, show all active filters separated by " -> "
    final_text <- paste(filter_parts, collapse = " -> ")
  }
  
  # Add the "Current Filter:" prefix
  paste("Current Filter:", final_text)
  
})
# --- *** END CORRECTED SECTION *** ---
# --- *** END NEW SECTION *** ---

# --- Reactive Data (summarized_data_long) (UPDATED) ---
summarized_data_long <- reactive({
  
  selected_metrics_list <- all_selected_metrics()
  # --- MODIFICATION: Check for empty selection ---
  if (length(selected_metrics_list) == 0) {
    # Return an empty tibble with the correct structure
    return(tibble(Category = character(), Metric = character(), Value = numeric()))
  }
  # --- END MODIFICATION ---
  
  state <- global_drill_state() 
  group_by_col <- state$level  
  metrics_to_process <- selected_metrics_list 
  data_in <- filtered_data()
  summaries_list <- list()
  
  if ("Total.Schools" %in% metrics_to_process) {
    school_count_summary <- data_in %>%
      group_by(!!sym(group_by_col)) %>%
      summarise(Value = n(), .groups = "drop") %>% 
      rename(Category = !!sym(group_by_col)) %>%
      mutate(Metric = "Total.Schools") 
    summaries_list[["school_count"]] <- school_count_summary
  }
  
  # --- UPDATED: Added new metrics to categorical list ---
  categorical_metrics <- c("Modified.COC", "School.Size.Typology", "Total.Schools","Shifting", "Completion",
                           "Outlier.Status", "Clustering.Status", "OwnershipType", "ElectricitySource", "WaterSource") # <-- NEW
  
  numeric_metrics_to_process <- setdiff(metrics_to_process, categorical_metrics)
  existing_metrics <- intersect(numeric_metrics_to_process, names(data_in))
  
  if (length(existing_metrics) > 0) {
    data_in <- data_in %>%
      mutate(across(all_of(existing_metrics), ~ as.numeric(as.character(.))))
    
    valid_metrics <- existing_metrics[sapply(data_in[existing_metrics], is.numeric)]
    
    if (length(valid_metrics) > 0) {
      numeric_summary <- data_in %>%
        select(!!sym(group_by_col), all_of(valid_metrics)) %>%
        pivot_longer(cols = all_of(valid_metrics), names_to = "Metric", values_to = "Value") %>%
        group_by(!!sym(group_by_col), Metric) %>%
        summarise(Value = sum(Value, na.rm = TRUE), .groups = "drop") %>%
        rename(Category = !!sym(group_by_col))
      summaries_list[["numeric_metrics"]] <- numeric_summary
    }
  }
  
  if (length(summaries_list) == 0) {
    return(tibble(Category = character(), Metric = character(), Value = numeric()))
  }
  
  bind_rows(summaries_list)
})


# --- Dynamic UI Dashboard Grid (FIXED) ---
output$dashboard_grid <- renderUI({
  
  selected_metrics <- all_selected_metrics() 
  
  if (length(selected_metrics) == 0) {
    return(
      tags$div(
        class = "d-flex align-items-center justify-content-center", style = "height: 60vh; padding: 20px;", 
        bslib::card(
          style = "max-width: 600px;", 
          bslib::card_body(
            h4("Welcome to your Dashboard!", class = "card-title"),
            p("Welcome to this Interactive Education Resource Dashboard."),
            p("Start by selecting any of the presets or choosing from the advanced filters available on the sidebar to build your view.")
          )
        )
      )
    )
  }
  
  # --- *** Pre-filter data for plots *** ---
  metric_plot_data <- summarized_data_long()
  
  # --- 1. Create Plotly Renders ---
  walk(selected_metrics, ~{
    current_metric <- .x
    
    # <-- BUG FIX (Change 3): Get current trigger value
    current_trigger_val <- isolate(global_trigger())
    
    # --- *** MODIFIED (Change 2 of 3): Use clean_metric_choices *** ---
    current_metric_name <- names(clean_metric_choices)[clean_metric_choices == current_metric]
    
    state <- global_drill_state()
    level_name <- stringr::str_to_title(state$level) 
    plot_title <- current_metric_name 
    
    if (state$level == "Region") {
      plot_title <- paste(plot_title, "by", level_name)
    } else if (state$level == "Division") {
      plot_title <- paste(plot_title, "by", level_name, "in", state$region)
    } else if (state$level == "Municipality") { 
      plot_title <- paste(plot_title, "by", level_name, "in", state$division)
    } else if (state$level == "Legislative.District") { 
      plot_title <- paste(plot_title, "by", level_name, "in", state$municipality)
    } else if (state$level == "District") { 
      plot_title <- paste(plot_title, "by", level_name, "in", state$legislative_district)
    }
    
    filter_parts <- c()
    if (!is.null(state$coc_filter)) { filter_parts <- c(filter_parts, state$coc_filter) }
    if (!is.null(state$typology_filter)) { filter_parts <- c(filter_parts, state$typology_filter) }
    if (!is.null(state$shifting_filter)) { filter_parts <- c(filter_parts, state$shifting_filter) }
    if (!is.null(state$outlier_filter)) { filter_parts <- c(filter_parts, state$outlier_filter) }
    if (!is.null(state$clustering_filter)) { filter_parts <- c(filter_parts, state$clustering_filter) }
    if (!is.null(state$ownership_filter)) { filter_parts <- c(filter_parts, state$ownership_filter) } 
    if (!is.null(state$electricity_filter)) { filter_parts <- c(filter_parts, state$electricity_filter) } 
    if (!is.null(state$water_filter)) { filter_parts <- c(filter_parts, state$water_filter) } 
    if (!is.null(state$buildable_filter)) { filter_parts <- c(filter_parts, state$buildable_filter) } # <-- NEW
    
    if (length(filter_parts) > 0) {
      plot_title <- paste0(plot_title, " (Filtered by: ", paste(filter_parts, collapse = ", "), ")")
    }
    
    # --- UPDATED IF CONDITION (Added Buildable_Space) ---
    if (current_metric %in% c("Modified.COC", "School.Size.Typology", "Shifting", "Total.Schools", "Completion", 
                              "Outlier.Status", "Clustering.Status", "OwnershipType", "ElectricitySource", "WaterSource")) { # <-- NEW
      
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          bar_data <- tibble() 
          if (current_metric == "Total.Schools") {
            bar_data <- metric_plot_data %>%
              filter(Metric == "Total.Schools", !is.na(Category)) %>%
              rename(Count = Value) 
          } else {
            
            # --- PREVIOUS LOGIC (Keep your existing filtering logic here) ---
            state <- global_drill_state()
            data_for_this_plot <- uni
            
            # ... (Keep all your existing Geographic and Categorical filters here) ...
            if (state$level == "Division") {
              req(state$region); data_for_this_plot <- data_for_this_plot %>% filter(Region == state$region)
            } else if (state$level == "Municipality") { 
              req(state$region, state$division); data_for_this_plot <- data_for_this_plot %>% filter(Region == state$region, Division == state$division)
            } else if (state$level == "Legislative.District") { 
              req(state$region, state$division, state$municipality); data_for_this_plot <- data_for_this_plot %>% filter(Region == state$region, Division == state$division, Municipality == state$municipality)
            } else if (state$level == "District") { 
              req(state$region, state$division, state$municipality, state$legislative_district); data_for_this_plot <- data_for_this_plot %>% filter(Region == state$region, Division == state$division, Municipality == state$municipality, Legislative.District == state$legislative_district)
            }
            
            # ... (Keep the rest of your categorical filters here: COC, Typology, etc.) ...
            if (!is.null(state$coc_filter) && current_metric != "Modified.COC") { data_for_this_plot <- data_for_this_plot %>% filter(Modified.COC == state$coc_filter) }
            if (!is.null(state$typology_filter) && current_metric != "School.Size.Typology") { data_for_this_plot <- data_for_this_plot %>% filter(School.Size.Typology == state$typology_filter) }
            if (!is.null(state$shifting_filter) && current_metric != "Shifting") { data_for_this_plot <- data_for_this_plot %>% filter(Shifting == state$shifting_filter) }
            if (!is.null(state$outlier_filter) && current_metric != "Outlier.Status") { data_for_this_plot <- data_for_this_plot %>% filter(Outlier.Status == state$outlier_filter) }
            if (!is.null(state$clustering_filter) && current_metric != "Clustering.Status") { data_for_this_plot <- data_for_this_plot %>% filter(Clustering.Status == state$clustering_filter) }
            if (!is.null(state$ownership_filter) && current_metric != "OwnershipType") { data_for_this_plot <- data_for_this_plot %>% filter(OwnershipType == state$ownership_filter) }
            if (!is.null(state$electricity_filter) && current_metric != "ElectricitySource") { data_for_this_plot <- data_for_this_plot %>% filter(ElectricitySource == state$electricity_filter) }
            if (!is.null(state$water_filter) && current_metric != "WaterSource") { data_for_this_plot <- data_for_this_plot %>% filter(WaterSource == state$water_filter) }
            if (!is.null(state$buildable_filter) && current_metric != "Buildable_Space") { data_for_this_plot <- data_for_this_plot %>% filter(Buildable_Space == state$buildable_filter) } 
            
            if (nrow(data_for_this_plot) > 0) {
              if (current_metric == "Buildable_Space") {
                bar_data <- data_for_this_plot %>%
                  mutate(Category = unlist(!!sym(current_metric))) %>% 
                  count(Category, name = "Count") %>%
                  filter(!is.na(Category))
              } else {
                bar_data <- data_for_this_plot %>%
                  count(!!sym(current_metric), name = "Count") %>%
                  filter(!is.na(!!sym(current_metric))) %>%
                  rename(Category = !!sym(current_metric)) 
              }
            }
          }
          
          if (nrow(bar_data) == 0) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          # --- NEW: Calculate Max Range with Buffer ---
          max_val <- max(bar_data$Count, na.rm = TRUE)
          x_range_limit <- c(0, max_val * 1.35) # Adds 35% buffer to the right
          
          # Source name generation (Keep existing)
          plot_source <- dplyr::case_when(
            current_metric == "Modified.COC" ~ paste0("coc_pie_click_", current_trigger_val),
            current_metric == "School.Size.Typology" ~ paste0("typology_bar_click_", current_trigger_val),
            current_metric == "Shifting" ~ paste0("shifting_bar_click_", current_trigger_val),
            current_metric == "Outlier.Status" ~ paste0("outlier_click_", current_trigger_val), 
            current_metric == "Clustering.Status" ~ paste0("clustering_click_", current_trigger_val),
            current_metric == "OwnershipType" ~ paste0("ownership_click_", current_trigger_val),
            current_metric == "ElectricitySource" ~ paste0("electricity_click_", current_trigger_val),
            current_metric == "WaterSource" ~ paste0("water_click_", current_trigger_val),
            current_metric == "Buildable_Space" ~ paste0("buildable_click_", current_trigger_val),
            current_metric == "LMS.School" ~ paste0("lms_click_", current_trigger_val),
            TRUE ~ paste0("plot_source_", current_metric, "_", current_trigger_val) 
          )
          
          plot_ly(
            data = bar_data, y = ~Category, x = ~Count,
            type = "bar", orientation = 'h', name = current_metric_name,
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10),
            source = plot_source
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), 
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              # --- MODIFIED XAXIS ---
              xaxis = list(title = "Total Count", tickformat = ',.0f', range = x_range_limit), 
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.02),
              margin = list(l = 150) 
            )
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
      
    } else {
      # --- RENDER DEFAULT DRILLDOWN BAR CHART (Unchanged) ---
      # --- *** PROGRAM COLUMNS WILL NOW BE RENDERED HERE *** ---
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          plot_data <- metric_plot_data %>%
            filter(Metric == current_metric, !is.na(Category))
          
          if (nrow(plot_data) == 0 || all(is.na(plot_data$Value))) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          xaxis_range <- c(0, max(plot_data$Value, na.rm = TRUE) * 1.3)
          
          plot_ly(
            data = plot_data, y = ~Category, x = ~Value, type = "bar",
            orientation = 'h', name = current_metric_name,
            
            # <-- BUG FIX (Change 3): Make plot source name dynamic
            source = paste0("plot_source_", current_metric, "_", current_trigger_val), 
            
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10)
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), 
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed", automargin = TRUE),
              xaxis = list(title = "Total Value", tickformat = ',.0f', range = xaxis_range),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.02),
              margin = list(t = 50, r = 20, b = 50)
            )
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
    }
  })
  
  # --- 2. Create the UI Card Elements ---
  # --- 3. Create the UI Card Elements ---
  plot_cards <- map(selected_metrics, ~{
    current_metric <- .x
    # --- *** MODIFIED (Change 3 of 3): Use clean_metric_choices *** ---
    current_metric_name <- names(clean_metric_choices)[clean_metric_choices == current_metric]
    summary_card_content <- NULL
    
    # --- UPDATED IF CONDITION (Added Buildable_Space) ---
    if (current_metric %in% c("Modified.COC", "School.Size.Typology", "Shifting", "Total.Schools", "Completion", 
                              "Outlier.Status", "Clustering.Status", "OwnershipType", "ElectricitySource", "WaterSource", "Buildable_Space")) { # <-- ADDED Buildable_Space here
      
      total_count <- tryCatch({
        if (current_metric == "Total.Schools") {
          metric_plot_data %>% filter(Metric == "Total.Schools") %>% pull(Value) %>% sum(na.rm = TRUE)
        } else {
          # --- FIX START: Accurate Count Excluding NAs ---
          # Get the data currently filtered by drilldown/sidebar
          data_for_count <- filtered_data()
          
          if (current_metric == "Buildable_Space") {
            # Special handling for list-column: Unlist and count non-NAs
            data_for_count %>%
              mutate(Category = unlist(Buildable_Space)) %>%
              filter(!is.na(Category)) %>%
              nrow()
          } else {
            # Standard columns: Filter where the specific metric is NOT NA, then count
            data_for_count %>%
              filter(!is.na(!!sym(current_metric))) %>%
              nrow()
          }
          # --- FIX END ---
        }
      }, error = function(e) { 0 }) 
      
      summary_title <- if (current_metric == "Total.Schools") paste("Total", current_metric_name) else "Total Records in View"
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light yellow, tight padding
        tags$h5(
          summary_title, 
          style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        ),
        tags$h2(
          scales::comma(total_count), 
          style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        )
      )
      
    } else {
      # --- *** PROGRAM COLUMNS WILL NOW BE HANDLED HERE *** ---
      total_val <- tryCatch({
        metric_plot_data %>% filter(Metric == current_metric) %>% pull(Value) %>% sum(na.rm = TRUE)
      }, error = function(e) { 0 }) 
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light yellow, tight padding
        tags$h5(
          paste("Total", current_metric_name), 
          style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        ),
        tags$h2(
          scales::comma(total_val), 
          style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        )
      )
    }
    
    bslib::card(
      full_screen = TRUE,
      card_header(current_metric_name),
      card_body(
        tags$div(style = "text-align: center; padding-bottom: 10px;", summary_card_content),
        plotlyOutput(paste0("plot_", .x), width = "100%", height = "100%") 
      )
    )
  })
  
  # --- 3. Arrange the cards into the layout (Logic Unchanged) ---
  plot_grid <- do.call(bslib::layout_columns, c(list(col_widths = 4), plot_cards))
  tagList(
    tags$h3("Interactive Education Resource Dashboard", style = "text-align: center; font-weight: bold; margin-bottom: 20px;"),
    tags$div(
      style = "text-align: center; font-size: 1.1em; font-weight: 500; color: #333; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 5px; padding: 10px; margin-bottom: 20px;",
      textOutput("current_filter_text")
    ),
    plot_grid 
  )
})


# --- *** NEW: School Details Logic for Build Your Dashboard *** ---

# --- 1. Reactive to get the full data for the selected school (UPDATED) ---
selected_school_data <- reactive({
  # Require the new reactiveVal to have a value
  req(reactive_selected_school_id())
  selected_id <- reactive_selected_school_id()
  
  # Filter the main 'uni' dataframe for this one school.
  uni %>% filter(SchoolID == selected_id)
})


# --- 2. Dynamic UI to show prompt or detail tables (UPDATED: GRANULAR VIEW) ---
output$build_dashboard_school_details_ui <- renderUI({
  
  # Check the reactiveVal
  if (is.null(reactive_selected_school_id())) {
    return(
      tags$div(
        style = "padding: 20px; text-align: center; color: #6c757d;",
        bs_icon("info-circle", size = "2em"),
        h5("Click a school in the 'Filtered Data' table or on the map to load its details here.")
      )
    )
  }
  
  # If a school IS selected, show the granular layout
  tagList(
    # Row 1: Basic Info (Full Width)
    layout_columns(
      col_widths = c(6,6),
      card(
        full_screen = TRUE,
        card_header(strong("Basic Information")),
        tableOutput("schooldetails_basic")),
      card(
        full_screen = TRUE,
        card_header(strong("Location")),
        tableOutput("schooldetails_location"))),
      
    
    
    # Row 2: Learners & Teachers
    layout_columns(
      col_widths = c(4, 4, 4),
      
      card(full_screen = TRUE,
           card_header(strong("Enrolment Profile")),
           tableOutput("schooldetails_enrolment")),
      
      card(full_screen = TRUE,
           card_header(strong("Teacher Inventory")),
           tableOutput("schooldetails_teachers")),
      
      card(full_screen = TRUE,
           card_header(strong("Teacher Needs")),
           tableOutput("schooldetails_teacher_needs"))
    ),
    
    # Row 3: Infrastructure
    layout_columns(
      col_widths = c(4, 4, 4),
      
      card(full_screen = TRUE,
           card_header(strong("Classroom Inventory")),
           tableOutput("schooldetails_classrooms")),
      
      card(full_screen = TRUE,
           card_header(strong("Classroom Needs")),
           tableOutput("schooldetails_classroom_needs")),
      
      card(full_screen = TRUE,
           card_header(strong("Utilities & Facilities")),
           tableOutput("schooldetails_utilities"))
    ),
    
    # Row 4: Others
    layout_columns(
      col_widths = c(6, 6),
      
      card(full_screen = TRUE,
           card_header(strong("Non-Teaching Personnel")),
           tableOutput("schooldetails_ntp")),
      
      card(full_screen = TRUE,
           card_header(div(strong("Specialization Data"),
                           tags$span(em("(JHS/SHS Only)"), style = "font-size: 0.7em; color: grey;"))),
           tableOutput("schooldetails_specialization"))
    )
  )
})

# --- 3. RENDER THE GRANULAR DETAIL TABLES (NO HEADERS) ---

# Helper function to bold content
make_bold <- function(df) {
  df[] <- lapply(df, function(x) paste0("<strong>", x, "</strong>"))
  return(df)
}

# 1. Basic Information
output$schooldetails_basic <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("School Name", "School ID", "School Head", "Position", "Curricular Offering", "Typology"),
    Value = as.character(c(
      data$School.Name, data$SchoolID, data$School.Head.Name, data$SH.Position, data$Modified.COC, data$School.Size.Typology
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x) # <-- Added colnames = FALSE

output$schooldetails_location <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  df <- data.frame(
    Metric = c("Region", "Division", "District", "Municipality", 
               "Barangay"),
    Value = as.character(c(
     data$Region, data$Division, data$District, data$Municipality, data$Barangay
    ))
  )
  make_bold(df)
}, striped = TRUE, hover = TRUE, bordered = TRUE, width = "100%", 
align = 'c', colnames = FALSE, sanitize.text.function = function(x) x) # <-- Added colnames = FALSE

# 2. Enrolment Profile
output$schooldetails_enrolment <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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
output$schooldetails_teachers <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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
output$schooldetails_teacher_needs <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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
output$schooldetails_classrooms <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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
output$schooldetails_classroom_needs <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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
output$schooldetails_utilities <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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
output$schooldetails_ntp <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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
output$schooldetails_specialization <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
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

# =======================================================
#  STRIDE CHATBOT LOGIC (V6 - ROBUST & SELF-HEALING)
# =======================================================

# Debug Message (Check your RStudio Console to see if this prints)
print("STRIDE CHATBOT: Loading Logic...")

# 1. Initialize Chat History
chat_state <- reactiveValues(
  history = list(
    list(role = "bot", content = "<b>Hello! I am STRIDER</b> 👋<br>I can analyze the entire STRIDE database.<br>Try: <i>'Highest STEM enrollment in Region VII'</i>")
  )
)

# 2. Render Chat Interface
output$chat_ui_container <- renderUI({
  tags$div(class = "chat-history",
           lapply(chat_state$history, function(msg) {
             tags$div(class = paste0("msg-row ", msg$role),
                      tags$div(class = "msg-bubble", HTML(msg$content))
             )
           })
  )
})

# 3. Handle 'Send' Button
observeEvent(input$chat_send_btn, {
  print("CHATBOT: Button Clicked!") # Debug Print
  
  user_text <- trimws(input$chat_msg_input)
  req(user_text != "")
  
  # A. Add User Message
  chat_state$history[[length(chat_state$history) + 1]] <- list(role = "user", content = user_text)
  
  # B. Clear Input
  updateTextInput(session, "chat_msg_input", value = "")
  
  # C. Process Logic
  bot_reply <- "Thinking..."
  
  tryCatch({
    if(!exists("uni")) {
      bot_reply <- "<b>System Error:</b> The 'uni' dataset is not loaded."
    } else {
      bot_reply <- get_chatbot_response(user_text, uni)
    }
  }, error = function(e) {
    print(paste("CHATBOT CRASH:", e$message))
    bot_reply <- "I encountered an internal error. Please check the R console."
  })
  
  # D. Add Bot Message
  chat_state$history[[length(chat_state$history) + 1]] <- list(role = "bot", content = bot_reply)
  
  # E. Scroll
  session$sendCustomMessage("scrollToBottom", "go")
})

# 4. THE BRAIN (Comprehensive & Safe)
get_chatbot_response <- function(query, df) {
  query_clean <- tolower(query)
  
  # --- A. DETECT SORTING ---
  sort_descending <- TRUE
  sort_label <- "Highest"
  if (grepl("lowest|least|bottom|smallest", query_clean)) {
    sort_descending <- FALSE
    sort_label <- "Lowest"
  }
  
  # --- B. DETECT METRIC ---
  metric <- NULL
  metric_name <- ""
  
  # 1. TEACHERS & HR
  if (grepl("teacher", query_clean)) {
    level <- "Total"
    if(grepl("elem", query_clean)) level <- "ES"
    if(grepl("jhs", query_clean)) level <- "JHS"
    if(grepl("shs", query_clean)) level <- "SHS"
    
    if(grepl("excess", query_clean)) {
      metric <- paste0(level, ".Excess")
      # Fix for "Total" case if naming differs
      if(level=="Total") metric <- "Total.Excess" 
      metric_name <- paste(level, "Teacher Excess")
    } else {
      metric <- paste0(level, ".Shortage")
      if(level=="Total") metric <- "Total.Shortage"
      metric_name <- paste(level, "Teacher Shortage")
    }
  }
  
  # 2. ENROLLMENT (Grade Specific)
  else if (grepl("enroll|learner|student", query_clean)) {
    if (grepl("stem", query_clean)) { metric <- "G12.STEM"; metric_name <- "STEM Enrollment" }
    else if (grepl("kinder", query_clean)) { metric <- "Kinder"; metric_name <- "Kinder Enrollment" }
    else if (grepl("grade 12|g12", query_clean)) { metric <- "G12"; metric_name <- "Grade 12 Enrollment" }
    else if (grepl("grade 7|g7", query_clean)) { metric <- "G7"; metric_name <- "Grade 7 Enrollment" }
    else if (grepl("shs", query_clean)) { metric <- "SHS.Enrolment"; metric_name <- "SHS Enrollment" }
    else { metric <- "TotalEnrolment"; metric_name <- "Total Enrollment" }
  }
  
  # 3. INFRASTRUCTURE
  else if (grepl("room|class", query_clean)) {
    if (grepl("condem", query_clean)) { metric <- "Number.of.Rooms_Condemned...For.Demolition"; metric_name <- "Condemned Rooms" }
    else if (grepl("shortage", query_clean)) { metric <- "Classroom.Shortage"; metric_name <- "Classroom Shortage" }
    else { metric <- "Instructional.Rooms.2023.2024"; metric_name <- "Instructional Rooms" }
  }
  else if (grepl("building", query_clean)) {
    if (grepl("condem", query_clean)) { metric <- "Building.Count_Condemned...For.Demolition"; metric_name <- "Condemned Buildings" }
    else if (grepl("repair", query_clean)) { metric <- "Building.Count_Needs.Major.Repair"; metric_name <- "Damaged Buildings" }
    else { metric <- "Buildings"; metric_name <- "Total Buildings" }
  }
  
  # 4. UTILITIES & OTHERS
  else if (grepl("internet", query_clean)) { metric <- "No.Internet"; metric_name <- "Schools No Internet" }
  else if (grepl("water", query_clean)) { metric <- "No.Piped.Water"; metric_name <- "Schools No Water" }
  else if (grepl("electric", query_clean)) { metric <- "No.Grid.Electricity"; metric_name <- "Schools No Power" }
  else if (grepl("seat|furniture", query_clean)) { metric <- "Total.Seats.Shortage"; metric_name <- "Seat Shortage" }
  
  # --- FALLBACK & CLEANUP ---
  if (is.null(metric)) return("I didn't catch that. Try asking about <b>Teachers, Enrollment, Rooms, Buildings, Internet, or Seats</b>.")
  
  # Handle Naming Variations (Dot vs Underscore)
  if (!metric %in% names(df)) {
    metric_alt <- gsub("\\.", "_", metric)
    if (metric_alt %in% names(df)) { metric <- metric_alt }
    else { 
      # Last ditch: try removing years or specific suffixes
      return(paste0("Sorry, data for <b>", metric_name, "</b> isn't in the loaded dataset.")) 
    }
  }
  
  # --- C. CONTEXT (Filter by Location) ---
  found_region <- NULL
  found_division <- NULL
  
  # Robust Region Scan (Ignore Blanks)
  if ("Region" %in% names(df)) {
    # Smart Roman Numeral Mapping
    roman_map <- list("1"="I", "2"="II", "3"="III", "4a"="IV-A", "4b"="IV-B", "5"="V", "6"="VI", "7"="VII", "8"="VIII", "9"="IX", "10"="X", "11"="XI", "12"="XII", "13"="CARAGA", "ncr"="NCR", "car"="CAR", "barmm"="BARMM")
    for (k in names(roman_map)) {
      if (grepl(paste0("region ", k), query_clean) || grepl(paste0("region", k), query_clean)) {
        target <- roman_map[[k]]
        matches <- grep(target, unique(df$Region), ignore.case=TRUE, value=TRUE)
        if(length(matches)>0) found_region <- matches[1]
        break
      }
    }
    # Standard Scan if no Roman Numeral found
    if(is.null(found_region)) {
      regs <- unique(as.character(df$Region))
      regs <- regs[!is.na(regs) & nchar(regs) > 0] # Remove blanks
      for (r in regs) {
        if (grepl(tolower(r), query_clean, fixed=TRUE)) { found_region <- r; break }
      }
    }
  }
  
  # Robust Division Scan
  if ("Division" %in% names(df)) {
    divs <- unique(as.character(df$Division))
    divs <- divs[!is.na(divs) & nchar(divs) > 0] # Remove blanks
    for (d in divs) {
      if (grepl(tolower(d), query_clean, fixed=TRUE)) { found_division <- d; break }
    }
  }
  
  # Apply Filters
  filtered_df <- df
  context <- "Nationwide"
  
  if (!is.null(found_division)) {
    filtered_df <- filtered_df %>% filter(Division == found_division)
    context <- paste("in", found_division)
  } else if (!is.null(found_region)) {
    filtered_df <- filtered_df %>% filter(Region == found_region)
    context <- paste("in", found_region)
  }
  
  # --- D. GROUPING (Drill Down) ---
  group_col <- "Region"
  group_label <- "Regions"
  
  if (grepl("school", query_clean)) { group_col <- "School.Name"; group_label <- "Schools" }
  else if (grepl("municipality", query_clean)) { group_col <- "Municipality"; group_label <- "Municipalities" }
  else if (grepl("division", query_clean)) { group_col <- "Division"; group_label <- "Divisions" }
  else {
    # Auto-Drill
    if (!is.null(found_division)) { group_col <- "School.Name"; group_label <- "Schools" }
    else if (!is.null(found_region)) { group_col <- "Division"; group_label <- "Divisions" }
  }
  
  if (!group_col %in% names(df)) return(paste("Error: Grouping column", group_label, "missing."))
  
  # --- E. CALCULATE ---
  tryCatch({
    stats <- filtered_df %>%
      group_by(.data[[group_col]]) %>%
      summarise(Value = {
        val_col <- .data[[metric]]
        if(is.numeric(val_col)) sum(val_col, na.rm=TRUE)
        else {
          # Handle Text Numbers
          clean <- gsub(",", "", as.character(val_col))
          if (all(grepl("^[0-9.]+$", clean[!is.na(clean) & clean!=""]))) sum(as.numeric(clean), na.rm=TRUE)
          else sum(!is.na(val_col) & val_col != "" & val_col != "0" & tolower(val_col) != "no")
        }
      })
    
    if (sort_descending) stats <- stats %>% arrange(desc(Value)) else stats <- stats %>% arrange(Value)
    stats <- head(stats, 5)
    
    if (nrow(stats) == 0) return(paste("No data found for", metric_name, context))
    
    rows <- lapply(1:nrow(stats), function(i) {
      name <- stats[[group_col]][i]
      if(is.na(name) || name=="") name <- "Unknown"
      val <- format(stats$Value[i], big.mark=",")
      paste0("<tr><td>", i, ". ", name, "</td><td class='val'>", val, "</td></tr>")
    })
    
    return(paste0(
      sort_label, " 5 <b>", group_label, "</b> for <b>", metric_name, "</b> (", context, "):<br>",
      "<table class='bot-table'>", paste(rows, collapse=""), "</table>"
    ))
    
  }, error = function(e) { return("Calculation Error. Please try a simpler query.") })
}

# Ensure UI updates even when tab is hidden
outputOptions(output, "chat_ui_container", suspendWhenHidden = FALSE)

# --- REPORT GENERATOR (Fixed for Categorical Data) ---
output$generate_report <- downloadHandler(
  filename = function() {
    paste("STRIDE_Report_", Sys.Date(), ".html", sep = "")
  },
  content = function(file) {
    # 1. Notify User
    id <- showNotification("Generating Report...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id), add = TRUE)
    
    # 2. Prepare Template
    tempReport <- file.path(tempdir(), "report.Rmd")
    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    
    # 3. INTELLIGENT DATA PREPARATION
    # We grab the standard summary data first
    final_data <- summarized_data_long()
    
    # We also need the raw data to calculate text categories correctly
    raw_df <- filtered_data()
    selected_metrics <- all_selected_metrics()
    
    # Loop through selected metrics to fix the "Text" ones
    for (m in selected_metrics) {
      
      # Check if the column exists and is strictly CHARACTER/TEXT (not numeric)
      if (m %in% names(raw_df) && is.character(raw_df[[m]])) {
        
        # Calculate the breakdown (Count of Small, Medium, Large, etc.)
        cat_summary <- raw_df %>%
          group_by(.data[[m]]) %>%
          tally(name = "Value") %>%
          rename(Category = .data[[m]]) %>%
          mutate(Metric = m) %>%
          mutate(Category = ifelse(is.na(Category) | Category == "", "Unknown", Category)) %>%
          ungroup() %>%
          select(Category, Metric, Value)
        
        # Remove the "Bad" calculation (sum of text) from the standard data
        final_data <- final_data %>% filter(Metric != m)
        
        # Add our "Good" calculation
        final_data <- bind_rows(final_data, cat_summary)
      }
    }
    
    # 4. Define Parameters
    params_list <- list(
      data = final_data,                # The fixed data
      metrics = selected_metrics,   
      state = global_drill_state(),       
      metric_names = clean_metric_choices 
    )
    
    # 5. Render
    rmarkdown::render(
      tempReport,
      output_file = file,
      params = params_list,
      envir = new.env(parent = globalenv())
    )
  }
)
