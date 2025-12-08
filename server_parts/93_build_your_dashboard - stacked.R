# Build your Dashboard

# --- Drilldown State Management ---
global_drill_state <- reactiveVal(list(
  level = "Region", 
  region = NULL,    
  division = NULL,
  municipality = NULL,         
  legislative_district = NULL, 
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


# --- *** NEW: Define Metric Choices for Plot Titles *** ---
# This must match the 'choices' in your 10_stride2_UI.R pickers
hr_metric_choices <- list(
  `School Information` = c("Number of Schools" = "Total.Schools",
    "School Size Typology" = "School.Size.Typology", 
                           "Curricular Offering" = "Modified.COC"),
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
                  "Classroom Shortage" = "Est.CS",
                  "Shifting" = "Shifting",
                  "Number of Buildings" = "Buildings",
                  "Building Condition" = "Building",
                  "Room Condition" = "RoomCondition",
                  "Buildable Space" = "Buidable_space",
                  "Major Repairs Needed" = "Major.Repair.2023.2024"),
  `Facilities` = c("Seats" = "Seats",
                   "Laptops" = "Laptops"),
  `Resources` = c("Ownership Type" = "OwnershipType",
                  "Electricity Source" = "ElectricitySource",
                  "Water Source" = "WaterSource"
  ))

# Combine and unlist to create a flat, named vector for lookups
metric_choices <- unlist(c(hr_metric_choices, infra_metric_choices))

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
  infra_metric_choices$Resources
)


# --- *** NEW: COMBINED METRIC REACTIVE *** ---
all_selected_metrics <- reactive({
  hr_metrics <- input$Combined_HR_Toggles_Build
  infra_metrics <- input$Combined_Infra_Toggles_Build
  c(hr_metrics, infra_metrics)
})


# --- *** START: PRESET & PICKER SYNC LOGIC *** ---

# --- Define Metric Groups ---
teacher_metrics <- c("TotalTeachers", "Total.Shortage", "Total.Excess")
school_metrics <- c("Total.Schools","School.Size.Typology", "Modified.COC") 
classroom_metrics <- c("Instructional.Rooms.2023.2024", "Classroom.Requirement", "Shifting")
enrolment_metrics <- c("G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12")

# --- Observer 1: Sync Pickers -> Toggles ---


# --- Observers 2-4: Sync Toggles -> Pickers (Add-only logic) ---

# --- Observers 2-5: Sync Toggles -> Pickers (UPDATED) ---

# Preset 1: Teacher Focus Toggle
observeEvent(input$preset_teacher, {
  current_selection <- isolate(input$Combined_HR_Toggles_Build)
  if (input$preset_teacher == TRUE) {
    new_selection <- union(current_selection, teacher_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, teacher_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_HR_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# Preset 2: School Focus Toggle
observeEvent(input$preset_school, {
  current_selection <- isolate(input$Combined_HR_Toggles_Build)
  if (input$preset_school == TRUE) {
    new_selection <- union(current_selection, school_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, school_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_HR_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)


# Preset 3: Infrastructure Focus Toggle
observeEvent(input$preset_classroom, {
  current_selection <- isolate(input$Combined_Infra_Toggles_Build)
  if (input$preset_classroom == TRUE) {
    new_selection <- union(current_selection, classroom_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, classroom_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_Infra_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# Preset 4: Enrolment Focus Toggle
observeEvent(input$preset_enrolment, {
  current_selection <- isolate(input$Combined_HR_Toggles_Build)
  if (input$preset_enrolment == TRUE) {
    new_selection <- union(current_selection, enrolment_metrics)
  } else {
    # --- ADDED: This will remove the metrics ---
    new_selection <- setdiff(current_selection, enrolment_metrics)
  }
  shinyWidgets::updatePickerInput(
    session, 
    "Combined_HR_Toggles_Build", 
    selected = new_selection
  )
}, ignoreInit = TRUE)

# --- *** END: PRESET & PICKER SYNC LOGIC *** ---

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
    addProviderTiles(providers$Esri.WorldImagery) %>%
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
    )
})

# --- data_in_bounds (Unchanged) ---
data_in_bounds <- reactive({
  data_to_filter <- filtered_data()
  req(nrow(data_to_filter) > 0)
  req("Latitude" %in% names(data_to_filter), "Longitude" %in% names(data_to_filter))
  
  bounds <- input$school_map_bounds
  if (is.null(bounds)) {
    return(data_to_filter)
  }
  
  data_to_filter %>%
    filter(
      Latitude >= bounds$south & Latitude <= bounds$north &
        Longitude >= bounds$west & Longitude <= bounds$east
    )
})

# --- school_table (Unchanged) ---
output$school_table <- DT::renderDataTable({
  req(global_trigger() > 0)
  data_for_table <- data_in_bounds()
  cols_to_show <- c("SchoolID", "School.Name", "Division", "Region", "TotalTeachers", "Modified.COC")
  cols_to_show <- intersect(cols_to_show, names(data_for_table))
  req(length(cols_to_show) > 0)
  
  DT::datatable(
    data_for_table[, cols_to_show],
    selection = 'single', 
    rownames = FALSE,
    options = list(
      pageLength = 10,
      scrollY = "400px", 
      scrollCollapse = TRUE,
      paging = FALSE 
    )
  )
})

# --- *** NEW: Observers for Map/Table Clicks *** ---

# --- Observer for Table Clicks (UPDATED) ---
observeEvent(input$school_table_rows_selected, {
  selected_row_index <- input$school_table_rows_selected
  req(selected_row_index)
  
  table_data <- data_in_bounds()
  selected_row_data <- table_data[selected_row_index, ]
  
  # Set the reactive ID for school details
  reactive_selected_school_id(selected_row_data$SchoolID)
  
  req("Latitude" %in% names(selected_row_data), "Longitude" %in% names(selected_row_data))
  
  # Zoom the map
  leafletProxy("school_map", session) %>%
    setView(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15 
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
output$back_button_ui <- renderUI({
  state <- global_drill_state() 
  button_label <- ""  
  show_button <- FALSE 
  
  if (!is.null(state$clustering_filter)) {
    label_text <- stringr::str_trunc(state$clustering_filter, 20) 
    button_label <- paste("Undo Filter:", label_text); show_button <- TRUE
  } else if (!is.null(state$outlier_filter)) {
    label_text <- stringr::str_trunc(state$outlier_filter, 20) 
    button_label <- paste("Undo Filter:", label_text); show_button <- TRUE
  } else if (!is.null(state$shifting_filter)) {
    label_text <- stringr::str_trunc(state$shifting_filter, 20) 
    button_label <- paste("Undo Filter:", label_text); show_button <- TRUE
  } else if (!is.null(state$typology_filter)) {
    label_text <- stringr::str_trunc(state$typology_filter, 20) 
    button_label <- paste("Undo Filter:", label_text); show_button <- TRUE
  } else if (!is.null(state$coc_filter)) {
    label_text <- stringr::str_trunc(state$coc_filter, 20)
    button_label <- paste("Undo Filter:", label_text); show_button <- TRUE
  } else if (state$level == "District") {
    button_label <- "Undo Drilldown"; show_button <- TRUE
  } else if (state$level == "Legislative.District") {
    button_label <- "Undo Drilldown"; show_button <- TRUE
  } else if (state$level == "Municipality") {
    button_label <- "Undo Drilldown"; show_button <- TRUE
  } else if (state$level == "Division") {
    button_label <- "Undo Drilldown"; show_button <- TRUE
  }
  
  if (show_button) { 
    actionButton("back_button", button_label, icon = icon("undo"), class = "btn-danger") 
  }
})

# --- Back Button Observer (UPDATED) ---
observeEvent(input$back_button, {
  state <- isolate(global_drill_state()) 
  new_state <- state 
  
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
  } 
  else if (state$level == "District") {
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


# --- *** UPDATED: DYNAMIC OBSERVER MANAGER *** ---
observe({
  selected_metrics <- all_selected_metrics() 
  
  old_handles <- isolate(drilldown_observers())
  walk(old_handles, ~ .x$destroy()) 
  
  new_handles <- map(selected_metrics, ~{
    current_metric <- .x
    current_metric_source <- paste0("plot_source_", current_metric)
    
    # --- Categorical Filter Observers (UPDATED) ---
    observeEvent(event_data("plotly_click", source = "coc_pie_click"), {
      d <- event_data("plotly_click", source = "coc_pie_click"); if (is.null(d$y)) return() 
      state <- isolate(global_drill_state()); state$coc_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = "typology_bar_click"), {
      d <- event_data("plotly_click", source = "typology_bar_click"); if (is.null(d$y)) return() 
      state <- isolate(global_drill_state()); state$typology_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = "shifting_bar_click"), {
      d <- event_data("plotly_click", source = "shifting_bar_click"); if (is.null(d$y)) return() 
      state <- isolate(global_drill_state()); state$shifting_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = "outlier_click"), {
      d <- event_data("plotly_click", source = "outlier_click"); if (is.null(d$y)) return() 
      state <- isolate(global_drill_state()); state$outlier_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    observeEvent(event_data("plotly_click", source = "clustering_click"), {
      d <- event_data("plotly_click", source = "clustering_click"); if (is.null(d$y)) return() 
      state <- isolate(global_drill_state()); state$clustering_filter <- d$y
      global_drill_state(state); global_trigger(global_trigger() + 1)
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
    
    # --- Geographic Drilldown Observer (Unchanged) ---
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
  
  drilldown_observers(new_handles)
})


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
  
  if (!is.null(state$coc_filter)) { temp_data <- temp_data %>% filter(Modified.COC == state$coc_filter) }
  if (!is.null(state$typology_filter)) { temp_data <- temp_data %>% filter(School.Size.Typology == state$typology_filter) }
  if (!is.null(state$shifting_filter)) { temp_data <- temp_data %>% filter(Shifting == state$shifting_filter) }
  if (!is.null(state$outlier_filter)) { temp_data <- temp_data %>% filter(Outlier.Status == state$outlier_filter) }
  if (!is.null(state$clustering_filter)) { temp_data <- temp_data %>% filter(Clustering.Status == state$clustering_filter) }
  
  temp_data
})

# --- Reactive Data (summarized_data_long) (UPDATED) ---
summarized_data_long <- reactive({
  
  selected_metrics_list <- all_selected_metrics()
  req(length(selected_metrics_list) > 0) 
  
  state <- global_drill_state() 
  group_by_col <- state$level 
  metrics_to_process <- selected_metrics_list 
  data_in <- filtered_data()
  summaries_list <- list()
  
  # --- Handle Special Metric: Total.Schools ---
  if ("Total.Schools" %in% metrics_to_process) {
    school_count_summary <- data_in %>%
      group_by(!!sym(group_by_col)) %>%
      summarise(Value = n(), .groups = "drop") %>% 
      rename(Category = !!sym(group_by_col)) %>%
      mutate(Metric = "Total.Schools") 
    summaries_list[["school_count"]] <- school_count_summary
  }
  
  # --- NEW: Handle Special Metric: Seats ---
  # This will grab the two specific columns for the stacked bar
  if ("Seats" %in% metrics_to_process) {
    seats_cols <- c("Total.Total.Seat", "Total.Seats.Shortage")
    existing_seats_cols <- intersect(seats_cols, names(data_in))
    
    if (length(existing_seats_cols) > 0) {
      
      # Ensure columns are numeric before summarizing
      seats_data <- data_in %>%
        mutate(across(all_of(existing_seats_cols), ~ as.numeric(as.character(.))))
      
      seats_summary <- seats_data %>%
        select(!!sym(group_by_col), all_of(existing_seats_cols)) %>%
        group_by(!!sym(group_by_col)) %>%
        # Sum up each seats column separately
        summarise(across(all_of(existing_seats_cols), ~ sum(.x, na.rm = TRUE)), .groups = "drop") %>%
        # Pivot to long format (Metric = "Total.Total.Seat", etc.)
        pivot_longer(
          cols = all_of(existing_seats_cols), 
          names_to = "Metric", 
          values_to = "Value"
        ) %>%
        rename(Category = !!sym(group_by_col))
      
      summaries_list[["seats"]] <- seats_summary
    }
  }
  
  # --- NEW: Handle Special Metric: Building ---
  if ("Building" %in% metrics_to_process) {
    
    # Find all columns that start with "Building.Count"
    all_cols <- names(data_in)
    building_cols <- all_cols[startsWith(all_cols, "Building.Count")]
    
    if (length(building_cols) > 0) {
      
      # Ensure columns are numeric
      building_data <- data_in %>%
        mutate(across(all_of(building_cols), ~ as.numeric(as.character(.))))
      
      building_summary <- building_data %>%
        select(!!sym(group_by_col), all_of(building_cols)) %>%
        group_by(!!sym(group_by_col)) %>%
        summarise(across(all_of(building_cols), ~ sum(.x, na.rm = TRUE)), .groups = "drop") %>%
        pivot_longer(
          cols = all_of(building_cols), 
          names_to = "Metric", 
          values_to = "Value"
        ) %>%
        rename(Category = !!sym(group_by_col))
      
      summaries_list[["building"]] <- building_summary
    }
  }
  
  if ("RoomCondition" %in% metrics_to_process) {
    
    # Find all columns that start with "Number.of.Rooms"
    all_cols <- names(data_in)
    room_cols <- all_cols[startsWith(all_cols, "Number.of.Rooms")]
    
    if (length(room_cols) > 0) {
      
      # Ensure columns are numeric
      room_data <- data_in %>%
        mutate(across(all_of(room_cols), ~ as.numeric(as.character(.))))
      
      room_summary <- room_data %>%
        select(!!sym(group_by_col), all_of(room_cols)) %>%
        group_by(!!sym(group_by_col)) %>%
        summarise(across(all_of(room_cols), ~ sum(.x, na.rm = TRUE)), .groups = "drop") %>%
        pivot_longer(
          cols = all_of(room_cols), 
          names_to = "Metric", 
          values_to = "Value"
        ) %>%
        rename(Category = !!sym(group_by_col))
      
      summaries_list[["room_condition"]] <- room_summary
    }
  }
  
  # --- Handle Standard Numeric Metrics ---
  
  # --- Handle Standard Numeric Metrics ---
  
  # Define ALL metrics that are NOT standard numeric sums.
  # "Seats" is added here to prevent it from being processed again below.
  categorical_metrics <- c(
    "Modified.COC", "School.Size.Typology", "Total.Schools", "Shifting", "Completion",
    "Outlier.Status", "Clustering.Status", 
    "Seats", "Building","RoomCondition" # IMPORTANT: Add "Seats" here
  )
  
  # Find metrics that are left over and are standard numeric sums
  numeric_metrics_to_process <- setdiff(metrics_to_process, categorical_metrics)
  existing_metrics <- intersect(numeric_metrics_to_process, names(data_in))
  
  if (length(existing_metrics) > 0) {
    data_in_numeric <- data_in %>%
      mutate(across(all_of(existing_metrics), ~ as.numeric(as.character(.))))
    
    # Check which are *actually* numeric after conversion
    valid_metrics <- existing_metrics[sapply(data_in_numeric[existing_metrics], is.numeric)]
    
    if (length(valid_metrics) > 0) {
      numeric_summary <- data_in_numeric %>%
        select(!!sym(group_by_col), all_of(valid_metrics)) %>%
        pivot_longer(cols = all_of(valid_metrics), names_to = "Metric", values_to = "Value") %>%
        group_by(!!sym(group_by_col), Metric) %>%
        summarise(Value = sum(Value, na.rm = TRUE), .groups = "drop") %>%
        rename(Category = !!sym(group_by_col))
      summaries_list[["numeric_metrics"]] <- numeric_summary
    }
  }
  
  # --- Combine all summaries ---
  if (length(summaries_list) == 0) {
    return(tibble(Category = character(), Metric = character(), Value = numeric()))
  }
  
  bind_rows(summaries_list)
})


# --- Dynamic UI Dashboard Grid (UPDATED) ---
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
  
  # --- 1. Create Plotly Renders ---
  walk(selected_metrics, ~{
    current_metric <- .x
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
    
    if (length(filter_parts) > 0) {
      plot_title <- paste0(plot_title, " (Filtered by: ", paste(filter_parts, collapse = ", "), ")")
    }
    
    # --- UPDATED IF/ELSE IF CONDITION ---
    if (current_metric %in% c("Modified.COC", "School.Size.Typology", "Shifting", "Total.Schools", "Completion", "Outlier.Status", "Clustering.Status")) {
      
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          bar_data <- tibble() 
          if (current_metric == "Total.Schools") {
            bar_data <- summarized_data_long() %>%
              filter(Metric == "Total.Schools", !is.na(Category)) %>%
              rename(Count = Value) 
          } else {
            plot_data_bar <- filtered_data()
            if (nrow(plot_data_bar) > 0) {
              bar_data <- plot_data_bar %>%
                count(!!sym(current_metric), name = "Count") %>%
                filter(!is.na(!!sym(current_metric))) %>%
                rename(Category = !!sym(current_metric)) 
            }
          }
          
          if (nrow(bar_data) == 0) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          # --- UPDATED CASE_WHEN ---
          plot_source <- dplyr::case_when(
            current_metric == "Modified.COC" ~ "coc_pie_click",
            current_metric == "School.Size.Typology" ~ "typology_bar_click",
            current_metric == "Shifting" ~ "shifting_bar_click",
            current_metric == "Outlier.Status" ~ "outlier_click", 
            current_metric == "Clustering.Status" ~ "clustering_click",
            TRUE ~ paste0("plot_source_", current_metric) 
          )
          
          click_source_name <- if (plot_source %in% c("coc_pie_click", "typology_bar_click", "shifting_bar_click", "outlier_click", "clustering_click")) {
            plot_source
          } else {
            paste0("plot_source_", current_metric) 
          }
          
          plot_ly(
            data = bar_data, y = ~Category, x = ~Count,
            type = "bar", orientation = 'h', name = current_metric_name,
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10),
            source = click_source_name 
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), 
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Count", tickformat = ',.0f'),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.02),
              margin = list(l = 150) 
            )
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
      
      # --- NEW BLOCK: Handle "Seats" Stacked Bar Chart ---
    } else if (current_metric == "Seats") {
      
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          # 1. Get and prepare data
          plot_data <- summarized_data_long() %>%
            filter(
              Metric %in% c("Total.Total.Seat", "Total.Seats.Shortage"), 
              !is.na(Category)
            ) %>%
            mutate(
              # Rename for cleaner legend labels
              Metric = recode(Metric, 
                              "Total.Total.Seat" = "Total Seats",
                              "Total.Seats.Shortage" = "Seats Shortage"
              ),
              Metric = factor(Metric, levels = c("Total Seats", "Seats Shortage"))
            )
          
          
          
          if (nrow(plot_data) == 0 || all(is.na(plot_data$Value))) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          # 2. Create data for the "Total" labels
          plot_data_totals <- plot_data %>%
            group_by(Category) %>%
            summarise(TotalValue = sum(Value, na.rm = TRUE), .groups = "drop")
          
          # 3. Define the specific colors
          seat_colors <- c("Total Seats" = "#1f77b4", "Seats Shortage" = "#dc3545") # Blue, Red
          
          # 4. Set x-axis range to make space for total labels
          xaxis_range <- c(0, max(plot_data_totals$TotalValue, na.rm = TRUE) * 1.3)
          
          # 5. Create the stacked bar plot
          plot_ly(
            data = plot_data, 
            y = ~Category, 
            x = ~Value, 
            type = "bar",
            orientation = 'h', 
            color = ~Metric,      # Use the recoded Metric for color
            colors = seat_colors, # Apply the defined colors
            source = paste0("plot_source_", current_metric)
            # We don't add segment texttemplate, only the total
          ) %>%
            layout(
              barmode = 'stack', # <-- Key for stacking
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Value", tickformat = ',.0f', range = xaxis_range),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.06),
              margin = list(l = 150)
            ) %>%
            # 6. Add the total labels at the end of the bar
            add_text(
              data = plot_data_totals, # Use the totals data
              x = ~TotalValue,         # Position at the total value
              y = ~Category, 
              text = ~scales::comma(TotalValue, 1), # Format the total value
              textposition = "middle right",       # Place it just outside
              textfont = list(color = '#000000', size = 10),
              showlegend = FALSE, 
              inherit = FALSE, 
              cliponaxis = FALSE
            )
          
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
      
    } else if (current_metric == "Building") {
    
    output[[paste0("plot_", current_metric)]] <- renderPlotly({
      tryCatch({
        # 1. Get and prepare data
        plot_data <- summarized_data_long() %>%
          filter(
            startsWith(Metric, "Building.Count"), 
            !is.na(Category)
          ) %>%
          mutate(
            # Clean up names for legend: "Building.Count.TypeA" -> "TypeA"
            Metric = stringr::str_remove(Metric, "Building.Count.")
          )
        
        if (nrow(plot_data) == 0 || all(is.na(plot_data$Value))) {
          return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
        }
        
        # 2. Create data for the "Total" labels
        plot_data_totals <- plot_data %>%
          group_by(Category) %>%
          summarise(TotalValue = sum(Value, na.rm = TRUE), .groups = "drop")
        
        # 3. Set x-axis range
        xaxis_range <- c(0, max(plot_data_totals$TotalValue, na.rm = TRUE) * 1.3)
        
        # 4. Create the stacked bar plot
        plot_ly(
          data = plot_data, 
          y = ~Category, 
          x = ~Value, 
          type = "bar",
          orientation = 'h', 
          color = ~Metric,      # Color by the cleaned metric name
          source = paste0("plot_source_", current_metric)
        ) %>%
          layout(
            barmode = 'stack', 
            yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
            xaxis = list(title = "Total Value", tickformat = ',.0f', range = xaxis_range),
            legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.35),
            margin = list(l = 150)
          ) %>%
          # 5. Add the total labels
          add_text(
            data = plot_data_totals, 
            x = ~TotalValue,
            y = ~Category, 
            text = ~scales::comma(TotalValue, 1), 
            textposition = "middle right",
            textfont = list(color = '#000000', size = 10),
            showlegend = FALSE, 
            inherit = FALSE, 
            cliponaxis = FALSE
          )
        
      }, error = function(e) {
        # ... (Error handling) ...
      })
    })
    
    } else if (current_metric == "RoomCondition") {
      
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          # 1. Get and prepare data
          plot_data <- summarized_data_long() %>%
            filter(
              startsWith(Metric, "Number.of.Rooms"), # <-- Search for Room columns
              !is.na(Category)
            ) %>%
            mutate(
              # Clean up names for legend: "Number.of.Rooms.TypeA" -> "TypeA"
              Metric = stringr::str_remove(Metric, "Number.of.Rooms.")
            )
          
          if (nrow(plot_data) == 0 || all(is.na(plot_data$Value))) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          # 2. Create data for the "Total" labels
          plot_data_totals <- plot_data %>%
            group_by(Category) %>%
            summarise(TotalValue = sum(Value, na.rm = TRUE), .groups = "drop")
          
          # 3. Set x-axis range
          xaxis_range <- c(0, max(plot_data_totals$TotalValue, na.rm = TRUE) * 1.3)
          
          # 4. Create the stacked bar plot
          plot_ly(
            data = plot_data, 
            y = ~Category, 
            x = ~Value, 
            type = "bar",
            orientation = 'h', 
            color = ~Metric,      # Color by the cleaned metric name
            source = paste0("plot_source_", current_metric)
          ) %>%
            layout(
              barmode = 'stack', 
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Value", tickformat = ',.0f', range = xaxis_range),
              
              # --- Applying the correct legend layout ---
              legend = list(
                orientation = 'h',   
                xanchor = 'center',  
                x = 0.5,             
                yanchor = 'bottom',  
                y = 1.02             
              ),
              margin = list(l = 150, t = 100) # Add top margin for legend
              
            ) %>%
            # 5. Add the total labels
            add_text(
              data = plot_data_totals, 
              x = ~TotalValue,
              y = ~Category, 
              text = ~scales::comma(TotalValue, 1), 
              textposition = "middle right",
              textfont = list(color = '#000000', size = 10),
              showlegend = FALSE, 
              inherit = FALSE, 
              cliponaxis = FALSE
            )
          
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
    }
      
      else {
      # --- RENDER DEFAULT DRILLDOWN BAR CHART (Unchanged) ---
      output[[paste0("plot_", current_metric)]] <- renderPlotly({
        tryCatch({
          plot_data <- summarized_data_long() %>%
            filter(Metric == current_metric, !is.na(Category))
          
          if (nrow(plot_data) == 0 || all(is.na(plot_data$Value))) {
            return(plot_ly() %>% layout(title = list(text = plot_title, x = 0.05), annotations = list(x = 0.5, y = 0.5, text = "No data available", showarrow = FALSE)))
          }
          
          xaxis_range <- c(0, max(plot_data$Value, na.rm = TRUE) * 1.3)
          
          plot_ly(
            data = plot_data, y = ~Category, x = ~Value, type = "bar",
            orientation = 'h', name = current_metric_name,
            source = paste0("plot_source_", current_metric), 
            texttemplate = '%{x:,.0f}', textposition = "outside",
            cliponaxis = FALSE, textfont = list(color = '#000000', size = 10)
          ) %>%
            layout(
              title = list(text = plot_title, x = 0.05), 
              yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
              xaxis = list(title = "Total Value", tickformat = ',.0f', range = xaxis_range),
              legend = list(orientation = 'h', xanchor = 'center', x = 0.5, y = 1.02),
              margin = list(l = 150)
            )
        }, error = function(e) {
          # ... (Error handling) ...
        })
      })
    }
  })
  
  # --- 2. Create the UI Card Elements ---
  plot_cards <- map(selected_metrics, ~{
    current_metric <- .x
    # --- *** MODIFIED (Change 3 of 3): Use clean_metric_choices *** ---
    current_metric_name <- names(clean_metric_choices)[clean_metric_choices == current_metric]
    summary_card_content <- NULL
    
    # --- UPDATED IF/ELSE IF CONDITION ---
    if (current_metric %in% c("Modified.COC", "School.Size.Typology", "Shifting", "Total.Schools", "Completion", "Outlier.Status", "Clustering.Status")) {
      
      total_count <- tryCatch({
        if (current_metric == "Total.Schools") {
          summarized_data_long() %>% filter(Metric == "Total.Schools") %>% pull(Value) %>% sum(na.rm = TRUE)
        } else {
          nrow(filtered_data()) 
        }
      }, error = function(e) { 0 }) 
      
      summary_title <- if (current_metric == "Total.Schools") paste("Total", current_metric_name) else "Total Records in View"
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light blue, tight padding
        tags$h5(
          summary_title, 
          style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        ),
        tags$h2(
          scales::comma(total_count), 
          style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;" # Tighter margins
        )
      )
      
      # --- NEW BLOCK: Handle "Seats" Summary Cards ---
    } else if (current_metric == "Seats") {
      
      # Get the total for "Total.Total.Seat"
      total_seats_val <- tryCatch({
        summarized_data_long() %>% 
          filter(Metric == "Total.Total.Seat") %>% 
          pull(Value) %>% 
          sum(na.rm = TRUE)
      }, error = function(e) { 0 })
      
      # Get the total for "Total.Seats.Shortage"
      total_shortage_val <- tryCatch({
        summarized_data_long() %>% 
          filter(Metric == "Total.Seats.Shortage") %>% 
          pull(Value) %>% 
          sum(na.rm = TRUE)
      }, error = function(e) { 0 })
      
      # Use layout_columns for a 50/50 split
      summary_card_content <- bslib::layout_columns(
        col_widths = 6, # Each card takes 6 of 12 columns
        gap = "10px",    # Add a small gap between cards
        
        # Card 1: Total Seats (Blue)
        bslib::card(
          style = "background-color: #1f77b445; padding: 0px;", # Light blue
          tags$h5(
            "Total Seats", 
            style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;"
          ),
          tags$h2(
            scales::comma(total_seats_val), 
            style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;"
          )
        ),
        
        # Card 2: Total Seats Shortage (Red)
        bslib::card(
          style = "background-color: #dc354545; padding: 0px;", # Light red
          tags$h5(
            "Total Seats Shortage", 
            style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;"
          ),
          tags$h2(
            scales::comma(total_shortage_val), 
            style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;"
          )
        )
      )
      
      # --- NEW BLOCK: Handle "Building" Summary Card ---
    } else if (current_metric == "Building") {
      
      # Get the total for ALL building columns
      total_building_val <- tryCatch({
        summarized_data_long() %>% 
          filter(startsWith(Metric, "Building.Count")) %>% 
          pull(Value) %>% 
          sum(na.rm = TRUE)
      }, error = function(e) { 0 })
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light blue
        tags$h5(
          "Total Buildings", 
          style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;"
        ),
        tags$h2(
          scales::comma(total_building_val), 
          style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;"
        )
      )
      
    } else if (current_metric == "RoomCondition") {
      
      # Get the total for ALL room columns
      total_room_val <- tryCatch({
        summarized_data_long() %>% 
          filter(startsWith(Metric, "Number.of.Rooms")) %>% 
          pull(Value) %>% 
          sum(na.rm = TRUE)
      }, error = function(e) { 0 })
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light blue
        tags$h5(
          "Total Rooms", 
          style = "font-weight: 600; color: #555; margin-top: 2px; margin-bottom: 2px;"
        ),
        tags$h2(
          scales::comma(total_room_val), 
          style = "font-weight: 700; color: #000; margin-top: 2px; margin-bottom: 2px;"
        )
      )
    }
    
    else {
      
      total_val <- tryCatch({
        summarized_data_long() %>% filter(Metric == current_metric) %>% pull(Value) %>% sum(na.rm = TRUE)
      }, error = function(e) { 0 }) 
      
      summary_card_content <- card(
        style = "background-color: #1f77b445; padding: 0px;", # Light blue, tight padding
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
        plotlyOutput(paste0("plot_", .x))
      )
    )
  })
  
  # --- 3. Arrange the cards into the layout (Logic Unchanged) ---
  plot_grid <- do.call(bslib::layout_columns, c(list(col_widths = 4), plot_cards))
  tagList(
    tags$h3("Interactive Education Resource Dashboard", style = "text-align: center; font-weight: bold; margin-bottom: 20px;"),
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


# --- 2. Dynamic UI to show prompt or detail tables (UPDATED) ---
output$build_dashboard_school_details_ui <- renderUI({
  
  # Check the new reactiveVal
  if (is.null(reactive_selected_school_id())) {
    return(
      tags$div(
        style = "padding: 20px; text-align: center; color: #6c757d;",
        bs_icon("info-circle", size = "2em"),
        h5("Click a school in the 'Filtered Data' table or on the map to load its details here.")
      )
    )
  }
  
  # If a school IS selected, show the 4-column layout
  layout_columns(
    col_widths = c(6,6,6,6),
    
    card(full_screen = TRUE,
         card_header(strong("Basic Information")),
         tableOutput("schooldetails_build")),
    
    card(full_screen = TRUE,
         card_header(strong("HR Data")),
         tableOutput("schooldetails_build2")),
    
    card(full_screen = TRUE,
         card_header(strong("Classroom Data")),
         tableOutput("schooldetails_build3")),
    
    card(full_screen = TRUE,
         card_header(div(strong("Specialization Data"),
                         tags$span(em("(based on eSF7 for SY 2023-2024)"),
                                   style = "font-size: 0.7em; color: grey;"
                         ))),
         tableOutput("schooldetails_build5"))
  )
})

# --- 3. Render the four detail tables (FIXED with correct column names) ---

# --- School Details Table 1: Basic Info ---
output$schooldetails_build <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  data.frame(
    Metric = c("Region", "Province", "Municipality", "Division", "District", 
               "Barangay", "Street Address", "School ID", "School Name", "School Head", 
               "School Head Position", "Implementing Unit", "Modified Curricular Offering", 
               "Latitude", "Longitude"),
    Value = as.character(c(
      data$Region, data$Province, data$Municipality, data$Division, data$District,
      data$Barangay, data$Street.Address, data$SchoolID, data$School.Name, data$School.Head.Name,
      data$SH.Position, data$Implementing.Unit, data$Modified.COC,
      data$Latitude, data$Longitude
    ))
  )
}, striped = TRUE, hover = TRUE, bordered = TRUE)

# --- School Details Table 2: HR Data ---
output$schooldetails_build2 <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  data.frame(
    Metric = c("ES Excess", "ES Shortage", "JHS Excess", "JHS Shortage", 
               "SHS Excess", "SHS Shortage", "ES Teachers", "JHS Teachers", 
               "SHS Teachers", "ES Enrolment", "JHS Enrolment", "SHS Enrolment", 
               "School Size Typology", "AO II Deployment", "COS Deployment"),
    Value = as.character(c(
      data$ES.Excess, data$ES.Shortage, data$JHS.Excess, data$JHS.Shortage,
      data$SHS.Excess, data$SHS.Shortage, data$ES.Teachers, data$JHS.Teachers,
      data$SHS.Teachers, data$ES.Enrolment, data$JHS.Enrolment, data$SHS.Enrolment,
      data$School.Size.Typology, data$PDOI_Deployment, data$Outlier.Status
    ))
  )
}, striped = TRUE, hover = TRUE, bordered = TRUE)

# --- School Details Table 3: Classroom Data ---
output$schooldetails_build3 <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  data.frame(
    Metric = c("Number of Buildings", "Number of Instructional Rooms", 
               "Classroom Requirement", "Estimated Classroom Shortage", 
               "With Buildable Space", "For Major Repairs", 
               "School Building Priority Index", "Shifting", "Ownership Type", 
               "Source of Electricity", "Source of Water", "Total Seats", 
               "Total Seats Shortage"),
    Value = as.character(c(
      data$Buildings, data$Instructional.Rooms.2023.2024,
      data$Classroom.Requirement, data$Est.CS,
      data$Buidable_space, data$Major.Repair.2023.2024,
      data$SBPI, data$Shifting, data$OwnershipType,
      data$ElectricitySource, data$WaterSource, data$Total.Seats.2023.2024,
      data$Total.Seats.Shortage.2023.2024
    ))
  )
}, striped = TRUE, hover = TRUE, bordered = TRUE)

# --- School Details Table 4: Specialization (was build5) ---
# --- School Details Table 4: Specialization (UPDATED) ---
output$schooldetails_build5 <- renderTable({
  data <- selected_school_data(); req(nrow(data) > 0)
  
  # --- Define the metric list ---
  metric_labels <- c("English", "Mathematics", "Science", "Biological Sciences", 
                     "Physical Sciences", "General Education", "Araling Panlipunan", 
                     "TLE", "MAPEH", "Filipino", "ESP", "Agriculture", 
                     "Early Childhood Education", "SPED")
  
  # --- Check if the school is "Purely ES" ---
  # We add !is.na() as a safety check
  if (!is.na(data$Modified.COC) && data$Modified.COC == "Purely ES") {
    
    # --- If YES, show dashes ("-") for all values ---
    data.frame(
      Metric = metric_labels,
      Value = rep("-", length(metric_labels))
    )
    
  } else {
    
    # --- If NO, show the actual specialization data ---
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
  
}, striped = TRUE, hover = TRUE, bordered = TRUE)