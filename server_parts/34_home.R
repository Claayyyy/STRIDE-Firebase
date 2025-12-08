# --- Modal Dialog Observers (for Home Page) ---

# 1. Drilldown Modal
observeEvent(input$showDrilldownModal, {
  bslib::modal_dialog(
    title = tagList(bslib::bs_icon("filter-circle"), " Drilldown Function"),
    tags$p("Our drilldown feature allows you to explore data from the national level all the way down to a specific school."),
    tags$ul(
      tags$li(tags$strong("National View:"), " See the entire country at a glance."),
      tags$li(tags$strong("Regional/Divisional View:"), " Click on a region or division to filter the data."),
      tags$li(tags$strong("School View:"), " Select a specific school to see its detailed profile and metrics.")
    ),
    easyClose = TRUE,
    footer = modalButton("Close")
  )
})

# 2. Reactive Tables Modal
observeEvent(input$showTablesModal, {
  bslib::modal_dialog(
    title = tagList(bslib::bs_icon("table"), " Reactive Data Tables"),
    tags$p("The data tables in STRIDE are dynamic and respond instantly to your inputs."),
    tags$ul(
      tags$li(tags$strong("Sort:"), " Click any column header to sort the data."),
      tags$li(tags$strong("Filter:"), " Use the selection inputs to narrow down the data."), # <-- FIX: Was tags_strong
      tags$li(tags$strong("Search:"), " Use the search box to find specific records instantly.")
    ),
    easyClose = TRUE,
    footer = modalButton("Close")
  )
})

# 3. Geospatial Mapping Modal
observeEvent(input$showMapModal, {
  bslib::modal_dialog(
    title = tagList(bslib::bs_icon("map"), " Geospatial Mapping"),
    tags$p("Visualize your data in its geographic context to uncover spatial patterns and disparities."),
    tags$ul(
      tags$li(tags$strong("Interactive Map:"), " Pan, zoom, and click on map features."),
      tags$li(tags$strong("Data-Driven Colors:"), " Map colors (choropleths) change based on the data you select, such as teacher-student ratios or resource gaps."),
      tags$li(tags$strong("School Locations:"), " Pinpoint individual schools and access their data by clicking on the map.")
    ),
    easyClose = TRUE,
    footer = modalButton("Close")
  )
})