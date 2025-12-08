# Home Old Template





#   

# # --- EDUCATION RESOURCE DASHBOARD SERVER LOGIC ---
# 
# # Track which category is selected
# erdb_selection <- reactiveVal("home")
# 
# # Observe sidebar clicks
# observeEvent(input$erdb_hr,         { erdb_selection("Human Resource") })
# observeEvent(input$erdb_school,     { erdb_selection("Basic Info") })
# observeEvent(input$erdb_infra,      { erdb_selection("Infrastructure") })
# observeEvent(input$erdb_financial,  { erdb_selection("Financial") })
# observeEvent(input$erdb_monitoring, { erdb_selection("Monitoring") })
# observeEvent(input$erdb_ppas,       { erdb_selection("PPAs") })
# observeEvent(input$reset_button,    { erdb_selection("home") })
# 
# # --- Dynamic Main Content ---
# output$dynamic_erdb_panel <- renderUI({
#   selected <- erdb_selection()
#   
#   # =====================================================
#   # HUMAN RESOURCE SECTION
#   # =====================================================
#   
#   if (selected == "Human Resource") {
#     tagList(
#       h3("Human Resource Overview"),
#       
#       # --- Back / Reset Button (Top of the Page) ---
#       div(
#         class = "text-start mb-3",
#         actionButton(
#           "reset_hr",
#           label = tagList(bs_icon("arrow-left"), "Back"),
#           class = "btn btn-secondary btn-md"
#         )
#       ),
#       
#       hr(),
#       
#       # --- Accordion Section: Teacher Deployment Summary ---
#       accordion(
#         accordion_panel(
#           title = "Teacher Deployment Summary",
#           icon = bs_icon("people-fill"),
#           
#           layout_column_wrap(
#             width = 1/5,
#             card(card_header("RO Filling-up Rate"), valueBoxOutput("hr_fill_ro")),
#             card(card_header("SDO Filling-up Rate"), valueBoxOutput("hr_fill_sdo")),
#             card(card_header("Unfilled Items"), valueBoxOutput("hr_unfilled")),
#             card(card_header("Net Shortage"), valueBoxOutput("hr_shortage")),
#             card(card_header("Deployment Status"), valueBoxOutput("hr_status"))
#           )
#         )
#       ),
#       
#       hr(),
#       
#       # --- Map and Data Table Section ---
#       layout_columns(
#         card(
#           full_screen = TRUE,
#           card_header("Teacher Deployment Map"),
#           leafletOutput("hr_map", height = 600)
#         ),
#         card(
#           full_screen = TRUE,
#           card_header("Teacher Deployment Table"),
#           dataTableOutput("hr_table")
#         ),
#         col_widths = c(6, 6)
#       ),
#       
#       hr(),
#       
#       # --- School Details Section ---
#       card(
#         full_screen = TRUE,
#         card_header(
#           div(
#             strong("School Details"),
#             tags$span(
#               em("(Select a school from the table above)"),
#               style = "font-size: 0.7em; color: grey;"
#             )
#           )
#         ),
#         layout_columns(
#           card(
#             full_screen = TRUE,
#             card_header(strong("Basic Information")),
#             tableOutput("schooldetails_erdb")
#           ),
#           card(
#             full_screen = TRUE,
#             card_header(strong("HR Data")),
#             tableOutput("schooldetails2_erdb")
#           ),
#           card(
#             full_screen = TRUE,
#             card_header(strong("Classroom Data")),
#             tableOutput("schooldetails3_erdb")
#           ),
#           card(
#             full_screen = TRUE,
#             card_header(
#               div(
#                 strong("Specialization Data"),
#                 tags$span(
#                   em("(based on eSF7 for SY 2023-2024)"),
#                   style = "font-size: 0.7em; color: grey;"
#                 )
#               )
#             ),
#             tableOutput("schooldetails5_erdb")
#           ),
#           col_widths = c(6, 6, 6, 6)
#         )
#       ),
#       
#       hr(),
#       
#       # --- Priority Divisions Section ---
#       card(
#         full_screen = TRUE,
#         card_header("Priority Divisions"),
#         
#         layout_column_wrap(
#           width = 1/3,
#           heights_equal = "row",
#           
#           card(
#             full_screen = TRUE,
#             card_header("Teacher Deployment Priorities"),
#             plotlyOutput("Teaching_Deployment_Division_Graph1")
#           ),
#           
#           card(
#             full_screen = TRUE,
#             card_header("Classroom Shortage Priorities"),
#             plotlyOutput("Classroom_Shortage_Division_Graph2")
#           ),
#           
#           card(
#             full_screen = TRUE,
#             card_header("Last Mile School Priorities"),
#             plotlyOutput("LMS_Division_Graph2")
#           )
#         )
#       ),
#       
#       hr(),
#       
#       # --- SDO Ranking Section ---
#       card(
#         full_screen = TRUE,
#         card_header("SDO Ranking"),
#         
#         # ✅ Reactable Header Styling
#         tags$head(
#           tags$style(HTML("
#         .reactable thead th {
#           white-space: normal !important;
#           word-wrap: break-word !important;
#           line-height: 1.1;
#           text-align: center;
#         }
#         .reactable .rt-thead.-header { height: auto !important; }
#         .reactable .rt-th {
#           display: flex;
#           justify-content: center;
#           align-items: center;
#           text-align: center;
#         }
#       "))
#         ),
#         
#         reactable::reactableOutput("priority_division_erdb"),
#         hr(),
#         downloadButton(
#           "download_priority_data",
#           "Download SDO Ranking as CSV",
#           class = "btn-success"
#         ),
#         height = 800
#       )
#     )
#   }else if (selected == "Basic Info") {
#     tagList(
#       h3("School Information Overview"),
#       
#       # --- Back / Reset Button (Top of the Page) ---
#       div(
#         class = "text-start mb-3",
#         actionButton(
#           "reset_basicinfo",
#           label = tagList(bs_icon("arrow-left"), "Back"),
#           class = "btn btn-secondary btn-md"
#         )
#       ),
#       
#       hr(),
#       
#       # --- Value Box Section ---
#       layout_columns(
#         uiOutput("total_schools_erdb2"),
#         col_widths = c(12)
#       ),
#       
#       hr(),
#       
#       # --- Graph Section (4 graphs total) ---
#       layout_columns(
#         card(full_screen = TRUE, card_header("Number of Schools (Click to Drill Down)"), plotlyOutput("totalschools_plot_erdb2")),
#         card(full_screen = TRUE, card_header("Curricular Offering"), plotlyOutput("curricular_plot_erdb2")),
#         card(full_screen = TRUE, card_header("School Size Typology"), plotlyOutput("typology_plot_erdb2")),
#         card(full_screen = TRUE, card_header("Last Mile Schools"), plotlyOutput("LMS_plot_erdb2", height = "420px")),
#         col_widths = c(6, 6, 6, 6)
#       ),
#       
#       hr(),
#       
#       # --- Dashboard Data Table + Mapping ---
#       layout_columns(
#         card(full_screen = TRUE, card_header("Data Table"), dataTableOutput("dashboarddt_erdb2"), height = "500px"),
#         card(full_screen = TRUE, card_header("School Mapping"), leafletOutput("mapping_erdb2"), height = "500px"),
#         col_widths = c(6, 6)
#       ),
#       
#       hr(),
#       
#       # --- School Details Section ---
#       card(
#         full_screen = TRUE,
#         card_header(
#           div(
#             strong("School Details"),
#             tags$span(
#               em("(Select a school from the table above)"),
#               style = "font-size: 0.7em; color: grey;"
#             )
#           )
#         ),
#         layout_columns(
#           card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_erdb")),
#           card(full_screen = TRUE, card_header(strong("HR Data")), tableOutput("schooldetails2_erdb")),
#           card(full_screen = TRUE, card_header(strong("Classroom Data")), tableOutput("schooldetails3_erdb")),
#           card(
#             full_screen = TRUE,
#             card_header(
#               div(
#                 strong("Specialization Data"),
#                 tags$span(
#                   em("(based on eSF7 for SY 2023-2024)"),
#                   style = "font-size: 0.7em; color: grey;"
#                 )
#               )
#             ),
#             tableOutput("schooldetails5_erdb")
#           ),
#           col_widths = c(6, 6, 6, 6)
#         )
#       ),
#       
#       hr(),
#       
#       # --- Priority Divisions Section ---
#       card(
#         full_screen = TRUE,
#         card_header("Priority Divisions"),
#         
#         layout_column_wrap(
#           width = 1/3,
#           heights_equal = "row",
#           
#           card(
#             full_screen = TRUE,
#             card_header("Teacher Deployment Priorities"),
#             plotlyOutput("Teaching_Deployment_Division_Graph1")
#           ),
#           
#           card(
#             full_screen = TRUE,
#             card_header("Classroom Shortage Priorities"),
#             plotlyOutput("Classroom_Shortage_Division_Graph2")
#           ),
#           
#           card(
#             full_screen = TRUE,
#             card_header("Last Mile School Priorities"),
#             plotlyOutput("LMS_Division_Graph2")
#           )
#         )
#       ),
#       
#       hr(),
#       
#       # --- SDO Ranking Section (Separate Card) ---
#       card(
#         full_screen = TRUE,
#         card_header("SDO Ranking"),
#         
#         tags$head(
#           tags$style(HTML("
#         .reactable thead th {
#           white-space: normal !important;
#           word-wrap: break-word !important;
#           line-height: 1.1;
#           text-align: center;
#         }
#         .reactable .rt-thead.-header { height: auto !important; }
#         .reactable .rt-th {
#           display: flex;
#           justify-content: center;
#           align-items: center;
#           text-align: center;
#         }
#       "))
#         ),
#         
#         reactable::reactableOutput("priority_division_erdb"),
#         hr(),
#         downloadButton(
#           "download_priority_data",
#           "Download SDO Ranking as CSV",
#           class = "btn-success"
#         ),
#         height = 800
#       )
#     )
#   }
#   
#   else if (selected == "Infrastructure") {
#     tagList(
#       h3("Infrastructure Overview"),
#       
#       # --- Back / Reset Button (Top of the Page) ---
#       div(
#         class = "text-start mb-3",
#         actionButton(
#           "reset_infra",
#           label = tagList(bs_icon("arrow-left"), "Back"),
#           class = "btn btn-secondary btn-md"
#         )
#       ),
#       
#       hr(),
#       
#       # --- Value Boxes Section ---
#       layout_columns(
#         uiOutput("total_classrooms_erdb2"),
#         uiOutput("total_classroom_shortage_erdb2"),
#         col_widths = c(6, 6)
#       ),
#       
#       hr(),
#       
#       # --- Graph Section ---
#       layout_columns(
#         card(
#           full_screen = TRUE,
#           card_header("Classroom Shortage"),
#           plotlyOutput("classroomshortage_plot_erdb2", height = "420px")
#         ),
#         col_widths = c(12)
#       ),
#       
#       hr(),
#       
#       # --- Data Table and Mapping Section ---
#       layout_columns(
#         card(
#           full_screen = TRUE,
#           card_header("Data Table"),
#           dataTableOutput("dashboarddt_erdb2"),
#           height = "500px"
#         ),
#         card(
#           full_screen = TRUE,
#           card_header("School Mapping"),
#           leafletOutput("mapping_erdb2"),
#           height = "500px"
#         ),
#         col_widths = c(6, 6)
#       ),
#       
#       hr(),
#       
#       # --- School Details Section ---
#       card(
#         full_screen = TRUE,
#         card_header(
#           div(
#             strong("School Details"),
#             tags$span(
#               em("(Select a school from the table above)"),
#               style = "font-size: 0.7em; color: grey;"
#             )
#           )
#         ),
#         layout_columns(
#           card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_erdb")),
#           card(full_screen = TRUE, card_header(strong("HR Data")), tableOutput("schooldetails2_erdb")),
#           card(full_screen = TRUE, card_header(strong("Classroom Data")), tableOutput("schooldetails3_erdb")),
#           card(
#             full_screen = TRUE,
#             card_header(
#               div(
#                 strong("Specialization Data"),
#                 tags$span(
#                   em("(based on eSF7 for SY 2023-2024)"),
#                   style = "font-size: 0.7em; color: grey;"
#                 )
#               )
#             ),
#             tableOutput("schooldetails5_erdb")
#           ),
#           col_widths = c(6, 6, 6, 6)
#         )
#       ),
#       
#       hr(),
#       
#       # --- Priority Divisions Section ---
#       card(
#         full_screen = TRUE,
#         card_header("Priority Divisions"),
#         
#         layout_column_wrap(
#           width = 1/3,
#           heights_equal = "row",
#           
#           card(
#             full_screen = TRUE,
#             card_header("Teacher Deployment Priorities"),
#             plotlyOutput("Teaching_Deployment_Division_Graph1")
#           ),
#           
#           card(
#             full_screen = TRUE,
#             card_header("Classroom Shortage Priorities"),
#             plotlyOutput("Classroom_Shortage_Division_Graph2")
#           ),
#           
#           card(
#             full_screen = TRUE,
#             card_header("Last Mile School Priorities"),
#             plotlyOutput("LMS_Division_Graph2")
#           )
#         )
#       ),
#       
#       hr(),
#       
#       # --- SDO Ranking Section (Separate Card) ---
#       card(
#         full_screen = TRUE,
#         card_header("SDO Ranking"),
#         
#         # ✅ Custom styling for reactable table header
#         tags$head(
#           tags$style(HTML("
#         .reactable thead th {
#           white-space: normal !important;
#           word-wrap: break-word !important;
#           line-height: 1.1;
#           text-align: center;
#         }
#         .reactable .rt-thead.-header { height: auto !important; }
#         .reactable .rt-th {
#           display: flex;
#           justify-content: center;
#           align-items: center;
#           text-align: center;
#         }
#       "))
#         ),
#         
#         reactable::reactableOutput("priority_division_erdb"),
#         hr(),
#         downloadButton(
#           "download_priority_data",
#           "Download SDO Ranking as CSV",
#           class = "btn-success"
#         ),
#         height = 800
#       )
#     )
#   }
#   else if (selected == "Financial") {
#     tagList(
#       h3("Financial Overview"),
#       
#       # --- Back / Reset Button (Top of the Page) ---
#       div(
#         class = "text-start mb-3",
#         actionButton(
#           "reset_financial",
#           label = tagList(bs_icon("arrow-left"), "Back"),
#           class = "btn btn-secondary btn-md"
#         )
#       ),
#       
#       hr(),
#       
#       # --- Main Financial Charts ---
#       layout_columns(
#         card(full_screen = TRUE, card_header("Budget Allocation by Region"), plotlyOutput("fin_alloc_plot")),
#         card(full_screen = TRUE, card_header("Utilization Rate"), plotlyOutput("fin_util_plot")),
#         card(full_screen = TRUE, card_header("Division Expenditure"), dataTableOutput("fin_table")),
#         col_widths = c(4, 4, 4)
#       ),
#       
#       hr(),
#       
#       # --- School Details Section ---
#       card(
#         full_screen = TRUE,
#         card_header(
#           div(
#             strong("School Details"),
#             tags$span(
#               em("(Select a school from the table above)"),
#               style = "font-size: 0.7em; color: grey;"
#             )
#           )
#         ),
#         layout_columns(
#           card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_fin1")),
#           card(full_screen = TRUE, card_header(strong("Financial Data")), tableOutput("schooldetails_fin2")),
#           card(full_screen = TRUE, card_header(strong("Infrastructure Data")), tableOutput("schooldetails_fin3")),
#           card(full_screen = TRUE, card_header(strong("Specialization Data")), tableOutput("schooldetails_fin4")),
#           col_widths = c(6, 6, 6, 6)
#         )
#       ),
#       
#       hr(),
#       
#       # --- Priority Divisions Section ---
#       card(
#         full_screen = TRUE,
#         card_header("Priority Divisions"),
#         layout_column_wrap(
#           width = 1/3,
#           heights_equal = "row",
#           card(card_header("Budget Prioritization by Division"), plotlyOutput("fin_priority_plot1")),
#           card(card_header("Utilization Rate Comparison"), plotlyOutput("fin_priority_plot2")),
#           card(card_header("Funding Gaps"), plotlyOutput("fin_priority_plot3"))
#         )
#       ),
#       
#       hr(),
#       
#       # --- SDO Ranking Section ---
#       card(
#         full_screen = TRUE,
#         card_header("SDO Ranking"),
#         tags$head(
#           tags$style(HTML("
#         .reactable thead th {
#           white-space: normal !important;
#           word-wrap: break-word !important;
#           line-height: 1.1;
#           text-align: center;
#         }
#         .reactable .rt-thead.-header { height: auto !important; }
#         .reactable .rt-th {
#           display: flex;
#           justify-content: center;
#           align-items: center;
#           text-align: center;
#         }
#       "))
#         ),
#         reactable::reactableOutput("priority_division_fin"),
#         hr(),
#         downloadButton("download_priority_fin", "Download SDO Ranking as CSV", class = "btn-success"),
#         height = 800
#       )
#     )
#   }
#   else if (selected == "Monitoring") {
#     tagList(
#       
#       
#       h3("Monitoring Overview"),
#       # --- Back / Reset Button (Top of the Page) ---
#       div(
#         class = "text-start mb-3",
#         actionButton(
#           "reset_monitoring",
#           label = tagList(bs_icon("arrow-left"), "Back"),
#           class = "btn btn-secondary btn-md"
#         )
#       ),
#       hr(),
#       
#       # --- Monitoring Charts ---
#       layout_columns(
#         card(
#           full_screen = TRUE,
#           card_header("Project Implementation Status"),
#           plotlyOutput("monitor_proj_plot")
#         ),
#         card(
#           full_screen = TRUE,
#           card_header("Monitoring Map"),
#           leafletOutput("monitor_map", height = 600)
#         ),
#         col_widths = c(6, 6)
#       ),
#       
#       hr(),
#       
#       # --- School Details Section ---
#       card(
#         full_screen = TRUE,
#         card_header(
#           div(
#             strong("School Details"),
#             tags$span(
#               em("(Select a school from the map or table above)"),
#               style = "font-size: 0.7em; color: grey;"
#             )
#           )
#         ),
#         layout_columns(
#           card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_monitor1")),
#           card(full_screen = TRUE, card_header(strong("Project Data")), tableOutput("schooldetails_monitor2")),
#           card(full_screen = TRUE, card_header(strong("Financial Monitoring")), tableOutput("schooldetails_monitor3")),
#           card(full_screen = TRUE, card_header(strong("Remarks / Status")), tableOutput("schooldetails_monitor4")),
#           col_widths = c(6, 6, 6, 6)
#         )
#       ),
#       
#       hr(),
#       
#       # --- Priority Divisions Section ---
#       card(
#         full_screen = TRUE,
#         card_header("Priority Divisions"),
#         layout_column_wrap(
#           width = 1/3,
#           heights_equal = "row",
#           card(card_header("Delayed Projects"), plotlyOutput("monitor_priority_plot1")),
#           card(card_header("On-time Completion Rate"), plotlyOutput("monitor_priority_plot2")),
#           card(card_header("High-risk Projects"), plotlyOutput("monitor_priority_plot3"))
#         )
#       ),
#       
#       hr(),
#       
#       # --- SDO Ranking Section ---
#       card(
#         full_screen = TRUE,
#         card_header("SDO Ranking"),
#         
#         # --- Table Styling ---
#         tags$head(
#           tags$style(HTML("
#         .reactable thead th {
#           white-space: normal !important;
#           word-wrap: break-word !important;
#           line-height: 1.1;
#           text-align: center;
#         }
#         .reactable .rt-thead.-header { height: auto !important; }
#         .reactable .rt-th {
#           display: flex;
#           justify-content: center;
#           align-items: center;
#           text-align: center;
#         }
#       "))
#         ),
#         
#         reactable::reactableOutput("priority_division_monitor"),
#         hr(),
#         downloadButton("download_priority_monitor", "Download SDO Ranking as CSV", class = "btn-success"),
#         height = 800
#       )
#     )
#   }
#   
#   else if (selected == "PPAs") {
#     tagList(
#       
#       h3("Programs, Projects, and Activities (PPAs) Overview"),
#       # --- Back / Reset Button (Top of the Page) ---
#       div(
#         class = "text-start mb-3",
#         actionButton(
#           "reset_ppas",
#           label = tagList(bs_icon("arrow-left"), "Back"),
#           class = "btn btn-secondary btn-md"
#         )
#       ),
#       
#       hr(),
#       
#       # --- Main PPAs Charts ---
#       layout_columns(
#         card(full_screen = TRUE, card_header("PPA Distribution by Region"), plotlyOutput("ppa_region_plot")),
#         card(full_screen = TRUE, card_header("PPA Table"), dataTableOutput("ppa_table")),
#         card(full_screen = TRUE, card_header("Mapping"), leafletOutput("ppa_map", height = 600)),
#         col_widths = c(4, 4, 4)
#       ),
#       
#       hr(),
#       
#       # --- School Details Section ---
#       card(
#         full_screen = TRUE,
#         card_header(
#           div(
#             strong("School Details"),
#             tags$span(
#               em("(Select a school from the map or table above)"),
#               style = "font-size: 0.7em; color: grey;"
#             )
#           )
#         ),
#         layout_columns(
#           card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_ppa1")),
#           card(full_screen = TRUE, card_header(strong("PPA Data")), tableOutput("schooldetails_ppa2")),
#           card(full_screen = TRUE, card_header(strong("Financial Info")), tableOutput("schooldetails_ppa3")),
#           card(full_screen = TRUE, card_header(strong("Implementation Status")), tableOutput("schooldetails_ppa4")),
#           col_widths = c(6, 6, 6, 6)
#         )
#       ),
#       
#       hr(),
#       
#       # --- Priority Divisions Section ---
#       card(
#         full_screen = TRUE,
#         card_header("Priority Divisions"),
#         layout_column_wrap(
#           width = 1/3,
#           heights_equal = "row",
#           card(card_header("Delayed PPAs"), plotlyOutput("ppa_priority_plot1")),
#           card(card_header("Low Budget Utilization"), plotlyOutput("ppa_priority_plot2")),
#           card(card_header("High Impact PPAs"), plotlyOutput("ppa_priority_plot3"))
#         )
#       ),
#       
#       hr(),
#       
#       # --- SDO Ranking Section ---
#       card(
#         full_screen = TRUE,
#         card_header("SDO Ranking"),
#         
#         # --- Table Styling ---
#         tags$head(
#           tags$style(HTML("
#         .reactable thead th {
#           white-space: normal !important;
#           word-wrap: break-word !important;
#           line-height: 1.1;
#           text-align: center;
#         }
#         .reactable .rt-thead.-header { height: auto !important; }
#         .reactable .rt-th {
#           display: flex;
#           justify-content: center;
#           align-items: center;
#           text-align: center;
#         }
#       "))
#         ),
#         
#         reactable::reactableOutput("priority_division_ppa"),
#         hr(),
#         downloadButton("download_priority_ppa", "Download SDO Ranking as CSV", class = "btn-success"),
#         height = 800
#       )
#     )
#   }
#   
#   else {
#     # Default Overview
#     tagList(
#       h3("Education Resource Dashboard Overview"),
#       hr(),
#       p("Select a category from the sidebar to explore the data visualizations, maps, and analytics for each component of the education resource system.")
#     )
#   }
# })
# 

#EDUCATION RESOURCE DASHBOARD OVERVIEW
# --- Overview Hard-Coded Value Boxes ---

# # 1. Central Office
# output$central_office_erdb <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Central Office", class = "text-center"),
#     bslib::card_body(
#       tags$h3("1", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })
# 
# # 2. Regional Offices
# output$regional_offices_erdb <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Regional Offices", class = "text-center"),
#     bslib::card_body(
#       tags$h3("16", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })
# 
# # 3. Schools Division Offices
# output$sdo_erdb <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Schools Division Offices", class = "text-center"),
#     bslib::card_body(
#       tags$h3("218", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })
# 
# # 4. Public Schools
# output$public_schools_erdb <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Public Schools", class = "text-center"),
#     bslib::card_body(
#       tags$h3("45,785", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })
# 
# # 5. Private Schools
# output$private_schools_erdb <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Private Schools", class = "text-center"),
#     bslib::card_body(
#       tags$h3("12,624", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })
# 
# # 6. SUCs/LUCs
# output$suc_luc_erdb <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("SUCs / LUCs", class = "text-center"),
#     bslib::card_body(
#       tags$h3("220", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })
# 
# # 7. Plantilla Positions
# output$plantilla_erdb <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Plantilla Positions", class = "text-center"),
#     bslib::card_body(
#       tags$h3("1,030,897", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })
# 
# # 8. Total Schools (public & private)
# output$total_schools_erdb1 <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Total Schools (Public + Private)", class = "text-center"),
#     bslib::card_body(
#       tags$h3("58,409", style = "text-align: center; font-weight: 700; color: #2c3895;")
#     )
#   )
# })