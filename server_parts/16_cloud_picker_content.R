# cloud picker content

output$cloud_main_content_area <- renderUI({
  req(input$cloud_main_category_picker)
  
  switch(input$cloud_main_category_picker,
         "cloud_enrolment" = {
           tagList(
             h3("Enrolment Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("enrolment_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("enrolment_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("enrolment_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("enrolment_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_sned" = {
           tagList(
             h3("SNED Learners"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("sned_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("sned_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("sned_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("sned_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_ip" = {
           tagList(
             h3("IP Learners"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("RegionalData"),
                                plotlyOutput("ip_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("ip_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("ip_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("ip_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_muslim" = {
           tagList(
             h3("Muslim Learners"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("muslim_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("muslim_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("muslim_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("muslim_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_displaced" = {
           tagList(
             h3("Displaced Learners"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("displaced_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("displaced_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("displaced_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("displaced_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_als" = {
           tagList(
             h3("ALS Learners"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("als_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("als_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("als_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("als_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_dropout" = {
           tagList(
             h3("School Dropout Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("dropout_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("dropout_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("dropout_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("dropout_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_teacherinventory" = {
           tagList(
             h3("Teaching Inventory Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("teacherinventory_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("teacherinventory_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("teacherinventory_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("teacherinventory_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_classroom" = {
           tagList(
             h3("Classroom Inventory"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("classroom_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("classroom_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("classroom_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("classroom_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_multigrade" = {
           tagList(
             h3("Multigrade Classes"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("multigrade_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("multigrade_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("multigrade_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("multigrade_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_organizedclass" = {
           tagList(
             h3("Number of Organized Class"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("organizedclass_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("organizedclass_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("organizedclass_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("organizedclass_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_jhsdeployment" = {
           tagList(
             h3("JHS Deployment"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("jhsdeployment_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("jhsdeployment_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("jhsdeployment_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("jhsdeployment_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_shifting" = {
           tagList(
             h3("Shifting Strategies"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shifting_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("shifting_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("shifting_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("shifting_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_LDM" = {
           tagList(
             h3("Learning Delivery Modality"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ldm_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("ldm_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("school_count_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("ldm_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_adm" = {
           tagList(
             h3("Alternative Delivery Modality"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("adm_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("adm_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("school_count_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("adm_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_ARAL" = {
           tagList(
             h3("Prospective ARAL Learners"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("aral_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("aral_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("aral_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("aral_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_crla" = {
           tagList(
             h3("CRLA Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("crla_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("crla_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("crla_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("crla_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_philiri" = {
           tagList(
             h3("PhilIRI Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("philiri_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("philiri_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("philiri_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("philiri_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_initiatives" = {
           tagList(
             h3("School Initiatives"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("initiatives_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("initiatives_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("initiatives_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("initiatives_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_moi" = {
           tagList(
             h3("Medium of Instruction"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("moi_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("moi_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("moi_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("moi_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_sosss" = {
           tagList(
             h3("School Organizational Structure and Staffing Standards"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sosss_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("sosss_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("sosss_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("sosss_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_shsimplem" = {
           tagList(
             h3("SHS Implementation"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shsimplem_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("shsimplem_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("shsimplem_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("shsimplem_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_overload" = {
           tagList(
             h3("Teaching Overload Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("overload_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("overload_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("overload_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("overload_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_resources" = {
           tagList(
             h3("School Resources"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("resources_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("resources_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("resources_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("resources_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_nat" = {
           tagList(
             h3("NAT Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("nat_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("nat_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("nat_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_nat_sufficiency" = {
           tagList(
             h3("NAT Sufficiency Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_sufficiency_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("nat_sufficiency_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("nat_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("nat_sufficiency_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_rf" = {
           tagList(
             h3("Reading Proficiency Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("rf_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("rf_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("nat_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("rf_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_lac" = {
           tagList(
             h3("LAC Sessions"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("lac_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("lac_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("lac_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("lac_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_feeding" = {
           tagList(
             h3("Feeding Program"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("feeding_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("feeding_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("feeding_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("feeding_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_sha" = {
           tagList(
             h3("Special Hardship Allowance"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sha_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("sha_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("sha_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("sha_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_childprotection" = {
           tagList(
             h3("Child Protection"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("childprotection_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("childprotection_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("childprotection_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("childprotection_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_support" = {
           tagList(
             h3("Support Received"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("support_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("support_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("support_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("support_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_extension" = {
           tagList(
             h3("Extension Schools Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("extension_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("extension_division_graph", height = 500))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("extension_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("extension_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_extension" = {
           tagList(
             h3("Extension Schools Data"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("school_count_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("school_count_division_graph", height = 00))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District  Data"),
               #                  plotlyOutput("school_count_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("school_count_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_years" = {
           tagList(
             h3("Years in Service"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("years_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("years_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("als_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("years_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_elec" = {
           tagList(
             h3("Electricity Source"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("elec_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("elec_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("als_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("elec_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_water" = {
           tagList(
             h3("Water Source"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("water_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("water_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("als_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("water_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_internet" = {
           tagList(
             h3("Internet Source"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("internet_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("als_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("internet_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_internet_usage" = {
           tagList(
             h3("Internet Usage"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_usage_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("internet_usage_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("als_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("internet_usage_data_table")))# This is the target for interaction
             )
           )
         },
         "cloud_bully" = {
           tagList(
             h3("Recorded Bullying Incidence"),
             hr(),
             layout_columns(
               # Adjusted col_widths for the three plots/tables to be side-by-side
               col_widths = c(12,12,12), # Assuming you want 3 columns for these
               #Uncomment and adjust if you need a national data table as a plotly table
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("bully_regional_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("SDO Data"),
                                plotlyOutput("bully_division_graph", height = 800))),
               # card(full_screen = TRUE,
               #      card_header(strong("Legislative District Data"),
               #                  plotlyOutput("als_district_graph", height = 500))),
               card(full_screen = TRUE,
                    card_header(strong("School Database"),
                                dataTableOutput("bully_data_table")))# This is the target for interaction
             )
           )
         }
         
  )
})
