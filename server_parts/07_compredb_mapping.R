# comprehensive dashboard mapping

filtered_data_for_map_and_table <- reactive({
  
  # 1. Get the current drilldown state
  state <- drilldown_state()
  
  # Get the click source, but provide a default if it's NULL
  click_source <- state$last_clicked_source
  if (is.null(click_source)) {
    click_source <- "default" # Use a default string
  }
  
  # 2. Conditionally select the base dataframe
  data_to_display <- switch(
    click_source,
    "drilldown_source_1" = uni,
    "drilldown_source_2" = LMS,
    "drilldown_source_3" = LMS,
    "drillkey_source_4" = df,
    "drilldown_source_5" = uni,
    uni # Default
  )
  
  # 3. Apply geographic filters (same as before)
  if (!is.null(state$region)) {
    data_to_display <- data_to_display %>%
      filter(Region == state$region)
    
    if (!is.null(state$division)) {
      data_to_display <- data_to_display %>%
        filter(Division == state$division)
      
      if (!is.null(state$legislative_district)) {
        if ("Legislative.District" %in% names(data_to_display)) {
          data_to_display <- data_to_display %>%
            filter(Legislative.District == state$legislative_district)
        } # <--- ADDED: Closing brace for 'if ("Legislative.District" %in% names(data_to_display))'
      } # <--- ADDED: Closing brace for 'if (!is.null(state$legislative_district))'
    } # <--- ADDED: Closing brace for 'if (!is.null(state$division))'
  } # <--- ADDED: Closing brace for 'if (!is.null(state$region))'
  
  # 4. Return the filtered data
  return(data_to_display)
  
})

# 1. A reactive expression to hold the data filtered by map bounds
data_within_bounds <- reactive({
  
  # Get the data from your main filters
  full_filtered_data <- filtered_data_for_map_and_table()
  
  # Get the map bounds
  bounds <- input$mapping_erdb_bounds
  
  # Start with the full set
  data_to_display <- full_filtered_data
  
  # Apply the spatial filter IF bounds exist
  if (!is.null(bounds) && nrow(full_filtered_data) > 0) {
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    data_to_display <- full_filtered_data %>%
      filter(
        Longitude >= lngRng[1] & Longitude <= lngRng[2],
        Latitude >= latRng[1] & Latitude <= latRng[2]
      )
  }
  
  # Return the filtered data
  return(data_to_display)
  
})

# --- Updated Data Table ---
# This now just renders the data from our new reactive
# 2. Render the data table using the reactive data
# (This replaces "PART B" from your old observer)
output$dashboarddt_erdb <- DT::renderDT({
  
  # ⭐️ Use the reactive expression here!
  data_within_bounds() 
  
},
selection = 'single',  
options = list(
  scrollX = TRUE,
  columnDefs = list(list(className = 'dt-left', targets ="_all"))
))

output$mapping_erdb <- renderLeaflet({
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 5) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
    addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright",
               primaryLengthUnit = "kilometers",
               primaryAreaUnit = "sqmeters") %>%
    addLayersControl(baseGroups = c("Satellite", "Road Map"))
})

# --- New Leaflet Proxy Observer ---
# This listens for changes to our reactive data and updates the map

# observeEvent(filtered_data_for_map_and_table(), {
#   
#   # 1. Get the filtered data
#   map_data <- filtered_data_for_map_and_table()
#   
#   # 2. Check if the data has any rows before trying to plot
#   if (nrow(map_data) > 0) {
#     
#     # Use the first row's coordinates to set the initial view
#     leafletProxy("mapping_erdb") %>%
#       clearMarkers() %>%
#       clearMarkerClusters() %>% # Keep this to ensure old clusters are removed
#       setView(
#         lng = map_data$Longitude[1],
#         lat = map_data$Latitude[1],
#         zoom = 4.5
#       ) %>%
#       addAwesomeMarkers(
#         lng = map_data$Longitude,
#         lat = map_data$Latitude,
#         icon = makeAwesomeIcon(
#           icon = "education",
#           library = "glyphicon",
#           markerColor = "blue"
#         ),
#         # ⭐️ ADDED: This line enables marker clustering
#         clusterOptions = markerClusterOptions()
#         # ,
#         # label = values.comp,
#         # labelOptions = labelOptions(...)
#       )
#     
#   } else {
#     # If there's no data, clear the markers and clusters
#     leafletProxy("mapping_erdb") %>%
#       clearMarkers() %>%
#       clearMarkerClusters()
#   }
# })

# 3. Observe the reactive data to update map markers
# (This replaces "PART A" from your old observer)
# NEW: Observe the MAIN filter reactive to set the "general view"
observe({
  
  # 1. Get the data from your MAIN filters
  #    (NOT data_within_bounds())
  full_data <- filtered_data_for_map_and_table()
  
  # 2. If there is data, zoom the map to show all of it
  if (nrow(full_data) > 0) {
    leafletProxy("mapping_erdb") %>%
      
      # 3. fitBounds() is better than setView() for this.
      #    It automatically finds the best zoom to show all points.
      fitBounds(
        lng1 = min(full_data$Longitude),
        lat1 = min(full_data$Latitude),
        lng2 = max(full_data$Longitude),
        lat2 = max(full_data$Latitude)
      )
  } else {
    # Optional: If no data, you could clear the bounds
    # or zoom to a default location.
    leafletProxy("mapping_erdb") %>%
      clearBounds()
  }
  
}) # End of new observe

# REVISED: Observe data_within_bounds to update the MARKERS
observe({
  
  # Get the data to display from our reactive
  data_to_display <- data_within_bounds()
  
  # Get a proxy for the map
  proxy <- leafletProxy("mapping_erdb", data = data_to_display) %>%
    clearMarkers() %>%
    clearMarkerClusters()
  # ❌ NO setView() or fitBounds() here!
  values.comp <- paste(
    strong("SCHOOL INFORMATION"),
    "<br>School Name:", data_to_display$School.Name,
    "<br>School ID:", data_to_display$SchoolID) %>% lapply(htmltools::HTML)
  # Add markers if we have any data
  if (nrow(data_to_display) > 0) {
    proxy %>%
      addAwesomeMarkers(
        lng = ~Longitude,
        lat = ~Latitude,
        icon = makeAwesomeIcon(
          icon = "education",
          library = "glyphicon",
          markerColor = "blue"
        ),
        label = values.comp,
        clusterOptions = markerClusterOptions()
      )
  }
}) # End of markers observe

# --- Create reactive values to store the table data ---
# This goes in your server, but OUTSIDE any observe() or render()
details_table_1 <- reactiveVal(NULL)
details_table_2 <- reactiveVal(NULL)
details_table_3 <- reactiveVal(NULL)
details_table_4 <- reactiveVal(NULL)
details_table_5 <- reactiveVal(NULL)

# 4. NEW: Observe a row click to zoom the map
observeEvent(input$dashboarddt_erdb_rows_selected, {
  
  # 1. Get the selected row index
  selected_row_index <- input$dashboarddt_erdb_rows_selected
  
  # 2. Check if a row is selected
  if (is.null(selected_row_index)) {
    # If deselected, clear all the tables
    details_table_1(NULL)
    details_table_2(NULL)
    details_table_3(NULL)
    details_table_4(NULL)
    details_table_5(NULL)
    return() # Stop here
  }
  
  # 3. Get the data *currently* in the table
  # (which is our reactive data)
  current_table_data <- data_within_bounds()
  
  # 4. Get the specific row that was clicked
  clicked_point <- current_table_data[selected_row_index, ]
  
  # 5. Zoom the map to that point
  if(nrow(clicked_point) > 0) {
    leafletProxy("mapping_erdb") %>%
      setView(
        lng = clicked_point$Longitude,
        lat = clicked_point$Latitude,
        zoom = 15 # ⭐️ You can adjust this zoom level!
      )
  }
  
  rowselected_table1 <- clicked_point %>% select(Region,Province,Municipality,Division,District,Barangay,Street.Address,SchoolID,School.Name,School.Head.Name,SH.Position,Implementing.Unit,Modified.COC,Latitude,Longitude) %>% rename("Modified Curricular Offering" = Modified.COC, "School ID" = SchoolID, "School Name" = School.Name, "Street Address" = Street.Address, "Implementing Unit" = Implementing.Unit, "School Head" = School.Head.Name,"School Head Position" = SH.Position) %>% mutate(dplyr::across(tidyr::everything(), as.character)) %>% pivot_longer(
    cols = everything(),    # Pivot all columns selected in details_to_pivot
    names_to = "Basic Info",     # Name of the new column holding the original column names
    values_to = "Data")     # Name of the new column holding the original values
  
  rowselected_table2 <- clicked_point %>% select(ES.Excess,ES.Shortage,JHS.Excess,JHS.Shortage,SHS.Excess,SHS.Shortage,ES.Teachers,JHS.Teachers,SHS.Teachers,ES.Enrolment,JHS.Enrolment,SHS.Enrolment,School.Size.Typology,Clustering.Status,Outlier.Status) %>% rename("ES Teachers"=ES.Teachers,"JHS Teachers"=JHS.Teachers,"SHS Teachers"=SHS.Teachers, "ES Enrolment" = ES.Enrolment, "JHS Enrolment" = JHS.Enrolment, "SHS Enrolment" = SHS.Enrolment, "School Size Typology" = School.Size.Typology, "AO II Deployment" = Clustering.Status,"COS Deployment" = Outlier.Status, "ES Shortage" = ES.Shortage,"ES Excess" = ES.Excess,"JHS Shortage" = JHS.Shortage,"JHS Excess" = JHS.Excess,"SHS Shortage" = SHS.Shortage,"SHS Excess" = SHS.Excess) %>% mutate(dplyr::across(tidyr::everything(), as.character)) %>% pivot_longer(
    cols = everything(),    # Pivot all columns selected in details_to_pivot
    names_to = "HR Data",     # Name of the new column holding the original column names
    values_to = "Data")     # Name of the new column holding the original values
  
  rowselected_table3 <- clicked_point %>% select(Buildings,Instructional.Rooms.2023.2024,Classroom.Requirement,Est.CS,Buidable_space,Major.Repair.2023.2024,SBPI,Shifting,OwnershipType,ElectricitySource,WaterSource,Total.Seats.2023.2024,Total.Seats.Shortage.2023.2024) %>% rename("With Buildable Space" = Buidable_space,"Number of Instructional Rooms" = Instructional.Rooms.2023.2024,"Classroom Requirement" = Classroom.Requirement,"Ownership Type" = OwnershipType,"Source of Electricity" = ElectricitySource,"Source of Water" = WaterSource,"Estimated Classroom Shortage"= Est.CS,"School Building Priority Index" = SBPI,"For Major Repairs"= Major.Repair.2023.2024,"Total Seats"=Total.Seats.2023.2024,"Total Seats Shortage"=Total.Seats.Shortage.2023.2024, "Number of Buildings"=Buildings) %>% mutate(dplyr::across(tidyr::everything(), as.character)) %>% pivot_longer(
    cols = everything(),    # Pivot all columns selected in details_to_pivot
    names_to = "Classroom Data",     # Name of the new column holding the original column names
    values_to = "Data")     # Name of the new column holding the original values
  
  
  rowselected_table4 <- clicked_point %>% select(SHA.2021.Index,Travel..Cost,Travel.Time,No.Piped.Water,No.Grid.Electricity,No.Internet,Conflict,TLS) %>% rename("HI 2021" = SHA.2021.Index,"Travel Cost" = Travel..Cost,"Travel Time" = Travel.Time,"No Access to Piped Water" = No.Piped.Water,"No Access to Grid Electricity"= No.Grid.Electricity,"No Access to Internet" = No.Internet,"Incidence of Conflict" = Conflict,"Existence of Temporary Learning Spaces"= TLS) %>% mutate(dplyr::across(tidyr::everything(), as.character)) %>% pivot_longer(
    cols = everything(),    # Pivot all columns selected in details_to_pivot
    names_to = "Other Data",     # Name of the new column holding the original column names
    values_to = "Data")     # Name of the new column holding the original values
  
  rowselected_table5 <- clicked_point %>% select(English,Mathematics,Science,Biological.Sciences,Physical.Sciences,General.Ed,Araling.Panlipunan,TLE,MAPEH,Filipino,ESP,Agriculture,ECE,SPED) %>% rename("Biological Sciences" = Biological.Sciences,"Physical Sciences" = Physical.Sciences,"General Education" = General.Ed,"Araling Panlipunan" = Araling.Panlipunan,"Early Chilhood Education" = ECE) %>% mutate(dplyr::across(tidyr::everything(), as.character)) %>% pivot_longer(
    cols = everything(),    # Pivot all columns selected in details_to_pivot
    names_to = "Other Data",     # Name of the new column holding the original column names
    values_to = "Data")     # Name of the new column holding the original values
  
  
  output$schooldetails_erdb <- renderTable({
    # Pass the pivoted data frame directly
    rowselected_table1
  },
  rownames = FALSE, # Don't show automatic row names
  colnames = TRUE,  # Show column names (Field, Value)
  hover = TRUE,     # Add hover effect to rows (optional styling)
  bordered = TRUE)
  
  output$schooldetails2_erdb <- renderTable({
    # Pass the pivoted data frame directly
    rowselected_table2
  },
  rownames = FALSE, # Don't show automatic row names
  colnames = TRUE,  # Show column names (Field, Value)
  hover = TRUE,     # Add hover effect to rows (optional styling)
  bordered = TRUE)
  
  output$schooldetails3_erdb <- renderTable({
    # Pass the pivoted data frame directly
    rowselected_table3
  },
  rownames = FALSE, # Don't show automatic row names
  colnames = TRUE,  # Show column names (Field, Value)
  hover = TRUE,     # Add hover effect to rows (optional styling)
  bordered = TRUE)
  
  output$schooldetails4_erdb <- renderTable({
    # Pass the pivoted data frame directly
    rowselected_table4
  },
  rownames = FALSE, # Don't show automatic row names
  colnames = TRUE,  # Show column names (Field, Value)
  hover = TRUE,     # Add hover effect to rows (optional styling)
  bordered = TRUE)
  
  output$schooldetails5_erdb <- renderTable({
    # Pass the pivoted data frame directly
    rowselected_table5
  },
  rownames = FALSE, # Don't show automatic row names
  colnames = TRUE,  # Show column names (Field, Value)
  hover = TRUE,     # Add hover effect to rows (optional styling)
  bordered = TRUE)
  
}) # End of observeEvent

