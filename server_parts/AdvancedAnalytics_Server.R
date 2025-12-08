

# --- 1. VALIDATE METADATA ---
if (!exists("col_info_adv_static")) {
  stop("FATAL ERROR: 'col_info_adv_static' object not found...")
} else {
  print("--- ADVANCED ANALYTICS: Server logic is loading. Metadata found. ---")
}


# --- 2. Dynamic Filter Management ---
# (This section is unchanged)
# --- 2. Dynamic Filter Management ---
# (This section is unchanged)
active_filter_ids <- reactiveVal(c()) 
adv_filter_counter <- reactiveVal(0) 

observeEvent(input$add_adv_filter_btn, {
  new_id <- isolate(adv_filter_counter()) + 1
  adv_filter_counter(new_id)
  ui_id <- paste0("adv_filter_row_", new_id)
  
  # --- MODIFICATION: Added a "Select..." option ---
  # This makes the req() function work more predictably.
  choices_with_prompt <- c("Select a column..." = "", adv_analytics_choices)
  
  insertUI(
    selector = "#adv_filter_container",
    where = "beforeEnd",
    ui = div(
      id = ui_id,
      class = "adv-filter-group",
      style = "border: 1px solid #ddd; border-radius: 5px; padding: 10px; margin-bottom: 10px;",
      actionButton(paste0("adv_remove_", new_id), "Remove", 
                   icon = icon("times"), class = "btn-danger btn-sm float-end"),
      selectInput(paste0("adv_col_", new_id), 
                  label = paste("Filter", new_id, ": Select Column"),
                  choices = choices_with_prompt), # Use the modified choices
      uiOutput(paste0("adv_filter_val_ui_", new_id))
    )
  )
  active_filter_ids(c(isolate(active_filter_ids()), new_id))
  
  local({
    current_filter_id <- new_id
    
    # --- MODIFIED: Added defensive checks and debug messages to this renderUI ---
    output[[paste0("adv_filter_val_ui_", current_filter_id)]] <- renderUI({
      
      col_name <- input[[paste0("adv_col_", current_filter_id)]]
      
      # This req() now correctly waits until the user selects something
      # *other* than the blank "Select a column..." option.
      req(col_name, col_name != "") 
      
      print(paste("--- Generating UI for filter", current_filter_id, "---"))
      print(paste("Selected col_name:", col_name))
      
      # --- Check 1: Does metadata exist for this column? ---
      col_type_vec <- col_info_adv_static$type[col_info_adv_static$Raw_Name == col_name]
      
      if (length(col_type_vec) == 0) {
        print(paste("DEBUG: No 'type' found in col_info_adv_static for Raw_Name:", col_name))
        return(tags$p(
          style = "color: #dc3545; font-weight: bold;",
          paste("Error: Metadata for column '", col_name, "' not found.")
        ))
      }
      
      col_type <- col_type_vec[1]
      print(paste("Found col_type:", col_type))
      
      # --- Check 2: Does this column exist in the 'uni' dataframe? ---
      if (!col_name %in% names(uni)) {
        print(paste("DEBUG: Column '", col_name, "' not found in 'uni' dataframe."))
        return(tags$p(
          style = "color: #dc3545; font-weight: bold;",
          paste("Error: Data for column '", col_name, "' not found.")
        ))
      }
      
      col_data <- uni[[col_name]] 
      
      # --- Your original logic (now protected by the checks above) ---
      if (col_type == "Numeric") {
        min_val <- min(col_data, na.rm = TRUE)
        max_val <- max(col_data, na.rm = TRUE)
        if (is.infinite(min_val) || is.infinite(max_val)) {
          tags$p("No valid numeric data.", style = "color: #dc3545;")
        } else {
          fluidRow(
            column(6,
                   numericInput(paste0("adv_num_min_", current_filter_id), 
                                "Min:", 
                                value = min_val)
            ),
            column(6,
                   numericInput(paste0("adv_num_max_", current_filter_id), 
                                "Max:", 
                                value = max_val)
            )
          )
        }
      } else if (col_type %in% c("Categorical", "Binary")) {
        choices <- sort(unique(col_data[!is.na(col_data)]))
        if (length(choices) == 0) {
          tags$p("No valid categories.", style = "color: #dc3545;")
        } else {
          pickerInput(
            inputId = paste0("adv_select_", current_filter_id),
            label = "Select Value(s):",
            choices = choices,
            selected = choices,
            multiple = TRUE, 
            options = list(
              `actions-box` = TRUE,
              `live-search` = TRUE,
              `selected-text-format` = "count > 3"
            )
          )
        }
      } else {
        # --- Check 3: Catch-all for unknown types ---
        print(paste("DEBUG: Unknown col_type '", col_type, "' for column:", col_name))
        return(tags$p(
          style = "color: #ffc107; font-weight: bold;",
          paste("Warning: No UI defined for column type '", col_type, "'.")
        ))
      }
    })
    # --- END OF MODIFICATION ---
    
    observeEvent(input[[paste0("adv_remove_", current_filter_id)]], {
      removeUI(selector = paste0("#adv_filter_row_", current_filter_id))
      active_filter_ids(setdiff(isolate(active_filter_ids()), current_filter_id))
    })
  }) # End local()
}) # End observeEvent(add_adv_filter_btn)

# --- 3. Filter Data and Manage State ---

# --- 3a. Add state management for the interactive drilldown ---
# --- MODIFIED: Start the level at "Overall" ---
adv_drill_state <- reactiveVal(list(level = "Overall", filters = list()))

# --- MODIFIED: 3b. Define the FINAL drilldown hierarchy ---

# This vector defines the *exact* order of the drilldown path
# We've added Municipality and District
drill_levels <- c("Overall", "Region", "Division", "Municipality", "Legislative.District", "District")

# This map links the "level" name to the *actual column name* in your 'uni' dataframe
# Make sure the names on the *right* side (e.g., "Legislative.District")
# exactly match the column names in your data.
col_name_map <- c(
  "Overall" = "Overall", 
  "Region" = "Region",
  "Division" = "Division",
  "Municipality" = "Municipality",
  "Legislative.District" = "Legislative.District",
  "District" = "District"
)

# --- 3c. 'Apply' button now filters data AND resets the drilldown ---
# --- MODIFIED: 3c. 'Apply' button now filters data AND resets drilldown to "Overall" ---
filtered_data_adv <- eventReactive(input$adv_analytics_run, {
  
  req(global_drill_state())
  print("--- ADVANCED ANALYTICS: 'Apply' button clicked, filtering data... ---")
  
  data_filtered <- uni 
  drill_state <- global_drill_state()
  
  # --- MODIFIED: Force the start level to be "Overall" ---
  start_level <- "Overall"
  adv_drill_state(list(level = start_level, filters = list()))
  print(paste("--- ADVANCED ANALYTICS: Drilldown reset to:", start_level, "---"))
  
  # --- 1. Apply all filters from the main dashboard ---
  if (!is.null(drill_state$ownership_filter)) {
    data_filtered <- data_filtered %>% filter(OwnershipType %in% drill_state$ownership_filter)
  }
  # ... (rest of this filter logic is unchanged) ...
  if (!is.null(drill_state$electricity_filter)) {
    data_filtered <- data_filtered %>% filter(ElectricitySource %in% drill_state$electricity_filter)
  }
  if (!is.null(drill_state$water_filter)) {
    data_filtered <- data_filtered %>% filter(WaterSource %in% drill_state$water_filter)
  }
  if (!is.null(drill_state$coc_filter)) {
    data_filtered <- data_filtered %>% filter(Modified.COC %in% drill_state$coc_filter)
  }
  if (!is.null(drill_state$typology_filter)) {
    data_filtered <- data_filtered %>% filter(School.Size.Typology %in% drill_state$typology_filter)
  }
  if (!is.null(drill_state$shifting_filter)) {
    data_filtered <- data_filtered %>% filter(Shifting %in% drill_state$shifting_filter)
  }
  
  # --- 2. Apply ALL dynamic filters from this panel ---
  filter_ids_to_apply <- isolate(active_filter_ids())
  if (length(filter_ids_to_apply) > 0) {
    for (id in filter_ids_to_apply) {
      col_name <- isolate(input[[paste0("adv_col_", id)]])
      if (is.null(col_name)) next 
      col_type <- col_info_adv_static$type[col_info_adv_static$Raw_Name == col_name]
      
      if (col_type == "Numeric") {
        min_val <- isolate(input[[paste0("adv_num_min_", id)]])
        max_val <- isolate(input[[paste0("adv_num_max_", id)]])
        if (is.null(min_val) || is.null(max_val)) next 
        data_filtered <- data_filtered %>%
          filter(!is.na(!!sym(col_name))) %>% 
          filter(!!sym(col_name) >= min_val, !!sym(col_name) <= max_val)
      } else if (col_type %in% c("Categorical", "Binary")) {
        selected_choices <- isolate(input[[paste0("adv_select_", id)]])
        if (is.null(selected_choices)) next 
        data_filtered <- data_filtered %>%
          filter(!!sym(col_name) %in% selected_choices)
      }
    }
  }
  
  # --- 3. Apply geographic drilldown filters ---
  # These filters *from the main dashboard* should still apply
  if (drill_state$level %in% c("Division", "Legislative", "District", "School")) {
    req(drill_state$region)
    data_filtered <- data_filtered %>% filter(Region == drill_state$region)
  }
  if (drill_state$level %in% c("Legislative", "District", "School")) {
    req(drill_state$division)
    data_filtered <- data_filtered %>% filter(Division == drill_state$division)
  }
  if (drill_state$level %in% c("District", "School")) {
    req(drill_state$legislative_district)
    data_filtered <- data_filtered %>% filter(Legislative.District == drill_state$legislative_district)
  }
  
  print("--- ADVANCED ANALYTICS: Base filtering complete. ---")
  return(data_filtered)
})

# --- 3d. Create a reactive for the drilldown data ---
drilled_data_and_level <- reactive({
  data <- filtered_data_adv()
  state <- adv_drill_state()
  
  if (length(state$filters) > 0) {
    print("--- ADVANCED ANALYTICS: Applying drilldown filters... ---")
    for (col_name in names(state$filters)) {
      filter_value <- state$filters[[col_name]]
      print(paste("     ... filtering", col_name, "==", filter_value))
      data <- data %>% filter(!!sym(col_name) == !!filter_value)
    }
  }
  return(list(data = data, level = state$level))
})

# --- 3e. Create a reactive for the plot data ---
# --- 3e. Create a reactive for the plot data ---
plot_data_r <- reactive({
  req(drilled_data_and_level())
  info <- drilled_data_and_level()
  data_to_plot <- info$data
  drill_level <- info$level
  
  # --- MODIFIED: Check if we are at the *actual* last level ---
  # This is no longer hard-coded to "District"
  last_level_name <- drill_levels[length(drill_levels)]
  
  if (drill_level == last_level_name) {
    # We are at the end, e.g., "Legislative.District"
    # We still need to group by this for the *click* to work (though clicks are disabled)
    # but the plot will be updated to say "End of drilldown"
    group_col_name <- col_name_map[drill_level]
  } else {
    # Otherwise, get the *next* level to display
    current_index <- match(drill_level, drill_levels)
    next_level <- drill_levels[current_index + 1]
    group_col_name <- col_name_map[next_level]
  }
  # --- END OF MODIFICATION ---
  
  group_col_sym <- sym(group_col_name)
  
  if (nrow(data_to_plot) == 0) return(NULL) 
  
  plot_data <- data_to_plot %>%
    group_by(!!group_col_sym) %>%
    summarise(School_Count = n(), .groups = 'drop') %>%
    rename(Group = !!group_col_sym) %>%
    filter(!is.na(Group)) %>% 
    arrange(desc(School_Count)) %>% 
    head(25) 
  
  return(plot_data)
})


# --- 4. Plot, Controls, and Click Logic ---
# --- MODIFIED: 4a. UI for "Reset" AND "Back" buttons ---
output$adv_drill_controls_ui <- renderUI({
  
  state <- adv_drill_state()
  
  # --- MODIFIED: The "start level" is always "Overall" ---
  start_level <- "Overall"
  
  show_reset <- state$level != start_level || length(state$filters) > 0
  show_back <- length(state$filters) > 0 # Show back if any filters are applied
  
  div(style = "display: flex; gap: 10px; margin-bottom: 10px;",
      if (show_reset) {
        actionButton("adv_drill_reset_btn", "Reset Drilldown View", 
                     icon = icon("undo"), class = "btn-secondary btn-sm")
      },
      if (show_back) {
        actionButton("adv_drill_back_btn", "Go Back One Level", 
                     icon = icon("arrow-left"), class = "btn-info btn-sm")
      }
  )
})

# --- MODIFIED: 4b. Observer for the "Reset" button ---
observeEvent(input$adv_drill_reset_btn, {
  print("--- ADVANCED ANALYTICS: Drilldown reset button clicked. ---")
  
  # --- MODIFIED: Always reset to "Overall" ---
  start_level <- "Overall"
  adv_drill_state(list(level = start_level, filters = list()))
})

# --- NEW: 4c. Observer for the "Back" button ---
observeEvent(input$adv_drill_back_btn, {
  print("--- ADVANCED ANALYTICS: Drilldown 'Back' button clicked. ---")
  
  current_state <- isolate(adv_drill_state())
  
  # If no filters, do nothing (button shouldn't be visible, but as a safeguard)
  if (length(current_state$filters) == 0) return()
  
  # 1. Get the name of the *current* level
  current_level <- current_state$level
  
  # 2. Get the *previous* level
  current_index <- match(current_level, drill_levels)
  # This should not happen, but safeguard
  if (current_index == 1) return() 
  prev_level <- drill_levels[current_index - 1]
  
  # 3. Remove the *last* filter from the list
  new_filters <- current_state$filters
  new_filters[[length(new_filters)]] <- NULL
  
  print(paste("--- Going back to level:", prev_level))
  
  # 4. Set the new state
  adv_drill_state(list(level = prev_level, filters = new_filters))
})


# --- MODIFIED: 4d. Render the interactive plot ---
output$advanced_drilldown_plot <- renderPlot({
  
  req(drilled_data_and_level())
  
  plot_data <- plot_data_r()
  drill_level <- drilled_data_and_level()$level
  
  if (is.null(plot_data) || nrow(plot_data) == 0) {
    print("--- ADVANCED ANALYTICS: No data to plot. ---")
    return(
      ggplot() + 
        labs(title = "No Data to Display",
             subtitle = "No schools match all selected filters. Try broadening your search.") +
        theme_minimal()
    )
  }
  
  # --- MODIFIED: Adjust plot title and subtitle based on level ---
  current_index <- match(drill_level, drill_levels)
  
  # If we are at the last level, we are *viewing* Districts
  if (current_index == length(drill_levels)) {
    title_text <- paste("School Count by", drill_level, "(Top 25)")
    subtitle_text <- "End of drilldown. See table and map below."
  } else {
    # Otherwise, we are viewing the *next* level
    next_level <- drill_levels[current_index + 1]
    title_text <- paste("School Count by", next_level, "(Top 25)")
    subtitle_text <- paste("Click a bar to drill down into a", next_level)
  }
  
  ggplot(plot_data, aes(x = School_Count, y = reorder(Group, School_Count))) +
    geom_col(fill = "#007bff") + 
    geom_text(aes(label = School_Count), hjust = -0.1, size = 3.5) +
    labs(
      title = title_text,
      subtitle = subtitle_text,
      x = "Number of Schools",
      y = if(current_index < length(drill_levels)) drill_levels[current_index+1] else drill_level
    ) +
    scale_x_continuous(expand = expansion(mult = c(0, .1))) + 
    theme_minimal() +
    theme(axis.text.y = element_text(size = 10), 
          axis.text.x = element_text(size = 10))
  
}, res = 96)


# --- MODIFIED: 4e. Observer for plot clicks (stops at District) ---
observeEvent(input$adv_plot_click, {
  
  print("--- PLOT CLICK DETECTED! ---") 
  
  plot_data_for_click <- plot_data_r()
  if (is.null(plot_data_for_click) || nrow(plot_data_for_click) == 0) {
    print("--- DEBUG: plot_data_r() is NULL. Aborting. ---")
    return()
  }
  
  current_state <- adv_drill_state()
  current_index <- match(current_state$level, drill_levels)
  
  # --- MODIFIED: Check if we are at the *second to last* level ---
  # We stop if the *current* level is "Legislative", because the
  # *next* level ("District") is the end.
  if (is.na(current_index) || current_index == length(drill_levels)) {
    print(paste("--- DEBUG: At final drill level (", current_state$level, "). No action. ---"))
    return()
  }
  
  # --- Manual click calculation (unchanged) ---
  plot_data_sorted_asc <- plot_data_for_click %>% arrange(School_Count)
  clicked_y_index <- round(input$adv_plot_click$y)
  
  if (clicked_y_index < 1 || clicked_y_index > nrow(plot_data_sorted_asc)) {
    print("--- DEBUG: Click index out of bounds. Aborting. ---")
    return()
  }
  
  clicked_bar_data <- plot_data_sorted_asc[clicked_y_index, ]
  clicked_x_value <- input$adv_plot_click$x
  bar_x_max <- clicked_bar_data$School_Count
  
  if (clicked_x_value < 0 || clicked_x_value > (bar_x_max * 1.1)) {
    print("--- DEBUG: Click x-coordinate outside bar area. Aborting. ---")
    return()
  }
  
  clicked_value <- as.character(clicked_bar_data$Group)
  print(paste("--- DEBUG: Click is valid. Group:", clicked_value, "---"))
  
  # --- Prepare the NEW state ---
  
  # --- MODIFIED: Get correct levels ---
  # The *next* level is the one we are drilling *to*
  next_level <- drill_levels[current_index + 1]
  # The *column to filter* is the one we just clicked
  col_to_filter <- col_name_map[next_level] # We clicked on a "Division" bar
  
  new_filters <- current_state$filters
  new_filters[[col_to_filter]] <- clicked_value
  
  print(paste("--- ADVANCED ANALYTICS: Drilling down to", next_level, 
              "where", col_to_filter, "=", clicked_value, "---"))
  
  new_state_list <- list(level = next_level, filters = new_filters)
  adv_drill_state(new_state_list)
})


# --- 5. Data Table and Map ---

# --- 5a. Render the Filtered Data Table ---
# --- 5. Data Table and Map ---

# --- MODIFIED: 5a. Render the Filtered Data Table ---
# This version shows ALL columns and freezes School.Name and SchoolID
# for horizontal scrolling.
output$advanced_data_table <- DT::renderDataTable({
  
  req(drilled_data_and_level())
  print("--- ADVANCED ANALYTICS: Rendering data table. ---")
  
  data_from_drilldown <- drilled_data_and_level()$data
  
  # --- NEW: Reorder columns to show all, with frozen columns first ---
  # We must ensure the columns we want to freeze are the first ones
  # in the dataframe. We use select() to put them first, followed
  # by 'everything()' else.
  #
  # NOTE: The map code uses 'SchoolID'. I'm assuming that's the
  # correct column name. If it's 'School.ID', just change it below.
  if (!"SchoolID" %in% names(data_from_drilldown)) {
    
    print("--- TABLE WARNING: 'SchoolID' column not found. Freezing 'School.Name' only. ---")
    
    data_to_show <- data_from_drilldown %>%
      select(School.Name, everything())
    
    cols_to_freeze <- 1
    
  } else {
    
    print("--- TABLE INFO: Reordering columns to freeze 'School.Name' and 'SchoolID'. ---")
    
    data_to_show <- data_from_drilldown %>%
      select(School.Name, SchoolID, everything())
    
    cols_to_freeze <- 2
  }
  
  datatable(
    data_to_show,
    selection = 'single', # Keep single row selection
    
    # --- MODIFICATION: Added 'FixedColumns' extension ---
    extensions = 'FixedColumns', 
    
    options = list(
      scrollX = TRUE,  
      pageLength = 10, 
      
      # --- MODIFICATION: autoWidth MUST be FALSE for FixedColumns to work ---
      autoWidth = FALSE, 
      
      # --- MODIFICATION: Add FixedColumns options ---
      # This freezes the first 'cols_to_freeze' (2) columns on the left
      fixedColumns = list(leftColumns = cols_to_freeze),
      
      # scrollCollapse is generally good practice with scrolling tables
      scrollCollapse = TRUE
    ),
    rownames = FALSE,
    filter = 'top' 
  )
})

# --- MODIFIED: 5b. Render the Leaflet Map (Popup is now a Label) ---
output$advanced_school_map <- renderLeaflet({
  
  print("--- MAP RENDER: Starting... ---")
  
  req(drilled_data_and_level())
  data_for_map <- drilled_data_and_level()$data
  
  print(paste("--- MAP RENDER: Data received with", nrow(data_for_map), "rows. ---"))
  
  # --- !!! ACTION REQUIRED !!! ---
  # Replace these with your actual latitude and longitude column names
  lat_col <- "Latitude" 
  lon_col <- "Longitude"
  
  
  # Check if columns exist
  if (!all(c(lat_col, lon_col) %in% names(data_for_map))) {
    print(paste("--- MAP RENDER ERROR: Lat/Lon columns (", lat_col, ",", lon_col, ") not found in data. ---"))
    return(leaflet() %>% addTiles() %>% 
             addControl(paste("MAP ERROR: Columns", lat_col, "or", lon_col, "not found."), 
                        position = "topright", className = "map-error-box"))
  }
  
  # Filter out rows with missing coordinates and ensure numeric type
  data_for_map_filtered <- data_for_map %>%
    mutate(
      !!sym(lat_col) := as.numeric(!!sym(lat_col)),
      !!sym(lon_col) := as.numeric(!!sym(lon_col))
    ) %>%
    filter(!is.na(!!sym(lat_col)) & !is.na(!!sym(lon_col))) 
  
  print(paste("--- MAP RENDER: Filtered to", nrow(data_for_map_filtered), "rows with valid numeric coordinates. ---"))
  
  if (nrow(data_for_map_filtered) == 0) {
    print("--- MAP RENDER: No schools with valid coordinates to plot. ---")
    return(leaflet() %>% addTiles() %>% 
             addControl("No schools with valid coordinates match your filters.", 
                        position = "topright"))
  }
  
  # --- Define a rich HTML string for the label ---
  # This is the same as before
  data_for_map_filtered <- data_for_map_filtered %>%
    mutate(
      map_label_html = paste(
        "<strong>", School.Name, "</strong><hr>",
        "<strong>School ID:</strong>", SchoolID, "<br>",
        "<strong>Region:</strong>", Region, "<br>",
        "<strong>Division:</strong>", Division, "<br>",
        "<strong>Municipality:</strong>", Municipality
      )
    )
  
  # --- NEW: Convert the HTML string to an actual HTML object ---
  # This tells leaflet to *render* the HTML, not just show the text
  data_for_map_filtered$map_label_html <- lapply(
    data_for_map_filtered$map_label_html, 
    htmltools::HTML
  )
  
  print("--- MAP RENDER: Rendering map with AwesomeMarkers and Tile options... ---")
  
  leaflet(data = data_for_map_filtered) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
    addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>% 
    
    # --- Use addAwesomeMarkers ---
    addAwesomeMarkers(
      lng = as.formula(paste0("~", lon_col)),
      lat = as.formula(paste0("~", lat_col)),
      
      # --- THIS IS THE CHANGE ---
      # 1. We REMOVED the 'popup' argument
      # 2. We set 'label' to our new HTML-formatted column
      label = ~map_label_html,
      # --- END OF CHANGE ---
      
      icon = icon("graduation-cap"),
      clusterOptions = markerClusterOptions()
    ) %>%
    
    # --- Add the control to switch between map layers ---
    addLayersControl(
      baseGroups = c("Satellite","Road Map"))
})


# --- 5c. Observer for table row selection (MERGED AND CORRECTED) ---
observeEvent(input$advanced_data_table_rows_selected, {
  
  req(input$advanced_data_table_rows_selected)
  
  selected_row_index <- input$advanced_data_table_rows_selected
  
  print("--- TABLE ROW SELECTED! ---")
  
  # --- !!! ACTION REQUIRED !!! ---
  # Replace these with your actual latitude and longitude column names
  lat_col <- "Latitude" 
  lon_col <- "Longitude"
  

  
  # Get the data for the selected row
  tryCatch({
    data_from_table <- drilled_data_and_level()$data
    
    if (!all(c(lat_col, lon_col) %in% names(data_from_table))) {
      print(paste("--- MAP SETVIEW ERROR: Lat/Lon columns (", lat_col, ",", lon_col, ") not found. ---"))
      return()
    }
    
    selected_row_data <- data_from_table[selected_row_index, ]
    
    # Explicitly convert to numeric
    selected_lat <- as.numeric(selected_row_data[[lat_col]])
    selected_lon <- as.numeric(selected_row_data[[lon_col]])
    
    # This check now robustly handles NA, NULL, or 0-length values
    if (length(selected_lat) == 0 || is.na(selected_lat) || 
        length(selected_lon) == 0 || is.na(selected_lon)) {
      
      print("--- MAP SETVIEW: Selected row has NA, NULL, or non-numeric coordinates. ---")
      return()
    }
    
    print(paste("--- MAP SETVIEW: Zooming to", selected_row_data$School.Name, "---"))
    
    leafletProxy("advanced_school_map") %>%
      clearPopups() %>% 
      setView(
        lng = selected_lon,
        lat = selected_lat,
        zoom = 15
      )
    
  }, error = function(e) {
    print(paste("--- MAP SETVIEW ERROR:", e$message, "---"))
  })
  
}) # <-- Make sure this is the ONLY observer for advanced_data_table_rows_selected


# --- MODIFIED: 5c. Observer for table row selection (to control map) ---
observeEvent(input$advanced_data_table_rows_selected, {
  
  req(input$advanced_data_table_rows_selected)
  
  selected_row_index <- input$advanced_data_table_rows_selected
  
  print("--- TABLE ROW SELECTED! ---")
  
  # --- !!! ACTION REQUIRED !!! ---
  # Replace these with your actual latitude and longitude column names
  lat_col <- "Latitude" 
  lon_col <- "Longitude"
  
  # --- NEW: Check if you changed the placeholders ---
  
  # Get the data for the selected row
  tryCatch({
    data_from_table <- drilled_data_and_level()$data
    
    if (!all(c(lat_col, lon_col) %in% names(data_from_table))) {
      print("--- MAP SETVIEW ERROR: Lat/Lon columns not found. ---")
      return()
    }
    
    selected_row_data <- data_from_table[selected_row_index, ]
    
    # Explicitly convert to numeric
    selected_lat <- as.numeric(selected_row_data[[lat_col]])
    selected_lon <- as.numeric(selected_row_data[[lon_col]])
    
    if (is.na(selected_lat) || is.na(selected_lon)) {
      # This will now catch both original NAs and conversion failures
      print("--- MAP SETVIEW: Selected row has NA or non-numeric coordinates. ---")
      return()
    }
    
    print(paste("--- MAP SETVIEW: Zooming to", selected_row_data$School.Name, "---"))
    
    leafletProxy("advanced_school_map") %>%
      clearPopups() %>% 
      setView(
        lng = selected_lon,
        lat = selected_lat,
        zoom = 15
      )
    
  }, error = function(e) {
    print(paste("--- MAP SETVIEW ERROR:", e$message, "---"))
  })
  
})
# # =========================================================
# # --- ADVANCED ANALYTICS REPORT GENERATOR ---
# # =========================================================
# 
# output$generate_report_adv <- downloadHandler(
#   filename = function() {
#     paste("Advanced_Analytics_Report_", Sys.Date(), ".html", sep = "")
#   },
#   content = function(file) {
#     # 1. Notify User
#     id <- showNotification("Generating Report...", duration = NULL, closeButton = FALSE)
#     on.exit(removeNotification(id), add = TRUE)
#     
#     # 2. Prepare Template
#     tempReport <- file.path(tempdir(), "report.Rmd")
#     file.copy("report.Rmd", tempReport, overwrite = TRUE)
#     
#     # 3. GET DATA
#     # We grab the filtered data currently shown in the Advanced Analytics table
#     # 'drilled_data_and_level()' is the reactive that holds your filtered table
#     req(drilled_data_and_level())
#     raw_data <- drilled_data_and_level()$data
#     
#     # 4. SUMMARIZE DATA FOR CHARTS
#     # We summarize the list of schools into counts so the report can draw bars
#     final_report_data <- data.frame()
#     
#     # --- A. Region Breakdown ---
#     if ("Region" %in% names(raw_data)) {
#       summ_reg <- raw_data %>%
#         group_by(Region) %>%
#         tally(name = "Value") %>%
#         rename(Category = Region) %>%
#         mutate(Metric = "Distribution by Region") %>%
#         ungroup()
#       final_report_data <- bind_rows(final_report_data, summ_reg)
#     }
#     
#     # --- B. Division Breakdown ---
#     if ("Division" %in% names(raw_data)) {
#       summ_div <- raw_data %>%
#         group_by(Division) %>%
#         tally(name = "Value") %>%
#         rename(Category = Division) %>%
#         mutate(Metric = "Distribution by Division") %>%
#         ungroup()
#       final_report_data <- bind_rows(final_report_data, summ_div)
#     }
#     
#     # --- C. School Type Breakdown (if available) ---
#     # Tries to find "School.Type" or "Sector" columns
#     type_col <- NULL
#     if ("School.Type" %in% names(raw_data)) type_col <- "School.Type"
#     else if ("Sector" %in% names(raw_data)) type_col <- "Sector"
#     
#     if (!is.null(type_col)) {
#       summ_type <- raw_data %>%
#         group_by(.data[[type_col]]) %>%
#         tally(name = "Value") %>%
#         rename(Category = .data[[type_col]]) %>%
#         mutate(Metric = "Distribution by School Type") %>%
#         ungroup()
#       final_report_data <- bind_rows(final_report_data, summ_type)
#     }
#     
#     # 5. PREPARE PARAMETERS
#     # Get unique list of metrics for the report loop
#     all_metrics <- unique(final_report_data$Metric)
#     metric_names_list <- setNames(as.list(all_metrics), all_metrics)
#     
#     params_list <- list(
#       data = final_report_data,
#       metrics = all_metrics,
#       state = list(
#         level = "Advanced Filter Selection",
#         region = "Custom Filtered Data",
#         division = NULL,
#         municipality = NULL
#       ),
#       metric_names = metric_names_list
#     )
#     
#     # 6. RENDER
#     rmarkdown::render(
#       tempReport,
#       output_file = file,
#       params = params_list,
#       envir = new.env(parent = globalenv())
#     )
#   }
# )