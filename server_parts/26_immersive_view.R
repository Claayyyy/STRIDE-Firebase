# ==============================================================================
# 26_immersive_view.R
# Purpose: Server logic for the Interactive Immersive View in Resource Mapping
# ==============================================================================

# 0. Base Leaflet Map for Immersive View (Required for leafletProxy to work)
output$ImmersiveMap <- renderLeaflet({
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 6) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
    addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>% 
    addLayersControl(
      baseGroups = c("Satellite", "Road Map"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>%
    addLegend(
      position = "bottomright",
      title = "Map Legend",
      colors = c("blue", "red", "red", "orange"),
      labels = c(
        "All Schools",
        "Last Mile Schools",
        "Teacher Shortage",
        "Classroom Shortage"
      )
    )
})

# 1. Reactive Data for Immersive View (PURE DATA LOGIC)
data_Immersive <- reactive({
  req(input$Immersive_Layer)
  
  region_filter <- input$Immersive_Region
  layer_type <- input$Immersive_Layer
  
  if (layer_type == "All Schools") {
    # 1. Base Data: All Schools from 'uni'
    data_out <- uni
    
    print(paste("🔍 ALL SCHOOLS DEBUG: Total schools in uni:", nrow(data_out)))
    
    # Check coordinates before filtering
    with_coords_before <- data_out %>% filter(!is.na(Latitude) & !is.na(Longitude))
    print(paste("🔍 ALL SCHOOLS DEBUG:", nrow(with_coords_before), "schools have coordinates"))
    
    # 2. Apply Region Filter
    if (region_filter != "All Regions") {
      data_out <- data_out %>% filter(Region == region_filter)
      print(paste("🔍 ALL SCHOOLS DEBUG: After region filter:", nrow(data_out), "schools"))
    }
    
    return(data_out %>% mutate(Latitude = as.numeric(Latitude), Longitude = as.numeric(Longitude)))
    
  } else if (layer_type == "Last Mile School") {
    # 1. Identify LMS School IDs from the base file
    lms_ids <- LMS %>% 
      filter(as.character(LMS) == "1") %>%
      pull(School_ID)
    
    print(paste("🔍 LMS DEBUG: Found", length(lms_ids), "LMS School IDs"))
      
    # 2. Filter the RICH 'uni' dataset for these IDs
    data_out <- uni %>%
      filter(SchoolID %in% lms_ids)
    
    print(paste("🔍 LMS DEBUG: Matched", nrow(data_out), "schools in uni dataset"))
    
    # Debug: Check how many have coordinates
    with_coords <- data_out %>% filter(!is.na(Latitude) & !is.na(Longitude))
    print(paste("🔍 LMS DEBUG:", nrow(with_coords), "schools have coordinates in uni"))
      
    # 3. Apply Region Filter
    if (region_filter != "All Regions") {
      data_out <- data_out %>% filter(Region == region_filter)
      print(paste("🔍 LMS DEBUG: After region filter:", nrow(data_out), "schools"))
    }
      
    return(data_out %>% mutate(Latitude = as.numeric(Latitude), Longitude = as.numeric(Longitude)))
    
  } else if (layer_type == "Teacher Shortage") {
    # Use uni (School-Level) data for Teacher Shortage (Column: Total.Shortage)
    data_out <- uni %>%
      # Ensure numeric conversion
      mutate(TeacherShortage = suppressWarnings(as.numeric(Total.Shortage))) %>% 
      filter(TeacherShortage > 0)
      
    # Apply Region Filter
    if (region_filter != "All Regions") {
      data_out <- data_out %>% filter(Region == region_filter)
    }
    return(data_out %>% mutate(Latitude = as.numeric(Latitude), Longitude = as.numeric(Longitude)))
    
  } else if (layer_type == "Classroom Shortage") {
    # Use uni (School-Level) data for Classroom Shortage
    data_out <- uni %>%
      mutate(Classroom.Shortage = suppressWarnings(as.numeric(Classroom.Shortage))) %>%
      filter(Classroom.Shortage > 0)
      
    # Apply Region Filter
    if (region_filter != "All Regions") {
      data_out <- data_out %>% filter(Region == region_filter)
    }
    return(data_out %>% mutate(Latitude = as.numeric(Latitude), Longitude = as.numeric(Longitude)))
  }
})

# 2. Update Map Markers (DISPLAY LOGIC)
observe({
  # Trigger on inputs to ensure initialization even if data doesn't "change" (e.g. initial load)
  layer_input <- input$Immersive_Layer
  region_input <- input$Immersive_Region
  
  # Debug print statements
  print(paste("🔍 IMMERSIVE DEBUG: Layer =", layer_input, "| Region =", region_input))
  
  # Require inputs first
  req(layer_input, region_input)
  
  # Get data and validate
  data_map <- tryCatch({
    data_Immersive()
  }, error = function(e) {
    print(paste("❌ ERROR getting data_Immersive:", e$message))
    return(NULL)
  })
  
  # Validate data exists
  if (is.null(data_map)) {
    print("❌ IMMERSIVE DEBUG: data_map is NULL")
    return()
  }
  
  # Debug data dimensions
  print(paste("✅ IMMERSIVE DEBUG: Got", nrow(data_map), "rows of data"))
  
  # Check if Latitude/Longitude columns exist
  if (!"Latitude" %in% names(data_map) || !"Longitude" %in% names(data_map)) {
    print("❌ IMMERSIVE DEBUG: Latitude or Longitude column missing!")
    return()
  }
  
  # Debug: Show coordinate data quality
  na_lat <- sum(is.na(data_map$Latitude))
  na_long <- sum(is.na(data_map$Longitude))
  zero_lat <- sum(data_map$Latitude == 0, na.rm = TRUE)
  zero_long <- sum(data_map$Longitude == 0, na.rm = TRUE)
  
  print(paste("📊 Coordinate Quality: NA Latitude =", na_lat, "| NA Longitude =", na_long, 
              "| Zero Latitude =", zero_lat, "| Zero Longitude =", zero_long))
  
  # Filter for valid coordinates (non-NA and non-zero)
  # Note: Latitude/Longitude are already numeric from app.R conversion
  data_map <- data_map %>% 
    filter(!is.na(Latitude) & !is.na(Longitude) & 
           Latitude != 0 & Longitude != 0)
  
  print(paste("✅ IMMERSIVE DEBUG:", nrow(data_map), "schools with valid coordinates"))
  
  req(nrow(data_map) > 0)
  
  layer_type <- input$Immersive_Layer
  
  proxy <- leafletProxy("ImmersiveMap", data = data_map) %>%
    clearMarkers() %>%
    clearMarkerClusters() %>% 
    clearControls()
    
  if (is.null(data_map) || nrow(data_map) == 0) return()
  
  # --- HELPER: Create Comprehensive Popup Content ---
  create_popup_content <- function(d) {
    # Helper to clean NAs
    safe_val <- function(x) ifelse(is.na(x) | x == "", "-", x)
    
    paste0(
      "<div style='font-family: Arial; font-size: 11px; line-height: 1.3; min-width: 300px; color: #333;'>",
      
      # --- HEADER ---
      "<div style='background-color: #007bff; color: white; padding: 5px; border-radius: 3px 3px 0 0;'>",
        "<h4 style='margin: 0; font-size: 14px;'>", safe_val(d$School.Name), "</h4>",
        "ID: ", safe_val(d$SchoolID), 
      "</div>",
      
      "<div style='padding: 5px;'>",
        "<strong>Location:</strong> ", safe_val(d$Region), " | ", safe_val(d$Division), " | ", safe_val(d$Municipality), "<br>",
        "<strong>Head:</strong> ", safe_val(d$School.Head.Name), " (", safe_val(d$School.Head.Contact), ")<br>",
      "</div>",
      
      "<hr style='margin: 3px 0;'>",
      
      # --- ENROLMENT & TEACHERS ---
      "<div style='display: flex; justify-content: space-between;'>",
        "<div style='width: 48%;'>",
          "<strong>Enrolment</strong><br>",
          "Total: ", safe_val(d$TotalEnrolment), "<br>",
          "Elementary: ", safe_val(suppressWarnings(as.numeric(d$G1) + as.numeric(d$G2) + as.numeric(d$G3) + as.numeric(d$G4) + as.numeric(d$G5) + as.numeric(d$G6))), "<br>",
          "JHS: ", safe_val(suppressWarnings(as.numeric(d$G7) + as.numeric(d$G8) + as.numeric(d$G9) + as.numeric(d$G10))), "<br>",
          "SHS: ", safe_val(suppressWarnings(as.numeric(d$G11) + as.numeric(d$G12))),
        "</div>",
        "<div style='width: 48%;'>",
          "<strong>Teachers</strong><br>",
          "Total: ", safe_val(d$TotalTeachers), "<br>",
          "Shortage: <span style='color:red; font-weight:bold;'>", safe_val(d$Total.Shortage), "</span><br>",
          "Excess: <span style='color:blue;'>", safe_val(d$Total.Excess), "</span>",
        "</div>",
      "</div>",
      
      "<hr style='margin: 3px 0;'>",
      
      # --- INFRASTRUCTURE ---
      "<strong>Infrastructure</strong><br>",
      "<div style='display: grid; grid-template-columns: 1fr 1fr; gap: 5px;'>",
        "<div>Buildings: ", safe_val(d$Buildings), "</div>",
        "<div>Classrooms: ", safe_val(d$Instructional.Rooms.2023.2024), "</div>",
        "<div><strong>CL Shortage:</strong> <span style='color:orange; font-weight:bold;'>", safe_val(d$Classroom.Shortage), "</span></div>",
        "<div>Buildable Space: ", safe_val(d$With_Buildable_space), "</div>",
      "</div>",
      
      "<hr style='margin: 3px 0;'>",
      
      # --- UTILITIES ---
      "<strong>Utilities</strong><br>",
      "Power: ", safe_val(d$ElectricitySource), "<br>",
      "Water: ", safe_val(d$WaterSource), "<br>",
      
      "</div>" 
    )
  }

  # Generate Popups for current map data
  # Ensure columns exist before running to avoid crash, fill with NA if missing
  required_cols <- c("School.Name","SchoolID","Region","Division","Municipality","School.Head.Name","School.Head.Contact",
                     "TotalEnrolment","G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12",
                     "TotalTeachers","Total.Shortage","Total.Excess","Buildings","Instructional.Rooms.2023.2024",
                     "Classroom.Shortage","With_Buildable_space","ElectricitySource","WaterSource")
  
  # Check if data_map is valid
  if(nrow(data_map) > 0) {
     # Simple check and fill for missing columns to prevent error in popup generation
     for(col in required_cols) {
       if(!col %in% names(data_map)) data_map[[col]] <- NA
     }
     popup_content <- create_popup_content(data_map) %>% lapply(htmltools::HTML)
  } else {
     popup_content <- NULL
  }

  # --- ALL SCHOOLS MARKERS ---
  if (layer_type == "All Schools") {
     print(paste("🎯 Adding", nrow(data_map), "ALL SCHOOLS markers"))
     proxy %>%
      addAwesomeMarkers(
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 12),
        lng = ~as.numeric(Longitude),
        lat = ~as.numeric(Latitude),
        icon = makeAwesomeIcon(icon = "education", library = "glyphicon", markerColor = "blue"),
        label = paste(data_map$School.Name) %>% lapply(htmltools::HTML),
        popup = popup_content
      )

  # --- LMS MARKERS ---
  } else if (layer_type == "Last Mile School") {
    print(paste("🎯 Adding", nrow(data_map), "LAST MILE SCHOOL markers"))
    proxy %>%
      addAwesomeMarkers(
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 12),
        lng = ~as.numeric(Longitude),
        lat = ~as.numeric(Latitude),
        icon = makeAwesomeIcon(icon = "education", library = "glyphicon", markerColor = "red"),
        label = paste(data_map$School.Name) %>% lapply(htmltools::HTML),
        popup = popup_content
      )
      
  # --- TEACHER SHORTAGE MARKERS ---
  } else if (layer_type == "Teacher Shortage") {
     print(paste("🎯 Adding", nrow(data_map), "TEACHER SHORTAGE markers"))
     proxy %>%
      addAwesomeMarkers(
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
        lng = ~as.numeric(Longitude),
        lat = ~as.numeric(Latitude),
        label = paste(
          strong("School:"), data_map$School.Name, "<br>",
          strong("Teacher Shortage:"), data_map$TeacherShortage
        ) %>% lapply(htmltools::HTML),
        popup = popup_content,
        icon = makeAwesomeIcon(icon = "user", library = "fa", markerColor = "red") 
      )
      
  # --- CLASSROOM SHORTAGE MARKERS ---
  } else if (layer_type == "Classroom Shortage") {
     print(paste("🎯 Adding", nrow(data_map), "CLASSROOM SHORTAGE markers"))
     proxy %>%
      addAwesomeMarkers(
        clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
        lng = ~as.numeric(Longitude),
        lat = ~as.numeric(Latitude),
        label = paste(
          strong("School:"), data_map$School.Name, "<br>",
          strong("Classroom Shortage:"), data_map$Classroom.Shortage
        ) %>% lapply(htmltools::HTML),
        popup = popup_content,
        icon = makeAwesomeIcon(icon = "home", library = "fa", markerColor = "orange") 
      )
  }
})

# --- NEW: Region Zoom Logic ---
observeEvent(input$Immersive_Region, {
  region <- input$Immersive_Region
  proxy <- leafletProxy("ImmersiveMap")
  
  if (region == "All Regions") {
    proxy %>% setView(lng = 122, lat = 13, zoom = 6)
  } else {
    # Define approximate centroids for regions
    # This is a simple lookup. Precision doesn't need to be perfect for filtered view.
    coords <- switch(region,
      "Region I"      = list(lat = 17.5, lng = 120.5),
      "Region II"     = list(lat = 17.0, lng = 121.8),
      "Region III"    = list(lat = 15.5, lng = 120.8),
      "Region IV-A"   = list(lat = 14.2, lng = 121.2),
      "MIMAROPA"      = list(lat = 13.0, lng = 121.0),
      "Region V"      = list(lat = 13.5, lng = 123.5),
      "Region VI"     = list(lat = 11.0, lng = 122.5),
      "NIR"           = list(lat = 10.0, lng = 123.0),
      "Region VII"    = list(lat = 10.0, lng = 123.8),
      "Region VIII"   = list(lat = 11.5, lng = 125.0),
      "Region IX"     = list(lat = 7.8,  lng = 122.5),
      "Region X"      = list(lat = 8.0,  lng = 125.0),
      "Region XI"     = list(lat = 7.0,  lng = 125.6),
      "Region XII"    = list(lat = 6.5,  lng = 124.8),
      "CARAGA"        = list(lat = 9.0,  lng = 125.8),
      "CAR"           = list(lat = 17.0, lng = 121.0),
      "NCR"           = list(lat = 14.6, lng = 121.0),
      NULL
    )
    
    if (!is.null(coords)) {
       proxy %>% setView(lng = coords$lng, lat = coords$lat, zoom = 8)
    }
  }
})

# 3. Update Search Choices (School Names)
observe({
  data_map <- data_Immersive()
  req(data_map)
  
  # Determine correct column name for School Name depending on dataset
  school_names <- if("School_Name" %in% names(data_map)) data_map$School_Name else data_map$School.Name
  school_names <- sort(unique(school_names))
  
  updateSelectizeInput(session, "Immersive_Search", choices = c("", school_names), server = TRUE)
})

# 4. Search Zoom Logic
observeEvent(input$Immersive_Search, {
  req(input$Immersive_Search)
  school_name <- input$Immersive_Search
  data_map <- data_Immersive()
  
  # Determine correct column name
  name_col <- if("School_Name" %in% names(data_map)) "School_Name" else "School.Name"
  
  target_school <- data_map[data_map[[name_col]] == school_name, ]
  
  if (nrow(target_school) > 0) {
    leafletProxy("ImmersiveMap") %>%
      flyTo(lng = target_school$Long[1], lat = target_school$Lat[1], zoom = 18) 
  }
})

# Helper for safe case_when inside makeAwesomeIcon if typical case_when fails or to match syntax
case_which <- function(...) {
  dplyr::case_when(...)
}
