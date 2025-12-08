# commented graphs in the resource mapping

# filtered_school_data_region <- reactive({
#   req(uni)
#   
#   temp_data <- uni
#   
#   if (!is.null(input$dashboard_region_filter) && length(input$dashboard_region_filter) > 0) {
#     temp_data <- temp_data %>%
#       filter(Region %in% input$dashboard_region_filter)
#   }
#   
#   return(temp_data)
# })
# 
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
# filtered_teacher_shortage_data_region <- reactive({
#   req(DBMProp)
#   
#   temp_data <- DBMProp
#   
#   if (!is.null(input$dashboard_region_filter) && length(input$dashboard_region_filter) > 0) {
#     temp_data <- temp_data %>%
#       filter(Region %in% input$dashboard_region_filter)
#   }
#   
#   return(temp_data)
# })
# 
# filtered_teacher_shortage_data_division <- reactive({
#   req(DBMProp)
#   
#   temp_data <- DBMProp
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
# 
# filtered_school_data_division <- reactive({
#   req(uni)
#   
#   temp_data <- uni
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
# # Inside your server function
# # Make sure you have the 'scales' library loaded for comma formatting
# library(scales) # Add this if not already present
# 
# # Assuming 'filtered_school_data_region' is a reactive expression that provides
# # the data, similar to how it was introduced in the first response.
# # Make sure your 'filtered_school_data_region' reactive is defined in your server logic.
# 
# 
# # Server
# output$total_schools_box <- renderUI({
#   # Get the count from the reactive data object
#   total_schools <- nrow(filtered_school_data_region())
#   
#   # Create the value_box with the reactive value
#   value_box(
#     title = "Total Schools in the Selected Regions",
#     value = total_schools,
#     showcase = bs_icon("building-fill")
#   )
# })
# 
# output$total_schools_box_div <- renderUI({
#   # Get the count from the reactive data object
#   total_schools <- nrow(filtered_school_data_division())
#   
#   # Create the value_box with the reactive value
#   value_box(
#     title = "Total Schools in the Selected Divisions",
#     value = total_schools,
#     showcase = bs_icon("building-fill")
#   )
# })
# 
# output$school_count_regional_graph <- renderPlotly({
#   
#   # --- If picker is empty, clear the plot ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)  # This will make the plot area blank
#   }
#   
#   # Continue only when there is a selection
#   current_filtered_data <- filtered_school_data_region()
#   
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
#     group_by(Region, Modified.COC) %>%
#     summarise(Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Modified.COC) %>%
#     summarise(TotalCount = sum(Count))
#   
#   p <- ggplot(plot_data, aes(
#     x = factor(Modified.COC, levels = coc_levels),
#     y = Count,
#     fill = Region,
#     text = paste("Region: ", Region,
#                  "<br>School Type: ", Modified.COC,
#                  "<br>Count: ", scales::comma(Count))
#   )) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Modified.COC, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs( title = "Regional Distribution of Schools by Curricular Offering", x = "Modified Curricular Offering",
#           y = "Number of Schools", fill = "Region") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text")
# })
# 
# output$SOSSS_DataTable <- DT::renderDT({
#   uni %>% mutate(School.Size.Typology = factor(School.Size.Typology, levels = c("Very Small","Small","Medium","Large","Very Large","Extremely Large","Mega"))) %>% 
#     select(School.Size.Typology) %>%
#     group_by(School.Size.Typology) %>%
#     summarize(Total = n()) %>% 
#     pivot_wider(names_from = "School.Size.Typology", values_from = "Total")
# },
# rownames = FALSE,
# options = list(
#   scrollX = TRUE,
#   columnDefs = list(list(className = 'dt-center', targets = "_all"))
# ))
# 
# output$SOSSS_Region_Typology <- renderPlotly({
#   
#   # --- Hide plot if Region picker is empty ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)
#   }
#   
#   # --- Use filtered region-level data ---
#   current_filtered_data <- filtered_school_data_region()
#   
#   # --- Handle no data case ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected regions") +
#                       theme_void()))
#   }
#   
#   # --- Prepare data for plotting ---
#   plot_data <- current_filtered_data %>%
#     group_by(Region, School.Size.Typology) %>%
#     summarise(Count = n(), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(School.Size.Typology) %>%
#     summarise(TotalCount = sum(Count))
#   
#   region_totals <- plot_data %>%
#     group_by(Region) %>%
#     summarise(TotalCount = sum(Count), .groups = 'drop')
#   
#   plot_data <- plot_data %>%
#     left_join(region_totals, by = "Region") %>%
#     mutate(Old.Region_reordered = reorder(Region, -TotalCount))
#   
#   sosss_levels <- c("Very Small", "Small", "Medium", "Large", 
#                     "Very Large", "Extremely Large", "Mega")
#   
#   # --- Plot ---
#   p <- ggplot(plot_data,
#               aes(x = factor(School.Size.Typology, levels = sosss_levels),
#                   y = Count,
#                   fill = Old.Region_reordered,
#                   text = paste("Region: ", Region,
#                                "<br>School Size: ", School.Size.Typology,
#                                "<br>Count: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = School.Size.Typology, y = TotalCount * 1.05, 
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE, size = 3.5, color = "black") +
#     labs(
#       title = "Regional Distribution of Schools by Size Typology",
#       x = "School Size Typology",
#       y = "Number of Schools",
#       fill = "Region") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "sosssRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100))
# })
# 
# 
# output$SOSSS_All_List_Typology <- DT::renderDT({
#   datatable(
#     uni %>%
#       select(Region, Division, SchoolID, School.Name, TotalEnrolment, School.Size.Typology) %>%
#       mutate(School.Size.Typology = factor(School.Size.Typology, levels = c("Very Small","Small","Medium","Large","Very Large","Extremely Large","Mega"))) %>% 
#       filter(Region %in% input$dashboard_region_filter) %>% 
#       arrange(School.Size.Typology), # This is the data argument to datatable()
#     extension = 'Buttons',  # These are now separate arguments to datatable()
#     rownames = FALSE,
#     filter = "top",
#     options = list(
#       scrollX = TRUE,
#       pageLength = 10,
#       columnDefs = list(list(className = 'dt-center', targets = "_all")),
#       dom = 'lfrtip', # Corrected dom string to include 'f' for filter/search input
#       buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
#     )
#   )
# })
# 
# observeEvent(input$dashboard_region_filter, {
#   # Assuming 'df' is your main dataset and it has a 'Division' column
#   # and 'Region' column
#   req(input$dashboard_region_filter, df) # Make sure df is available
#   
#   filtered_divisions <- df %>%
#     filter(Region  %in%  input$dashboard_region_filter) %>%
#     pull(Division) %>%
#     unique() %>%
#     sort()
#   
#   updatePickerInput(
#     session = session,
#     inputId = "dashboard_division_filter",
#     choices = filtered_divisions,
#     # CHANGE THIS LINE:
#     selected = filtered_divisions[1] # This will select all available divisions
#   )
# })
# 
# output$Classroom_Shortage_Region_Graph <- renderPlotly({
#   
#   # Hide plot when no region is selected
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_LMS_region()
#   
#   # Handle empty data
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5,
#                  label = "No data for selected regions") +
#         theme_void()
#     ))
#   }
#   
#   # Prepare data
#   plot_data <- current_filtered_data %>%
#     group_by(Region) %>%
#     summarise(Count = sum(as.numeric(Estimated_CL_Shortage), na.rm = TRUE), .groups = 'drop')
#   
#   # Plot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Region, -Count),
#                   y = Count,
#                   fill = Region,
#                   text = paste("Region: ", Region,
#                                "<br>Classroom Shortage: ", scales::comma(Count)))) +
#     geom_bar(stat = "identity", color = "black") +
#     geom_text(aes(y = Count * 1.05, label = scales::comma(Count)),
#               size = 3.5, color = "black") +
#     labs(title = "Regional Classroom Shortage Distribution", x = "Region", y = "Classroom Shortage") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "none",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "classroomShortageRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100))
# })
# 
# 
# 
# output$LMS_Nation_Graph <- renderPlotly({
#   
#   # Hide plot when no region is selected
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)
#   }
#   
#   # Reactive data
#   current_filtered_data <- filtered_LMS_region() %>%
#     rename(
#       "With Buildable Space" = Buildable_space,
#       "With Excess Classrooms" = With_Excess,
#       "Without Classroom Shortage" = Without_Shortage,
#       "Last Mile Schools" = LMS,
#       "GIDCA" = GIDCA,
#       "With Shortage" = With_Shortage
#     ) %>%
#     pivot_longer(13:18, names_to = "Type", values_to = "Count")
#   
#   # Handle empty data
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions") +
#         theme_void()
#     ))
#   }
#   
#   # Prepare data
#   plot_data <- current_filtered_data %>%
#     group_by(Region, Type) %>%
#     summarise(Count = sum(as.numeric(Count), na.rm = TRUE), .groups = 'drop')
#   
#   plot_data_totals <- plot_data %>%
#     group_by(Type) %>%
#     summarise(TotalCount = sum(Count))
#   
#   # Plot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Type, -Count),
#                   y = Count,
#                   fill = Region,
#                   text = paste("Type:", Type, "<br>Count:", scales::comma(Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Type, y = TotalCount * 1.05, label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs( title = "Regional Distribution of Last Mile School Indicators", x = "Type", y = "Count", fill = "Region") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "right",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "LMS_Region") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100)) %>%
#     style(hoverinfo = "text")
# })
# 
# 
# # --- Teaching Deployment: Regional Breakdown Graph ---
# output$Teaching_Deployment_Region_Graph <- renderPlotly({
#   
#   # --- Use the full dataset instead of the filtered one ---
#   current_filtered_data <- df  
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5,
#                  label = "No data available for Teaching Deployment",
#                  size = 5, color = "red") +
#         theme_void()
#     ))
#   }
#   
#   # --- Prepare grouped data (all regions) ---
#   plot_data <- current_filtered_data %>%
#     group_by(Region) %>%
#     summarise(TeacherShortage = sum(as.numeric(TeacherShortage), na.rm = TRUE),
#               .groups = "drop")
#   
#   # --- Add labels ---
#   plot_data <- plot_data %>%
#     mutate(Label = scales::comma(TeacherShortage))
#   
#   # --- Plot ---
#   p <- ggplot(plot_data,
#               aes(x = reorder(Region, -TeacherShortage),
#                   y = TeacherShortage,
#                   fill = Region,
#                   text = paste("Region:", Region,
#                                "<br>Teacher Shortage:", scales::comma(TeacherShortage)))) +
#     geom_bar(stat = "identity", color = "black") +
#     geom_text(aes(label = Label), vjust = -0.5, size = 3.5, color = "black") +
#     labs(
#       title = "Teacher Shortage by Region",
#       x = "Region",
#       y = "Number of Teacher Shortages"
#     ) +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
#       axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#       legend.position = "none"
#     )
#   
#   ggplotly(p, tooltip = "text") %>%
#     layout(
#       hoverlabel = list(bgcolor = "white"),
#       margin = list(b = 100)
#     )
# })
# 
# 
# #Classroom Shortage
# output$Classroom_Shortage_Region_Graph2 <- renderPlotly({
#   
#   # Use the reactive filtered data
#   current_filtered_data <- LMS
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
#                       theme_void()))
#   }
#   
#   # Prepare the data for plotting
#   plot_data <- current_filtered_data %>%
#     group_by(Region) %>%
#     summarise(Count = sum(as.numeric(Estimated_CL_Shortage), na.rm = TRUE), .groups = 'drop')
#   
#   # Create the ggplot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Region, -Count),
#                   y = Count,
#                   fill = Region,
#                   text = paste("Region: ", Region,
#                                "<br>Classroom Shortage: ", scales::comma(Count)))) + # Custom tooltip text
#     geom_bar(stat = "identity", color = "black") +
#     geom_text(data = plot_data,
#               aes(x = Region, y = Count * 1.05, label = scales::comma(Count)), # Modified line
#               inherit.aes = FALSE,
#               size = 3.5,
#               color = "black") +
#     labs(x = "Region",
#          y = "Classroom Shortage") +
#     scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "none", # No legend needed for single fill
#           plot.title = element_text(hjust = 0.5)) # Center the plot title
#   
#   # Convert ggplot to plotly, ensuring custom text is used for hover
#   ggplotly(p, tooltip = "text", source = "classroomShortageRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            # Adjust margins to prevent labels from being cut off if needed
#            margin = list(b = 100)) # Increase bottom margin for x-axis labels
# })
# 
# #learner congestion
# output$Congest_Regional_Graph <- renderPlotly({
#   # --- Use filtered or static data (replace with your reactive dataset) ---
#   current_filtered_data <- Learner_Congestion  # Example placeholder
#   
#   # --- Empty Data Handling ---
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions") +
#         theme_void()
#     ))
#   }
#   
#   # --- Data preparation ---
#   plot_data <- current_filtered_data %>%
#     group_by(Region, Congestion_Level) %>%
#     summarise(Count = sum(as.numeric(Count), na.rm = TRUE), .groups = "drop")
#   
#   # --- Compute region totals ---
#   region_totals <- plot_data %>%
#     group_by(Region) %>%
#     summarise(Total = sum(Count, na.rm = TRUE), .groups = "drop")
#   
#   # --- Plot ---
#   p <- ggplot(plot_data,
#               aes(
#                 x = reorder(Region, -Count),
#                 y = Count,
#                 fill = Congestion_Level,
#                 text = paste(
#                   "Region:", Region,
#                   "<br>Congestion Level:", Congestion_Level,
#                   "<br>Count:", scales::comma(Count)
#                 )
#               )) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(
#       data = region_totals,
#       aes(x = Region, y = Total * 1.05, label = scales::comma(Total)),
#       inherit.aes = FALSE,
#       size = 3.5,
#       color = "black"
#     ) +
#     labs(
#       title = "Regional Learner Congestion Distribution",
#       x = "Region",
#       y = "Learner Count",
#       fill = "Congestion Level"
#     ) +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
#       axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#       legend.position = "right"
#     )
#   
#   ggplotly(p, tooltip = "text") %>%
#     layout(
#       hoverlabel = list(bgcolor = "white"),
#       margin = list(b = 100)
#     ) %>%
#     style(hoverinfo = "text")
# })
# 
# output$Congest_Division_Graph <- renderPlotly({
#   current_filtered_data <- Learner_Congestion  # Example placeholder
#   
#   if (nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data for selected divisions") +
#         theme_void()
#     ))
#   }
#   
#   # --- Data preparation ---
#   plot_data <- current_filtered_data %>%
#     group_by(Division, Congestion_Level) %>%
#     summarise(Count = sum(as.numeric(Count), na.rm = TRUE), .groups = "drop") %>%
#     arrange(desc(Count)) %>%
#     slice_head(n = 20)
#   
#   division_totals <- plot_data %>%
#     group_by(Division) %>%
#     summarise(Total = sum(Count, na.rm = TRUE), .groups = "drop")
#   
#   p <- ggplot(plot_data,
#               aes(
#                 x = reorder(Division, -Count),
#                 y = Count,
#                 fill = Congestion_Level,
#                 text = paste(
#                   "Division:", Division,
#                   "<br>Congestion Level:", Congestion_Level,
#                   "<br>Count:", scales::comma(Count)
#                 )
#               )) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(
#       data = division_totals,
#       aes(x = Division, y = Total * 1.05, label = scales::comma(Total)),
#       inherit.aes = FALSE,
#       size = 3.5,
#       color = "black"
#     ) +
#     labs(
#       title = "Top 20 Divisions: Learner Congestion Distribution",
#       x = "Division",
#       y = "Learner Count",
#       fill = "Congestion Level"
#     ) +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
#       axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#       legend.position = "right"
#     )
#   
#   ggplotly(p, tooltip = "text") %>%
#     layout(
#       hoverlabel = list(bgcolor = "white"),
#       margin = list(b = 100)
#     ) %>%
#     style(hoverinfo = "text")
# })
# 
# #Facilities
# output$Facilities_Regional_Graph <- renderPlotly({
#   # Placeholder dataset until reactive data is ready
#   current_filtered_data <- Facilities
#   
#   # --- Empty data handler ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data available for selected facilities type") +
#         theme_void()
#     ))
#   }
#   
#   # --- Data prep ---
#   plot_data <- current_filtered_data %>%
#     group_by(Region, ProjectType) %>%
#     summarise(Count = sum(as.numeric(Count), na.rm = TRUE), .groups = "drop")
#   
#   region_totals <- plot_data %>%
#     group_by(Region) %>%
#     summarise(Total = sum(Count, na.rm = TRUE), .groups = "drop")
#   
#   # --- Chart ---
#   p <- ggplot(plot_data,
#               aes(
#                 x = reorder(Region, -Count),
#                 y = Count,
#                 fill = ProjectType,
#                 text = paste(
#                   "Region:", Region,
#                   "<br>Project Type:", ProjectType,
#                   "<br>Count:", scales::comma(Count)
#                 )
#               )) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(
#       data = region_totals,
#       aes(x = Region, y = Total * 1.05, label = scales::comma(Total)),
#       inherit.aes = FALSE,
#       size = 3.5,
#       color = "black"
#     ) +
#     labs(
#       title = "Regional Breakdown: Facilities Projects",
#       x = "Region",
#       y = "Number of Projects",
#       fill = "Project Type"
#     ) +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
#       axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
#       legend.position = "right"
#     )
#   
#   ggplotly(p, tooltip = "text") %>%
#     layout(hoverlabel = list(bgcolor = "white"), margin = list(b = 100))
# })
# 
# 
# output$Facilities_Division_Graph <- renderPlotly({
#   # Placeholder dataset
#   current_filtered_data <- Facilities
#   
#   # --- Empty data handler ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data available for selected facilities type") +
#         theme_void()
#     ))
#   }
#   
#   # --- Data prep ---
#   plot_data <- current_filtered_data %>%
#     group_by(Division, ProjectType) %>%
#     summarise(Count = sum(as.numeric(Count), na.rm = TRUE), .groups = "drop") %>%
#     arrange(desc(Count)) %>%
#     slice_head(n = 20)  # Top 20 only
#   
#   division_totals <- plot_data %>%
#     group_by(Division) %>%
#     summarise(Total = sum(Count, na.rm = TRUE), .groups = "drop")
#   
#   # --- Chart ---
#   p <- ggplot(plot_data,
#               aes(
#                 x = reorder(Division, -Count),
#                 y = Count,
#                 fill = ProjectType,
#                 text = paste(
#                   "Division:", Division,
#                   "<br>Project Type:", ProjectType,
#                   "<br>Count:", scales::comma(Count)
#                 )
#               )) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(
#       data = division_totals,
#       aes(x = Division, y = Total * 1.05, label = scales::comma(Total)),
#       inherit.aes = FALSE,
#       size = 3.5,
#       color = "black"
#     ) +
#     labs(
#       title = "Top 20 Divisions: Facilities Projects",
#       x = "Division",
#       y = "Number of Projects",
#       fill = "Project Type"
#     ) +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
#       axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
#       legend.position = "right"
#     )
#   
#   ggplotly(p, tooltip = "text") %>%
#     layout(hoverlabel = list(bgcolor = "white"), margin = list(b = 100))
# })
# 
# 
# #LMS
# output$LMS_Nation_Graph2 <- renderPlotly({
#   full_data <- LMS %>%   
#     rename(
#       "With Buildable Space" = Buildable_space,
#       "With Excess Classrooms" = With_Excess,
#       "Without Classroom Shortage" = Without_Shortage,
#       "Last Mile Schools" = LMS,
#       "GIDCA" = GIDCA,
#       "With Shortage" = With_Shortage
#     ) %>%
#     pivot_longer(13:18, names_to = "Type", values_to = "Count")
#   
#   # --- Keep only "Last Mile Schools" and aggregate all regions ---
#   plot_data <- full_data %>%
#     filter(Type == "Last Mile Schools") %>%
#     group_by(Region) %>%
#     summarise(
#       Count = sum(as.numeric(Count), na.rm = TRUE),
#       .groups = "drop"
#     )
#   
#   # --- Compute national total ---
#   national_total <- sum(plot_data$Count, na.rm = TRUE)
#   
#   # ---  Create the chart ---
#   p <- ggplot(plot_data,
#               aes(
#                 x = reorder(Region, -Count),
#                 y = Count,
#                 fill = Region,
#                 text = paste(
#                   "Region:", Region,
#                   "<br>Count:", scales::comma(Count)
#                 )
#               )) +
#     geom_bar(stat = "identity", color = "black", size = 0.25) +
#     geom_text(
#       aes(label = scales::comma(Count), y = Count * 1.05),
#       size = 3.5,
#       color = "black"
#     ) +
#     labs(
#       x = "Region",
#       y = "Number of Last Mile Schools",
#       fill = "Region"
#     ) +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
#       axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#       legend.position = "none"
#     )
#   
#   ggplotly(p, tooltip = "text") %>%
#     layout(
#       hoverlabel = list(bgcolor = "white"),
#       margin = list(b = 100)
#     ) %>%
#     style(hoverinfo = "text")
# })
# 
# 
# output$LMS_Division_Graph <- renderPlotly({
#   
#   # Hide plot when region or division is unselected
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0 ||
#       is.null(input$dashboard_division_filter) || length(input$dashboard_division_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_LMS_division() %>%
#     rename(
#       "With Buildable Space" = Buildable_space,
#       "With Excess Classrooms" = With_Excess,
#       "Without Classroom Shortage" = Without_Shortage,
#       "Last Mile Schools" = LMS,
#       "GIDCA" = GIDCA,
#       "With Shortage" = With_Shortage
#     ) %>%
#     pivot_longer(13:18, names_to = "Type", values_to = "Count")
#   
#   # Handle empty data
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
#     group_by(Division, Type) %>%
#     summarise(Count = sum(as.numeric(Count), na.rm = TRUE), .groups = 'drop')
#   
#   # Plot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Type, -Count),
#                   y = Count,
#                   fill = Division,
#                   text = paste("Division:", Division,
#                                "<br>Count:", scales::comma(Count)))) +
#     geom_bar(stat = "identity", color = "black", size = 0.25) +
#     geom_text(data = plot_data,
#               aes(x = Type, y = Count * 1.05, label = scales::comma(Count)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs( title = "Division Distribution of Last Mile School Indicators",x = "Division", y = "Count") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "right",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "LMS_Division") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100)) %>%
#     style(hoverinfo = "text")
# })
# 
# 
# # --- Regional Breakdown: Total number of industries per Region ---
# output$Ind_Regional_Graph <- renderPlotly({
#   
#   # --- Use your existing dataset name (replace this if named differently)
#   plot_data <- ind %>%
#     group_by(Region, Sector) %>%
#     summarise(Total = n(), .groups = "drop")  # count number of companies
#   
#   # --- Compute totals per Region for total labels ---
#   region_totals <- plot_data %>%
#     group_by(Region) %>%
#     summarise(Total_All = sum(Total, na.rm = TRUE), .groups = "drop") %>%
#     arrange(desc(Total_All))
#   
#   # --- Make Region an ordered factor for display ---
#   plot_data$Region <- factor(plot_data$Region, levels = region_totals$Region)
#   region_totals$Region <- factor(region_totals$Region, levels = region_totals$Region)
#   
#   # --- Create stacked bar chart ---
#   p <- ggplot(plot_data,
#               aes(
#                 x = Region,
#                 y = Total,
#                 fill = Sector,
#                 text = paste0(
#                   "Region: ", Region,
#                   "<br>Sector: ", Sector,
#                   "<br>Count: ", scales::comma(Total)
#                 )
#               )) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     
#     # --- Add total count label above each Region ---
#     geom_text(
#       data = region_totals,
#       aes(x = Region, y = Total_All, label = scales::comma(Total_All)),
#       inherit.aes = FALSE,
#       vjust = -0.7,
#       size = 3.8,
#       fontface = "bold",
#       color = "black"
#     ) +
#     
#     labs(
#       title = "",
#       x = "Region",
#       y = "Industry Count",
#       fill = "Sector"
#     ) +
#     scale_y_continuous(
#       labels = scales::comma,
#       expand = expansion(mult = c(0, 0.12))  # Extra space above bars for labels
#     ) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
#       axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#       legend.position = "right"
#     )
#   
#   # --- Convert ggplot to interactive plotly ---
#   ggplotly(p, tooltip = "text") %>%
#     layout(
#       hoverlabel = list(bgcolor = "white"),
#       margin = list(b = 100)
#     ) %>%
#     style(hoverinfo = "text")
# })
# 
# 
# 
# # --- Priority Divisions: Total number of industries per Division ---
# output$Ind_Division_Graph <- renderPlotly({
#   
#   # --- Base dataset ---
#   plot_data <- ind %>%
#     group_by(Province, Sector) %>%
#     summarise(Total = n(), .groups = "drop")
#   
#   # --- Compute totals per Province for ranking ---
#   province_totals <- plot_data %>%
#     group_by(Province) %>%
#     summarise(Total_All = sum(Total, na.rm = TRUE), .groups = "drop") %>%
#     arrange(desc(Total_All)) %>%
#     slice_head(n = 20)  # Top 20 provinces
#   
#   # --- Keep only those top 20 provinces in the main data ---
#   plot_data <- plot_data %>%
#     filter(Province %in% province_totals$Province)
#   
#   # --- Make Province an ordered factor for display ---
#   plot_data$Province <- factor(plot_data$Province, levels = province_totals$Province)
#   province_totals$Province <- factor(province_totals$Province, levels = province_totals$Province)
#   
#   # --- Create stacked bar chart ---
#   p <- ggplot(plot_data,
#               aes(
#                 x = Province,
#                 y = Total,
#                 fill = Sector,
#                 text = paste0(
#                   "Province: ", Province,
#                   "<br>Sector: ", Sector,
#                   "<br>Count: ", scales::comma(Total)
#                 )
#               )) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     
#     # --- Add total count label above each province ---
#     geom_text(
#       data = province_totals,
#       aes(x = Province, y = Total_All, label = scales::comma(Total_All)),
#       inherit.aes = FALSE,   # 👈 Prevent ggplot from looking for "Sector"
#       vjust = -0.7,
#       size = 3.8,
#       fontface = "bold",
#       color = "black"
#     ) +
#     
#     labs(
#       title = "",
#       x = "Division",
#       y = "Industry Count",
#       fill = "Sector"
#     ) +
#     scale_y_continuous(
#       labels = scales::comma,
#       expand = expansion(mult = c(0, 0.12))  # Extra space above for labels
#     ) +
#     theme_minimal() +
#     theme(
#       plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
#       axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#       legend.position = "right"
#     )
#   
#   # --- Convert to interactive plotly ---
#   ggplotly(p, tooltip = "text") %>%
#     layout(
#       hoverlabel = list(bgcolor = "white"),
#       margin = list(b = 120)
#     ) %>%
#     style(hoverinfo = "text")
# })
# 
# 
# output$LMS_All_List  <- DT::renderDT({
#   
#   data_to_display <- filtered_LMS_division() %>% select(Region, Division, School_Name, With_Excess, Without_Shortage, Buildable_space, LMS, GIDCA) 
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
# 
# output$LMS_Dataset  <- DT::renderDT(server = TRUE, {
#   
#   data_to_display <- LMS %>%
#     filter(LMS == 1) %>%
#     select(
#       Region,
#       Division,
#       School_Name,
#       Total_Enrollment,
#       Instructional_Rooms,
#       Estimated_CL_Shortage,
#       Buildable_space
#     ) %>%
#     rename(
#       "School Name" = School_Name,
#       "Total Enrolment" = Total_Enrollment,
#       "Number of Classrooms" = Instructional_Rooms,
#       "Estimated Classroom Shortage" = Estimated_CL_Shortage,
#       "Buildable Space" = Buildable_space
#     ) %>%
#     # ✅ Convert 0/1 values to Yes/No for Buildable Space
#     mutate(`Buildable Space` = ifelse(`Buildable Space` == 1, "Yes", "No"))
#   
#   # Handle empty data
#   if (is.null(data_to_display) || nrow(data_to_display) == 0) {
#     return(DT::datatable(
#       data.frame("Message" = "No data available based on current selection."),
#       options = list(dom = 't'),
#       rownames = FALSE
#     ))
#   }
#   
#   # Render DataTable
#   DT::datatable(
#     data_to_display,
#     options = list(
#       extensions = 'Buttons',
#       dom = 'Bfrtip',
#       buttons = list('csv', 'excel', 'pdf', 'print'),
#       pageLength = 10,
#       lengthMenu = c(5, 10, 15, 20),
#       searching = TRUE,
#       filter = "top",
#       paging = TRUE,
#       info = TRUE,
#       ordering = TRUE
#     ),
#     rownames = FALSE
#   )
# })
# 
# 
# output$Classroom_Shortage_Dataset  <- DT::renderDT(server = TRUE, {
#   
#   data_to_display <- LMS %>%
#     select(
#       Region,
#       Division,
#       School_Name,
#       Total_Enrollment,
#       Instructional_Rooms,
#       Estimated_CL_Shortage,
#       Buildable_space
#     ) %>%
#     rename(
#       "School Name" = School_Name,
#       "Total Enrolment" = Total_Enrollment,
#       "Number of Classrooms" = Instructional_Rooms,
#       "Estimated Classroom Shortage" = Estimated_CL_Shortage,
#       "Buildable Space" = Buildable_space
#     ) %>%
#     # ✅ Convert 0/1 to Yes/No for Buildable Space
#     mutate(`Buildable Space` = ifelse(`Buildable Space` == 1, "Yes", "No"))
#   
#   if (is.null(data_to_display) || nrow(data_to_display) == 0) {
#     return(DT::datatable(
#       data.frame("Message" = "No data available based on current selection."),
#       options = list(dom = 't'),
#       rownames = FALSE
#     ))
#   }
#   
#   DT::datatable(
#     data_to_display,
#     options = list(
#       extensions = 'Buttons',
#       dom = 'Bfrtip',
#       buttons = list('csv', 'excel', 'pdf', 'print'),
#       pageLength = 10,
#       lengthMenu = c(5, 10, 15, 20),
#       searching = TRUE,
#       filter = "top",
#       paging = TRUE,
#       info = TRUE,
#       ordering = TRUE
#     ),
#     rownames = FALSE
#   )
# })
# 
# 
# output$Teacher_Shortage_Data_Table <- DT::renderDT({
#   # Ensure DBMProp is accessible within this reactive context.
#   # If DBMProp is a reactive expression, call it like DBMProp().
#   # If it's a static dataframe loaded globally, it's fine as is.
#   DBMProp
# },
# rownames = FALSE,
# options = list(
#   scrollX = TRUE,
#   columnDefs = list(list(className = 'dt-center', targets = "_all"))
# ))
# 
# output$School_Principal_Shortage_Data_Table <- DT::renderDT({
#   
#   uni %>% filter(Region != "BARMM") %>% mutate(Country = "Philippines") %>%
#     select(Country, Designation) %>%
#     group_by(Designation) %>%
#     summarize(Count = n()) %>% 
#     arrange(desc(Count))
# },
# rownames = FALSE,
# options = list(
#   scrollX = TRUE,
#   columnDefs = list(list(className = 'dt-center', targets = "_all"))
# ))
# 
# # Assuming 'uni' is your original unfiltered data frame for School Principal data
# # Make sure 'uni' is loaded and available in your Shiny app's global environment or server.R
# 
# # Define filtered_school_principal_data as a reactive expression in your server logic
# # This reactive expression will filter the 'uni' data based on the selected region and division.
# 
# 
# output$School_Principal_Regional_Graph <- renderPlotly({
#   
#   # --- Hide plot when no region/division is selected ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_region()
#   
#   # --- Empty Data Handling ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5,
#                  label = "No data for selected regions") +
#         theme_void()
#     ))
#   }
#   
#   # --- Prepare data ---
#   plot_data <- current_filtered_data %>%
#     group_by(Region, Designation) %>%
#     summarise(Total_Count = n(), .groups = 'drop')
#   
#   # --- Totals for each Designation ---
#   plot_data_totals <- plot_data %>%
#     group_by(Designation) %>%
#     summarise(TotalCount = sum(Total_Count))
#   
#   # --- Order of designations ---
#   designation_levels <- c("School Principal", "Teacher-in-Charge", "Officer-in-Charge")
#   
#   # --- Build Plot ---
#   p <- ggplot(plot_data,
#               aes(x = factor(Designation, levels = designation_levels),
#                   y = Total_Count,
#                   fill = Region,
#                   text = paste("Region: ", Region,
#                                "<br>Designation: ", Designation,
#                                "<br>Total Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = Designation, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE,
#               size = 3.5, color = "black") +
#     labs(x = "Designation",
#          y = "Total Count of Individuals",
#          title = "Regional School Principal Shortage by Designation") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   # --- Convert to Plotly ---
#   ggplotly(p, tooltip = "text", source = "schoolPrincipalRegionPlot") %>%
#     layout(
#       hoverlabel = list(bgcolor = "white"),
#       margin = list(b = 100)
#     )
# })
# 
# 
# output$School_Principal_All_List <- DT::renderDT({
#   datatable(uni %>% filter(Region != "BARMM") %>% filter(Region %in% input$dashboard_region_filter) %>% select("Division","SchoolID","School.Name","Designation") %>% rename("School" = School.Name, "School ID" = SchoolID), extension = 'Buttons', rownames = FALSE, filter = 'top', options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = 'Bfrtip', buttons = list('csv','excel','pdf','print')))})
# 
# 
# output$AOII_Data_Table <- DT::renderDT({
#   uni %>% filter(Region != "BARMM") %>% 
#     select(Clustering.Status) %>% 
#     mutate(Country = "Philippines") %>%
#     group_by(Country,Clustering.Status) %>%
#     summarize(Count = n()) %>% 
#     select(Clustering.Status, Count) %>% 
#     rename("AO II Deployment" = Clustering.Status, "Total" = Count)
# },
# rownames = FALSE,
# options = list(
#   scrollX = TRUE,
#   columnDefs = list(list(className = 'dt-center', targets = "_all"))
# ))
# 
# output$PDOI_Data_Table <- DT::renderDT({
#   uni %>% filter(Region != "BARMM") %>%
#     select(PDOI_Deployment) %>% 
#     mutate(Country = "Philippines") %>%
#     group_by(Country,PDOI_Deployment) %>%
#     summarize(Count = n()) %>% 
#     select(PDOI_Deployment, Count) %>% 
#     rename("PDO I Deployment" = PDOI_Deployment, "Total" = Count)
# },
# rownames = FALSE,
# options = list(
#   scrollX = TRUE,
#   columnDefs = list(list(className = 'dt-center', targets = "_all"))
# ))
# 
# # Assuming 'uni' is your original unfiltered data frame for AOII Deployment
# # Make sure 'uni' is loaded and available in your Shiny app's global environment or server.R
# 
# # Assuming 'filtered_school_data_region' and 'filtered_pdoi_data' are reactive expressions
# # defined in your server logic.
# 
# output$AOII_Regional_Graph <- renderPlotly({
#   
#   # --- Hide plot when no region/division is selected ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_region()
#   
#   # --- Empty Data Handling ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(ggplot() +
#                       annotate("text", x = 0.5, y = 0.5, 
#                                label = "No data for selected regions") +
#                       theme_void()))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Region, Clustering.Status) %>%
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
#                   fill = Region,
#                   text = paste("Region: ", Region,
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
#          title = "Regional AO II Deployment by Clustering Status") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "aoiiRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100))
# })
# 
# 
# output$PDOI_Regional_Graph <- renderPlotly({
#   
#   # --- Hide plot when no region is selected ---
#   if (is.null(input$dashboard_region_filter) || length(input$dashboard_region_filter) == 0) {
#     return(NULL)
#   }
#   
#   current_filtered_data <- filtered_school_data_region()
#   
#   # --- Empty Data Handling ---
#   if (is.null(current_filtered_data) || nrow(current_filtered_data) == 0) {
#     return(ggplotly(
#       ggplot() +
#         annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions") +
#         theme_void()
#     ))
#   }
#   
#   plot_data <- current_filtered_data %>%
#     group_by(Region, PDOI_Deployment) %>%
#     summarise(Total_Count = n(), .groups = 'drop')
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
#                   fill = Region,
#                   text = paste("Region: ", Region,
#                                "<br>PDO I Deployment: ", PDOI_Deployment,
#                                "<br>Total Count: ", scales::comma(Total_Count)))) +
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) +
#     geom_text(data = plot_data_totals,
#               aes(x = PDOI_Deployment, y = TotalCount * 1.05,
#                   label = scales::comma(TotalCount)),
#               inherit.aes = FALSE, size = 3.5, color = "black") +
#     labs(x = "PDO I Deployment",
#          y = "Total Count of Schools",
#          title = "Regional PDO I Deployment by Status") +
#     scale_y_continuous(labels = scales::comma) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom",
#           plot.title = element_text(hjust = 0.5))
#   
#   ggplotly(p, tooltip = "text", source = "pdoiRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            hovermode = "closest",
#            margin = list(b = 100))
# })
# 
# 
# # Assuming 'uni' is your original unfiltered data frame for Sufficiency data
# # Make sure 'uni' is loaded and available in your Shiny app's global environment or server.R
# 
# # Define filtered_sufficiency_data_region as a reactive expression in your server logic
# # This reactive expression will filter the 'uni' data based on the selected region and division.
# filtered_sufficiency_data_region <- reactive({
#   # Ensure uni data is available.
#   req(uni)
#   
#   # Start with the full dataset
#   data <- uni
#   
#   # Data transformation as per your original code, but applied to the filtered data
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
#     ) %>%
#     pivot_longer(
#       cols = c(Teacher.Sufficiency, Classroom.Sufficiency, SH.Sufficiency, AO.Sufficiency),
#       names_to = "Criteria",
#       values_to = "Sufficiency"
#     ) %>%
#     filter(!is.na(Sufficiency)) %>% # Filter NA sufficiency before grouping
#     group_by(Region, Criteria, Sufficiency) %>%
#     summarise(SufficiencyTotal = n(), .groups = 'drop_last') %>%
#     # Calculate the total for each Region and Criteria for percentage calculation
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
# # Assuming 'filtered_sufficiency_data_region' is a reactive expression that provides
# # the data, similar to how it was introduced in previous responses.
# # Make sure your 'filtered_sufficiency_data_region' reactive is defined in your server logic.
# 
# output$Sufficiency_Regional_Graph <- renderPlotly({
#   # Use the reactive filtered data
#   current_filtered_data_for_plot <- filtered_sufficiency_data_region()
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
#     group_by(Region) %>%
#     summarise(Grand_Total_Percentage = sum(Percentage), .groups = 'drop') # Sum percentages for labeling
#   
#   # Create the ggplot
#   p <- ggplot(plot_data,
#               aes(x = reorder(Region, -Percentage), # Reorder regions based on the percentage of the current 'Criteria' and 'Sufficiency'
#                   y = Percentage,
#                   fill = Sufficiency, # Fill by Sufficiency for stacking
#                   text = paste("Region: ", Region,
#                                "<br>Sufficiency: ", Sufficiency,
#                                "<br>Percentage: ", scales::percent(Percentage, accuracy = 0.1),
#                                "<br>Total Schools (Category): ", scales::comma(SufficiencyTotal)))) + # Custom tooltip text
#     geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25) + # Changed to position="stack" for stacked bars
#     labs(x = "Region",
#          y = "Percentage",
#          fill = "Sufficiency Category") +
#     scale_y_continuous(labels = scales::percent, limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) + # Format y-axis as percentage
#     theme_minimal() +
#     theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
#           legend.position = "bottom", # Position legend at the bottom
#           plot.title = element_text(hjust = 0.5)) # Center the plot title
#   
#   # Convert ggplot to plotly, ensuring custom text is used for hover
#   ggplotly(p, tooltip = "text", source = "sufficiencyRegionPlot") %>%
#     layout(hoverlabel = list(bgcolor = "white"),
#            margin = list(b = 100)) # Increase bottom margin for x-axis labels
# })
# 
# output$Sufficiency_All_List <- DT::renderDT({
#   datatable(
#     uni %>% filter(Region %in% input$dashboard_region_filter) %>% 
#       select(SchoolID, School.Name, Region, Division, Teacher, Classroom, School.Head, AO) %>%
#       mutate(
#         Teacher = as.numeric(Teacher),
#         Classroom = as.numeric(Classroom),
#         School.Head = as.numeric(School.Head)
#       ) %>%
#       mutate(
#         Teacher.Sufficiency = case_when(
#           (Teacher >= 0 & Teacher <= 0.25) ~ "Critically Under-Resourced",
#           (Teacher > 0.25 & Teacher <= 0.5) ~ "Under-Resourced",
#           (Teacher > 0.5 & Teacher <= 0.75) ~ "Resource-Deficient",
#           (Teacher > 0.75 & Teacher <= 0.9) ~ "Adequately Resourced",
#           (Teacher > 0.9 & Teacher <= 1) ~ "Generously Resourced",
#           Teacher > 1 ~ "For Validation",
#           TRUE ~ NA_character_
#         ),
#         Classroom.Sufficiency = case_when(
#           (Classroom >= 0 & Classroom <= 0.25) ~ "Critically Under-Resourced",
#           (Classroom > 0.25 & Classroom <= 0.5) ~ "Under-Resourced",
#           (Classroom > 0.5 & Classroom <= 0.75) ~ "Resource-Deficient",
#           (Classroom > 0.75 & Classroom <= 0.9) ~ "Adequately Resourced",
#           (Classroom > 0.9 & Classroom <= 1) ~ "Generously Resourced",
#           Classroom > 1 ~ "For Validation",
#           TRUE ~ NA_character_
#         ),
#         SH.Sufficiency = case_when(
#           (School.Head >= 0 & School.Head <= 0.25) ~ "Critically Under-Resourced",
#           (School.Head > 0.25 & School.Head <= 0.5) ~ "Under-Resourced",
#           (School.Head > 0.5 & School.Head <= 0.75) ~ "Resource-Deficient",
#           (School.Head > 0.75 & School.Head <= 0.9) ~ "Adequately Resourced",
#           (School.Head > 0.9 & School.Head <= 1) ~ "Generously Resourced",
#           School.Head > 1 ~ "For Validation",
#           TRUE ~ NA_character_
#         ),
#         AO.Sufficiency = case_when(
#           (AO >= 0 & AO <= 0.25) ~ "Critically Under-Resourced",
#           (AO > 0.25 & AO <= 0.5) ~ "Under-Resourced",
#           (AO > 0.5 & AO <= 0.75) ~ "Resource-Deficient",
#           (AO > 0.75 & AO <= 0.9) ~ "Adequately Resourced",
#           (AO > 0.9 & AO <= 1) ~ "Generously Resourced",
#           AO > 1 ~ "For Validation",
#           TRUE ~ NA_character_
#         )
#       ) %>% select("SchoolID","School.Name","Division","Teacher.Sufficiency","Classroom.Sufficiency","SH.Sufficiency","AO.Sufficiency") %>% rename("School" = School.Name, "School ID" = SchoolID, "Teacher Sufficiency" = Teacher.Sufficiency, "Classroom Sufficiency" = Classroom.Sufficiency, "School Principal Sufficiency" = SH.Sufficiency, "AO Sufficiency" = AO.Sufficiency), extension = 'Buttons', rownames = FALSE, filter ='top', options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = 'Bfrtip', buttons = list('csv','excel','pdf','print')))})
# 
