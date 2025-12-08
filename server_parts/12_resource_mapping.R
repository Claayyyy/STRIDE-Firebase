# dynamic panel for resource mapping

# Reactive expression to generate the main panel content
output$dynamic_resource_panel <- renderUI({
  
  selected_resource_type <- input$resource_type_selection
  if (selected_resource_type == "Teaching Deployment") {
    
    tagList(
      h3("Teaching Deployment Overview"),
      hr(),
      # 
      # layout_columns(
      #   selectInput("resource_map_level", "Filter Curricular Level:",
      #               choices = c("Elementary School"="ES",
      #                           "Junior High School"="JHS",
      #                           "Senior High School"="SHS"),
      #               selected = "ES"),
      #   input_task_button("Teaching_Deployment_Refresh", strong("Refresh"), class = "btn-warning"),
      #   col_widths = c(4, -8, 2)
      # ),
      # 
      # hr(),
      
      # --- Accordion only for summary cards ---
      accordion(
        open = "Deployment Summary by Level",
        
        accordion_panel(
          title = "Deployment Summary by Level",
          icon = bsicons::bs_icon("bar-chart-fill"),
          
          # --- Start of Tabset (now ABOVE the summary cards) ---
          navset_tab(
            # Note: All panels are commented out, so this tabset will be empty.
            # nav_panel("Regional Breakdown",
            #           plotlyOutput("Teaching_Deployment_Region_Graph")
            # ),
            # nav_panel("Priority Divisions",
            #           plotlyOutput("Teaching_Deployment_Division_Graph1")
            # ),
            # nav_panel("Dataset",
            #           dataTableOutput("Teaching_Deployment_Dataset")
            # )
          ),
          # --- End of Tabset ---
          
          hr(),
          
          # --- Summary Cards ---
          layout_column_wrap(
            width = 1/4,
            card(
              card_header(strong("RO Filling-up Rate")),
              valueBoxOutput("f")
            ),
            card(
              card_header(strong("RO Unfilled Items")),
              valueBoxOutput("g")
            ),
            card(
              card_header(strong("SDO Filling-up Rate")),
              valueBoxOutput("a")
            ),
            card(
              card_header(strong("SDO Unfilled Items")),
              valueBoxOutput("b")
            )
            # card(
            #   card_header(strong("SDO Net Shortage")),
            #   valueBoxOutput("e")
            # )
          ),
          
          hr(),
          
          layout_columns(
            card(
              card_header(strong("Teacher Excess and Shortage")),
              dataTableOutput("TeacherShortage_Table")
            ),
            card(
              full_screen = TRUE,
              card_header(strong("Personnel Deployment Mapping")),
              leafletOutput("TeacherShortage_Mapping", height = 700)
            ),
            # card(
            #   height = 200,
            #   card_header(div(
            #     "School Summary",
            #     tags$span(em("(Select a school from the table above)"),
            #               style = "font-size: 0.7em; color: grey;")
            #   )),
            #   uiOutput("TeacherShortage_Assessment")
            # ),
            col_widths = c(4, 8)
          )
        ) # <- End accordion_panel
      ) # <- End accordion
      
    ) # <--- THIS WAS THE MISSING PARENTHESIS
    
  } # <- End if
  else if (selected_resource_type == "Non-teaching Deployment") {
    tagList(
      h3("Non-teaching Deployment Overview"),
      hr(),
      
      # --- Accordion for the summary sections ---
      accordion(
        open = "Deployment Summary by Level",
        accordion_panel(
          title = "Deployment Summary by Level",
          icon = bsicons::bs_icon("people-fill"),
          
          # --- Tabbed summaries inside accordion ---
          navset_card_tab(
            nav_spacer(),
            
            # --- Regional Summary ---
            nav_panel(
              title = "Regional Summary",
              layout_column_wrap(
                width = 1/2,  # Two cards side by side
                card(
                  card_header(strong("Schools under Clustered AO II Deployment")),
                  valueBoxOutput("f2")
                ),
                card(
                  card_header(strong("Schools with Dedicated AOII Deployment")),
                  valueBoxOutput("g2")
                )
              )
            ),
            
            # --- Division Summary ---
            nav_panel(
              title = "Division Summary",
              layout_column_wrap(
                width = 1/2,
                card(
                  card_header(strong("Schools under Clustered AO II Deployment")),
                  valueBoxOutput("a2")
                ),
                card(
                  card_header(strong("Schools with Dedicated AOII Deployment")),
                  valueBoxOutput("b2")
                )
              )
            ),
            
            # --- District Summary ---
            nav_panel(
              title = "District Summary",
              layout_column_wrap(
                width = 1/2,
                card(
                  card_header(strong("Schools under Clustered AO II Deployment")),
                  valueBoxOutput("e2")
                ),
                card(
                  card_header(strong("Schools with Dedicated AOII Deployment")),
                  valueBoxOutput("h2")
                )
              )
            )
          )
        )
      ),
      
      hr(),
      
      # --- This part stays outside the accordion ---
      layout_columns(
        card(
          card_header(
            div(
              strong("AO II Deployment Status"),
              tags$span(
                em("(as of September 2, 2025)"),
                style = "font-size: 0.8em; color: grey; margin-top: 0.1em; margin-bottom: 0;"
              )
            )
          ),
          dataTableOutput("AO2Table")
        ),
        card(
          full_screen = TRUE,
          card_header(strong("Personnel Deployment Mapping")),
          leafletOutput("AO2Mapping", height = 800)
        ),
        col_widths = c(5,7)
      )
    )
    
    
  } else if (selected_resource_type == "Classroom Inventory") {
    tagList(
      h3("Classroom Inventory Overview"),
      hr(),
      
      # --- Accordion for National and Shortage Summaries ---
      accordion(
        
        # ⃣Panel: National Overview
        accordion_panel(
          title = "National Classroom Inventory Overview",
          icon = bsicons::bs_icon("bar-chart-fill"),
          layout_columns(
            # card(
            #   full_screen = TRUE,
            #   card_header(
            #     tagList(
            #       strong("Classroom Shortage Breakdown"),
            #       tags$br(),
            #       tags$em("(n = 165,443)")
            #     )
            #   ),
            #   # Start of Tabset
            #   navset_tab(
            #     # Tab 1: Regional Classroom Breakdown (Your existing content)
            #     # nav_panel("Regional Breakdown",
            #     #           plotlyOutput("Classroom_Shortage_Region_Graph2")
            #     # ),
            #     # Tab 2: Division Classroom Shortage Breakdown (The new tab)
            #     # nav_panel("Priority Divisions",
            #     #           plotlyOutput("Classroom_Shortage_Division_Graph2")
            #     # ),
            #     nav_panel("Dataset",
            #               dataTableOutput("Classroom_Shortage_Dataset"))
            #   )),
            # # End of Tabset
            
            card(
              card_header(strong("Regional Classroom Shortage")),
              valueBoxOutput("ROCRShort")
            ),
            card(
              card_header(strong("Division Classroom Shortage")),
              valueBoxOutput("SDOCRShort")
            ),
            #card(
            # card_header(strong("District Classroom Shortage")),
            #valueBoxOutput("DistCRShort")
            #),
            col_widths = c(6,6)
          )
        )
      ),
      
      hr(),
      
      # --- Table and Mapping ---
      layout_columns(
        card(
          full_screen = TRUE,
          card_header(strong("Classroom Shortage")),
          dataTableOutput("CLTable")
        ),
        card(
          full_screen = TRUE,
          card_header(strong("School Mapping")),
          leafletOutput("CLMapping", height = 800)
        )
      )
    )
    
    
  } else if (selected_resource_type == "Industries") {
    
    tagList(
      h3("Industries Overview"),
      hr(),
      
      # --- Accordion for Industry Summary and others ---
      accordion(
        open = "Industry Summary",
        
        #  Panel: Industry Summary
        accordion_panel(
          title = "Industry Summary",
          icon = bsicons::bs_icon("bar-chart"),
          
          # # --- Industry Distribution Overview Card placed FIRST ---
          # card(
          #   full_screen = TRUE,
          #   card_header(
          #     tagList(
          #       strong("Industry Breakdown"),
          #       tags$br(),
          #       tags$em("(n = )")
          #     )
          #   ),
          #   
          #   # --- Tabset ---
          #   navset_tab(
          #     nav_panel("Regional Breakdown",
          #               plotlyOutput("Ind_Regional_Graph")
          #     ),
          #     # nav_panel("Priority Divisions",
          #     #           plotlyOutput("Ind_Division_Graph")
          #     # ),
          #     nav_panel("Dataset",
          #               dataTableOutput("Ind_Dataset")
          #     )
          #   )
          # ),
          # 
          # # --- Divider line for better separation ---
          # hr(),
          # 
          # --- Summary Counts ---
          layout_column_wrap(
            width = 1/2,
            card(
              card_header(strong("Total SHS Count")),
              valueBoxOutput("SHSCountUniv")
            ),
            card(
              card_header(strong("Total Industry Count")),
              valueBoxOutput("IndCount")
            )
          ),
          
          # --- Nearby Industry Count ---
          card(
            card_header("Nearby Industry Count (~10 km radius):"),
            layout_column_wrap(
              width = 1/6,
              card(
                card_header(strong("Manufacturing and Engineering")),
                valueBoxOutput("AccoCount")
              ),
              card(
                card_header(strong("Hospitality and Tourism")),
                valueBoxOutput("ProfCount")
              ),
              card(
                card_header(strong("Public Administration")),
                valueBoxOutput("TranCount")
              ),
              card(
                card_header(strong("Professional/Private Services")),
                valueBoxOutput("WastCount")
              ),
              card(
                card_header(strong("Business and Finance")),
                valueBoxOutput("WholCount")
              ),
              card(
                card_header(strong("Agriculture and Agri-business")),
                valueBoxOutput("WholCount2")
              )
            )
          )
        )
      ),
      
      hr(),
      
      # --- Remaining Layout: SHS list, mapping, etc. ---
      layout_columns(
        card(
          card_header(strong("List of SHS")),
          dataTableOutput("SHSListTable")
        ),
        card(
          full_screen = TRUE,
          card_header(strong("SHS to Industry Mapping")),
          leafletOutput("SHSMapping", height = 700, width = "100%")
        ),
        card(
          full_screen = TRUE,
          card_header(div(strong("School Profile"),
                          tags$span(em("(Select a school in the table above)"),
                                    style = "font-size: 0.7em; color: grey;")
          )),
          tableOutput("SHSTablex")
        ),
        card(
          full_screen = TRUE,
          card_header(div(strong("Specialization Data"),
                          tags$span(em("(based on eSF7 for SY 2023-2024)"),
                                    style = "font-size: 0.7em; color: grey;")
          )),
          tableOutput("PilotSpec")
        ),
        card(
          card_header(div(strong("Nearby Industries"),
                          tags$span(em("(Select a school in the table above)"),
                                    style = "font-size: 0.7em; color: grey;")
          )),
          dataTableOutput("dataTableSHS")
        ),
        col_widths = c(4, 8, 6, 6, 12)
      )
    )
  }
  
  
  else if (selected_resource_type == "Facilities") {
    
    tagList(
      h3("Education Facilities Mapping"),
      
      layout_columns(
        col_widths = c(6, 6), 
        selectInput("EFD_Type", "Select Type",
                    choices = c("New Construction","Electrification","Health","QRF","LMS","ALS-CLC","Gabaldon", "Repairs"),
                    selected = "New Construction"
        )
      ),
      
      input_task_button("Facilities_Refresh", strong("Refresh"), class = "btn-success"),
      hr(),
      
      # # --- Accordion Wrapper ---
      # accordion(
      #   open = "Facilities Overview",
      #   
      #   accordion_panel(
      #     title = "Facilities Overview",
      #     icon = bsicons::bs_icon("building"),
      #     
      #     # --- Start of Tabset ---
      #     navset_tab(
      #       nav_panel("Regional Breakdown",
      #                 plotlyOutput("Facilities_Regional_Graph")
      #       ),
      #       nav_panel("Division Breakdown",
      #                 plotlyOutput("Facilities_Division_Graph")
      #       ),
      #       nav_panel("Dataset",
      #                 dataTableOutput("Facilities_Dataset")
      #       )
      #     )
      #     # --- End of Tabset ---
      #   )
      # ),
      
      hr(),
      
      layout_columns(
        card(
          full_screen = TRUE,
          card_header(strong("School Project Allocation per Funding Year")),
          dataTableOutput("FacTable")
        ),
        card(
          full_screen = TRUE,
          card_header(strong("School Mapping")),
          leafletOutput("FacMapping", height = 800)
        )
      )
    )
    
  }
  else if (selected_resource_type == "Learner Congestion") {
    
    tagList(
      h3("Learner Congestion Mapping (SY 2023-2024)"),
      hr(),
      
      # # --- Accordion Wrapper ---
      # accordion(
      #   open = "Learner Congestion Overview",
      #   
      #   accordion_panel(
      #     title = "Learner Congestion Overview",
      #     icon = bsicons::bs_icon("diagram-3-fill"),
      #     
      #     # --- Start of Tabset ---
      #     navset_tab(
      #       nav_panel("Regional Breakdown",
      #                 plotlyOutput("Congest_Regional_Graph")
      #       ),
      #       nav_panel("Division Breakdown",
      #                 plotlyOutput("Congest_Division_Graph")
      #       ),
      #       nav_panel("Dataset",
      #                 dataTableOutput("Congest_Dataset")
      #       )
      #     )
      #     # --- End of Tabset ---
      #   )
      # ),
      
      hr(),
      
      layout_columns(
        card(
          full_screen = TRUE,
          card_header(strong("Congestion Summary Table")),
          dataTableOutput("CongestTable")
        ),
        card(
          full_screen = TRUE,
          card_header(strong("School Mapping")),
          leafletOutput("CongestMapping", height = 800)
        )
      )
    )
    
  }
  else if (selected_resource_type == "Last Mile School") {
    tagList(
      h3("Last Mile Schools (LMS) Overview"),
      hr(),
      
      # --- Accordion for LMS Summaries ---
      accordion(
        open = "National and Regional Breakdown",  # optional: open first panel by default
        
        # 1️⃣ Panel: National + Regional Breakdown
        accordion_panel(
          title = "National and Regional Breakdown",
          icon = bsicons::bs_icon("bar-chart"),
          layout_columns(
            # card(
            #   full_screen = TRUE,
            #   card_header(
            #     tagList(
            #       strong("Breakdown of Last Mile Schools"),
            #       tags$br(),
            #       tags$em("(n = 9,100)")
            #     )
            #   ),
            #   # Start of Tabset
            #   navset_tab(
            #     # Tab 1: Regional Breakdown (Your existing content)
            #     # nav_panel("Regional Breakdown",
            #     #           plotlyOutput("LMS_Nation_Graph2")
            #     # ),
            #     # # Tab 2: Division Breakdown (The new tab)
            #     # nav_panel("Priority Divisions",
            #     #           plotlyOutput("LMS_Division_Graph2")
            #     # ),
            #     nav_panel("Dataset",
            #               dataTableOutput("LMS_Dataset")
            #     )
            #   )),
            card(
              card_header(strong("Total Last Mile Schools by Region")),
              valueBoxOutput("LMS_Total_Region")
            ),
            card(
              card_header(strong("Total Last Mile Schools by Division")),
              valueBoxOutput("LMS_Total_Division")
            ),
            col_widths = c(6,6)
          )
        )
      ),
      
      hr(), 
      
      layout_columns(
        card(
          full_screen = TRUE,
          card_header(strong("List of Last Mile Schools")),
          dataTableOutput("LMSTable")
        ),
        card(
          full_screen = TRUE,
          card_header(strong("LMS Mapping")),
          leafletOutput("LMSMapping", height = 800)
        ),
        col_widths = c(6, 6)
      )
    )
  }
})

observeEvent(input$Facilities_Refresh, {
  
  # Ensure all necessary inputs are ready before proceeding
  req(input$resource_map_region, input$Resource_SDO, input$EFD_Type)
  
  # Filter the data based on user inputs
  mainreactEFD <- EFDMP %>% 
    filter(!is.na(Old.Region), Old.Region != "") %>% 
    filter(!is.na(Latitude), !is.na(Longitude)) %>% 
    mutate(Latitude = as.numeric(Latitude),
           Allocation = dollar(Allocation, prefix = "₱")) %>%  # Use 'dollar' to format Allocation) %>% 
    distinct(SchoolID, FundingYear, Allocation, Category, .keep_all = TRUE) %>%
    filter(Region == input$resource_map_region) %>%
    filter(Division == input$Resource_SDO) %>%
    filter(Category %in% input$EFD_Type) %>% 
    mutate(FundingCategory = factor(
      case_when(
        FundingYear < 2025 ~ "Before 2025",
        (FundingYear >= 2025 & FundingYear <= 2030) ~ "2025-2030",
        FundingYear > 2030 ~ "After 2030"
      ),
      levels = c("Before 2025", "2025-2030", "After 2030")
    ))
  
  # This req() is crucial: it stops the code if the filter returns no rows, preventing the crash.
  req(mainreactEFD)
  
  # Now that you have a non-empty data frame, you can use leafletProxy
  
  values.efdmasterlist <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactEFD$School.Name,"<br>School ID:",mainreactEFD$SchoolID,"<br>Category:",mainreactEFD$Category,"<br>Funding Year:",mainreactEFD$FundingYear,"<br>Allocation:",mainreactEFD$Allocation) %>% lapply(htmltools::HTML)
  
  color_palette <- colorFactor(
    palette = c("red", "green", "blue"),
    domain = mainreactEFD$FundingCategory,
    levels = levels(mainreactEFD$FundingCategory) # Ensure the order is respected
  )
  
  # 3. Use the new factor variable and color palette in your leaflet code
  leafletProxy("FacMapping", data = mainreactEFD) %>%
    clearMarkers() %>%
    clearControls() %>%
    setView(lng = mainreactEFD$Longitude[1], lat = mainreactEFD$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = ~Longitude,
      lat = ~Latitude,
      popup = values.efdmasterlist,
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = case_when(mainreactEFD$FundingCategory == "Before 2025" ~ "red", mainreactEFD$FundingCategory == "2025-2030" ~ "green", mainreactEFD$FundingCategory == "After 2030" ~ "blue") # Use the new factor variable
      )
    ) %>%
    addLegend(
      "bottomright",
      pal = color_palette,
      values = ~FundingCategory, # Use the new factor variable
      title = "Funding Year",
      opacity = 1
    )
  
  dfreact_fac <- reactive({
    if (is.null(input$FacMapping_bounds)) {
      mainreactEFD
    } else {
      bounds <- input$FacMapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreactEFD,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  output$FacTable <- DT::renderDT(server = TRUE, {
    datatable(dfreact_fac() %>%
                arrange(FundingYear) %>% 
                select("Region","Division","School.Name","FundingYear","Allocation") %>%
                rename("School" = School.Name, "Funding Year" = FundingYear),
              extension = 'Buttons',
              rownames = FALSE,
              options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = 'Bfrtip', buttons = list('csv','excel','pdf','print')))
  })
})

observeEvent(input$Teaching_Deployment_Refresh, {
  
  output$TeacherShortage_Mapping <- renderLeaflet({
    p = colorFactor(palette = c("red","deepskyblue","green"),domain = c("Shortage","Excess","Balanced"), ordered = T)
    leaflet() %>%
      setView(lng = 122, lat = 13, zoom =6) %>%
      addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>% 
      addProviderTiles(providers$Esri.WorldStreetMap, group = "Road Map") %>%
      addMeasure(position = "topright", primaryLengthUnit = "kilometers", primaryAreaUnit = "sqmeters") %>% 
      addLegend(position = "bottomright", title = "Legend", pal = p, values = c("Shortage","Excess","Balanced")) %>% 
      addLayersControl(
        baseGroups = c("Satellite","Road Map"))
  })
  
  RegRCT <- input$resource_map_region
  SDORCT1 <- input$Resource_SDO
  DistRCT1 <- input$Resource_LegDist
  Lev <- input$resource_map_level
  
  mainreact1 <- df %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) %>% filter(Legislative.District == DistRCT1) %>% arrange(desc(TeacherShortage))
  
  NetShortage <- df %>% select(Region,Division,Level,TeacherShortage,TeacherExcess) %>%
    pivot_longer(cols = c(TeacherShortage, TeacherExcess), names_to = "Inventory", values_to = "Count") %>% mutate(Count=as.numeric(Count)) %>% na.omit(Count) %>% group_by(Region, Division,Level, Inventory) %>% summarize(Count = sum(Count)) %>% pivot_wider(names_from = "Inventory", values_from = "Count") %>% mutate(NetShortage=TeacherShortage-TeacherExcess) %>% mutate(NetShortage = ifelse(NetShortage < 0, 0, NetShortage))
  
  SDONetShortage <- NetShortage %>% filter(Region == RegRCT) %>% filter(Division == SDORCT1) #%>% filter(Level == Lev)
  
  values_teacher_shortage <- paste(mainreact1$School.Name,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage) %>% lapply(htmltools::HTML)
  
  values_teacher_shortage_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreact1$School.Name,"<br>School ID:",mainreact1$SchoolID,"<br>Enrolment Size:",mainreact1$TotalEnrolment,"<br>","<br>",strong("TEACHING PERSONNEL DATA"),"<br>Teacher Inventory:", mainreact1$TotalTeachers,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage,"<br>","<br>",strong("SPECIALIZATION DATA"),"<br>English:", mainreact1$English,"<br>Mathematics:", mainreact1$Mathematics,"<br>Science:", mainreact1$Science,"<br>Biological Science:", mainreact1$Biological.Sciences,"<br>Physical Sciences:", mainreact1$Physical.Sciences,"<br>General Education:", mainreact1$General.Ed,"<br>Araling Panlipunan:", mainreact1$Araling.Panlipunan,"<br>TLE:", mainreact1$TLE,"<br>MAPEH:", mainreact1$MAPEH,"<br>Filipino:", mainreact1$Filipino,"<br>ESP:", mainreact1$ESP,"<br>Agriculture:", mainreact1$Agriculture,"<br>ECE:", mainreact1$ECE,"<br>SPED:", mainreact1$SPED) %>% lapply(htmltools::HTML)
  
  leafletProxy("TeacherShortage_Mapping") %>% clearMarkers() %>% clearMarkerClusters() %>% setView(lng = mainreact1$Longitude[1], lat = mainreact1$Latitude[1], zoom = 7) %>% 
    addAwesomeMarkers(clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15), lng = mainreact1$Longitude, lat = mainreact1$Latitude, popup = values_teacher_shortage_popup, options = popupOptions(), label = values_teacher_shortage, labelOptions = labelOptions(noHide = F, textsize = "12px", direction = "top"), icon = makeAwesomeIcon(icon = "education", library = "glyphicon", markerColor = case_when(mainreact1$TeacherShortage > 0 ~ "red", mainreact1$TeacherExcess > 0 ~ "blue", (mainreact1$TeacherExcess == 0 & mainreact1$TeacherShortage == 0) ~ "green", is.na(mainreact1$TeacherShortage) ~ "gray")))
  
  dfreact_TS <- reactive({
    
    if (is.null(input$TeacherShortage_Mapping_bounds)) {
      mainreact1
    } else {
      bounds <- input$TeacherShortage_Mapping_bounds
      latRng <- range(bounds$north, bounds$south)
      lngRng <- range(bounds$east, bounds$west)
      
      subset(mainreact1,
             Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
    }
  })
  
  
  
  output$a <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Region==RegRCT & SDO$Division==SDORCT1),"FillUpRate"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$b <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Region==RegRCT & SDO$Division==SDORCT1),"Unfilled"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
    
  })
  
  output$e <- renderValueBox({
    valueBox(tags$p(strong(SDONetShortage$NetShortage), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
    
  })
  
  output$c <- renderValueBox({
    valueBox(tags$p(strong(sum(df1()$TeacherExcess)), style = "font-size: 65%;"), subtitle = NULL)
    
  })
  
  output$d <- renderValueBox({
    valueBox(tags$p(strong("-"), style = "font-size: 65%;"), subtitle = NULL)})
  
  output$f <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Division==RegRCT),"FillUpRate"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
  })
  
  output$g <- renderValueBox({
    valueBox(tags$p(strong(SDO[which(SDO$Division==RegRCT),"Unfilled"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
    
  })
  
})