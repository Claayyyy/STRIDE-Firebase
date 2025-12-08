# education resource dashboard with clickable sidebar

# --- EDUCATION RESOURCE DASHBOARD SERVER ---

# line 2593
erdb_selection <- reactiveVal("Overview")

# --- Observe Sidebar Button Clicks ---
observeEvent(input$erdb_overview, { erdb_selection("Overview") })
observeEvent(input$erdb_hr,         { erdb_selection("Human Resource") })
observeEvent(input$erdb_basic,      { erdb_selection("Basic Info") })
observeEvent(input$erdb_infra,      { erdb_selection("Infrastructure") })
observeEvent(input$erdb_fin,        { erdb_selection("Financial") })
observeEvent(input$erdb_monitoring, { erdb_selection("Monitoring") })
observeEvent(input$erdb_ppas,       { erdb_selection("PPAs") })
observeEvent(input$reset_button,    { erdb_selection("home") })

# --- Dynamic Main Content ---
output$erdb_content <- renderUI({
  selected <- erdb_selection()
  
  if (selected == "Overview") {
    # This code assumes it is the content being returned by your reactive
    # server function to fill uiOutput("erdb_content") when the "Overview" button is clicked.
    
    # The overall structure is just a single layout_columns()
    layout_columns(
      # Set the column widths for all 11 items (8 value boxes + hr + 2 main cards)
      col_widths = c(
        # Row 1 (Value Boxes 1-4: 4 items, 3 columns each)
        3, 3, 3, 3,
        # Row 2 (Value Boxes 5-8: 4 items, 3 columns each)
        3, 3, 3, 3,
        # Row 3 (Separator: 1 item, 12 columns wide)
        # 12,
        # Row 4 (Plots and Filter: 2 items, 9 columns total)
        6, 6 
        # Note: I'll use 6, 3, 3 to cleanly separate the large plot, the small plot, and the filter UI 
        # The structure is flexible, but 6+3=9 is what you had, so I'll structure the last row to 6, 6
      ),
      
      # --- Row 1: Top 4 Value Boxes (Items 1-4) ---
      
      # 1. Total Schools (public & private)
      card(
        style = "background-color: #FFFFFF;",
        card_header("Total Schools (Public + Private)", class = "text-center"),
        card_body(
          tags$h3("58,409", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # 2. Central Office
      card(
        style = "background-color: #FFFFFF;",
        card_header("Central Office", class = "text-center"),
        card_body(
          tags$h3("1", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # 3. Regional Offices
      card(
        style = "background-color: #FFFFFF;",
        card_header("Regional Offices", class = "text-center"),
        card_body(
          tags$h3("16", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # 4. Schools Division Offices
      card(
        style = "background-color: #FFFFFF;",
        card_header("Schools Division Offices", class = "text-center"),
        card_body(
          tags$h3("218", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # --- Row 2: Bottom 4 Value Boxes (Items 5-8) ---
      
      # 5. Public Schools
      card(
        style = "background-color: #FFFFFF;",
        card_header("Public Schools", class = "text-center"),
        card_body(
          tags$h3("45,785", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # 6. Private Schools
      card(
        style = "background-color: #FFFFFF;",
        card_header("Private Schools", class = "text-center"),
        card_body(
          tags$h3("12,624", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # 7. SUCs/LUCs
      card(
        style = "background-color: #FFFFFF;",
        card_header("SUCs / LUCs", class = "text-center"),
        card_body(
          tags$h3("220", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # 8. Plantilla Positions
      card(
        style = "background-color: #FFFFFF;",
        card_header("Plantilla Positions", class = "text-center"),
        card_body(
          tags$h3("1,030,897", style = "text-align: center; font-weight: 700; color: #2c3895;")
        )
      ),
      
      # --- Row 3: Separator (Item 9) ---
      # The hr() will occupy 12 columns, forcing the next item to the next row
      card(
        selectInput(
          "position_filter",
          "Select Position:",
          choices = NULL
        )
      ),
      
      # --- Row 4: Main Plots (Items 10-12) ---
      
      # 10. Main Plot (6 columns)
      card(
        full_screen = TRUE,
        card_header(
          "Positions by Region (All Positions)"
        ),
        card_body(
          plotlyOutput("overall_GMIS")
        )
      ),
      
      # 11. Filter Input Card + Filtered Plot (The remaining 6 columns of the row)
      card(
        full_screen = TRUE,
        card_header(
          "Filtered by Position"
        ),
        card_body(
          # Assuming 'all_positions' is defined globally for the UI (as discussed before)
          plotlyOutput("filtered_GMIS")
        )
      ),
      
      # 12. Overall Totals Card (Commented out in your original, but added for completeness)
      # This card would also occupy 6 columns to be next to the Filter/Plot card, but since
      # your original only showed 6 and 3, I'm adjusting to make the full 12 columns used
      # on that final row. 
      # Since you had `width=3` for the filter card and `width=6` for the main plot, 
      # I'll put the Filter Input and Filtered Plot *together* in a 6-column card 
      # to make the row clean (6 + 6 = 12 columns).
      
      # If you want the two plots to be side-by-side:
      # Plot 1: 6 columns
      # Filter Card (Filter + Plot 2): 6 columns
      # This matches the code above.
      
      # If you wanted the Totals Card instead of combining the filter/plot:
      # card(
      #   card_header("Overall Totals"),
      #   ...
      # ),
      
      # This ensures only one `layout_columns` is used for the entire dynamic panel content.
    )} # /layout_columns
  # =====================================================
  # HUMAN RESOURCE SECTION
  # =====================================================
  else if (selected == "Human Resource") {
    tagList(
      h3("Human Resource Overview"),
      
      div(
        class = "text-start mb-3",
        actionButton("reset_hr", label = tagList(bs_icon("arrow-left"), "Back"), class = "btn btn-secondary btn-md")
      ),
      
      hr(),
      
      # --- TABSET CONTAINER ---
      navset_tab(
        
        # =====================================================
        # TAB 1: Teacher Deployment Summary
        # =====================================================
        nav_panel(
          title = "Teacher Deployment Summary",
          icon = bs_icon("people-fill"),
          
          accordion(
            accordion_panel(
              title = "Teacher Deployment Summary",
              icon = bs_icon("bar-chart-fill"),
              layout_column_wrap(
                width = 1/5,
                card(card_header("RO Filling-up Rate"), valueBoxOutput("hr_fill_ro")),
                card(card_header("SDO Filling-up Rate"), valueBoxOutput("hr_fill_sdo")),
                card(card_header("Unfilled Items"), valueBoxOutput("hr_unfilled")),
                card(card_header("Net Shortage"), valueBoxOutput("hr_shortage")),
                card(card_header("Deployment Status"), valueBoxOutput("hr_status"))
              )
            )
          ),
          
          hr(),
          
          layout_columns(
            card(full_screen = TRUE, card_header("Teacher Deployment Map"), leafletOutput("hr_map", height = 600)),
            card(full_screen = TRUE, card_header("Teacher Deployment Table"), dataTableOutput("hr_table")),
            col_widths = c(6, 6)
          )
        ),
        
        # =====================================================
        # TAB 2: School Details
        # =====================================================
        nav_panel(
          title = "School Details",
          icon = bs_icon("building"),
          
          card(
            full_screen = TRUE,
            card_header(div(strong("School Details"), tags$span(em("(Select a school from the table above)"), style = "font-size: 0.7em; color: grey;"))),
            layout_columns(
              card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_erdb")),
              card(full_screen = TRUE, card_header(strong("HR Data")), tableOutput("schooldetails2_erdb")),
              card(full_screen = TRUE, card_header(strong("Classroom Data")), tableOutput("schooldetails3_erdb")),
              card(full_screen = TRUE, card_header(div(strong("Specialization Data"), tags$span(em("(based on eSF7 for SY 2023-2024)"), style = "font-size: 0.7em; color: grey;"))), tableOutput("schooldetails5_erdb")),
              col_widths = c(6, 6, 6, 6)
            )
          )
        ),
        
        # =====================================================
        # TAB 3: Priority Divisions
        # =====================================================
        nav_panel(
          title = "Priority Divisions",
          icon = bs_icon("list-stars"),
          
          card(
            full_screen = TRUE,
            card_header("Priority Divisions Overview"),
            layout_column_wrap(
              width = 1/3,
              heights_equal = "row",
              card(full_screen = TRUE, card_header("Teacher Deployment Priorities"), plotlyOutput("Teaching_Deployment_Division_Graph1")),
              card(full_screen = TRUE, card_header("Classroom Shortage Priorities"), plotlyOutput("Classroom_Shortage_Division_Graph2")),
              card(full_screen = TRUE, card_header("Last Mile School Priorities"), plotlyOutput("LMS_Division_Graph2"))
            )
          )
        ),
        
        # =====================================================
        # TAB 4: SDO Ranking
        # =====================================================
        nav_panel(
          title = "SDO Ranking",
          icon = bs_icon("award"),
          
          card(
            full_screen = TRUE,
            card_header("SDO Ranking"),
            tags$head(tags$style(HTML("
            .reactable thead th {
              white-space: normal !important;
              word-wrap: break-word !important;
              line-height: 1.1;
              text-align: center;
            }
            .reactable .rt-thead.-header { height: auto !important; }
            .reactable .rt-th {
              display: flex;
              justify-content: center;
              align-items: center;
              text-align: center;
            }
          "))),
            dataTableOutput("priority_division_erdb"),
            height = 800
          )
        ),
        
        # =====================================================
        # TAB 5: Workforce Planning (Future Placeholder)
        # =====================================================
        nav_panel(
          title = "Workforce Planning",
          icon = bs_icon("clipboard-data"),
          div(class = "text-center p-5", tags$em("No data yet. This section will contain workforce planning analytics soon."))
        )
      )
    )
    # =====================================================
    # BASIC INFORMATION SECTION (with Tabs)
    # =====================================================
  } else if (selected == "Basic Info") {
    tagList(
      h3("School Information Overview"),
      
      div(
        class = "text-start mb-3",
        actionButton("reset_basicinfo",
                     label = tagList(bs_icon("arrow-left"), "Back"),
                     class = "btn btn-secondary btn-md")
      ),
      
      hr(),
      
      # --- TABSET PANEL START ---
      tabsetPanel(
        id = "basicinfo_tabs",
        
        # =====================================================
        # TAB 1: Overview (Reactive Values + Charts)
        # =====================================================
        tabPanel(
          title = "Overview",
          icon = icon("chart-bar"),
          
          # --- Reactive Values (e.g. total schools, counts, etc.) ---
          layout_columns(uiOutput("total_schools_erdb"), col_widths = c(12)),
          
          hr(),
          
          # --- Charts Section ---
          layout_columns(
            # Row 1
            card(
              full_screen = TRUE,
              card_header("Number of Schools (Click to Drill Down)"),
              plotlyOutput("totalschools_plot_erdb")
            ),
            card(
              full_screen = TRUE,
              card_header("Total Enrollment (Click to Drill Down)"),
              plotlyOutput("total_enrollment_plot_erdb", height = "420px")
            ),
            
            # Row 2
            card(
              full_screen = TRUE,
              card_header("Curricular Offering"),
              plotlyOutput("curricular_plot_erdb")
            ),
            card(
              full_screen = TRUE,
              card_header("School Size Typology"),
              plotlyOutput("typology_plot_erdb")
            ),
            
            # Row 3
            card(
              full_screen = TRUE,
              card_header("Last Mile Schools"),
              plotlyOutput("LMS_plot_erdb", height = "420px")
            ),
            
            col_widths = c(6, 6, 6, 6)
          ),
          
          # === PRIVATE SCHOOLS SECTION ===
          
          layout_columns(
            col_widths = c(6, 6),
            uiOutput("total_private_schools_box"),
            uiOutput("total_private_seats_box")
          ),
          
          layout_columns(
            col_widths = c(6, 6),
            
            card(
              full_screen = TRUE,
              card_header(
                div(
                  "Number of Private Schools (Click to Drill Down)",
                  actionButton("private_back", "⬅ Back", class = "btn btn-sm btn-outline-primary float-end")
                )
              ),
              plotlyOutput("private_schools_count_plot", height = "420px")
            ),
            
            card(
              full_screen = TRUE,
              card_header(
                div(
                  "Number of Seats in Private Schools (Click to Drill Down)",
                  actionButton("private_back2", "⬅ Back", class = "btn btn-sm btn-outline-primary float-end")
                )
              ),
              plotlyOutput("private_schools_seats_plot", height = "420px")
            )
          )
          
        ),
        
        # =====================================================
        # TAB 2: Data Table, Map, and Basic Information
        # =====================================================
        tabPanel(
          title = "Data & Map",
          icon = icon("table"),
          tagList(
            # --- Data Table & Map Section ---
            layout_columns(
              card(full_screen = TRUE, card_header("Data Table"), dataTableOutput("dashboarddt_erdb"), height = "500px"),
              card(full_screen = TRUE, card_header("School Mapping"), leafletOutput("mapping_erdb"), height = "500px"),
              col_widths = c(6, 6)
            ),
            
            hr(),
            
            # --- Basic Information Tables Section ---
            card(
              full_screen = TRUE,
              card_header(
                div(
                  strong("School Details"),
                  tags$span(em("(Select a school from the table above)"), style = "font-size: 0.7em; color: grey;")
                )
              ),
              layout_columns(
                card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_erdb")),
                card(full_screen = TRUE, card_header(strong("HR Data")), tableOutput("schooldetails2_erdb")),
                card(full_screen = TRUE, card_header(strong("Classroom Data")), tableOutput("schooldetails3_erdb")),
                card(
                  full_screen = TRUE,
                  card_header(
                    div(
                      strong("Specialization Data"),
                      tags$span(em("(based on eSF7 for SY 2023-2024)"), style = "font-size: 0.7em; color: grey;")
                    )
                  ),
                  tableOutput("schooldetails5_erdb")
                ),
                col_widths = c(6, 6, 6, 6)
              )
            )
          )
        ),
        
        # # =====================================================
        # # TAB 3: (Optional Future Use)
        # # =====================================================
        # tabPanel(
        #   title = "Additional Insights",
        #   icon = icon("chart-area"),
        #   p("This tab can be used for future data analysis or additional charts.")
        # )
      ) # --- END OF TABSET PANEL ---
    )
    
    # =====================================================
    # INFRASTRUCTURE SECTION (with Tabs + School Details)
    # =====================================================
  } else if (selected == "Infrastructure") {
    tagList(
      h3("Infrastructure Overview"),
      
      div(
        class = "text-start mb-3",
        actionButton("reset_infra",
                     label = tagList(bs_icon("arrow-left"), "Back"),
                     class = "btn btn-secondary btn-md")
      ),
      
      hr(),
      
      # --- TABSET PANEL START ---
      tabsetPanel(
        id = "infrastructure_tabs",
        
        # =====================================================
        # TAB 1: Overview (Reactive Values + Charts)
        # =====================================================
        tabPanel(
          title = "Overview",
          icon = icon("building"),
          
          # --- Reactive Values ---
          layout_columns(
            uiOutput("total_classrooms_erdb"),
            uiOutput("total_classroom_shortage_erdb"),
            col_widths = c(6, 6)
          ),
          
          hr(),
          
          # --- Chart Section ---
          layout_columns(
            card(
              full_screen = TRUE,
              card_header("Classroom Shortage"),
              plotlyOutput("classroomshortage_plot_erdb", height = "420px")
            ),
            col_widths = c(12)
          )
        ),
        
        # =====================================================
        # TAB 2: Data Table, Map, and Basic Information
        # =====================================================
        tabPanel(
          title = "Data & Map",
          icon = icon("table"),
          tagList(
            # --- Data Table & Map Section ---
            layout_columns(
              card(full_screen = TRUE, card_header("Data Table"), dataTableOutput("dashboarddt_erdb"), height = "500px"),
              card(full_screen = TRUE, card_header("School Mapping"), leafletOutput("mapping_erdb"), height = "500px"),
              col_widths = c(6, 6)
            ),
            
            hr(),
            
            # --- Basic Information (School Details) Section ---
            card(
              full_screen = TRUE,
              card_header(
                div(
                  strong("School Details"),
                  tags$span(em("(Select a school from the table above)"), style = "font-size: 0.7em; color: grey;")
                )
              ),
              layout_columns(
                card(full_screen = TRUE, card_header(strong("Basic Information")), tableOutput("schooldetails_erdb")),
                card(full_screen = TRUE, card_header(strong("HR Data")), tableOutput("schooldetails2_erdb")),
                card(full_screen = TRUE, card_header(strong("Classroom Data")), tableOutput("schooldetails3_erdb")),
                card(
                  full_screen = TRUE,
                  card_header(
                    div(
                      strong("Specialization Data"),
                      tags$span(em("(based on eSF7 for SY 2023-2024)"), style = "font-size: 0.7em; color: grey;")
                    )
                  ),
                  tableOutput("schooldetails5_erdb")
                ),
                col_widths = c(6, 6, 6, 6)
              )
            )
          )
        )
      ) # --- END OF TABSET PANEL ---
    )
    
    # =====================================================
    # FINANCIAL SECTION (with Tabs)
    # =====================================================
  } else if (selected == "Financial") {
    tagList(
      h3("Financial Overview"),
      
      div(
        class = "text-start mb-3",
        actionButton(
          "reset_financial",
          label = tagList(bs_icon("arrow-left"), "Back"),
          class = "btn btn-secondary btn-md"
        )
      ),
      
      hr(),
      
      # --- TABSET PANEL START ---
      tabsetPanel(
        id = "financial_tabs",
        
        # =====================================================
        # TAB 1: Overview (Charts / Summary)
        # =====================================================
        tabPanel(
          title = "Overview",
          icon = icon("chart-bar"),
          layout_columns(
            card(full_screen = TRUE, card_header("Budget Allocation by Region"), plotlyOutput("fin_alloc_plot")),
            card(full_screen = TRUE, card_header("Utilization Rate"), plotlyOutput("fin_util_plot")),
            col_widths = c(6, 6)
          )
        ),
        
        # =====================================================
        # TAB 2: Data Table & Mapping
        # =====================================================
        tabPanel(
          title = "Data & Map",
          icon = icon("table"),
          layout_columns(
            card(full_screen = TRUE, card_header("Division Expenditure Table"), dataTableOutput("fin_table"), height = "500px"),
            card(full_screen = TRUE, card_header("Financial Mapping"), leafletOutput("fin_map"), height = "500px"),
            col_widths = c(6, 6)
          )
        ),
        
        # =====================================================
        # TAB 3: Future Financial Reports (Placeholder)
        # =====================================================
        tabPanel(
          title = "Reports",
          icon = icon("file-alt"),
          div(
            class = "text-center p-5",
            tags$h4("Financial Reports Section"),
            tags$p("Detailed budget and expenditure reports will be available here soon.")
          )
        )
      ) # --- END TABSET PANEL ---
    )
    
    # =====================================================
    # MONITORING SECTION (with Tabs)
    # =====================================================
  } else if (selected == "Monitoring") {
    tagList(
      h3("Monitoring Overview"),
      
      div(
        class = "text-start mb-3",
        actionButton(
          "reset_monitoring",
          label = tagList(bs_icon("arrow-left"), "Back"),
          class = "btn btn-secondary btn-md"
        )
      ),
      
      hr(),
      
      # --- TABSET PANEL START ---
      tabsetPanel(
        id = "monitoring_tabs",
        
        # =====================================================
        # TAB 1: Overview (Charts / Status)
        # =====================================================
        tabPanel(
          title = "Overview",
          icon = icon("chart-line"),
          
          # Optional: Add summary cards later (e.g., total projects, completed %, delayed %)
          layout_columns(
            card(full_screen = TRUE, card_header("Project Implementation Status"), plotlyOutput("monitor_proj_plot", height = "450px")),
            card(full_screen = TRUE, card_header("Monitoring Progress Trends"), plotlyOutput("monitor_trend_plot", height = "450px")),
            col_widths = c(6, 6)
          )
        ),
        
        # =====================================================
        # TAB 2: Data Table & Map
        # =====================================================
        tabPanel(
          title = "Data & Map",
          icon = icon("table"),
          layout_columns(
            card(full_screen = TRUE, card_header("Monitoring Table"), dataTableOutput("monitor_table"), height = "500px"),
            card(full_screen = TRUE, card_header("Monitoring Map"), leafletOutput("monitor_map", height = "500px")),
            col_widths = c(6, 6)
          )
        ),
        
        # =====================================================
        # TAB 3: Reports / Insights (Placeholder)
        # =====================================================
        tabPanel(
          title = "Reports",
          icon = icon("file-alt"),
          div(
            class = "text-center p-5",
            tags$h4("Monitoring Reports Section"),
            tags$p("Insights and performance summaries will be displayed here soon.")
          )
        )
      ) # --- END TABSET PANEL ---
    )
    
    # =====================================================
    # PPAs SECTION (with Tabs)
    # =====================================================
  } else if (selected == "PPAs") {
    tagList(
      h3("Programs, Projects, and Activities (PPAs) Overview"),
      
      div(
        class = "text-start mb-3",
        actionButton(
          "reset_ppas",
          label = tagList(bs_icon("arrow-left"), "Back"),
          class = "btn btn-secondary btn-md"
        )
      ),
      
      hr(),
      
      # --- TABSET PANEL START ---
      tabsetPanel(
        id = "ppas_tabs",
        
        # =====================================================
        # TAB 1: Overview (Charts / Summary)
        # =====================================================
        tabPanel(
          title = "Overview",
          icon = icon("chart-pie"),
          
          # Optional summary values (for later: total PPAs, total budget, completion rate)
          layout_columns(
            card(full_screen = TRUE, card_header("PPA Distribution by Region"), plotlyOutput("ppa_region_plot", height = "450px")),
            card(full_screen = TRUE, card_header("PPA Status Breakdown"), plotlyOutput("ppa_status_plot", height = "450px")),
            col_widths = c(6, 6)
          )
        ),
        
        # =====================================================
        # TAB 2: Data Table & Map
        # =====================================================
        tabPanel(
          title = "Data & Map",
          icon = icon("table"),
          layout_columns(
            card(full_screen = TRUE, card_header("PPA Data Table"), dataTableOutput("ppa_table"), height = "500px"),
            card(full_screen = TRUE, card_header("PPA Mapping"), leafletOutput("ppa_map", height = "500px")),
            col_widths = c(6, 6)
          )
        ),
        
        # =====================================================
        # TAB 3: Reports / Analysis (Placeholder)
        # =====================================================
        tabPanel(
          title = "Reports",
          icon = icon("file-alt"),
          div(
            class = "text-center p-5",
            tags$h4("PPAs Reports Section"),
            tags$p("Detailed PPA progress and budget analysis will be displayed here soon.")
          )
        )
      ) # --- END TABSET PANEL ---
    )
    # =====================================================
    # DEFAULT DASHBOARD HOME
    # =====================================================
  }
  else {
    tagList(
      h3("Education Resource Dashboard Overview"),
      hr(),
      p("Select a category from the sidebar to explore the data visualizations, maps, and analytics for each component of the education resource system.")
    )
  }
})