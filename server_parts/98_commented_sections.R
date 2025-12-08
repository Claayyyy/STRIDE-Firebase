# commented sections

# Call the shinyauthr::logoutServer module
# logout_init <- shinyauthr::logoutServer(
#   id = "logout",
#   active = reactive(credentials()$user_auth) # Logout button active only when logged in
# )


# # --- Curricular Offering Bar Chart ---
# output$Curricular_Offering_Bar <- renderPlotly({
#   data <- data.frame(
#     Category = c("Purely ES", "JHS with SHS", "ES and JHS (K to 10)",
#                  "Purely JHS", "All Offering (K to 12)", "Purely SHS"),
#     Count = c(35036, 6598, 1690, 1367, 832, 262),
#     marker = list(color = "#0072B2")
#   )
#   
#   plot_ly(
#     data,
#     y = ~Category,  # Flipped
#     x = ~Count,     # Flipped
#     type = "bar", 
#     marker = list(color = "#002D62"),
#     text = ~Count,              # Added
#     texttemplate = '%{x:,.0f}',# Added
#     textposition = 'outside'   # Added
#   ) |>
#     layout(
#       title = list(text = "Curricular Offering Distribution", x = 0.5),
#       yaxis = list(title = "", autorange = "reversed"), # Swapped, added autorange
#       xaxis = list(title = "Number of Schools") # Swapped
#     )
# })
# 
# # --- Curricular Offering Pie Chart --- (No changes)
# output$Curricular_Offering_Pie <- renderPlotly({
#   data <- data.frame(
#     Category = c("Purely ES", "JHS with SHS", "ES and JHS (K to 10)",
#                  "Purely JHS", "All Offering (K to 12)", "Purely SHS"),
#     Count = c(35036, 6598, 1690, 1367, 832, 262),
#     marker = list(color = "#D9534F")
#   )
#   
#   plot_ly(
#     data,
#     labels = ~Category, values = ~Count, type = "pie",
#     textinfo = "label+percent", insidetextorientation = "radial"
#   ) |> layout(title = list(text = "Curricular Offering (Pie)", x = 0.5))
# })
# 
# # --- Toggle visibility for Curricular Offering graphs --- (No changes)
# observeEvent(input$show_curricular_graphs, {
#   if (input$show_curricular_graphs %% 2 == 1) {
#     shinyjs::show("curricular_graphs")
#     updateActionButton(session, "show_curricular_graphs", label = "Hide Graphs")
#   } else {
#     shinyjs::hide("curricular_graphs")
#     updateActionButton(session, "show_curricular_graphs", label = "Show Graphs")
#   }
# })
# 
# # --- School Size Typology Bar Chart ---
# output$School_Size_Typology_Bar <- renderPlotly({
#   data <- data.frame(
#     Size = c("Very Small", "Small", "Medium", "Large",
#              "Very Large", "Extremely Large", "Mega"),
#     Count = c(24976, 10105, 5726, 4210, 727, 38, 3)
#   )
#   
#   plot_ly(
#     data,
#     y = ~Size,  # Flipped
#     x = ~Count, # Flipped
#     type = "bar", 
#     marker = list(color = "#0074D9"),
#     text = ~Count,              # Added
#     texttemplate = '%{x:,.0f}',# Added
#     textposition = 'outside'   # Added
#   ) |>
#     layout(
#       title = list(text = "School Size Typology Distribution", x = 0.5),
#       yaxis = list(            # Swapped
#         title = "", categoryorder = "total descending", autorange = "reversed"
#       ), 
#       xaxis = list(title = "Number of Schools") # Swapped
#     )
# })
# 
# # --- School Size Typology Pie Chart --- (No changes)
# output$School_Size_Typology_Pie <- renderPlotly({
#   data <- data.frame(
#     Size = c("Very Small", "Small", "Medium", "Large",
#              "Very Large", "Extremely Large", "Mega"),
#     Count = c(24976, 10105, 5726, 4210, 727, 38, 3)
#   )
#   
#   plot_ly(
#     data,
#     labels = ~Size, values = ~Count,
#     type = "pie", textinfo = "label+percent",
#     insidetextorientation = "radial"
#   ) |> layout(title = list(text = "School Size Typology (Pie)", x = 0.5))
# })
# 
# # --- Curricular Offering Bar Chart ---
# output$Curricular_Offering_Bar <- renderPlotly({
#   data <- data.frame(
#     Category = c("Purely ES", "JHS with SHS", "ES and JHS (K to 10)",
#                  "Purely JHS", "All Offering (K to 12)", "Purely SHS"),
#     Count = c(35036, 6598, 1690, 1367, 832, 262),
#     marker = list(color = "#0072B2")
#   )
#   
#   plot_ly(
#     data,
#     x = ~Category, y = ~Count,
#     type = "bar", marker = list(color = "#002D62")
#   ) |>
#     layout(title = list(text = "Curricular Offering Distribution", x = 0.5),
#            xaxis = list(title = ""), yaxis = list(title = "Number of Schools"))
# })
# 
# # --- Curricular Offering Pie Chart ---
# output$Curricular_Offering_Pie <- renderPlotly({
#   data <- data.frame(
#     Category = c("Purely ES", "JHS with SHS", "ES and JHS (K to 10)",
#                  "Purely JHS", "All Offering (K to 12)", "Purely SHS"),
#     Count = c(35036, 6598, 1690, 1367, 832, 262),
#     marker = list(color = "#D9534F")
#   )
#   
#   plot_ly(
#     data,
#     labels = ~Category, values = ~Count, type = "pie",
#     textinfo = "label+percent", insidetextorientation = "radial"
#   ) |> layout(title = list(text = "Curricular Offering (Pie)", x = 0.5))
# })
# 
# # --- Toggle visibility for Curricular Offering graphs ---
# observeEvent(input$show_curricular_graphs, {
#   if (input$show_curricular_graphs %% 2 == 1) {
#     shinyjs::show("curricular_graphs")
#     updateActionButton(session, "show_curricular_graphs", label = "Hide Graphs")
#   } else {
#     shinyjs::hide("curricular_graphs")
#     updateActionButton(session, "show_curricular_graphs", label = "Show Graphs")
#   }
# })
# 
# # --- School Size Typology Bar Chart ---
# output$School_Size_Typology_Bar <- renderPlotly({
#   data <- data.frame(
#     Size = c("Very Small", "Small", "Medium", "Large",
#              "Very Large", "Extremely Large", "Mega"),
#     Count = c(24976, 10105, 5726, 4210, 727, 38, 3)
#   )
#   
#   plot_ly(
#     data,
#     x = ~Size, y = ~Count,
#     type = "bar", marker = list(color = "#0074D9")
#   ) |>
#     layout(title = list(text = "School Size Typology Distribution", x = 0.5),
#            xaxis = list(title = ""), yaxis = list(title = "Number of Schools"))
# })
# 
# # --- School Size Typology Pie Chart ---
# output$School_Size_Typology_Pie <- renderPlotly({
#   data <- data.frame(
#     Size = c("Very Small", "Small", "Medium", "Large",
#              "Very Large", "Extremely Large", "Mega"),
#     Count = c(24976, 10105, 5726, 4210, 727, 38, 3)
#   )
#   
#   plot_ly(
#     data,
#     labels = ~Size, values = ~Count,
#     type = "pie", textinfo = "label+percent",
#     insidetextorientation = "radial"
#   ) |> layout(title = list(text = "School Size Typology (Pie)", x = 0.5))
# })# --- Authentication ---
# Call the shinyauthr::loginServer module
# credentials() will be a reactive returning a tibble with user_auth, info, and additional columns from user_base
# credentials <- shinyauthr::loginServer(
#   id = "login",
#   data = user_base,
#   user_col = user,
#   pwd_col = password_hash, # Use the hashed password column
#   sodium_hashed = TRUE,    # Important: tell shinyauthr we are using sodium hashes
#   log_out = reactive(logout_init()) # Link to the logout button
# )
# 
# 
# 
# # --- Reactive Values & Observers ---
# # Observe the authentication status
# observe({
#   auth_status <- credentials()$user_auth
#   if (auth_status) {
#     # User is authenticated. Let's get their details.
#     user_info <- credentials()$info
#     # This is a tibble with the user's row
#     
#     # Ensure user_info is available and has the username
#     # (It should if auth_status is TRUE and your user_base is set up correctly)
#     if (!is.null(user_info) && "user" %in% names(user_info)) {
#       current_username <- user_info$user # Get the username
#       
#       # --- Always hide the login panel when authenticated ---
#       shinyjs::hide(selector = "#login") # Or shinyjs::hide(id = "login-login_ui")
#       shinyjs::hide("StrideLogo")
#       # --- Conditional logic based on username ---
#       if (current_username == "iamdeped") { # <<<< Your specific username condition
#         # Authenticated AND username is "user1"
#         shinyjs::show("main_content")
#         shinyjs::hide("mgmt_content")
#       } else {
#         
#         if (current_username == "depedadmin") {
#           # Authenticated BUT username is NOT "user1"
#           # This could be user2, user3, etc.
#           shinyjs::show("mgmt_content")
#           shinyjs::hide("main_content")
#           # output$generic_secure_data <- renderPrint({"Generic secure data for other users..."})
#         }}}
#   } else {
#     # User is NOT authenticated (e.g., after logout or initially)
#     shinyjs::show(selector = "#login")
#     shinyjs::show("StrideLogo")
#     shinyjs::hide("main_content")
#     shinyjs::hide("mgmt_content")
#   }
#   
#   if (auth_status) {
#     shinyjs::runjs('
#   $("#loading-overlay").fadeIn(200);
#   document.body.classList.remove("login-bg");
#   document.body.classList.add("dashboard-bg");
# ')
#   } else {
#     shinyjs::runjs('$("#loading-overlay").hide();')
#     shinyjs::runjs('document.body.classList.remove("dashboard-bg");')
#     shinyjs::runjs('document.body.classList.add("login-bg");')
#   }})

# output$explorer_masterlist_data_table <- DT::renderDT(server = TRUE, {datatable(EFDMP %>% filter(Region == input$explorer_masterlist_region_filter) %>% filter(Division == input$explorer_masterlist_SDO) %>% arrange(desc(FundingYear)) %>% select(Region, Division, District, SchoolID, School.Name,FundingYear,Category,Allocation,Completion,Status), extension = 'Buttons', filter = 'top', options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), rownames = FALSE, dom = 'Bfrtip', buttons = list('csv','excel','print')))})
# 
# output$explorer_efd_division_filter <- renderUI({
#   req(input$explorer_efd_region_filter) # Ensure region is selected before updating division
#   selectInput("explorer_efd_SDO","Select a Division:", 
#               choices = c(unique(df[df$Region==input$explorer_efd_region_filter,"Division"])),
#               selected = "")
# })
# 
# output$explorer_masterlist_division_filter <- renderUI({
#   req(input$explorer_masterlist_region_filter) # Ensure region is selected before updating division
#   selectInput("explorer_masterlist_SDO","Select a Division:", 
#               choices = c(unique(df[df$Region==input$explorer_masterlist_region_filter,"Division"])),
#               selected = "")
# })


# # --- Initialize map only once ---
# 
# 
# output$deped <- renderImage({
#   list(src="deped.png", width= "100%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$A1 <- renderImage({
#   list(src="map.png", width= "100%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$A2 <- renderImage({
#   list(src="person.png", width= "100%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$A3 <- renderImage({
#   list(src="inform.png", width= "100%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$B1 <- renderImage({
#   list(src="filter.png", width= "80%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$B2 <- renderImage({
#   list(src="database.png", width= "80%", 
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$B3 <- renderImage({
#   list(src="sliders.png", width= "110%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$B4 <- renderImage({
#   list(src="click.png", width= "70%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$B5 <- renderImage({
#   list(src="dot.png", width= "70%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# output$B6 <- renderImage({
#   list(src="six.png", width= "70%",
#        filetype = "image/png"
#   )}, deleteFile = FALSE)
# 
# 
# output$ESEx <- renderValueBox({
#   valueBox(strong("50,579"), subtitle = strong("Excess"), icon = icon("users"), color = "blue")
# })
# 
# output$ESSh <- renderValueBox({
#   valueBox(strong("24,634"), subtitle = strong("Shortage"), icon = icon("users"), color = "red")
# })
# 
# output$JHSEx <- renderValueBox({
#   valueBox(strong("108,342"), subtitle = strong("Excess"), icon = icon("users"), color = "blue")
# })
# 
# output$JHSSh <- renderValueBox({
#   valueBox(strong("10,108"), subtitle = strong("Shortage"), icon = icon("users"), color = "red")
# })
# 
# output$SHSEx <- renderValueBox({
#   valueBox(strong("4,383"), subtitle = strong("Excess"), icon = icon("users"), color = "blue")
# })
# 
# output$SHSSh <- renderValueBox({
#   valueBox(strong("24,581"), subtitle = strong("Shortage"), icon = icon("users"), color = "red")
# })
# 
# output$AO2 <- renderValueBox({
#   valueBox(strong("21,262"), subtitle = strong("AOII Items Created"), icon = icon("users"), color = "blue")
# })
# 
# output$clustered <- renderValueBox({
#   valueBox("9,627", subtitle = "Clustered Schools", icon = icon("school"), color = "green")
# })
# 
# output$cos <- renderValueBox({
#   valueBox("7,062", subtitle = "Outlier Schools", icon = icon("school"), color = "purple")
# })
# 
# output$otherdataselection <- renderUI({
#   otherdata2 <- input$OtherData
#   data_column <- uni[[otherdata2]]
#   selectInput("otherdataselect",strong("Select a Category:"), c(unique(data_column[!is.na(data_column) & data_column != "#N/A" & data_column != "For Verification"])))
# })

# output$SDOSelectionGMIS <- renderUI({
#   dfGMISRegDiv <- read.csv("GMIS-Apr2025-RegDiv.csv")
#   # Get the list of divisions based on the selected region
#   divisions <- dfGMISRegDiv[dfGMISRegDiv$Region %in% input$RegionGMIS, "Division"]
#   
#   # Render the pickerInput
#   pickerInput(
#     inputId = "SDOGMIS",
#     label = "Select a Division:",
#     choices = divisions,
#     selected = divisions,
#     multiple = TRUE,
#     options = pickerOptions(
#       actionsBox = TRUE, # Changed to TRUE
#       liveSearch = TRUE,
#       header = "Select one or more Divisions", # Changed header text
#       title = "No Divisions Selected", # Changed title text
#       selectedTextFormat = "count > 3",
#       dropupAuto = FALSE, # This tells it NOT to automatically switch direction
#       dropup = FALSE # Added this option
#     ),
#     choicesOpt = list()
#   )
# })
# 
# output$PosSelectionGMIS <- renderUI({
#   dfGMISPosCat <- read.csv("GMIS-Apr2025-PosCat.csv")
#   # Filter the data frame to get positions based on the selected position category
#   positions <- sort(unique(dfGMISPosCat$Position))
#   
#   # Render the pickerInput
#   pickerInput(
#     inputId = "PosSelGMIS",
#     label = "Select a Position:",
#     choices = positions,
#     selected = c("Teacher I","Teacher II","Teacher III"),
#     multiple = TRUE,
#     options = pickerOptions(
#       actionsBox = TRUE, # Changed to TRUE
#       liveSearch = TRUE,
#       header = "Select Positions", # Changed header text
#       title = "No Positions Selected", # Changed title text
#       selectedTextFormat = "count > 3",
#       dropupAuto = FALSE, # This tells it NOT to automatically switch direction
#       dropup = FALSE # Added this option
#     ),
#     choicesOpt = list()
#   )
# })
# 
# ### GMIS Count
# 
# observe({
#   PosCatGMISRCT <- input$PosCatGMIS
#   req(PosCatGMISRCT)
#   PosSelGMISRCT <- input$PosSelGMIS
#   req(PosSelGMISRCT)
#   
#   output$itemcount <- renderPlot({
#     dfGMIS <- read.csv("GMIS-FillingUpPerPosition-2025.csv")
#     mainreact1g <- dfGMIS %>% filter(Position == PosSelGMISRCT) %>% group_by(Region) %>% summarise(Filled = sum(Total.Filled, na.rm = TRUE), Unfilled = sum(Total.Unfilled, na.rm = TRUE)) |>  pivot_longer(cols = c(Filled,Unfilled), names_to = "Category", values_to = "Count")
#     ggplot(mainreact1g, aes(x=reorder(Region,-Count), y=Count, fill = factor(Category, levels = c("Unfilled","Filled")))) +
#       geom_bar(stat = "identity",position = "stack", color = "black") +
#       geom_text(data = subset(mainreact1g, Count != 0), aes(label = Count),vjust =-1,position = position_stack(vjust = 0.5), check_overlap = TRUE)+
#       scale_fill_manual(values = c("Filled" = "green","Unfilled" = "grey")) +
#       guides(fill = guide_legend(nrow = 1)) + 
#       labs(x ="", y="",fill="Inventory")+
#       theme(axis.text.x = element_text(size = 14, angle = 45, hjust = 1),
#             legend.position = "top")})
#   
#   output$itemcount2 <- renderPlot({
#     dfGMIS <- read.csv("GMIS-FillingUpPerPosition-2025.csv")
#     mainreact1g <- dfGMIS %>% filter(Position == PosSelGMISRCT) %>% filter(Region == input$RegionCountItem) %>% group_by(Division) %>% summarise(Filled = sum(Total.Filled, na.rm = TRUE), Unfilled = sum(Total.Unfilled, na.rm = TRUE))  %>%  pivot_longer(cols = c(Filled,Unfilled), names_to = "Category", values_to = "Count")
#     ggplot(mainreact1g, aes(x=reorder(Division,-Count), y=Count, fill = factor(Category, levels = c("Unfilled","Filled")))) +
#       geom_bar(stat = "identity",position = "stack", color = "black") +
#       geom_text(data = subset(mainreact1g, Count != 0), aes(label = Count),vjust =-1, position = position_stack(vjust = 0.5), check_overlap = TRUE)+
#       scale_fill_manual(values = c("Filled" = "green","Unfilled" = "grey")) +
#       guides(fill = guide_legend(nrow = 1)) + 
#       labs(x ="", y="",fill="Inventory")+
#       theme(axis.text.x = element_text(size = 14, angle = 45, hjust = 1),
#             legend.position = "top")})
# })

# 
# # --- Reactive Filter for GMIS Data (handles CSV + filtering) ---
# filtered_GMIS <- reactive({
#   
#   # --- Handle deselect-all / empty pickers ---
#   if (is.null(input$RegionGMIS) || length(input$RegionGMIS) == 0 ||
#       is.null(input$SDOGMIS)   || length(input$SDOGMIS) == 0 ||
#       is.null(input$PosSelGMIS) || length(input$PosSelGMIS) == 0) {
#     return(list(
#       stacked = tibble::tibble(),
#       table = tibble::tibble()
#     ))
#   }
#   
#   RegGMISRCT <- input$RegionGMIS
#   SDOGMISRCT <- input$SDOGMIS
#   PosSelGMISRCT <- input$PosSelGMIS
#   
#   # --- Summary for stacked bar chart ---
#   stacked_data <- dfGMIS %>%
#     filter(GMIS.Region %in% RegGMISRCT) %>%
#     filter(GMIS.Division %in% SDOGMISRCT) %>%
#     filter(Position %in% PosSelGMISRCT) %>%
#     group_by(Position) %>%
#     summarise(
#       Filled = sum(Total.Filled, na.rm = TRUE),
#       Unfilled = sum(Total.Unfilled, na.rm = TRUE),
#       .groups = "drop"
#     ) %>%
#     # --- Ensure all selected positions appear, even if missing or zero ---
#     right_join(
#       tibble(Position = PosSelGMISRCT),
#       by = "Position"
#     ) %>%
#     mutate(
#       Filled = ifelse(is.na(Filled), 0, Filled),
#       Unfilled = ifelse(is.na(Unfilled), 0, Unfilled)
#     ) %>%
#     tidyr::pivot_longer(
#       cols = c("Filled", "Unfilled"),
#       names_to = "Status",
#       values_to = "Count"
#     )
#   
#   # --- Summary for DataTable ---
#   table_data <- dfGMIS %>%
#     filter(GMIS.Region %in% RegGMISRCT) %>%
#     filter(GMIS.Division %in% SDOGMISRCT) %>%
#     filter(Position %in% PosSelGMISRCT) %>%
#     group_by(GMIS.Region, GMIS.Division, Position) %>%
#     summarise(
#       Filled = sum(Total.Filled, na.rm = TRUE),
#       Unfilled = sum(Total.Unfilled, na.rm = TRUE),
#       Authorized = sum(Total.Authorized, na.rm = TRUE),
#       .groups = "drop"
#     ) %>%
#     # --- Keep even zero positions ---
#     right_join(
#       tibble(Position = PosSelGMISRCT),
#       by = "Position"
#     ) %>%
#     mutate(
#       Region = ifelse(is.na(GMIS.Region), "", GMIS.Region),
#       Division = ifelse(is.na(GMIS.Division), "", GMIS.Division),
#       Filled = ifelse(is.na(Filled), 0, Filled),
#       Unfilled = ifelse(is.na(Unfilled), 0, Unfilled),
#       Authorized = ifelse(is.na(Authorized), 0, Authorized),
#       `Filling Up Rate (%)` = ifelse(Authorized > 0, round(Filled / Authorized * 100, 2), 0)
#     ) %>%
#     select(Region, Division, Position, Filled, Unfilled, Authorized, `Filling Up Rate (%)`)
#   
#   # --- Return both summaries ---
#   list(
#     stacked = stacked_data,
#     table = table_data
#   )
# })
# 
# 
# # --- Render Plotly Chart ---
# output$GMISTable <- renderPlotly({
#   plot_data_stacked <- filtered_GMIS()$stacked
#   
#   # --- Handle no selection ---
#   if (is.null(plot_data_stacked) || nrow(plot_data_stacked) == 0) {
#     empty_plot <- ggplot() +
#       theme_void() +
#       annotate(
#         "text", x = 0.5, y = 0.5,
#         label = "No data selected",
#         size = 6, color = "gray50", hjust = 0.5, vjust = 0.5
#       )
#     return(ggplotly(empty_plot) %>% layout(hoverlabel = list(bgcolor = "white")))
#   }
#   
#   # --- Compute totals for labels ---
#   plot_data_totals <- plot_data_stacked %>%
#     group_by(Position) %>%
#     summarise(TotalCount = sum(Count), .groups = "drop")
#   
#   # --- Define colors ---
#   category_colors <- c("Filled" = "blue", "Unfilled" = "red")
#   
#   # --- Build the plot ---
#   p <- ggplot(plot_data_stacked, aes(
#     x = factor(Position),
#     y = Count,
#     fill = factor(Status, levels = c("Unfilled", "Filled")),
#     text = paste(
#       "Position: ", Position,
#       "<br>Status: ", Status,
#       "<br>Count: ", Count
#     )
#   )) +
#     geom_bar(stat = "identity", position = "stack") +
#     geom_text(
#       data = plot_data_totals,
#       aes(x = Position, y = TotalCount * 1.05, label = scales::comma(TotalCount)),
#       inherit.aes = FALSE,
#       size = 3.5,
#       color = "black"
#     ) +
#     labs(x = "Position", y = "Count") +
#     scale_y_continuous(labels = scales::comma) +
#     scale_fill_manual(name = "Legend", values = category_colors) +
#     theme_minimal() +
#     theme(legend.position = "bottom")
#   
#   ggplotly(p, tooltip = "text", source = "stackedBarPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"))
# })
# 
# 
# # --- Render DataTable ---
# output$GMISTable1 <- renderDataTable(server = TRUE, {
#   table_data <- filtered_GMIS()$table
#   
#   # --- When deselect-all or no data, keep headers and show "No data available in table" ---
#   if (is.null(table_data) || nrow(table_data) == 0) {
#     empty_df <- dfGMIS %>%
#       transmute(
#         Region = GMIS.Region,
#         Division = GMIS.Division,
#         Position,
#         Filled = Total.Filled,
#         Unfilled = Total.Unfilled,
#         Authorized = Total.Authorized,
#         `Filling Up Rate (%)` = round(Total.Filled / Total.Authorized * 100, 2)
#       ) %>%
#       dplyr::slice(0)
#     
#     return(DT::datatable(
#       empty_df,
#       filter = "top",
#       extensions = "FixedHeader",
#       options = list(
#         fixedHeader = list(header = TRUE, footer = FALSE),
#         scrollY = "300px",
#         scrollCollapse = TRUE,
#         columnDefs = list(list(className = 'dt-center', targets = '_all')),
#         rownames = FALSE,
#         language = list(emptyTable = "No data available in table")
#       )
#     ))
#   }
#   
#   # --- Render normal data table ---
#   DT::datatable(
#     table_data,
#     filter = "top",
#     extensions = "FixedHeader",
#     options = list(
#       fixedHeader = list(header = TRUE, footer = FALSE),
#       scrollY = "300px",
#       scrollCollapse = TRUE,
#       columnDefs = list(list(className = 'dt-center', targets = '_all')),
#       rownames = FALSE
#     )
#   )
# })

# output$school_count_division_graph <- renderPlotly({
#   
#   # --- If region or division picker is empty, clear the plot ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)  # Make plot area blank when "Deselect All" is clicked
#   }
#   
#   current_filtered_data <- filtered_school_data_division() # Use the reactive filtered data
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, 
#                  label = "No data for selected regions/divisions") +
#         theme_void()
#     ))
#   }
#   
#   coc_levels <- c("Purely ES", "JHS with SHS", "ES and JHS (K to 10)",
#                   "Purely JHS", "All Offering (K to 12)", "Purely SHS")
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Division, Modified.COC) %>%
#     summarise(Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Modified.COC) %>%
#     summarise(TotalCount = sum(Count))
#   
#   division_total_counts <- plot_data %>%
#     group_by(Division) %>%
#     summarise(Total_Division_Count = sum(Count), .groups = 'drop')
#   
#   plot_data <- plot_data %>%
#     left_join(division_total_counts, by = "Division") %>%
#     mutate(Division_reordered = reorder(Division, Total_Division_Count))
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Modified.COC, levels = coc_levels),
#                   y = Count,
#                   fill = Division_reordered,
#                   key = paste(Division, Modified.COC),
#                   text = paste("Division: ", Division,
#                                "<br>School Type: ", Modified.COC,
#                                "<br>Count: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Modified.COC, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(  title = "Division Distribution of Schools by Curricular Offering", x = "Region",
#            y = "Number of Schools",
#            fill = "School Type") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "schoolcountplot_division") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# 
# output$school_count_district_graph <- renderPlotly({
#   
#   # --- If region or division picker is empty, clear the plot ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, 
#                  label = "No data for selected regions/Legislative Districts") +
#         theme_void()
#     ))
#   }
#   
#   coc_levels <- c("Purely ES", "JHS with SHS", "ES and JHS (K to 10)",
#                   "Purely JHS", "All Offering (K to 12)", "Purely SHS")
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Division, Legislative.District, Modified.COC) %>%
#     summarise(Count = n(), .groups = 'drop') %>%
#     mutate(
#       Division = as.character(Division),
#       Legislative.District = as.character(Legislative.District),
#       Modified.COC = as.character(Modified.COC)
#     )
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Modified.COC) %>%
#     summarise(TotalCount = sum(Count))
#   
#   plot_data <- plot_data %>%
#     mutate(Division_LegDist = paste0(Division, "- ", Legislative.District))
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Modified.COC, levels = coc_levels),
#                   y = Count,
#                   fill = Division_LegDist,
#                   text = paste("Legislative District:", Division_LegDist,
#                                "<br>Modified.COC:", Modified.COC,
#                                "<br>Count:", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Modified.COC, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs( title = "District Distribution of Schools by Curricular Offering", x = "Modified COC",
#           y = "Count",
#           fill = "Legislative District") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# 
# 
# # In your server.R file, ensure 'rv' is initialized once, e.g., at the top of the server function:
# # rv <- reactiveValues(latest_sosss_click_key = NULL) # Only if not already initialized
# 
# # Observer for SOSSS_Region_Typology clicks
# # This should be placed in your server.R file, outside of any output$... block,
# # but within the main server function.
# observeEvent(event_data("plotly_click", source = "sosssRegionPlot"), {
#   click_data <- event_data("plotly_click", source = "sosssRegionPlot")
#   if (!is.null(click_data)) {
#     # Store the combined key (e.g., "Region I Very Small")
#     rv$latest_sosss_click_key <- click_data$key
#   } else {
#     # If a click somehow clears, reset the key
#     rv$latest_sosss_click_key <- NULL
#   }
# })
# 
# output$SOSSS_Division_Typology <- renderPlotly({
#   
#   # --- Hide plot if Region or Division picker is empty ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Handle no data case ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected divisions") +
#                       theme_void()))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Division, School.Size.Typology) %>%
#     summarise(Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(School.Size.Typology) %>%
#     summarise(TotalCount = sum(Count))
#   
#   region_totals <- plot_data %>%
#     group_by(Division) %>%
#     summarise(TotalCount = sum(Count), .groups = 'drop')
#   
#   plot_data <- plot_data %>%
#     left_join(region_totals, by = "Division") %>%
#     mutate(Division_reordered = reorder(Division, -TotalCount))
#   
#   sosss_levels <- c("Very Small", "Small", "Medium", "Large", 
#                     "Very Large", "Extremely Large", "Mega")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(School.Size.Typology, levels = sosss_levels),
#                   y = Count,
#                   fill = Division_reordered,
#                   key = paste(Division, School.Size.Typology),
#                   text = paste("Division: ", Division,
#                                "<br>School Size: ", School.Size.Typology,
#                                "<br>Count: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = School.Size.Typology, y = TotalCount * 1.05, 
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE, size = 3.5, color = "black") +
#     labs( title = "Division-Level Distribution of Schools by Size Typology", x = "School Size Typology",
#           y = "Number of Schools",
#           fill = "Division") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "sosssDivisionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# output$SOSSS_District_Typology <- renderPlotly({
#   
#   # --- Hide plot if Region or Division picker is empty ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Handle no data case ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected legislative districts") +
#                       theme_void()))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Division, Legislative.District, School.Size.Typology) %>%
#     summarise(Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(School.Size.Typology) %>%
#     summarise(TotalCount = sum(Count))
#   
#   region_totals <- plot_data %>%
#     group_by(Legislative.District) %>%
#     summarise(TotalCount = sum(Count), .groups = 'drop')
#   
#   plot_data <- plot_data %>%
#     left_join(region_totals, by = "Legislative.District") %>%
#     mutate(Legislative.District_reordered = reorder(Legislative.District, -TotalCount)) %>%
#     mutate(Division_LegDist = paste0(Division, "- ", Legislative.District))
#   
#   sosss_levels <- c("Very Small", "Small", "Medium", "Large", 
#                     "Very Large", "Extremely Large", "Mega")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(School.Size.Typology, levels = sosss_levels),
#                   y = Count,
#                   fill = Division_LegDist,
#                   text = paste("Legislative District: ", Division_LegDist,
#                                "<br>School Size: ", School.Size.Typology,
#                                "<br>Count: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = School.Size.Typology, y = TotalCount * 1.05, 
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE, size = 3.5, color = "black") +
#     labs(title = "District Distribution of Schools by Size Typology", x = "School Size Typology",
#          y = "Number of Schools",
#          fill = "Legislative District") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "sosssDistrictPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# 
# # Reactive expression for filtering the SOSSS table data based on dashboard filters and plot clicks
# filtered_sosss_table_data <- reactive({
#   # Ensure uni data is available.
#   req(uni)
#   
#   # Start with the full dataset for filtering based on dashboard inputs
#   data <- uni
#   
#   if (!is.null(input$dashboard_region_filter) && length(input$dashboard_region_filter) > 0) {
#     data <- data %>%
#       filter(Region %in% input$dashboard_region_filter)
#   }
#   
#   if (!is.null(input$dashboard_division_filter) && length(input$dashboard_division_filter) > 0) {
#     data <- data %>%
#       filter(Division %in% input$dashboard_division_filter)
#   }
#   
#   # Now, filter based on the latest plot click for SOSSS graph
#   clicked_region <- NULL
#   clicked_sosss_typology <- NULL
#   
#   if (!is.null(rv$latest_sosss_click_key)) {
#     # Define the levels for School.Size.Typology for consistent mapping and parsing
#     sosss_levels_for_parsing <- c("Very Small", "Small", "Medium", "Large", "Very Large", "Extremely Large", "Mega")
#     # Sort by length descending to match multi-word typologies first
#     sosss_levels_ordered_by_length <- sosss_levels_for_parsing[order(nchar(sosss_levels_for_parsing), decreasing = TRUE)]
#     
#     found_typology <- FALSE
#     for (typology_val in sosss_levels_ordered_by_length) {
#       # Check if the typology is at the end of the key string
#       if (grepl(paste0(typology_val, "$"), rv$latest_sosss_click_key)) {
#         clicked_sosss_typology <- typology_val
#         # The region is everything before this typology
#         clicked_region <- sub(paste0(" ", typology_val, "$"), "", rv$latest_sosss_click_key)
#         found_typology <- TRUE
#         break
#       }
#     }
#     
#     if (!found_typology) {
#       # Fallback if parsing fails, return data filtered only by dashboard inputs
#       clicked_region <- NULL
#       clicked_sosss_typology <- NULL
#       warning("Could not parse clicked SOSSS key for Region and Typology: ", rv$latest_sosss_click_key)
#     }
#   }
#   
#   if (!is.null(clicked_region) && !is.null(clicked_sosss_typology)) {
#     # Apply filter based on click data if both are valid
#     data <- data %>%
#       filter(Region == clicked_region,
#              School.Size.Typology == clicked_sosss_typology)
#   }
#   
#   return(data)
# })
# 
# 
# # Your Teacher_Shortage_Regional_Graph renderPlotly
# output$Teacher_Shortage_Regional_Graph <- renderPlotly({
#   
#   # --- Hide plot when Region filter is empty ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_teacher_shortage_data_region()
#   
#   # --- Empty data handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, 
#                  label = "No data for selected regions/divisions") +
#         theme_void()
#     ))
#   }
#   
#   # --- Prepare data ---
#   plot_data <- current_filtered_data %>%
#     pivot_longer(cols = c(ES_Shortage, JHS_Shortage, SHS_Shortage),
#                  names_to = "Inventory", values_to = "Count") %>%
#     mutate(Count = as.numeric(Count)) %>%
#     na.omit() %>%
#     group_by(Region, Inventory) %>%
#     summarise(Total_Count = sum(Count, na.rm = TRUE), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Inventory) %>%
#     summarise(TotalCount = sum(Total_Count))
#   
#   inventory_levels <- c("ES_Shortage", "JHS_Shortage", "SHS_Shortage")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Inventory, levels = inventory_levels),
#                   y = Total_Count,
#                   fill = Region,
#                   text = paste("Region: ", Region,
#                                "<br>School Type: ", gsub("_Shortage", "", Inventory),
#                                "<br>Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Inventory, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(x = "School Type",
#          y = "Total Shortage Count",
#          title = "Regional Teacher Shortage by School Type",
#          fill = "Region") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "teacherShortageRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# output$Teacher_Shortage_Division_Graph <- renderPlotly({
#   
#   # --- Hide plot when region or division filter is empty ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_teacher_shortage_data_division()
#   
#   # --- Empty data handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5,
#                  label = "No data for selected divisions") +
#         theme_void()
#     ))
#   }
#   
#   # --- Prepare data ---
#   plot_data <- current_filtered_data %>%
#     pivot_longer(cols = c(ES_Shortage, JHS_Shortage, SHS_Shortage),
#                  names_to = "Inventory", values_to = "Count") %>%
#     mutate(Count = as.numeric(Count)) %>%
#     na.omit() %>%
#     group_by(Division, Inventory) %>%
#     summarise(Total_Count = sum(Count, na.rm = TRUE), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Inventory) %>%
#     summarise(TotalCount = sum(Total_Count))
#   
#   inventory_levels <- c("ES_Shortage", "JHS_Shortage", "SHS_Shortage")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Inventory, levels = inventory_levels),
#                   y = Total_Count,
#                   fill = Division,
#                   text = paste("Division: ", Division,
#                                "<br>School Type: ", gsub("_Shortage", "", Inventory),
#                                "<br>Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Inventory, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(x = "School Type",
#          y = "Total Shortage Count",
#          title = "Division Teacher Shortage by School Type",
#          fill = "Division") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "teacherShortageDivisionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# # In your server.R file, ensure 'rv' is initialized with the new reactive value:
# # rv <- reactiveValues(
# #   latest_click_key = NULL,           # For school_count graph
# #   latest_sosss_click_key = NULL,     # For SOSSS graph
# #   latest_classroom_click_key = NULL, # For Classroom Shortage graph
# #   latest_teacher_shortage_click_key = NULL, # For Teacher Shortage graph
# #   latest_principal_click_key = NULL # New: For School Principal graph
# # )
# # Make sure to include all rv initializations from previous steps if you are creating it from scratch.
# 
# # Observer for School_Principal_Regional_Graph clicks
# # This should be placed in your server.R file, outside of any output$... block,
# # but within the main server function.
# observeEvent(event_data("plotly_click", source = "schoolPrincipalRegionPlot"), {
#   click_data <- event_data("plotly_click", source = "schoolPrincipalRegionPlot")
#   if (!is.null(click_data)) {
#     # Store the combined key (e.g., "Region I School Principal")
#     rv$latest_principal_click_key <- click_data$key
#   } else {
#     # If a click somehow clears, reset the key
#     rv$latest_principal_click_key <- NULL
#   }
# })
# 
# output$School_Principal_Division_Graph <- renderPlotly({
#   
#   # --- Hide plot when no region/division is selected ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Empty Data Handling ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected regions/divisions") +
#                       theme_void()))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     select(Division, Designation) %>%
#     group_by(Division, Designation) %>%
#     summarize(Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Designation) %>%
#     summarise(TotalCount = sum(Count))
#   
#   designation_levels <- c("School Principal", "Teacher-in-Charge", "Officer-in-Charge")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Designation, levels = designation_levels),
#                   y = Count,
#                   fill = Division,
#                   key = paste(Division, Designation),
#                   text = paste("Division: ", Division,
#                                "<br>Designation: ", Designation,
#                                "<br>Count: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Designation, y = TotalCount * 1.05, 
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(x = "Designation", y = "Count of Individuals",
#          title = "Division School Principal Shortage by Designation") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "schoolPrincipalDivisionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# output$School_Principal_District_Graph <- renderPlotly({
#   
#   # --- Hide plot when no region/division is selected ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Empty Data Handling ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected Legislative Districts") +
#                       theme_void()))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     select(Division, Legislative.District, Designation) %>%
#     group_by(Division, Legislative.District, Designation) %>%
#     summarize(Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Designation) %>%
#     summarise(TotalCount = sum(Count))
#   
#   plot_data <- plot_data %>%
#     mutate(Division_LegDist = paste0(Division, " - ", Legislative.District))
#   
#   designation_levels <- c("School Principal", "Teacher-in-Charge", "Officer-in-Charge")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Designation, levels = designation_levels),
#                   y = Count,
#                   fill = Division_LegDist,
#                   key = paste(Division_LegDist, Designation),
#                   text = paste("Legislative District: ", Legislative.District,
#                                "<br>Designation: ", Designation,
#                                "<br>Count: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Designation, y = TotalCount * 1.05, 
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(x = "Designation", y = "Count of Individuals",
#          title = "Legislative District School Principal Shortage by Designation") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "schoolPrincipalDistrictPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# 
# # Reactive expression for filtering the School Principal table data
# # based on dashboard filters and plot clicks
# # This assumes 'filtered_school_principal_data()' provides the base data.
# filtered_principal_table_data <- reactive({
#   # Ensure base data is available.
#   req(filtered_school_data_division())
#   
#   # Start with the data filtered by dashboard inputs
#   data <- filtered_school_data_division()
#   
#   # Now, filter based on the latest plot click for School Principal graph
#   clicked_region <- NULL
#   clicked_designation <- NULL
#   
#   if (!is.null(rv$latest_principal_click_key)) {
#     clicked_key <- as.character(rv$latest_principal_click_key)
#     
#     # Define the possible designation levels for parsing (order matters for accurate matching)
#     designation_levels_for_parsing <- c("School Principal", "Teacher-in-Charge", "Officer-in-Charge")
#     # Sort by length descending to match longer names first
#     designation_levels_ordered_by_length <- designation_levels_for_parsing[order(nchar(designation_levels_for_parsing), decreasing = TRUE)]
#     
#     found_designation <- FALSE
#     for (desig_val in designation_levels_ordered_by_length) {
#       # Check if the designation type is at the end of the key string
#       if (grepl(paste0(" ", desig_val, "$"), clicked_key)) { # Prepend space to ensure full word match
#         clicked_designation <- desig_val
#         # The region is everything before this designation type
#         clicked_region <- sub(paste0(" ", desig_val, "$"), "", clicked_key)
#         found_designation <- TRUE
#         break
#       }
#     }
#     
#     if (!found_designation) {
#       # Fallback if parsing fails, return data filtered only by dashboard inputs
#       clicked_region <- NULL
#       clicked_designation <- NULL
#       warning("Could not parse clicked Principal key for Region and Designation: ", clicked_key)
#     }
#   }
#   
#   if (!is.null(clicked_region) && !is.null(clicked_designation)) {
#     # Apply filter based on click data if both are valid
#     data <- data %>%
#       filter(Region == clicked_region,
#              Designation == clicked_designation) %>%
#       select(SchoolID, Region, Division, Designation) # Adjust columns as needed for your table
#   } else {
#     # If no specific bar is clicked, or parsing failed,
#     # show all schools from the dashboard filters with any of these designations
#     data <- data %>%
#       filter(Designation %in% designation_levels) %>% # Ensure only valid designations are included
#       select(SchoolID, Region, Division, Designation) # Adjust columns as needed for your table
#   }
#   
#   return(data)
# })
# 
# # Your DT::renderDT for School_Principal_All_List
# output$School_Principal_All_List <- DT::renderDT({
#   table_to_display <- filtered_school_data_division() %>% select(Region, Division, Legislative.District, SchoolID, School.Name, Designation) %>% rename("School Head Designation" = Designation)
#   
#   if (nrow(table_to_display) == 0) {
#     return(DT::datatable(data.frame(Message = "No principal data available for this selection."), options = list(dom = 't')))
#   }
#   
#   DT::datatable(table_to_display %>% slice(1:100),
#                 options = list(pageLength = 10, scrollX = TRUE, filter = "top"),
#                 rownames = FALSE)
# })
# 
# # In your server.R file, ensure 'rv' is initialized with the new reactive value:
# # rv <- reactiveValues(
# #   latest_click_key = NULL,           # For school_count graph
# #   latest_sosss_click_key = NULL,     # For SOSSS graph
# #   latest_classroom_click_key = NULL, # For Classroom Shortage graph
# #   latest_teacher_shortage_click_key = NULL, # For Teacher Shortage graph
# #   latest_principal_click_key = NULL, # For School Principal graph
# #   latest_aoii_click_key = NULL       # New: For AOII Deployment graph
# # )
# # Make sure to include all rv initializations from previous steps if you are creating it from scratch.
# 
# # Observer for AOII_Regional_Graph clicks
# # This should be placed in your server.R file, outside of any output$... block,
# # but within the main server function.
# observeEvent(event_data("plotly_click", source = "aoiiRegionPlot"), {
#   click_data <- event_data("plotly_click", source = "aoiiRegionPlot")
#   if (!is.null(click_data)) {
#     # Store the combined key (e.g., "Region I None Deployed")
#     rv$latest_aoii_click_key <- click_data$key
#   } else {
#     # If a click somehow clears, reset the key
#     rv$latest_aoii_click_key <- NULL
#   }
# })
# 
# output$AOII_Division_Graph <- renderPlotly({
#   
#   # --- Hide plot when no region/division is selected ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Empty Data Handling ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected divisions") +
#                       theme_void()))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Division, Clustering.Status) %>%
#     summarise(Total_Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Clustering.Status) %>%
#     summarise(TotalCount = sum(Total_Count))
#   
#   clustering_levels <- c("None Deployed", "Clustered", "Dedicated")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Clustering.Status, levels = clustering_levels),
#                   y = Total_Count,
#                   fill = Division,
#                   text = paste("Division: ", Division,
#                                "<br>Clustering Status: ", Clustering.Status,
#                                "<br>Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Clustering.Status, y = TotalCount * 1.05, 
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(x = "Clustering Status",
#          y = "Total Count of Schools",
#          title = "Division AO II Deployment by Clustering Status") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "aoiiDivisionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# output$AOII_District_Graph <- renderPlotly({
#   
#   # --- Hide plot when no region/division is selected ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Empty Data Handling ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected legislative districts") +
#                       theme_void()))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Division, Legislative.District, Clustering.Status) %>%
#     summarise(Total_Count = n(), .groups = 'drop') %>%
#     mutate(Division_LegDist = paste0(Division, " - ", Legislative.District))
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Clustering.Status) %>%
#     summarise(TotalCount = sum(Total_Count))
#   
#   clustering_levels <- c("None Deployed", "Clustered", "Dedicated")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(Clustering.Status, levels = clustering_levels),
#                   y = Total_Count,
#                   fill = Division_LegDist,
#                   text = paste("Legislative District: ", Legislative.District,
#                                "<br>Clustering Status: ", Clustering.Status,
#                                "<br>Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Clustering.Status, y = TotalCount * 1.05, 
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(x = "Clustering Status",
#          y = "Total Count of Schools",
#          title = "Legislative District AO II Deployment by Clustering Status") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "aoiiDistrictPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# 
# # Reactive expression for filtering the AOII table data
# # based on dashboard filters and plot clicks
# # This assumes 'filtered_school_data_region()' provides the base data.
# filtered_aoii_table_data <- reactive({
#   # Ensure base data is available.
#   req(filtered_school_data_region())
#   
#   # Start with the data filtered by dashboard inputs
#   data <- filtered_school_data_region()
#   
#   # Now, filter based on the latest plot click for AOII graph
#   clicked_region <- NULL
#   clicked_clustering_status <- NULL
#   
#   if (!is.null(rv$latest_aoii_click_key)) {
#     clicked_key <- as.character(rv$latest_aoii_click_key)
#     
#     # Define the possible clustering status levels for parsing (order matters for accurate matching)
#     clustering_levels_for_parsing <- c("None Deployed", "Clustered", "Dedicated")
#     # Sort by length descending to match longer names first
#     clustering_levels_ordered_by_length <- clustering_levels_for_parsing[order(nchar(clustering_levels_for_parsing), decreasing = TRUE)]
#     
#     found_status <- FALSE
#     for (status_val in clustering_levels_ordered_by_length) {
#       # Check if the status type is at the end of the key string
#       if (grepl(paste0(" ", status_val, "$"), clicked_key)) { # Prepend space to ensure full word match
#         clicked_clustering_status <- status_val
#         # The region is everything before this status type
#         clicked_region <- sub(paste0(" ", status_val, "$"), "", clicked_key)
#         found_status <- TRUE
#         break
#       }
#     }
#     
#     if (!found_status) {
#       # Fallback if parsing fails, return data filtered only by dashboard inputs
#       clicked_region <- NULL
#       clicked_clustering_status <- NULL
#       warning("Could not parse clicked AOII key for Region and Clustering Status: ", clicked_key)
#     }
#   }
#   
#   if (!is.null(clicked_region) && !is.null(clicked_clustering_status)) {
#     # Apply filter based on click data if both are valid
#     data <- data %>%
#       filter(Region == clicked_region,
#              Clustering.Status == clicked_clustering_status) %>%
#       # Select relevant columns for display in the table
#       select(SchoolID, Region, Division, Clustering.Status) # Adjust columns as needed
#   } else {
#     # If no specific bar segment is clicked, or parsing failed,
#     # show all schools from the dashboard filters that have any of these clustering statuses
#     data <- data %>%
#       filter(Clustering.Status %in% clustering_levels) %>% # Ensure only valid statuses are included
#       select(SchoolID, Region, Division, Clustering.Status) # Adjust columns as needed
#   }
#   
#   return(data)
# })
# 
# # Your DT::renderDT for AOII_Data_Table
# output$AOII_Data_Table <- DT::renderDT({
#   table_to_display <- filtered_school_data_division() %>% select(Region, Division, Legislative.District, SchoolID, School.Name, Clustering.Status, Outlier.Status,PDOI_Deployment)
#   
#   if (nrow(table_to_display) == 0) {
#     return(DT::datatable(data.frame(Message = "No AO II deployment data available for this selection."), options = list(dom = 't')))
#   }
#   
#   DT::datatable(table_to_display %>% slice(1:100),
#                 options = list(pageLength = 10, scrollX = TRUE, filter = "top"),
#                 rownames = FALSE)
# })
# 
# # In your server.R file, ensure 'rv' is initialized with the new reactive value:
# # rv <- reactiveValues(
# #   latest_click_key = NULL,           # For school_count graph
# #   latest_sosss_click_key = NULL,     # For SOSSS graph
# #   latest_classroom_click_key = NULL, # For Classroom Shortage graph
# #   latest_teacher_shortage_click_key = NULL, # For Teacher Shortage graph
# #   latest_principal_click_key = NULL, # For School Principal graph
# #   latest_aoii_click_key = NULL,      # For AOII Deployment graph
# #   latest_pdoi_click_key = NULL       # New: For PDOI Deployment graph
# # )
# # Make sure to include all rv initializations from previous steps if you are creating it from scratch.
# 
# # Observer for PDOI_Regional_Graph clicks
# # This should be placed in your server.R file, outside of any output$... block,
# # but within the main server function.
# observeEvent(event_data("plotly_click", source = "pdoiRegionPlot"), {
#   click_data <- event_data("plotly_click", source = "pdoiRegionPlot")
#   if (!is.null(click_data)) {
#     # Store the combined key (e.g., "Region I With PDO I")
#     rv$latest_pdoi_click_key <- click_data$key
#   } else {
#     # If a click somehow clears, reset the key
#     rv$latest_pdoi_click_key <- NULL
#   }
# })
# 
# 
# output$PDOI_Division_Graph <- renderPlotly({
#   # Hide plot when region or division is unselected
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data for selected divisions") +
#         theme_void()
#     ))
#   }
#   
#   # Prepare data
#   plot_data <- current_filtered_data %>%
#     select(Division, PDOI_Deployment) %>%
#     group_by(Division, PDOI_Deployment) %>%
#     summarize(Total_Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(PDOI_Deployment) %>%
#     summarise(TotalCount = sum(Total_Count))
#   
#   pdoi_levels <- c("Without PDO I", "With PDO I")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(PDOI_Deployment, levels = pdoi_levels),
#                   y = Total_Count,
#                   fill = Division,
#                   text = paste("Division: ", Division,
#                                "<br>PDO I Deployment: ", PDOI_Deployment,
#                                "<br>Total Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black") +
#     geom_text(data = plot_data_totals,
#               aes(x = PDOI_Deployment, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE, size = 3.5, color = "black") +
#     labs(x = "PDO I Deployment", y = "Total Count of Schools",
#          title = "Division PDO I Deployment by Status") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "pdoiDivisionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# output$PDOI_District_Graph <- renderPlotly({
#   # Hide plot when region or division is unselected
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_division()
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data for selected Legislative Districts") +
#         theme_void()
#     ))
#   }
#   
#   # Prepare data
#   plot_data <- current_filtered_data %>%
#     select(Division, Legislative.District, PDOI_Deployment) %>%
#     group_by(Division, Legislative.District, PDOI_Deployment) %>%
#     summarize(Total_Count = n(), .groups = 'drop') %>%
#     mutate(Division_LegDist = paste0(Division, " - ", Legislative.District))
#   
#   plot_data_totals <- plot_data %>%
#     group_by(PDOI_Deployment) %>%
#     summarise(TotalCount = sum(Total_Count))
#   
#   pdoi_levels <- c("Without PDO I", "With PDO I")
#   
#   p <- ggplot(plot_data,
#               aes(x = factor(PDOI_Deployment, levels = pdoi_levels),
#                   y = Total_Count,
#                   fill = Division_LegDist,
#                   text = paste("Legislative District: ", Legislative.District,
#                                "<br>PDO I Deployment: ", PDOI_Deployment,
#                                "<br>Total Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black") +
#     geom_text(data = plot_data_totals,
#               aes(x = PDOI_Deployment, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE, size = 3.5, color = "black") +
#     labs(x = "PDO I Deployment", y = "Total Count of Schools",
#          title = "Legislative District PDO I Deployment by Status") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "pdoiDistrictPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# # Reactive expression for filtering the PDOI table data
# # based on dashboard filters and plot clicks
# # This assumes 'filtered_school_data_region()' provides the base data as per the graph's usage.
# filtered_pdoi_table_data <- reactive({
#   # Ensure base data is available.
#   req(filtered_school_data_region()) # Using filtered_school_data_region() as per the graph's source
#   
#   # Start with the data filtered by dashboard inputs
#   data <- filtered_school_data_region() # Using filtered_school_data_region() as per the graph's source
#   
#   # Now, filter based on the latest plot click for PDOI graph
#   clicked_region <- NULL
#   clicked_pdoi_deployment <- NULL
#   
#   if (!is.null(rv$latest_pdoi_click_key)) {
#     clicked_key <- as.character(rv$latest_pdoi_click_key)
#     
#     # Define the possible PDOI Deployment levels for parsing (order matters if some are substrings of others)
#     pdoi_levels_for_parsing <- c("Without PDO I", "With PDO I")
#     # Sort by length descending to match longer names first
#     pdoi_levels_ordered_by_length <- pdoi_levels_for_parsing[order(nchar(pdoi_levels_for_parsing), decreasing = TRUE)]
#     
#     found_deployment <- FALSE
#     for (deployment_val in pdoi_levels_ordered_by_length) {
#       # Check if the deployment type is at the end of the key string
#       if (grepl(paste0(" ", deployment_val, "$"), clicked_key)) { # Prepend space to ensure full word match
#         clicked_pdoi_deployment <- deployment_val
#         # The region is everything before this deployment type
#         clicked_region <- sub(paste0(" ", deployment_val, "$"), "", clicked_key)
#         found_deployment <- TRUE
#         break
#       }
#     }
#     
#     if (!found_deployment) {
#       # Fallback if parsing fails, return data filtered only by dashboard inputs
#       clicked_region <- NULL
#       clicked_pdoi_deployment <- NULL
#       warning("Could not parse clicked PDOI key for Region and PDOI Deployment: ", clicked_key)
#     }
#   }
#   
#   if (!is.null(clicked_region) && !is.null(clicked_pdoi_deployment)) {
#     # Apply filter based on click data if both are valid
#     data <- data %>%
#       filter(Region == clicked_region,
#              PDOI_Deployment == clicked_pdoi_deployment) %>%
#       # Select relevant columns for display in the table (adjust as needed)
#       select(SchoolID, Region, Division, PDOI_Deployment)
#   } else {
#     # If no specific bar segment is clicked, or parsing failed,
#     # show all schools from the dashboard filters that have any of these PDOI statuses
#     data <- data %>%
#       filter(PDOI_Deployment %in% pdoi_levels) %>% # Ensure only valid statuses are included
#       select(SchoolID, Region, Division, PDOI_Deployment) # Adjust columns as needed
#   }
#   
#   return(data)
# })
# 
# # Your DT::renderDT for PDOI_Data_Table
# output$PDOI_Data_Table <- DT::renderDT({
#   table_to_display <- filtered_school_data_division() %>% select(Region, Division, Legislative.District, SchoolID, School.Name, Clustering.Status, Outlier.Status,PDOI_Deployment)
#   
#   if (nrow(table_to_display) == 0) {
#     return(DT::datatable(data.frame(Message = "No PDO I deployment data available for this selection."), options = list(dom = 't')))
#   }
#   
#   DT::datatable(table_to_display %>% slice(1:100),
#                 options = list(pageLength = 10, scrollX = TRUE, filter = "top"),
#                 rownames = FALSE)
# })
# 
# # In your server.R file, ensure 'rv' is initialized with the new reactive value:
# # rv <- reactiveValues(
# #   latest_click_key = NULL,           # For school_count graph
# #   latest_sosss_click_key = NULL,     # For SOSSS graph
# #   latest_classroom_click_key = NULL, # For Classroom Shortage graph
# #   latest_teacher_shortage_click_key = NULL, # For Teacher Shortage graph
# #   latest_principal_click_key = NULL, # For School Principal graph
# #   latest_aoii_click_key = NULL,      # For AOII Deployment graph
# #   latest_pdoi_click_key = NULL,      # For PDOI Deployment graph
# #   latest_sufficiency_click_key = NULL # New: For Sufficiency graph
# # )
# # Make sure to include all rv initializations from previous steps if you are creating it from scratch.
# 
# # In your server.R file, ensure 'rv' is initialized with the new reactive value:
# # rv <- reactiveValues(
# #   latest_click_key = NULL,           # For school_count graph
# #   latest_sosss_click_key = NULL,     # For SOSSS graph
# #   latest_classroom_click_key = NULL, # For Classroom Shortage graph
# #   latest_teacher_shortage_click_key = NULL, # For Teacher Shortage graph
# #   latest_principal_click_key = NULL, # For School Principal graph
# #   latest_aoii_click_key = NULL,      # For AOII Deployment graph
# #   latest_pdoi_click_key = NULL,      # For PDOI Deployment graph
# #   latest_sufficiency_click_key = NULL # New: For Sufficiency graph
# # )
# # Make sure to include all rv initializations from previous steps if you are creating it from scratch.
# 
# # Observer for Sufficiency_Regional_Graph clicks
# # This should be placed in your server.R file, outside of any output$... block,
# # but within the main server function.
# observeEvent(event_data("plotly_click", source = "sufficiencyRegionPlot"), {
#   click_data <- event_data("plotly_click", source = "sufficiencyRegionPlot")
#   if (!is.null(click_data)) {
#     # Store the combined key (e.g., "Region I Critically Under-Resourced")
#     rv$latest_sufficiency_click_key <- click_data$key
#   } else {
#     # If a click somehow clears, reset the key
#     rv$latest_sufficiency_click_key <- NULL
#   }
# })
# 
# # Reactive for the raw data filtered by dashboard inputs and with sufficiency categories calculated
# # This will be the base for both the graph's aggregated data and the table's detailed data.
# filtered_sufficiency_raw_data_region <- reactive({
#   # Ensure uni data is available.
#   req(uni)
#   
#   # Start with the full dataset
#   data <- uni
#   
#   # Filter by selected region(s) if any are chosen
#   if (!is.null(input$dashboard_region_filter) && length(input$dashboard_region_filter) > 0) {
#     data <- data %>%
#       filter(Region %in% input$dashboard_region_filter)
#   }
#   
#   # Data transformation to calculate sufficiency categories for each school
#   data %>%
#     select(SchoolID, Region, Division, Teacher, Classroom, School.Head, AO) %>%
#     mutate(
#       Teacher = as.numeric(Teacher),
#       Classroom = as.numeric(Classroom),
#       School.Head = as.numeric(School.Head),
#       AO = as.numeric(AO) # Ensure AO is also numeric
#     ) %>%
#     mutate(
#       Teacher.Sufficiency = case_when(
#         (Teacher >= 0 & Teacher <= 0.25) ~ "Critically Under-Resourced",
#         (Teacher > 0.25 & Teacher <= 0.5) ~ "Under-Resourced",
#         (Teacher > 0.5 & Teacher <= 0.75) ~ "Resource-Deficient",
#         (Teacher > 0.75 & Teacher <= 0.9) ~ "Adequately Resourced",
#         (Teacher > 0.9 & Teacher <= 1) ~ "Generously Resourced",
#         Teacher > 1 ~ "For Validation",
#         TRUE ~ NA_character_
#       ),
#       Classroom.Sufficiency = case_when(
#         (Classroom >= 0 & Classroom <= 0.25) ~ "Critically Under-Resourced",
#         (Classroom > 0.25 & Classroom <= 0.5) ~ "Under-Resourced",
#         (Classroom > 0.5 & Classroom <= 0.75) ~ "Resource-Deficient",
#         (Classroom > 0.75 & Classroom <= 0.9) ~ "Adequately Resourced",
#         (Classroom > 0.9 & Classroom <= 1) ~ "Generously Resourced",
#         Classroom > 1 ~ "For Validation",
#         TRUE ~ NA_character_
#       ),
#       SH.Sufficiency = case_when(
#         (School.Head >= 0 & School.Head <= 0.25) ~ "Critically Under-Resourced",
#         (School.Head > 0.25 & School.Head <= 0.5) ~ "Under-Resourced",
#         (School.Head > 0.5 & School.Head <= 0.75) ~ "Resource-Deficient",
#         (School.Head > 0.75 & School.Head <= 0.9) ~ "Adequately Resourced",
#         (School.Head > 0.9 & School.Head <= 1) ~ "Generously Resourced",
#         School.Head > 1 ~ "For Validation",
#         TRUE ~ NA_character_
#       ),
#       AO.Sufficiency = case_when(
#         (AO >= 0 & AO <= 0.25) ~ "Critically Under-Resourced",
#         (AO > 0.25 & AO <= 0.5) ~ "Under-Resourced",
#         (AO > 0.5 & AO <= 0.75) ~ "Resource-Deficient",
#         (AO > 0.75 & AO <= 0.9) ~ "Adequately Resourced",
#         (AO > 0.9 & AO <= 1) ~ "Generously Resourced",
#         AO > 1 ~ "For Validation",
#         TRUE ~ NA_character_
#       )
#     )
# })
# 
# filtered_sufficiency_data_division <- reactive({
#   req(filtered_sufficiency_raw_data_region())
#   
#   filtered_sufficiency_raw_data_region() %>%
#     pivot_longer(
#       cols = c(Teacher.Sufficiency, Classroom.Sufficiency, SH.Sufficiency, AO.Sufficiency),
#       names_to = "Criteria",
#       values_to = "Sufficiency"
#     ) %>%
#     filter(!is.na(Sufficiency)) %>% # Filter NA sufficiency before grouping
#     group_by(Region, Division, Criteria, Sufficiency) %>%
#     summarise(SufficiencyTotal = n(), .groups = 'drop_last') %>%
#     # Calculate the total for each Division and Criteria for percentage calculation
#     mutate(RegionCriteriaTotal = sum(SufficiencyTotal)) %>%
#     mutate(Percentage = (SufficiencyTotal / RegionCriteriaTotal)) %>%
#     ungroup() %>%
#     mutate(Sufficiency = factor(Sufficiency, levels = c(
#       "Critically Under-Resourced",
#       "Under-Resourced",
#       "Resource-Deficient",
#       "Adequately Resourced",
#       "Generously Resourced",
#       "For Validation"))) # Ensure consistent order for plotting
# })
# 
# 
# output$Sufficiency_Division_Graph <- renderPlotly({
#   # Use the reactive filtered data
#   current_filtered_data_for_plot <- filtered_sufficiency_data_division()
#   
#   # Filter by the selected category from input$SuffOpt
#   plot_data <- current_filtered_data_for_plot %>%
#     filter(Criteria == input$SuffOpt)
#   
#   # --- Empty Data Handling ---
#   if (nrow(plot_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, label = paste("No data for selected regions/divisions and category:", input$SuffOpt)) +
#                       theme_void()))
#   }
#   
#   # Determine the title based on the selected input$SuffOpt
#   plot_title <- switch(input$SuffOpt,
#                        "Teacher.Sufficiency" = "Regional Teacher Sufficiency by Category",
#                        "Classroom.Sufficiency" = "Regional Classroom Sufficiency by Category",
#                        "SH.Sufficiency" = "Regional School Principal Sufficiency by Category",
#                        "AO.Sufficiency" = "Regional AO Sufficiency by Category",
#                        "Regional Sufficiency Overview")
#   
#   # Calculate total percentages per region for the overall labels on top of stacked bars
#   # This needs to be done *after* filtering by Criteria
#   total_labels_data <- plot_data %>%
#     group_by(Division) %>%
#     summarise(Grand_Total_Percentage = sum(Percentage), .groups = 'drop') # Sum percentages for labeling
#   
#   # Define specific colors for Sufficiency (adjust as per your actual categories and desired colors)
#   sufficiency_colors <- c(
#     "Critically Under-Resourced" = "#E41A1C", # Red
#     "Under-Resourced" = "#FF7F00",        # Orange
#     "Resource-Deficient" = "#FFFF33",     # Yellow
#     "Adequately Resourced" = "#A6CEE3",   # Light Blue
#     "Generously Resourced" = "#33A02C",   # Green
#     "For Validation" = "#BEBADA"          # Grey/Purple for validation
#   )
#   # Define the levels for Sufficiency for consistent stacking order in the legend and on the bars
#   sufficiency_levels_ordered <- c(
#     "Critically Under-Resourced",
#     "Under-Resourced",
#     "Resource-Deficient",
#     "Adequately Resourced",
#     "Generously Resourced",
#     "For Validation"
#   )
#   
#   # Create the ggplot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Division, -Percentage), # Reorder regions based on the percentage of the current 'Criteria' and 'Sufficiency'
#                   y = Percentage,
#                   fill = factor(Sufficiency, levels = sufficiency_levels_ordered), # Fill by Sufficiency for stacking and consistent order
#                   # IMPORTANT: Add 'key' aesthetic here to store combined info for click events
#                   key = paste(Division, Sufficiency),
#                   text = paste("Region: ", Division,
#                                "<br>Sufficiency: ", Sufficiency,
#                                "<br>Percentage: ", scales::percent(Percentage, accuracy = 0.1),
#                                "<br>Total Schools (Category): ", scales::comma(SufficiencyTotal)))) + # Custom tooltip text
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) + # Changed to position="stack" for stacked bars
#     scale_fill_manual(values = sufficiency_colors, name = "Sufficiency Category") + # Apply custom colors
#     labs(x = "Region",
#          y = "Percentage",
#          fill = "Sufficiency Category",
#          title = plot_title) +
#     scale_y_continuous(labels = scales::percent, limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) + # Format y-axis as percentage
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom", # Position legend at the bottom
#           plot.title = element_text(hjust = 0.5)) # Center the plot title
#   
#   # Convert ggplot to plotly, ensuring custom text is used for hover
#   ggplotly(p, tooltip = "text", source = "sufficiencyRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest", # Changed to "closest" for individual segment tooltips
#            margin = list(b = 100)) # Increase bottom margin for x-axis labels
# })
# 
# 
# # Reactive expression for filtering the Sufficiency table data
# # based on dashboard filters, input$SuffOpt, and plot clicks
# filtered_sufficiency_table_data <- reactive({
#   # Ensure raw data with calculated sufficiency is available.
#   req(filtered_sufficiency_raw_data_region())
#   
#   # Start with the data already filtered by dashboard inputs and with sufficiency calculated
#   data <- filtered_sufficiency_raw_data_region()
#   
#   # Apply filter by input$SuffOpt immediately
#   req(input$SuffOpt) # Ensure input$SuffOpt is not NULL
#   data <- data %>%
#     filter(get(input$SuffOpt) %in% c(
#       "Critically Under-Resourced",
#       "Under-Resourced",
#       "Resource-Deficient",
#       "Adequately Resourced",
#       "Generously Resourced",
#       "For Validation"
#     )) # Filter out NA or unexpected values in the selected sufficiency column
#   
#   # Select only the relevant sufficiency column to simplify subsequent filtering
#   data_filtered_by_suffopt <- data %>%
#     select(SchoolID, Region, Division, Teacher, Classroom, School.Head, AO, !!sym(input$SuffOpt)) %>%
#     rename(SelectedSufficiency = !!sym(input$SuffOpt)) # Rename for easier generic filtering below
#   
#   # Now, filter based on the latest plot click for Sufficiency graph
#   clicked_region <- NULL
#   clicked_sufficiency_status <- NULL
#   
#   if (!is.null(rv$latest_sufficiency_click_key)) {
#     clicked_key <- as.character(rv$latest_sufficiency_click_key)
#     
#     # Define the possible Sufficiency levels for parsing (order matters: longest first)
#     sufficiency_levels_for_parsing <- c(
#       "Critically Under-Resourced",
#       "Under-Resourced",
#       "Resource-Deficient",
#       "Adequately Resourced",
#       "Generously Resourced",
#       "For Validation"
#     )
#     # Sort by length descending to match longer names first
#     sufficiency_levels_ordered_by_length <- sufficiency_levels_for_parsing[order(nchar(sufficiency_levels_for_parsing), decreasing = TRUE)]
#     
#     found_status <- FALSE
#     for (status_val in sufficiency_levels_ordered_by_length) {
#       # Check if the status type is at the end of the key string with a preceding space
#       if (grepl(paste0(" ", status_val, "$"), clicked_key)) {
#         clicked_sufficiency_status <- status_val
#         # The region is everything before this status type
#         clicked_region <- sub(paste0(" ", status_val, "$"), "", clicked_key)
#         found_status <- TRUE
#         break
#       }
#     }
#     
#     if (!found_status) {
#       # Fallback if parsing fails, return data filtered only by dashboard inputs and SuffOpt
#       clicked_region <- NULL
#       clicked_sufficiency_status <- NULL
#       warning("Could not parse clicked Sufficiency key for Region and Sufficiency Status: ", clicked_key)
#     }
#   }
#   
#   if (!is.null(clicked_region) && !is.null(clicked_sufficiency_status)) {
#     # Apply filter based on click data if both are valid
#     final_data <- data_filtered_by_suffopt %>%
#       filter(Region == clicked_region,
#              SelectedSufficiency == clicked_sufficiency_status)
#   } else {
#     # If no specific bar segment is clicked, or parsing failed,
#     # show all schools from the dashboard filters for the selected SuffOpt
#     final_data <- data_filtered_by_suffopt
#   }
#   
#   # Select final columns for the table display. Adjust as needed.
#   # Include the original numeric columns if desired, and the specific sufficiency column selected.
#   final_data %>%
#     select(SchoolID, Region, Division, Teacher, Classroom, School.Head, AO, SelectedSufficiency)
#   
# })
# 
# # Your DT::renderDT for Sufficiency_All_List
# output$Sufficiency_All_List <- DT::renderDT({
#   table_to_display <- filtered_sufficiency_table_data()
#   
#   if (nrow(table_to_display) == 0) {
#     # Display a more informative message including the selected Sufficiency Option
#     return(DT::datatable(data.frame(Message = paste0("No school data available for '",
#                                                      gsub("\\.", " ", input$SuffOpt), # Clean up SuffOpt for display
#                                                      "' with current filters and graph selection.")),
#                          options = list(dom = 't', filter = "top")))
#   }
#   
#   # Dynamically format columns if they exist.
#   # This section needs to consider which numeric columns are relevant based on input$SuffOpt.
#   # You might want to format 'Teacher', 'Classroom', 'School.Head', 'AO' as percentages or numbers.
#   # For simplicity, let's just format the "SelectedSufficiency" column as text.
#   # For numeric columns like Teacher, Classroom etc., you'd typically apply formatPercentage or formatCurrency.
#   # If the table should show all original numeric values, ensure they are selected above in filtered_sufficiency_table_data.
#   
#   dt_table <- DT::datatable(table_to_display %>% slice(1:100),
#                             options = list(pageLength = 10, scrollX = TRUE, filter = "top"),
#                             rownames = FALSE)
#   
#   # Example: Format Teacher, Classroom, SH, AO as percentages if they are in the table
#   # You might need to adjust this based on the specific columns you want to display in the final table.
#   numeric_sufficiency_cols <- c("Teacher", "Classroom", "School.Head", "AO")
#   for (col in numeric_sufficiency_cols) {
#     if (col %in% colnames(table_to_display)) {
#       dt_table <- dt_table %>% formatPercentage(col, 2) # Format as percentage with 2 decimal places
#     }
#   }
#   
#   dt_table
# })
# 
# rv <- reactiveValues(
#   latest_click_key = NULL,
#   latest_sosss_click_key = NULL,
#   latest_classroom_click_key = NULL,
#   latest_teacher_shortage_click_key = NULL,
#   latest_principal_click_key = NULL,
#   latest_aoii_click_key = NULL,
#   latest_pdoi_click_key = NULL,
#   latest_sufficiency_click_key = NULL
# )
# 
# observeEvent(
#   event_data("plotly_click", source = "classroomShortageRegionPlot"),
#   {
#     click_data <- event_data("plotly_click", source = "classroomShortageRegionPlot")
#     rv$latest_classroom_click_key <- if (!is.null(click_data)) click_data$key else NULL
#   }
# )
# 
# output$Classroom_Shortage_Division_Graph <- renderPlotly({
#   
#   # Hide plot when region or division is unselected
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_LMS_division()
#   
#   # Handle empty data
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5,
#                  label = "No data for selected divisions") +
#         theme_void()
#     ))
#   }
#   
#   # Prepare data
#   plot_data <- current_filtered_data %>%
#     mutate(Estimated_CL_Shortage = as.numeric(Estimated_CL_Shortage)) %>%
#     group_by(Division) %>%
#     summarise(Count = sum(Estimated_CL_Shortage, na.rm = TRUE), .groups = "drop")
#   
#   # Plot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Division, -Count),
#                   y = Count,
#                   fill = Division,
#                   text = paste0("Division: ", Division,
#                                 "<br>Classroom Shortage: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", color = "black") +
#     geom_text(aes(y = Count * 1.05, label = scales::comma(Count)),
#               size = 3.5, color = "black") +
#     labs(  title = "Division Classroom Shortage Distribution", x = "Division", y = "Classroom Shortage") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "none",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "classroomShortage_division") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# 
# output$Classroom_Shortage_District_Graph <- renderPlotly({
#   
#   # Hide plot when region or division is unselected
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_LMS_division()
#   
#   # Handle empty data
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5,
#                  label = "No data for selected legislative districts") +
#         theme_void()
#     ))
#   }
#   
#   # Prepare data
#   plot_data <- current_filtered_data %>%
#     mutate(Estimated_CL_Shortage = as.numeric(Estimated_CL_Shortage)) %>%
#     group_by(Division, Legislative_District) %>%
#     summarise(Count = sum(Estimated_CL_Shortage, na.rm = TRUE), .groups = "drop") %>%
#     mutate(Division_LegDist = paste0(Division, " - ", Legislative_District))
#   
#   # Plot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Division_LegDist, -Count),
#                   y = Count,
#                   fill = Division_LegDist,
#                   text = paste0("Legislative District: ", Division_LegDist,
#                                 "<br>Classroom Shortage: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", color = "black") +
#     geom_text(aes(y = Count * 1.05, label = scales::comma(Count)),
#               size = 3.5, color = "black") +
#     labs(title = "District Classroom Shortage Distribution",x = "Legislative District", y = "Classroom Shortage") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "none",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "classroomShortage_district") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# filtered_classroom_shortage_table_data <- reactive({
#   req(filtered_school_data_region())
#   
#   data <- filtered_school_data_region() |>
#     mutate(Est.CS = as.numeric(Est.CS)) |>
#     filter(Est.CS > 0)
#   
#   if (!is.null(rv$latest_classroom_click_key)) {
#     data <- data |> filter(Region == rv$latest_classroom_click_key)
#   }
#   
#   data |>
#     select(SchoolID, Region, Division, Est.CS) |>
#     rename(`Classroom Shortage` = Est.CS)
# })
# 
# clicked_info <- reactiveVal(NULL)
# 
# observeEvent(plotly::event_data("plotly_click", source = "teacherShortageRegionPlot"), {
#   click <- plotly::event_data("plotly_click", source = "teacherShortageRegionPlot")
#   
#   if (!is.null(click)) {
#     region_clicked <- click$x
#     
#     # Print for debugging
#     print(paste("Clicked Region:", region_clicked))
#     
#     clicked_info(region_clicked)
#   }
# })
# 
# 
# 
# output$Teacher_Shortage_Data_Table <- DT::renderDT({
#   data <- DBMProp
#   
#   # Clean Region column to remove any whitespace
#   data <- data %>%
#     mutate(Region = stringr::str_trim(as.character(Region)))
#   
#   # Apply region filter if user has clicked
#   region <- clicked_info()
#   
#   if (!is.null(region)) {
#     region <- stringr::str_trim(as.character(region))  # trim click data too
#     data <- data %>%
#       filter(Region == region)
#   }
#   
#   datatable(
#     data,
#     rownames = FALSE,
#     options = list(
#       scrollX = TRUE,
#       columnDefs = list(list(className = 'dt-center', targets = "_all"))
#     )
#   )
# })
# 
# # New reactive expression for the Teacher Shortage Regional Summary Table
# # New reactive expression for the Teacher Shortage Regional Summary Table (now by Division within a clicked Region)
# filtered_teacher_shortage_regional_summary_data <- reactive({
#   req(filtered_teacher_shortage_data_region())
#   data <- filtered_teacher_shortage_data_region()
#   
#   # Ensure shortage columns are numeric
#   data <- data %>%
#     mutate(
#       ES_Shortage = as.numeric(ES_Shortage),
#       JHS_Shortage = as.numeric(JHS_Shortage),
#       SHS_Shortage = as.numeric(SHS_Shortage)
#     )
#   
#   clicked_region <- NULL
#   # We only care about the region here, not the specific inventory type clicked for this summary
#   if (!is.null(rv$latest_teacher_shortage_click_key)) {
#     clicked_key <- as.character(rv$latest_teacher_shortage_click_key)
#     split_key <- strsplit(clicked_key, "::")[[1]]
#     if (length(split_key) >= 1) { # Only need the first part for Region
#       clicked_region <- split_key[1]
#     }
#   }
#   
#   if (!is.null(clicked_region)) {
#     # If a specific region was clicked: summarize by Division within that region
#     summary_data <- data %>%
#       filter(Region == clicked_region) %>%
#       group_by(Region, Division) %>%
#       summarize(
#         `Total ES Shortage` = sum(ES_Shortage, na.rm = TRUE),
#         `Total JHS Shortage` = sum(JHS_Shortage, na.rm = TRUE),
#         `Total SHS Shortage` = sum(SHS_Shortage, na.rm = TRUE),
#         `Overall Shortage` = sum(ES_Shortage, JHS_Shortage, SHS_Shortage, na.rm = TRUE),
#         .groups = 'drop'
#       ) %>%
#       select(Region, Division, `Total ES Shortage`, `Total JHS Shortage`, `Total SHS Shortage`, `Overall Shortage`)
#   } else {
#     # If no specific region is clicked (initial state or click reset):
#     # Summarize by Division across all currently dashboard-filtered regions
#     summary_data <- data %>%
#       group_by(Region, Division) %>%
#       summarize(
#         `Total ES Shortage` = sum(ES_Shortage, na.rm = TRUE),
#         `Total JHS Shortage` = sum(JHS_Shortage, na.rm = TRUE),
#         `Total SHS Shortage` = sum(SHS_Shortage, na.rm = TRUE),
#         `Overall Shortage` = sum(ES_Shortage, JHS_Shortage, SHS_Shortage, na.rm = TRUE),
#         .groups = 'drop'
#       ) %>%
#       select(Region, Division, `Total ES Shortage`, `Total JHS Shortage`, `Total SHS Shortage`, `Overall Shortage`)
#   }
#   
#   return(summary_data)
# })
# # Make sure to include the 'filtered_teacher_shortage_regional_summary_data' reactive
# # that I provided in the previous step, before this DT::renderDT.
# 
# # DT::renderDT for the new Teacher Shortage Regional Summary Table
# # This will display the aggregated regional data, filtered by graph clicks or dashboard inputs.
# # DT::renderDT for the new Teacher Shortage Regional Summary Table
# # This will display the aggregated regional data by division, filtered by graph clicks or dashboard inputs.
# output$Teacher_Shortage_Regional_Table <- DT::renderDT({
#   table_to_display <- filtered_teacher_shortage_regional_summary_data()
#   
#   # Handle case where no data is available based on filters/clicks
#   if (nrow(table_to_display) == 0) {
#     return(DT::datatable(data.frame(Message = "No regional teacher shortage data available for this selection."), options = list(dom = 't')))
#   }
#   
#   # Render the data table
#   DT::datatable(table_to_display %>% slice(1:100),
#                 options = list(pageLength = 10, scrollX = TRUE, filter = "top"),
#                 rownames = FALSE) %>%
#     # Format the shortage columns as integers with commas
#     formatCurrency(c("Total ES Shortage", "Total JHS Shortage", "Total SHS Shortage", "Overall Shortage"), currency = '', digits = 0)
# })
# 
# observeEvent(event_data("plotly_click", source = "teacherShortageRegionPlot"), {
#   click_data <- event_data("plotly_click", source = "teacherShortageRegionPlot")
#   if (!is.null(click_data)) {
#     rv$latest_teacher_shortage_click_key <- click_data$key
#     # Add a print statement here to see if the click is registered
#     print(paste("Graph Clicked! Key:", click_data$key))
#   } else {
#     rv$latest_teacher_shortage_click_key <- NULL
#   }
# })
# 
# filtered_teacher_shortage_table_data <- reactive({
#   # Add this print statement
#   print(paste("filtered_teacher_shortage_table_data: rv$latest_teacher_shortage_click_key =", rv$latest_teacher_shortage_click_key))
#   
#   req(filtered_teacher_shortage_data())
#   data <- filtered_teacher_shortage_data()
#   
#   # ... (rest of your reactive code) ...
#   
#   if (!is.null(clicked_region) && !is.null(clicked_inventory_type)) {
#     # Add this print statement
#     print(paste("Filtering for Region:", clicked_region, "Type:", clicked_inventory_type))
#     # ... (rest of filtering logic) ...
#   } else {
#     # Add this print statement
#     print("No specific click, showing all relevant data.")
#     # ... (rest of else logic) ...
#   }
#   
#   # Add this print statement before returning
#   print(paste("filtered_teacher_shortage_table_data: Rows in final_data =", nrow(final_data)))
#   
#   return(final_data)
# })
# 
# # server.R
# 
# # Ensure 'uni' is accessible (e.g., loaded at the top of server.R or globally)
# # For demonstration, let's assume 'uni' is a data.frame already loaded.
# # If 'uni' is a reactive expression, use uni() when accessing it.
# # Example:
# # uni <- read.csv("your_data.csv") # Or whatever your data source is
# 
# # --- Reactive Values for Global Filtering (if you have them, not shown here) ---
# # Example:
# # filtered_school_data <- reactive({
# #   # Your global filtering logic here
# #   # e.g., uni %>%
# #   #   filter(Region %in% input$selected_region,
# #   #          Modified.COC %in% input$selected_coc_type)
# #   # For this example, let's assume it's just 'uni' for simplicity
# #   uni
# # })
# 
# 
# # reactiveVal to store the data for the table based on clicks
# reactive_clicked_school_data <- reactiveVal(
#   data.frame(
#     SchoolID = character(),
#     SchoolName = character(),
#     Region = character(),
#     Division = character(),
#     Legislative.District = character(),
#     Modified.COC = character(),
#     stringsAsFactors = FALSE
#   )
# )
# 
# # A reactive value to track if a chart has been clicked (and to show click-filtered data)
# # This helps distinguish between initial load/global filter and click-filtered state
# rv <- reactiveValues(
#   chart_clicked = FALSE # TRUE if any chart was clicked, FALSE otherwise
# )
# 
# # Observe click events from the regional plot
# observeEvent(event_data("plotly_click", source = "schoolcountplot_region"), {
#   click_data <- event_data("plotly_click", source = "schoolcountplot_region")
#   print("Regional graph clicked!") # DEBUG
#   
#   req(click_data, click_data$key, is.character(click_data$key))
#   
#   clicked_info <- click_data$key
#   print(paste0("Regional Clicked Key (raw): '", clicked_info, "'")) # DEBUG
#   
#   # Use strsplit with fixed = TRUE for literal "|"
#   parsed_info <- strsplit(clicked_info, "|", fixed = TRUE)[[1]]
#   region_name <- trimws(parsed_info[1]) # Trim whitespace, just in case
#   school_type <- trimws(parsed_info[2]) # Trim whitespace
#   
#   print(paste0("Regional Parsed: Region = '", region_name, "', School Type = '", school_type, "'")) # DEBUG
#   
#   # Filter the original 'uni' data based on the click
#   # IMPORTANT: Make sure 'uni' is the correct dataset and columns match
#   filtered_schools <- uni %>%
#     filter(Region == region_name, Modified.COC == school_type)
#   
#   print(paste("Regional Filtered Schools Count:", nrow(filtered_schools))) # DEBUG
#   if (nrow(filtered_schools) > 0) {
#     print("Head of Regional Filtered Schools:") # DEBUG
#     print(head(filtered_schools)) # DEBUG (See first few rows of filtered data)
#   } else {
#     print("No schools found after filtering for this regional click.")
#   }
#   
#   reactive_clicked_school_data(filtered_schools)
#   rv$chart_clicked <- TRUE # Indicate that a chart has been clicked
# })
# 
# # Observe click events from the division plot
# observeEvent(event_data("plotly_click", source = "schoolcountplot_division"), {
#   click_data <- event_data("plotly_click", source = "schoolcountplot_division")
#   print("Division graph clicked!") # DEBUG
#   
#   req(click_data, click_data$key, is.character(click_data$key))
#   
#   clicked_info <- click_data$key
#   print(paste0("Division Clicked Key (raw): '", clicked_info, "'")) # DEBUG
#   
#   # Assuming key is now "DivisionName|SchoolTypeWithSpaces"
#   parsed_info <- strsplit(clicked_info, "|", fixed = TRUE)[[1]]
#   division_name <- trimws(parsed_info[1])
#   school_type <- trimws(parsed_info[2])
#   
#   print(paste0("Division Parsed: Division = '", division_name, "', School Type = '", school_type, "'")) # DEBUG
#   
#   # Make sure you're filtering the correct base data.
#   # If filtered_school_data_region() is meant to be the *source* for division filtering, use it.
#   # Otherwise, filter from the main 'uni' dataset, applying prior filters if necessary.
#   # For simplicity and correctness, let's filter from 'uni' directly here.
#   # If you have an existing chain of filters (e.g., region -> division), ensure that logic.
#   # For now, let's assume `uni` is the base.
#   filtered_schools <- uni %>%
#     filter(Division == division_name, Modified.COC == school_type)
#   
#   print(paste("Division Filtered Schools Count:", nrow(filtered_schools))) # DEBUG
#   
#   reactive_clicked_school_data(filtered_schools)
#   rv$chart_clicked <- TRUE # Indicate that a chart has been clicked
# })
# 
# # Observe click events from the district plot
# observeEvent(event_data("plotly_click", source = "schoolcountplot_district"), {
#   click_data <- event_data("plotly_click", source = "schoolcountplot_district")
#   print("District graph clicked!") # DEBUG
#   
#   req(click_data, click_data$key, is.character(click_data$key))
#   
#   clicked_info <- click_data$key
#   print(paste0("District Clicked Key (raw): '", clicked_info, "'")) # DEBUG
#   
#   # Assuming key is now "DistrictName|SchoolTypeWithSpaces"
#   parsed_info <- strsplit(clicked_info, "|", fixed = TRUE)[[1]]
#   district_name <- trimws(parsed_info[1])
#   school_type <- trimws(parsed_info[2])
#   
#   print(paste0("District Parsed: District = '", district_name, "', School Type = '", school_type, "'")) # DEBUG
#   
#   # Make sure you're filtering the correct base data.
#   # Same as division, filter from 'uni' or your intended pre-filtered reactive.
#   filtered_schools <- uni %>%
#     filter(Legislative.District == district_name, Modified.COC == school_type)
#   
#   print(paste("District Filtered Schools Count:", nrow(filtered_schools))) # DEBUG
#   
#   reactive_clicked_school_data(filtered_schools)
#   rv$chart_clicked <- TRUE # Indicate that a chart has been clicked
# })
# 
# output$school_count_data_table <- DT::renderDT({
#   
#   data_to_display <- filtered_school_data_division() %>% select(Region, Division, Legislative.District, SchoolID, School.Name, Modified.COC) %>% rename("Modified Curricular OFfering" = Modified.COC)
#   
#   # You might want to add a check for NULL or empty data if filtered_school_data_division()
#   # could return such states and you want to display a message or an empty table.
#   if (is.null(data_to_display) || nrow(data_to_display) == 0) {
#     return(DT::datatable(
#       data.frame("Message" = "No data available based on current selection."),
#       options = list(dom = 't'), # 't' hides all controls, showing only the table body
#       rownames = FALSE
#     ))
#   }
#   
#   DT::datatable(
#     data_to_display,
#     options = list(pageLength = 10, scrollX = TRUE),
#     filter = 'top',
#     selection = 'multiple',
#     rownames = FALSE
#   )
# })
# 
# output$regprof_DT <- DT::renderDT({
#   data_to_display <- filtered_school_data_region() %>% 
#     select(Region, Division, Legislative.District, SchoolID, School.Name, School.Type, School.Size.Typology, Modified.COC, TotalEnrolment, Clustering.Status, PDOI_Deployment) %>% 
#     rename("Modified Curricular Offering" = Modified.COC)
#   
#   if (is.null(data_to_display) || nrow(data_to_display) == 0) {
#     return(DT::datatable(
#       data.frame("Message" = "No data available based on current selection."),
#       options = list(dom = 't', scrollX = TRUE, fixedColumns = list(leftColumns = 5)),
#       rownames = FALSE
#     ))
#   }
#   
#   DT::datatable(
#     data_to_display,
#     extensions = c("FixedHeader", "FixedColumns", "Buttons"),
#     options = list(
#       pageLength = 10, 
#       scrollX = TRUE,
#       scrollY = 400,
#       autoWidth = TRUE,
#       fixedHeader = TRUE,
#       fixedColumns = list(leftColumns = 5),
#       dom = 'Bfrtip',
#       buttons = list(
#         list(extend = "csv", exportOptions = list(modifier = list(page = "all"))),
#         list(extend = "excel", exportOptions = list(modifier = list(page = "all"))),
#         list(extend = "print", exportOptions = list(modifier = list(page = "all")))
#       )
#     ),
#     filter = 'top',
#     selection = 'multiple',
#     rownames = FALSE
#   )
# })
# 
# output$regprof_DT_CL <- DT::renderDT({
#   data_to_display <- filtered_LMS_region() %>%
#     mutate(across(13:17, ~ case_when(
#       . == 0 ~ "No",
#       TRUE ~ "Yes"
#     ))) %>% 
#     select(Region, Division, Legislative_District, School_ID, School_Name, Total_Enrollment, Instructional_Rooms, Estimated_CL_Shortage, With_Excess, Without_Shortage, Buildable_space, LMS, GIDCA) %>% 
#     rename(
#       "Estimated Classroom Shortage" = Estimated_CL_Shortage,
#       "Schools with Excess Classrooms" = With_Excess,
#       "Schools without Classroom Shortage" = Without_Shortage,
#       "Schools with Buildable Space" = Buildable_space
#     )
#   
#   if (is.null(data_to_display) || nrow(data_to_display) == 0) {
#     return(DT::datatable(
#       data.frame("Message" = "No data available based on current selection."),
#       options = list(dom = 't', scrollX = TRUE, fixedColumns = list(leftColumns = 5)),
#       rownames = FALSE
#     ))
#   }
#   
#   DT::datatable(
#     data_to_display,
#     extensions = c("FixedHeader", "FixedColumns", "Buttons"),
#     options = list(
#       pageLength = 10, 
#       scrollX = TRUE,
#       scrollY = 400,
#       autoWidth = TRUE,
#       fixedHeader = TRUE,
#       fixedColumns = list(leftColumns = 5),
#       dom = 'Bfrtip',
#       buttons = list(
#         list(extend = "csv", exportOptions = list(modifier = list(page = "all"))),
#         list(extend = "excel", exportOptions = list(modifier = list(page = "all"))),
#         list(extend = "print", exportOptions = list(modifier = list(page = "all")))
#       )
#     ),
#     filter = 'top',
#     selection = 'multiple',
#     rownames = FALSE
#   )
# })

# observeEvent(list(input$selected_region, input$selected_division), {
#   rv$chart_clicked <- FALSE # Reset the click state
#   print("Global filters changed, resetting chart_clicked state.") # DEBUG
# })
# 
# # For Classroom_Shortage_Division_Graph
# observeEvent(plotly::event_data("plotly_click", source = "classroomShortage_division"), {
#   click_data <- plotly::event_data("plotly_click", source = "classroomShortage_division")
#   if (!is.null(click_data)) {
#     rv$latest_classroom_click_key <- click_data$x
#     rv$latest_classroom_click_type <- "classroom_division"
#     print(paste("DEBUG: Classroom Division Clicked:", rv$latest_classroom_click_key))
#     print(paste("DEBUG: Classroom Click Type:", rv$latest_classroom_click_type))
#   }
# })
# 
# # For Classroom_Shortage_District_Graph
# observeEvent(plotly::event_data("plotly_click", source = "classroomShortage_district"), {
#   click_data <- plotly::event_data("plotly_click", source = "classroomShortage_district")
#   if (!is.null(click_data)) {
#     rv$latest_classroom_click_key <- click_data$x
#     rv$latest_classroom_click_type <- "classroom_district"
#     print(paste("DEBUG: Classroom District Clicked:", rv$latest_classroom_click_key))
#     print(paste("DEBUG: Classroom Click Type:", rv$latest_classroom_click_type))
#   }
# })
# 
# # Assuming 'rv' is a reactiveValues object initialized in your server.R,
# # for example:
# # rv <- reactiveValues(
# #   latest_classroom_click_key = NULL,
# #   latest_classroom_click_type = NULL
# # )
# 
# # Assuming Classroom_Shortage_All_List is a data frame available in your server.R
# # Example dummy data for demonstration:
# # Classroom_Shortage_All_List <- data.frame(
# #   Division = c("Division A", "Division B", "Division A", "Division C", "Division B"),
# #   Legislative.District = c("District 1", "District 2", "District 1", "District 3", "District 1"),
# #   Shortage = c(10, 5, 12, 8, 3),
# #   Other_Column = c("X", "Y", "Z", "A", "B")
# # )
# 
# # Assuming 'filtered_school_data_division' is a reactive expression defined elsewhere in your server.R,
# # for example:
# # filtered_school_data_division <- reactive({
# #   # Your filtering logic here, e.g.,
# #   # if (!is.null(rv$some_filter_key)) {
# #   #   Classroom_Shortage_All_List[Classroom_Shortage_All_List$Division == rv$some_filter_key, ]
# #   # } else {
# #   #   Classroom_Shortage_All_List
# #   # }
# # })
# 
# output$Classroom_Shortage_All_List  <- DT::renderDT({
#   # Ensure that filtered_school_data_division() returns a data frame
#   # and handle cases where it might be NULL or empty initially.
#   data_to_display <- filtered_school_data_division() %>% select(Region, Division, Legislative.District, SchoolID, School.Name, Est.CS) %>% rename("Estimated Classroom Shortage" = Est.CS)
#   
#   # You might want to add a check for NULL or empty data if filtered_school_data_division()
#   # could return such states and you want to display a message or an empty table.
#   if (is.null(data_to_display) || nrow(data_to_display) == 0) {
#     return(DT::datatable(
#       data.frame("Message" = "No data available based on current selection."),
#       options = list(dom = 't'), # 't' hides all controls, showing only the table body
#       rownames = FALSE
#     ))
#   }
#   
#   DT::datatable(
#     data_to_display, # Use the output of your reactive expression
#     options = list(
#       pageLength = 10, # Number of rows to display per page
#       lengthMenu = c(5, 10, 15, 20), # Options for number of rows per page
#       searching = TRUE, # Enable search box
#       filter = "top",
#       paging = TRUE, # Enable pagination
#       info = TRUE, # Display table information (e.g., "Showing 1 to 10 of 50 entries")
#       ordering = TRUE # Enable column sorting
#     ),
#     rownames = FALSE # Do not display row names
#   )
# })

# filtered_LMS_region <- reactive({
#   req(LMS)
#   
#   temp_data <- LMS
#   
#   if (!is.null(input$dashboard_region_filter) && length(input$dashboard_region_filter) > 0) {
#     temp_data <- temp_data %>%
#       filter(Region %in% input$dashboard_region_filter)
#   }
#   
#   return(temp_data)
# })
# 
# filtered_LMS_division <- reactive({
#   req(LMS)
#   
#   temp_data <- LMS
#   
#   if (!is.null(input$dashboard_region_filter) && length(input$dashboard_region_filter) > 0) {
#     temp_data <- temp_data %>%
#       filter(Region %in% input$dashboard_region_filter)
#   }
#   
#   if (!is.null(input$dashboard_division_filter) && length(input$dashboard_division_filter) > 0) {
#     temp_data <- temp_data %>%
#       filter(Division %in% input$dashboard_division_filter)
#   }
#   
#   return(temp_data)
# })

# output$adm_data_table <- DT::renderDT({
#   
#   data_to_display <- filtered_cloud_region_v2() %>%
#     select(BASIC.REGION,BASIC.DIVISION, contains("ALTERNATIVE.ADM")) %>% 
#     mutate(across(3:last_col(), as.numeric)) %>% 
#     mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
#     filter(BASIC.DIVISION != "") %>% 
#     group_by(BASIC.REGION,BASIC.DIVISION) %>%
#     summarise(across(everything(), sum, na.rm = TRUE))
#   
#   # You might want to add a check for NULL or empty data if filtered_school_data_division()
#   # could return such states and you want to display a message or an empty table.
#   if (is.null(data_to_display) || nrow(data_to_display) == 0) {
#     return(DT::datatable(
#       data.frame("Message" = "No data available based on current selection."),
#       options = list(dom = 't'), # 't' hides all controls, showing only the table body
#       rownames = FALSE
#     ))
#   }
#   
#   DT::datatable(
#     data_to_display,
#     options = list(pageLength = 10, scrollX = TRUE),
#     filter = 'top',
#     selection = 'multiple',
#     rownames = FALSE
#   )
# })
# 
# output$adm_regional_graph <- renderPlotly({
#   # Use the reactive filtered data
#   
#   data_to_display <- cloud_v2 %>%
#     select(BASIC.REGION, contains("ALTERNATIVE.ADM")) %>% 
#     mutate(across(2:last_col(), as.numeric)) %>% 
#     mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
#     filter(BASIC.REGION != "") %>% 
#     group_by(BASIC.REGION) %>%
#     summarise(across(everything(), sum, na.rm = TRUE))  %>% 
#     pivot_longer(
#       cols = 2:last_col(), # Specifies the columns to pivot
#       names_to = "Sections", # The new column to hold the original column names
#       values_to = "Count" # The new column to hold the values
#     )
#   
#   current_filtered_data <- data_to_display
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
#                       theme_void()))
#   }
#   
#   # Prepare the data for plotting
#   plot_data <- data_to_display
#   
#   # Create the ggplot
#   p <- ggplot(plot_data,
#               aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
#                   y = Count,
#                   fill = Sections, # Fill by Clustering.Status for coloring and consistent order
#                   text = paste("Region: ", BASIC.REGION,
#                                "<br>Section: ", Sections,
#                                "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
#     geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
#     labs(x = "",
#          y = "") +
#     scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom", # Position legend at the bottom
#           plot.title = element_text(hjust = 0.5)) # Center the plot title
#   
#   # Convert ggplot to plotly, ensuring custom text is used for hover
#   ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100)) # Increase bottom margin for x-axis labels
# })
# 
# output$adm_division_graph <- renderPlotly({
#   # Use the reactive filtered data
#   
#   data_to_display <- filtered_cloud_region_v2() %>%
#     select(BASIC.DIVISION, contains("ALTERNATIVE.ADM")) %>% 
#     mutate(across(2:last_col(), as.numeric)) %>% 
#     mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
#     filter(BASIC.DIVISION != "") %>% 
#     group_by(BASIC.DIVISION) %>%
#     summarise(across(everything(), sum, na.rm = TRUE))  %>% 
#     pivot_longer(
#       cols = 2:last_col(), # Specifies the columns to pivot
#       names_to = "Sections", # The new column to hold the original column names
#       values_to = "Count" # The new column to hold the values
#     )
#   
#   current_filtered_data <- data_to_display
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
#                       theme_void()))
#   }
#   
#   # Prepare the data for plotting
#   plot_data <- data_to_display
#   
#   # Create the ggplot
#   p <- ggplot(plot_data,
#               aes(x = Sections, # Reorder regions based on overall total count for the region
#                   y = Count,
#                   fill = Sections, # Fill by Clustering.Status for coloring and consistent order
#                   text = paste("Region: ", BASIC.DIVISION,
#                                "<br>Section: ", Sections,
#                                "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
#     geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
#     labs(x = "",
#          y = "") +
#     scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom", # Position legend at the bottom
#           plot.title = element_text(hjust = 0.5)) +
#     facet_wrap(~BASIC.DIVISION) + coord_flip()+
#     labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
#   
#   # Convert ggplot to plotly, ensuring custom text is used for hover
#   ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100)) # Increase bottom margin for x-axis labels
# })

# #Home Nav panel go to dashboard button function
# #allows to go to build your own dashboard nav panel
# observeEvent(input$goto_dashboard_btn, {
#   
#   # This function programmatically selects a tab in the main navbar
#   nav_select(
#     id = "STRIDE2_navbar",           # The ID of your main page_navbar
#     selected = "build_dashboard_tab" # The 'value' of the target tab
#   )
#   
#   # --- ADD THIS LINE TO FIX THE HANGING MENU ---
#   # This JavaScript finds any open dropdown toggle (which has aria-expanded="true")
#   # and triggers a "blur" event, which mimics the user clicking away.
#   shinyjs::runjs("$('a.dropdown-toggle[aria-expanded=\"true\"]').blur();")
#   
# })