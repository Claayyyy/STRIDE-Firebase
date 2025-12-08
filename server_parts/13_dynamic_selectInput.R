# dynamic selecinput 

#For Division:

output$dashboard_division_filter<- renderUI({
  filtered_division <- c(df[df$Region==input$dashboard_region_filter,"Division"])
  pickerInput(
    inputId = "Dashboard_SDO",
    label = HTML(paste0("Division ", em(style = "font-size: 0.8em;", "(for Legislative District data):"))),
    choices = filtered_division,
    selected = filtered_division[1], # This will select all choices by default
    multiple = TRUE, # Set to TRUE to enable multiple selections
    options = pickerOptions(
      actionsBox = TRUE,
      liveSearch = TRUE,
      header = "Select one or more Divisions",
      title = "No Divisions Selected",
      selectedTextFormat = "count > 3",
      dropupAuto = FALSE,
      dropup = FALSE
    ),
    choicesOpt = list()
  )
})

output$cloud_dashboard_division_filter <- renderUI({
  filtered_division <- c(df[df$Region==input$cloud_dashboard_region_filter,"Division"])
  selectInput("cloud_Dashboard_SDO",HTML(paste0("Division ", em(style = "font-size: 0.8em;", "(for Legislative District data):"))), filtered_division, selected = filtered_division[1])})

# --- Update Division Picker when Region changes ---
observeEvent(input$resource_map_region, {
  req(input$resource_map_region)  # make sure region exists
  
  filtered_division <- unique(df[df$Region == input$resource_map_region, "Division"])
  filtered_division <- filtered_division[!is.na(filtered_division) & filtered_division != ""]
  
  shinyWidgets::updatePickerInput(
    session = session,
    inputId = "Resource_SDO",
    choices = filtered_division,
    selected = if (length(filtered_division) > 0) filtered_division[1] else NULL
  )
  
  # Reset district when region changes
  shinyWidgets::updatePickerInput(
    session = session,
    inputId = "Resource_LegDist",
    choices = NULL,
    selected = NULL
  )
})

# --- Update District Picker when Division changes ---
observeEvent(input$Resource_SDO, {
  req(input$Resource_SDO)
  
  filtered_district <- unique(df[df$Division == input$Resource_SDO, "Legislative.District"])
  filtered_district <- filtered_district[!is.na(filtered_district) & filtered_district != ""]
  
  shinyWidgets::updatePickerInput(
    session = session,
    inputId = "Resource_LegDist",
    choices = filtered_district,
    selected = if (length(filtered_district) > 0) filtered_district[1] else NULL
  )
})

observeEvent(TRUE, {
  req(df)
  
  # Initialize only once at startup
  isolate({
    if (!is.null(input$resource_map_region) && input$resource_map_region == "Region I") {
      filtered_division <- unique(df[df$Region == "Region I", "Division"])
      filtered_division <- filtered_division[!is.na(filtered_division) & filtered_division != ""]
      
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "Resource_SDO",
        choices = filtered_division,
        selected = if (length(filtered_division) > 0) filtered_division[1] else NULL
      )
    }
  })
})

# Reactive value to store uploaded data
uploaded_data <- reactiveVal(NULL)

# --- Single reactive value for the currently selected dashboard sub-page ---
# Default to the first option of the new first category ("General Info" -> "School Count")
current_dashboard_selection <- reactiveVal("general_school_count")

# --- Observers to update the single selection and deselect others (Dashboard) ---
observeEvent(input$dashboard_general_selector, {
  if (!is.null(input$dashboard_general_selector)) {
    current_dashboard_selection(input$dashboard_general_selector)
    # Deselect other groups
    updateRadioButtons(session, "dashboard_others_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_resource_shortage_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_infrastructure_selector", selected = character(0))
  }
})

observeEvent(input$dashboard_others_selector, {
  if (!is.null(input$dashboard_others_selector)) {
    current_dashboard_selection(input$dashboard_others_selector)
    # Deselect other groups
    updateRadioButtons(session, "dashboard_general_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_resource_shortage_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_infrastructure_selector", selected = character(0))
  }
})

observeEvent(input$dashboard_resource_shortage_selector, {
  if (!is.null(input$dashboard_resource_shortage_selector)) {
    current_dashboard_selection(input$dashboard_resource_shortage_selector)
    # Deselect other groups
    updateRadioButtons(session, "dashboard_general_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_others_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_infrastructure_selector", selected = character(0))
  }
})

observeEvent(input$dashboard_infrastructure_selector, {
  if (!is.null(input$dashboard_infrastructure_selector)) {
    current_dashboard_selection(input$dashboard_infrastructure_selector)
    # Deselect other groups
    updateRadioButtons(session, "dashboard_general_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_others_selector", selected = character(0))
    updateRadioButtons(session, "dashboard_resource_shortage_selector", selected = character(0))
  }
})

# --- Dashboard Structure ---