# # dynamic panel for dashboard
# 
# # Inside your server function:
# output$dashboard_main_content_area <- renderUI({
#   req(input$hrod_main_category_picker)
#   
#   switch(input$hrod_main_category_picker,
#          "general_school_count" = {
#            tagList(
#              h3("School Count Overview"),
#              hr(),
#              layout_column_wrap(
#                width = 1/6,
#                value_box(title = "Purely ES", value = "35,036"),
#                value_box(title = "JHS with SHS", value = "6,598"),
#                value_box(title = "ES and JHS (K to 10)", value = "1,690"),
#                value_box(title = "Purely JHS", value = "1,367"),
#                value_box(title = "All Offering (K to 12)", value = "832"),
#                value_box(title = "Purely SHS", value = "262")
#              ),
#              layout_columns(
#                # Adjusted col_widths for the three plots/tables to be side-by-side
#                col_widths = c(12,6,6,12), # Assuming you want 3 columns for these
#                #Uncomment and adjust if you need a national data table as a plotly table
#                # Changed to plotlyOutput
#                card(full_screen = TRUE,
#                     card_header(strong("Regional School Count Data"),
#                                 plotlyOutput("school_count_regional_graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO School Count Data"),
#                                 plotlyOutput("school_count_division_graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("Legislative District School Count Data"),
#                                 plotlyOutput("school_count_district_graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("school_count_data_table")))# This is the target for interaction
#              )
#            )
#          },
#          "resource_shortage_classroom" = {
#            tagList(
#              h3("Classroom Shortage Overview"),
#              hr(),
#              layout_column_wrap(
#                width = 1/3,
#                value_box(title = "National Classroom Shortage", value = "165,443", showcase = bs_icon("building"))
#              ),
#              layout_columns(
#                col_widths = c(12,6,6,12), # Keep this as is for now, but consider adjusting for better layout if needed
#                # Uncomment and adjust if you need a national data table as a plotly table
#                card(full_screen = TRUE,
#                     card_header(strong("Regional Classroom Shortage Data"),
#                                 plotlyOutput("Classroom_Shortage_Region_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO Classroom Shortage Data"),
#                                 plotlyOutput("Classroom_Shortage_Division_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("Legislative District Classroom Shortage Data"),
#                                 plotlyOutput("Classroom_Shortage_District_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("Classroom_Shortage_All_List"))) # Changed to plotlyOutput
#              )
#            )
#          },
#          "resource_lms" = {
#            tagList(
#              h3("Last Mile Schools Overview (NSBI SY 2023-2024)"),
#              hr(),
#              layout_columns(
#                col_widths = c(12,12,12),
#                # Uncomment and adjust if you need a national data table as a plotly table
#                card(full_screen = TRUE,
#                     card_header(strong("Regional LMS Data"),
#                                 plotlyOutput("LMS_Nation_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO LMS Data"),
#                                 plotlyOutput("LMS_Division_Graph", height = 500))),
#                # card(full_screen = TRUE,
#                #      card_header(strong("Legislative District Classroom Shortage Data"),
#                #                  plotlyOutput("Classroom_Shortage_District_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("LMS_All_List"))) # Changed to plotlyOutput
#              )
#            )
#          },
#          "general_sosss" = {
#            tagList(
#              h3("School Organization and Staffing Standards (SOSSS)"),
#              hr(),
#              layout_column_wrap(
#                width = 1/7,
#                value_box(title = "Very Small", value = "24,976"),
#                value_box(title = "Small", value = "10,105"),
#                value_box(title = "Medium", value = "5,726"),
#                value_box(title = "Large", value = "4,210"),
#                value_box(title = "Very Large", value = "727"),
#                value_box(title = "Extremely Large", value = "38"),
#                value_box(title = "Mega", value = "3")
#              ),
#              layout_columns(
#                col_widths = c(12,6,6,12), # Keep as is
#                # Uncomment and adjust if you need a national data table as a plotly table
#                card(full_screen = TRUE,
#                     card_header(strong("Regional SOSSS Typology Data"),
#                                 plotlyOutput("SOSSS_Region_Typology", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO SOSSS Typology Data"),
#                                 plotlyOutput("SOSSS_Division_Typology", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("Legislative District SOSSS Typology Data"),
#                                 plotlyOutput("SOSSS_District_Typology", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("SOSSS_All_List_Typology"))) # Changed to plotlyOutput
#              )
#            )
#          },
#          "resource_shortage_principal" = {
#            tagList(
#              h3("School Principal Shortage Overview"),
#              hr(),
#              layout_column_wrap(
#                width = 1/3,
#                value_box(title = "School Principal", value = "21,781", showcase = bs_icon("person-badge")),
#                value_box(title = "Teacher-in-Charge", value = "23,370", showcase = bs_icon("exclamation-circle")),
#                value_box(title = "Officer-in-Charge", value = "177", showcase = bs_icon("person-fill-add"))
#              ),
#              layout_columns(
#                col_widths = c(12,6,6,12),
#                card(full_screen = TRUE,
#                     card_header(strong("Regional School Principal Shortage Data"),
#                                 plotlyOutput("School_Principal_Regional_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO School Principal Shortage Data"),
#                                 plotlyOutput("School_Principal_Division_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("Legislative District School Principal Shortage Data"),
#                                 plotlyOutput("School_Principal_District_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("School_Principal_All_List")))),
#            )
#          },
#          "resource_shortage_teacher" = {
#            tagList(
#              h3("Teacher Shortage Overview"),
#              hr(),
#              layout_column_wrap(
#                width = 1/5,
#                value_box(title = "Total Teacher Shortage", value = "32,916", showcase = bs_icon("person-vcard"), theme = "danger"),
#                value_box(title = "ES Shortage", value = "22,023", showcase = bs_icon("exclamation-circle")),
#                value_box(title = "JHS Shortage", value = "9,302", showcase = bs_icon("exclamation-circle")),
#                value_box(title = "SHS Shortage", value = "1,591", showcase = bs_icon("exclamation-circle")),
#                value_box(title = "Total Schools with Teacher Shortage", value = "26,102", showcase = bs_icon("person-vcard"), theme = "danger")
#              ),
#              layout_columns(
#                col_widths = c(12,12,12), # Keep as is
#                # Uncomment and adjust if you need a national data table as a plotly table
#                card(full_screen = TRUE,
#                     card_header(strong("Regional Teacher Shortage Data"),
#                                 plotlyOutput("Teacher_Shortage_Regional_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO Teacher Shortage Data"),
#                                 plotlyOutput("Teacher_Shortage_Division_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO Database"),
#                                 dataTableOutput("Teacher_Shortage_Regional_Table", height = 500))),
#              )
#            )
#          },
#          "resource_shortage_non_teaching" = {
#            tagList(
#              h3("AO II Shortage Overview"),
#              hr(),
#              layout_column_wrap(
#                width = 1/3,
#                value_box(title = "Dedicated", value = "12,734", showcase = bs_icon("person-lines-fill")),
#                value_box(title = "Clustered", value = "20,169", showcase = bs_icon("exclamation-circle")),
#                value_box(title = "None Deployed", value = "12,425", showcase = bs_icon("clipboard2-pulse"), theme = "danger")
#              ),
#              layout_columns(
#                col_widths = c(12,6,6,12), # Keep as is
#                # Uncomment and adjust if you need a national data table as a plotly table
#                card(full_screen = TRUE,
#                     card_header(strong("Regional AO II Deployment Data"),
#                                 plotlyOutput("AOII_Regional_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO AO II Deployment Data"),
#                                 plotlyOutput("AOII_Division_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("Legislative District AO II Deployment Data"),
#                                 plotlyOutput("AOII_District_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("AOII_Data_Table"))), # Changed to plotlyOutput
#              ),
#              h3("PDO I Shortage Overview"),
#              hr(),
#              layout_column_wrap(
#                width = 1/2,
#                value_box(title = "With PDO I", value = "1500", showcase = bs_icon("person-lines-fill")),
#                value_box(title = "Without PDO I", value = "43,828", showcase = bs_icon("exclamation-circle"), theme = "danger")
#              ),
#              layout_columns(
#                col_widths = c(12,6,6,12), # Keep as is
#                # Uncomment and adjust if you need a national data table as a plotly table
#                card(full_screen = TRUE,
#                     card_header(strong("Regional PDO I Deployment Data"),
#                                 plotlyOutput("PDOI_Regional_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO PDO I Deployment Data"),
#                                 plotlyOutput("PDOI_Division_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("Legislative District PDO I Deployment Data"),
#                                 plotlyOutput("PDOI_District_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("PDOI_Data_Table"))), # Changed to plotlyOutput
#              )
#            )
#          },
#          "others_sufficiency" = {
#            tagList(
#              h3("Sufficiency Overview"),
#              hr(),
#              layout_columns(
#                col_widths = c(12,12,12), # Keep as is
#                card(full_screen = TRUE,
#                     card_header(strong("Regional Sufficiency Data"),
#                                 selectInput("SuffOpt","Select a Category:", multiple = FALSE, selected = "Teacher.Sufficiency", choices = c("Teacher Sufficiency" = "Teacher.Sufficiency","Classroom Sufficiency" = "Classroom.Sufficiency","School Principal Sufficiency" = "SH.Sufficiency", "AO Sufficiency" = "AO.Sufficiency")),
#                                 plotlyOutput("Sufficiency_Regional_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("SDO Sufficiency Data"),
#                                 selectInput("SuffOpt","Select a Category:", multiple = FALSE, selected = "Teacher.Sufficiency", choices = c("Teacher Sufficiency" = "Teacher.Sufficiency","Classroom Sufficiency" = "Classroom.Sufficiency","School Principal Sufficiency" = "SH.Sufficiency", "AO Sufficiency" = "AO.Sufficiency")),
#                                 plotlyOutput("Sufficiency_Division_Graph", height = 500))),
#                card(full_screen = TRUE,
#                     card_header(strong("School Database"),
#                                 dataTableOutput("Sufficiency_All_List"))) # Changed to plotlyOutput
#              )
#            )
#          }
#   )
# })