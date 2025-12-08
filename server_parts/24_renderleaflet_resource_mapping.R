# renderleaflet for resrouce mapping

output$TeacherShortage_Mapping <- renderLeaflet({
  p = colorFactor(palette = c("red","deepskyblue","green"),domain = c("Shortage","Excess","Balanced"), ordered = T)
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom =7) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
   addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>% 
    addLegend(position = "bottomright", title = "Legend", pal = p, values = c("Shortage","Excess","Balanced")) %>% 
    addLayersControl(
      baseGroups = c("Satellite","Road Map"))
})

output$SHSMapping <- renderLeaflet({
  domain <- c("Manufacturing and Engineering",
              "Hospitality and Tourism",
              "Professional/Private Services",
              "Public Administration",
              "Business and Finance",
              "Agriculture and Agri-business")
  
  p <- colorFactor(
    palette = c("red", "orange", "violet", "green", "blue", "magenta"),
    levels = domain
  )
  
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 6) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
   addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(
      position = "topright",
      primaryLengthUnit = "kilometers",
      primaryAreaUnit = "sqmeters"
    ) %>% 
    addLegend(
      position = "bottomright",
      title = "Industry Type",
      pal = p,
      values = domain
    ) %>%
    addLayersControl(
      baseGroups = c("Satellite", "Road Map")
    )
})


output$AO2Mapping <- renderLeaflet({
  p = colorFactor(
    palette = c("red","orange","green"),
    domain = c("No AO II and PDO I","With at least 1 AO II or PDO I","With AO II and PDO I"),
    ordered = TRUE
  )
  
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 6) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
   addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>% 
    addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>% 
    addLegend(
      position = "bottomright",
      title = "Legend",
      pal = p,
      values = c("No AO II and PDO I","With at least 1 AO II or PDO I","With AO II and PDO I")
    ) %>% 
    addLayersControl(baseGroups = c("Satellite","Road Map"))
})

# --- Base map with static legend ---
output$CLMapping <- renderLeaflet({
  # Legend domain + palette
  domain <- c(
    "With Classroom Shortage", 
    "Without Classroom Shortage"
  )
  
  pal <- colorFactor(
    palette = c("red","green"),
    domain = domain,
    ordered = TRUE
  )
  
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 6) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
   addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(
      position = "topright",
      primaryLengthUnit = "kilometers",
      primaryAreaUnit = "sqmeters"
    ) %>% 
    addLegend(
      position = "bottomright",
      title = "Legend",
      pal = pal,
      values = domain
    ) %>% 
    addLayersControl(
      baseGroups = c("Satellite","Road Map")
    )
})


output$FacMapping <- renderLeaflet({
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom =6) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
   addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>%
    addLayersControl(
      baseGroups = c("Satellite","Road Map")
    )
})

values.coord <- paste("Region: ", geojson_table$Region, "<br>",
                      "Learner Congestion:",":", geojson_table$Congestion.Index) %>% lapply(htmltools::HTML)

output$CongestMapping <- renderLeaflet({
  
  pal <- colorBin(
    palette = c("green", "orange", "red"),
    domain = geojson_table$Congestion.Index
  )
  
  domain = c("Not Congested","Moderately Congested","Severely Congested")
  p = colorFactor(palette = c("green","orange","red"), levels = as.factor(domain), ordered = F)
  
  leaflet() %>%
    setView(lng = 122, lat = 13, zoom = 6) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
   addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>%
    addLayersControl(
      baseGroups = c("Satellite", "Road Map")
    ) %>%
    addTiles() %>%
    addPolygons(
      data = geojson_data,
      stroke = FALSE,
      weight = 4,
      fillOpacity = 0.75,
      fillColor = ~pal(geojson_table$Congestion.Index),
      label = values.coord
    ) %>% 
    addLegend(
      position = "bottomright", 
      title = "Legend", 
      pal = p, 
      values = c("Not Congested","Moderately Congested","Severely Congested"))
})


#LMSTABLE 
# output$LMSTable <- renderDataTable({
#   req(LMS, uni, buildablecsv)
#   
#   lms_data <- LMS %>%
#     filter(LMS == 1) %>%   # Step 1: LMS only
#     left_join(uni, by = c("School_ID" = "SchoolID")) %>%   # Step 2: lat/long
#     left_join(buildablecsv, by = c(`Buildable_Space` = `Avaiability of Buildable Space (Y/N)`)) %>%  # Step 2: buildable remarks
#     filter(Region == input$resource_map_region) %>%       # Step 3
#     filter(Division == input$Resource_SDO) %>%            # Step 3
#     filter(LD == input$leg_district) %>%                  # Step 3
#     select(                                                # Step 4
#       `NAME OF SCHOOL`,
#       `Avaiability of Buildable Space (Y/N)`,
#       `OTHER REMARKS (Buildable Space)`
#     )
#   
#   datatable(
#     lms_data,
#     options = list(pageLength = 10, scrollX = TRUE, fixedColumns = list(leftColumns = 4)),
#     selection = "single",   #allow single row selection
#     extensions = c("FixedColumns") ,
#     callback = JS("window.dispatchEvent(new Event('resize'));")
#   )
# })

# --- LMS Map (initialize once) ---

output$LMSMapping <- renderLeaflet({
  # NOTE: We no longer use colorFactor() as the colors are determined 
  # by case_when in the proxy, which handles the logic. 
  # We just need to define the map structure and the legend colors/labels.
  
  leaflet() %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
   addProviderTiles(providers$OpenStreetMap.Mapnik, group = "Road Map") %>%
    setView(lng = 122, lat = 13, zoom = 6) %>%
    addLayersControl(
      baseGroups = c("Satellite", "Road Map"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>%
    addLegend(
      position = "bottomright",
      title = "Last Mile Schools Status",
      
      # 1. Define the colors (must match the case_when output in leafletProxy)
      colors = c("red", "green", "gray"),
      
      # 2. Define the labels (must describe the conditions that result in those colors)
      labels = c(
        "With Shortage + Without Buildable Space", 
        "With Shortage + With Buildable Space", 
        "Without Shortage + No Buildable Space"
      )
    )
})

# --- 1. Central Storage for Filtered Data ---
# This object will hold all our data after the "Run" button is clicked.
data_filtered <- reactiveValues()