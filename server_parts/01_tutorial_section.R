# TUTORIAL SECTION

current_drilldown <- reactiveVal(list(level = "region", filter = NULL))

current_totals <- reactive({
  req(uni)
  state <- current_drilldown()
  
  data_to_sum <- uni
  
  if (state$level == "division") {
    data_to_sum <- uni %>% filter(Region == state$filter)
  } else if (state$level == "district") {
    data_to_sum <- uni %>% filter(Division == state$filter)
  }
  
  list(
    schools = nrow(data_to_sum), 
    enroll = sum(as.numeric(data_to_sum$TotalEnrolment), na.rm = TRUE),
    teach = sum(as.numeric(data_to_sum$TotalTeachers), na.rm = TRUE)
  )
})

output$card_enrollment <- renderUI({ 
  req(current_totals())
  card(
    card_header("Total Enrollment"),
    div(
      style="font-size: 2rem; font-weight: bold;", 
      class="text-primary text-center", 
      format(round(current_totals()$enroll), nsmall = 0, big.mark = ",")
    ),
    class = "mb-1" 
  )
})

output$card_teachers <- renderUI({ 
  req(current_totals())
  card(
    card_header("Total Teachers"),
    div(
      style="font-size: 2rem; font-weight: bold;", 
      class="text-primary text-center",
      format(round(current_totals()$teach), nsmall = 0, big.mark = ",")
    ),
    class = "mb-1"
  )
})

output$card_schools <- renderUI({ 
  req(current_totals())
  card(
    card_header("Total Schools"),
    div(
      style="font-size: 2rem; font-weight: bold;", 
      class="text-primary text-center",
      format(round(current_totals()$schools), nsmall = 0, big.mark = ",")
    ),
    class = "mb-1"
  )
})

drilldown_data <- reactive({
  req(uni)
  state <- current_drilldown()
  
  if (state$level == "region") {
    uni %>%
      group_by(Region) %>%
      summarise(
        Total_Enrollment = sum(as.numeric(TotalEnrolment), na.rm = TRUE),
        Total_Teachers = sum(as.numeric(TotalTeachers), na.rm = TRUE),
        Total_Schools = n() 
      ) %>%
      filter(!is.na(Region)) %>%
      rename(group_col = Region) 
  } else if (state$level == "division") {
    req(state$filter)
    uni %>%
      filter(Region == state$filter) %>%
      group_by(Division) %>%
      summarise(
        Total_Enrollment = sum(as.numeric(TotalEnrolment), na.rm = TRUE),
        Total_Teachers = sum(as.numeric(TotalTeachers), na.rm = TRUE),
        Total_Schools = n()
      ) %>%
      filter(!is.na(Division)) %>%
      rename(group_col = Division)
  } else if (state$level == "district") {
    req(state$filter)
    uni %>%
      filter(Division == state$filter) %>%
      group_by(District) %>%
      summarise(
        Total_Enrollment = sum(as.numeric(TotalEnrolment), na.rm = TRUE),
        Total_Teachers = sum(as.numeric(TotalTeachers), na.rm = TRUE),
        Total_Schools = n()
      ) %>%
      filter(!is.na(District)) %>%
      rename(group_col = District)
  }
})

output$plotly_enrollment <- renderPlotly({
  req(drilldown_data())
  plot_ly(
    drilldown_data(), 
    y = ~group_col, x = ~Total_Enrollment,
    type = 'bar', color = I("#0d6efd"), source = "drilldown_plot",
    text = ~Total_Enrollment,
    texttemplate = '%{text:,.0f}',
    textposition = 'outside',
    textfont = list(color = '#000000', size = 10)
  ) %>%
    layout(
      title = "Total Enrollment",
      xaxis = list(title = "Enrollment"), 
      yaxis = list(title = "", autorange = "reversed"),
      showlegend = FALSE,
      uniformtext_minsize=8, uniformtext_mode='show'
    )
})

output$plotly_teachers <- renderPlotly({
  req(drilldown_data())
  plot_ly(
    drilldown_data(), 
    y = ~group_col, x = ~Total_Teachers,
    type = 'bar', color = I("#3d8bfd"), source = "drilldown_plot",
    text = ~Total_Teachers,
    texttemplate = '%{text:,.0f}',
    textposition = 'outside',
    textfont = list(color = '#000000', size = 10)
  ) %>%
    layout(
      title = "Total Teachers",
      xaxis = list(title = "Teachers"), 
      yaxis = list(title = "", autorange = "reversed"),
      showlegend = FALSE,
      uniformtext_minsize=8, uniformtext_mode='show'
    )
})

output$plotly_schools <- renderPlotly({
  req(drilldown_data())
  plot_ly(
    drilldown_data(), 
    y = ~group_col, x = ~Total_Schools, 
    type = 'bar', color = I("#6caefd"), source = "drilldown_plot",
    text = ~Total_Schools, 
    texttemplate = '%{text:,.0f}',
    textposition = 'outside',
    textfont = list(color = '#000000', size = 10)
  ) %>%
    layout(
      title = "Total Schools", 
      xaxis = list(title = "Schools"), 
      yaxis = list(title = "", autorange = "reversed"),
      showlegend = FALSE,
      uniformtext_minsize=8, uniformtext_mode='show'
    )
})

observeEvent(event_data("plotly_click", source = "drilldown_plot"), {
  clicked_value <- event_data("plotly_click", source = "drilldown_plot")$y
  if (is.null(clicked_value)) return()
  state <- current_drilldown()
  if (state$level == "region") {
    current_drilldown(list(level = "division", filter = clicked_value))
  } else if (state$level == "division") {
    current_drilldown(list(level = "district", filter = clicked_value))
  }
  
  # --- MODIFIED: Hide school details when drilling down ---
  shinyjs::hide("school_details_card") 
  selected_school_data(NULL)
})

observeEvent(input$btn_back, {
  state <- current_drilldown()
  if (state$level == "district") {
    parent_region <- uni %>% 
      filter(Division == state$filter) %>% 
      slice(1) %>% 
      pull(Region)
    current_drilldown(list(level = "division", filter = parent_region))
  } else if (state$level == "division") {
    current_drilldown(list(level = "region", filter = NULL))
  }
  
  # --- MODIFIED: Hide school details when going back ---
  shinyjs::hide("school_details_card")
  selected_school_data(NULL)
})

observeEvent(current_drilldown(), {
  if (current_drilldown()$level == "region") {
    shinyjs::hide("btn_back")
  } else {
    shinyjs::show("btn_back")
  }
})


# --- Logic for Feature 2 ---
feature_2_data <- reactiveVal(NULL)

# --- NEW: ReactiveVal to store data for the clicked school ---
selected_school_data <- reactiveVal(NULL) 

# --- MODIFIED: Load *all* columns needed for the card ---
observeEvent(uni, {
  if (is.null(feature_2_data())) {
    
    # Define all columns we *want* for the card, based on your image
    all_card_cols <- c(
      "Region", "Province", "Municipality", "Division", "District", "Barangay",
      "Street.Address", "SchoolID", "School.Name", "School.Head",
      "School.Head.Position", "Implementing.Unit", "Modified.Curricular.Offering",
      "Latitude", "Longitude",
      "ES.Excess", "ES.Shortage", "JHS.Excess", "JHS.Shortage", "SHS.Excess", "SHS.Shortage",
      "ES.Teachers", "JHS.Teachers", "SHS.Teachers", "ES.Enrolment", "JHS.Enrolment",
      "SHS.Enrolment", "School.Size.Typology", "AO.II.Deployment", "COS.Deployment",
      "TotalEnrolment" # Also used by map popup
    )
    
    # Filter for valid lat/long first
    valid_geo_data <- uni %>%
      filter(!is.na(Latitude) & !is.na(Longitude) & Latitude != 0 & Longitude != 0)
    
    # IMPORTANT: Check which of our desired columns *actually exist* in the loaded CSV
    # This prevents the app from crashing if "School.Head" or another column is missing
    available_cols <- all_card_cols[all_card_cols %in% names(valid_geo_data)]
    
    # Select only the columns that are available
    sample_data <- valid_geo_data %>%
      select(all_of(available_cols)) %>%
      sample_n(min(10, nrow(.))) # Sample 10 (or fewer if data is small)
    
    feature_2_data(sample_data) 
  }
})

output$demo_table_2 <- renderDT({
  req(feature_2_data()) 
  datatable(
    feature_2_data()[, c("Region", "Division", "School.Name")], 
    selection = 'single', 
    rownames = FALSE,
    options = list(
      dom = 't',
      # --- MODIFIED: Center all columns in the DT table ---
      columnDefs = list(list(className = 'dt-center', targets = '_all'))
    ) 
  )
})

output$demo_map <- renderLeaflet({
  req(feature_2_data())
  data <- feature_2_data()
  
  schoolIcon <- awesomeIcons(
    icon = 'graduation-cap',
    library = 'fa',
    markerColor = 'blue'
  )
  
  leaflet(data) %>%
    addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
    addAwesomeMarkers(
      lng = ~Longitude, 
      lat = ~Latitude,
      popup = ~School.Name,
      label = ~paste( 
        "<strong>School:</strong>", `School.Name`, "<br>",
        "<strong>Region:</strong>", Region, "<br>",
        "<strong>Division:</strong>", Division, "<br>",
        "<strong>Enrollment:</strong>", TotalEnrolment
      ) %>% lapply(htmltools::HTML),
      icon = schoolIcon,
      labelOptions = labelOptions(noHide = FALSE)
    )
})

# --- MODIFIED: Observer for table row click ---
observeEvent(input$demo_table_2_rows_selected, {
  req(input$demo_table_2_rows_selected) 
  
  selected_row_index <- input$demo_table_2_rows_selected
  data <- feature_2_data() 
  selected_school <- data[selected_row_index, ] 
  
  # --- NEW: Store data and show the card ---
  selected_school_data(selected_school) # Store the full data for the selected school
  shinyjs::show("school_details_card")   # Show the hidden div
  # --- END NEW ---
  
  leafletProxy("demo_map") %>%
    flyTo(lng = selected_school$Longitude, 
          lat = selected_school$Latitude, 
          zoom = 12,
          options = list(duration = 0.5))
})

# (This observer for map zoom is unchanged)
observeEvent(list(feature_2_data(), input$demo_map_zoom), {
  
  proxy <- leafletProxy("demo_map") %>% clearGroup("zoomed_label")
  data <- feature_2_data()
  zoom <- input$demo_map_zoom
  
  if (!is.null(data) && !is.null(zoom) && zoom >= 12) {
    
    label_content <- paste( 
      "<strong>School:</strong>", data$School.Name, "<br>",
      "<strong>Region:</strong>", data$Region, "<br>",
      "<strong>Enrollment:</strong>", data$TotalEnrolment
    ) %>% lapply(htmltools::HTML)
    
    proxy %>% addLabelOnlyMarkers(
      lng = data$Longitude,
      lat = data$Latitude,
      label = label_content,
      group = "zoomed_label",
      labelOptions = labelOptions(
        noHide = TRUE,
        direction = 'auto',
        textOnly = TRUE,
        style = list(
          "background-color" = "white",
          "border-color" = "blue",
          "border-width" = "1px",
          "border-radius" = "3px",
          "padding" = "5px",
          "font-size" = "10px"
        )
      )
    )
  }
})

# --- NEW: Render the School Details Card UI ---
output$school_details_ui <- renderUI({
  # This UI will only render if selected_school_data() is not NULL
  req(selected_school_data())
  school_data <- selected_school_data()
  
  # Helper function to safely get data from the school's record
  # This prevents the app from crashing if a column was missing from the CSV
  get_data <- function(col_name) {
    if (col_name %in% names(school_data)) {
      val <- school_data[[col_name]]
      # Return "N/A" if value is NA or an empty string
      if (is.na(val) || val == "") "N/A" else val
    } else {
      "N/A" # Return "N/A" if the column doesn't exist
    }
  }
  
  # 1. Create the data frame for "Basic Information"
  basic_info_df <- data.frame(
    `Basic Info` = c("Region", "Province", "Municipality", "Division", "District",
                     "Barangay", "Street Address", "School ID", "School Name", "School Head",
                     "School Head Position", "Implementing Unit", "Modified Curricular Offering",
                     "Latitude", "Longitude"),
    Data = c(
      get_data("Region"), get_data("Province"), get_data("Municipality"), get_data("Division"), get_data("District"),
      get_data("Barangay"), get_data("Street.Address"), get_data("SchoolID"), get_data("School.Name"), get_data("School.Head"),
      get_data("School.Head.Position"), get_data("Implementing.Unit"), get_data("Modified.Curricular.Offering"),
      get_data("Latitude"), get_data("Longitude")
    ),
    check.names = FALSE # Allows spaces in the column name "Basic Info"
  )
  
  # 2. Create the data frame for "HR Data"
  hr_data_df <- data.frame(
    `HR Data` = c("ES Excess", "ES Shortage", "JHS Excess", "JHS Shortage", "SHS Excess", "SHS Shortage",
                  "ES Teachers", "JHS Teachers", "SHS Teachers", "ES Enrolment", "JHS Enrolment",
                  "SHS Enrolment", "School Size Typology", "AO II Deployment", "COS Deployment"),
    Data = c(
      get_data("ES.Excess"), get_data("ES.Shortage"), get_data("JHS.Excess"), get_data("JHS.Shortage"), get_data("SHS.Excess"), get_data("SHS.Shortage"),
      get_data("ES.Teachers"), get_data("JHS.Teachers"), get_data("SHS.Teachers"), get_data("ES.Enrolment"), get_data("JHS.Enrolment"),
      get_data("SHS.Enrolment"), get_data("School.Size.Typology"), get_data("AO.II.Deployment"), get_data("COS.Deployment")
    ),
    check.names = FALSE
  )
  
  # 3. Build the UI using tagList, layout_columns, and reactable
  tagList(
    layout_columns(
      col_widths = c(6, 6), # Two equal-width columns
      
      # Card 1: Basic Information
      card(
        card_body(
          # padding = 0, # <-- Removed. DT tables usually look better with default padding.
          DT::datatable(
            basic_info_df,
            class = 'stripe compact cell-border', # <-- Translated from striped, compact, bordered
            width = "100%",                       # <-- Translated from fullWidth = TRUE
            rownames = FALSE,                     # <-- Good practice to hide row names
            extensions = 'Buttons',               # <-- Enables the Buttons extension
            options = list(
              # --- Feature: Download Buttons & Filter (Search) ---
              dom = get_dt_dom('Bfrti'), # 'B'=Buttons, 'f'=filter, 'r'=processing, 't'=table, 'i'=info
              buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), # Specify buttons
              
              # --- Feature: Disable Pagination ---
              paging = FALSE, # <-- Translated from pagination = FALSE
              
              # --- Style: Column Definitions ---
              columnDefs = list(
                # Center-align all columns (header and body)
                list(targets = '_all', className = 'dt-center'),
                
                # Set widths (equivalent to minWidth)
                list(targets = 0, width = '180px'), # 'Basic Info' column
                list(targets = 1, width = '120px')  # 'Data' column
              )
            )
          )
        )
      ),
      # Card 2: HR Data
      card(
        card_body(
          padding = 0,
          reactable(
            hr_data_df,
            columns = list(
              `HR Data` = colDef(
                # style = list(fontWeight = "bold"), # <-- REMOVED
                minWidth = 180,
                align = "center", 
                headerStyle = list(textAlign = "center", fontWeight = "bold") # <-- MODIFIED
              ),
              Data = colDef(
                minWidth = 120, 
                align = "center",
                headerStyle = list(textAlign = "center", fontWeight = "bold") # <-- MODIFIED
              ) 
            ),
            striped = TRUE, compact = TRUE, bordered = TRUE,
            pagination = FALSE,
            fullWidth = TRUE
          )
        )
      )
    )
  )
})


# --- Logic for Feature 3 (MODIFIED) ---

# Reactive to prepare the data for the reactable table
feature_3_data <- reactive({
  req(uni)
  uni %>%
    select(
      Region, 
      Division, 
      District, 
      Legislative.District, # Make sure this column name is exact
      School.Name, 
      SchoolID, 
      TotalEnrolment, 
      TotalTeachers
    ) %>%
    mutate(
      TotalEnrolment = as.numeric(TotalEnrolment),
      TotalTeachers = as.numeric(TotalTeachers)
    ) %>%
    # Ensure data has rows before sampling
    { if(nrow(.) > 0) sample_n(., min(500, nrow(.))) else . } # Sample up to 500 rows
})

# Render the reactable table
output$feature_3_table <- DT::renderDataTable(server = FALSE, {
  req(feature_3_data())
  
  # --- Find the column index for "Region" ---
  # DT::datatable uses 0-based indexing for 'order'
  region_col_index <- which(colnames(feature_3_data()) == "Region") - 1
  
  # Handle case where "Region" column might not exist
  default_sort <- list()
  if (length(region_col_index) > 0) {
    default_sort <- list(list(region_col_index, 'asc')) # list(list(col_index, 'asc'/'desc'))
  }
  
  DT::datatable(
    feature_3_data(),
    
    # --- Features ---
    extensions = 'Buttons',         # Enables download buttons
    filter = 'top',                 # <-- 'filterable = TRUE' (adds column filters)
    rownames = FALSE,               # Good practice
    
    # --- Styling ---
    class = 'stripe hover cell-border compact', # <-- 'striped', 'highlight', 'bordered', 'compact'
    
    # --- Options List ---
    options = list(
      # --- Layout ---
      # 'l' = length menu
      # 'B' = Buttons
      # 'f' = global filter ('searchable = TRUE')
      # 'r' = processing
      # 't' = the table
      # 'i' = info
      # 'p' = pagination
      dom = get_dt_dom('lBfrtip'), 
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), # Download buttons
      
      # --- Pagination ---
      pageLength = 10,              # <-- 'defaultPageSize = 10'
      lengthMenu = c(10, 25, 50, 100), # <-- 'pageSizeOptions'
      
      # --- Sorting ---
      order = default_sort,         # <-- 'defaultSorted = "Region"'
      
      # --- Alignment ---
      columnDefs = list(
        list(targets = '_all', className = 'dt-center') # <-- 'defaultColDef'
      )
    )
  )
})

# Download handler
output$download_feature3 <- downloadHandler(
  filename = function() {
    paste0("stride_sample_data_", Sys.Date(), ".csv")
  },
  content = function(file) {
    req(feature_3_data())
    write.csv(feature_3_data(), file, row.names = FALSE, na = "")
  }
)


# --- Logic for Navigation ---

observeEvent(input$btn_to_dashboard, {
  nav_select(id = "main_nav", selected = "dashboard_tab")
})