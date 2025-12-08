# CLOUD Graphs and TAbles


filtered_cloud_region <- reactive({
  req(cloud)
  
  temp_data <- cloud
  
  if (!is.null(input$cloud_region_filter) && length(input$cloud_region_filter) > 0) {
    temp_data <- temp_data %>%
      filter(BASIC.REGION %in% input$cloud_region_filter)
  }
  
  if (!is.null(input$cloud_division_filter) && length(input$cloud_division_filter) > 0) {
    temp_data <- temp_data %>%
      filter(BASIC.DIVISION %in% input$cloud_division_filter)
  }
  
  return(temp_data)
})

filtered_cloud_region_v2 <- reactive({
  req(cloud_v2)
  
  temp_data <- cloud_v2
  
  if (!is.null(input$cloud_region_filter) && length(input$cloud_region_filter) > 0) {
    temp_data <- temp_data %>%
      filter(BASIC.REGION %in% input$cloud_region_filter)
  }
  
  if (!is.null(input$cloud_division_filter) && length(input$cloud_division_filter) > 0) {
    temp_data <- temp_data %>%
      filter(BASIC.DIVISION %in% input$cloud_division_filter)
  }
  
  return(temp_data)
})

filtered_cloud_region_v3 <- reactive({
  req(cloud_v3)
  
  temp_data <- cloud_v3
  
  if (!is.null(input$cloud_region_filter) && length(input$cloud_region_filter) > 0) {
    temp_data <- temp_data %>%
      filter(BASIC.REGION %in% input$cloud_region_filter)
  }
  
  if (!is.null(input$cloud_division_filter) && length(input$cloud_division_filter) > 0) {
    temp_data <- temp_data %>%
      filter(BASIC.DIVISION %in% input$cloud_division_filter)
  }
  
  return(temp_data)
})

# Add a mechanism to reset the table when global filters change (optional but recommended)
# This will make the table revert to globally filtered data if user changes region/division
# after clicking on a chart

output$enrolment_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION,ENROLLMENT.G1,ENROLLMENT.G2,ENROLLMENT.G3,ENROLLMENT.G4,ENROLLMENT.G5,ENROLLMENT.G6,ENROLLMENT.G7,ENROLLMENT.G8,ENROLLMENT.G9,ENROLLMENT.G10,ENROLMENT.G11,ENROLMENT.G12) %>%
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>% 
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    rename("REGION" = BASIC.REGION,
           "DIVISION" = BASIC.DIVISION,
           "GRADE 1" = ENROLLMENT.G1,
           "GRADE 2" = ENROLLMENT.G2,
           "GRADE 3" = ENROLLMENT.G3,
           "GRADE 4" = ENROLLMENT.G4,
           "GRADE 5" = ENROLLMENT.G5,
           "GRADE 6" = ENROLLMENT.G6,
           "GRADE 7" = ENROLLMENT.G7,
           "GRADE 8" = ENROLLMENT.G8,
           "GRADE 9" = ENROLLMENT.G9,
           "GRADE 10" = ENROLLMENT.G10,
           "GRADE 11" = ENROLMENT.G11,
           "GRADE 12" = ENROLMENT.G12)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$enrolment_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION,ENROLLMENT.G1,ENROLLMENT.G2,ENROLLMENT.G3,ENROLLMENT.G4,ENROLLMENT.G5,ENROLLMENT.G6,ENROLLMENT.G7,ENROLLMENT.G8,ENROLLMENT.G9,ENROLLMENT.G10,ENROLMENT.G11,ENROLMENT.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    rename("REGION" = BASIC.REGION,
           "GRADE 1" = ENROLLMENT.G1,
           "GRADE 2" = ENROLLMENT.G2,
           "GRADE 3" = ENROLLMENT.G3,
           "GRADE 4" = ENROLLMENT.G4,
           "GRADE 5" = ENROLLMENT.G5,
           "GRADE 6" = ENROLLMENT.G6,
           "GRADE 7" = ENROLLMENT.G7,
           "GRADE 8" = ENROLLMENT.G8,
           "GRADE 9" = ENROLLMENT.G9,
           "GRADE 10" = ENROLLMENT.G10,
           "GRADE 11" = ENROLMENT.G11,
           "GRADE 12" = ENROLMENT.G12) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Enrolment", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(Enrolment = factor(Enrolment, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Enrolment, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Enrolment,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$enrolment_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION,ENROLLMENT.G1,ENROLLMENT.G2,ENROLLMENT.G3,ENROLLMENT.G4,ENROLLMENT.G5,ENROLLMENT.G6,ENROLLMENT.G7,ENROLLMENT.G8,ENROLLMENT.G9,ENROLLMENT.G10,ENROLMENT.G11,ENROLMENT.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    rename("DIVISION" = BASIC.DIVISION,
           "GRADE 1" = ENROLLMENT.G1,
           "GRADE 2" = ENROLLMENT.G2,
           "GRADE 3" = ENROLLMENT.G3,
           "GRADE 4" = ENROLLMENT.G4,
           "GRADE 5" = ENROLLMENT.G5,
           "GRADE 6" = ENROLLMENT.G6,
           "GRADE 7" = ENROLLMENT.G7,
           "GRADE 8" = ENROLLMENT.G8,
           "GRADE 9" = ENROLLMENT.G9,
           "GRADE 10" = ENROLLMENT.G10,
           "GRADE 11" = ENROLMENT.G11,
           "GRADE 12" = ENROLMENT.G12) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Enrolment", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(Enrolment = factor(Enrolment, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Enrolment, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Enrolment, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Division: ", DIVISION,
                               "<br>Section: ", Enrolment,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sned_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, SPECIAL.NEEDS.G1, SPECIAL.NEEDS.G2, SPECIAL.NEEDS.G3, SPECIAL.NEEDS.G4, SPECIAL.NEEDS.G5, SPECIAL.NEEDS.G6, SPECIAL.NEEDS.G7, SPECIAL.NEEDS.G8, SPECIAL.NEEDS.G9, SPECIAL.NEEDS.G10) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    mutate(SPECIAL.NEEDS.G1 = as.integer(SPECIAL.NEEDS.G1),SPECIAL.NEEDS.G2 = as.integer(SPECIAL.NEEDS.G2)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = SPECIAL.NEEDS.G1,
      "GRADE 2" = SPECIAL.NEEDS.G2,
      "GRADE 3" = SPECIAL.NEEDS.G3,
      "GRADE 4" = SPECIAL.NEEDS.G4,
      "GRADE 5" = SPECIAL.NEEDS.G5,
      "GRADE 6" = SPECIAL.NEEDS.G6,
      "GRADE 7" = SPECIAL.NEEDS.G7,
      "GRADE 8" = SPECIAL.NEEDS.G8,
      "GRADE 9" = SPECIAL.NEEDS.G9,
      "GRADE 10" = SPECIAL.NEEDS.G10
    )
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$sned_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, SPECIAL.NEEDS.G1, SPECIAL.NEEDS.G2, SPECIAL.NEEDS.G3, SPECIAL.NEEDS.G4, SPECIAL.NEEDS.G5, SPECIAL.NEEDS.G6, SPECIAL.NEEDS.G7, SPECIAL.NEEDS.G8, SPECIAL.NEEDS.G9, SPECIAL.NEEDS.G10) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "GRADE 1" = SPECIAL.NEEDS.G1,
      "GRADE 2" = SPECIAL.NEEDS.G2,
      "GRADE 3" = SPECIAL.NEEDS.G3,
      "GRADE 4" = SPECIAL.NEEDS.G4,
      "GRADE 5" = SPECIAL.NEEDS.G5,
      "GRADE 6" = SPECIAL.NEEDS.G6,
      "GRADE 7" = SPECIAL.NEEDS.G7,
      "GRADE 8" = SPECIAL.NEEDS.G8,
      "GRADE 9" = SPECIAL.NEEDS.G9,
      "GRADE 10" = SPECIAL.NEEDS.G10
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "SNED_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(SNED_Learners = factor(SNED_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10")))
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = SNED_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", SNED_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sned_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, SPECIAL.NEEDS.G1, SPECIAL.NEEDS.G2, SPECIAL.NEEDS.G3, SPECIAL.NEEDS.G4, SPECIAL.NEEDS.G5, SPECIAL.NEEDS.G6, SPECIAL.NEEDS.G7, SPECIAL.NEEDS.G8, SPECIAL.NEEDS.G9, SPECIAL.NEEDS.G10) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = SPECIAL.NEEDS.G1,
      "GRADE 2" = SPECIAL.NEEDS.G2,
      "GRADE 3" = SPECIAL.NEEDS.G3,
      "GRADE 4" = SPECIAL.NEEDS.G4,
      "GRADE 5" = SPECIAL.NEEDS.G5,
      "GRADE 6" = SPECIAL.NEEDS.G6,
      "GRADE 7" = SPECIAL.NEEDS.G7,
      "GRADE 8" = SPECIAL.NEEDS.G8,
      "GRADE 9" = SPECIAL.NEEDS.G9,
      "GRADE 10" = SPECIAL.NEEDS.G10
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "SNED_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(SNED_Learners = factor(SNED_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10")))
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = SNED_Learners, y = Count,
                  fill = SNED_Learners,
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", SNED_Learners,
                               "<br>Count: ", scales::comma(Count)))) +
    geom_bar(stat = "identity", position = "dodge", color = "black") +
    scale_y_continuous(labels = scales::comma) +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom",
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  
  
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$ip_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, IP.G1.IP, IP.G2.IP, IP.G3.IP, IP.G4.IP, IP.G5.IP, IP.G6.IP, IP.G7.IP, IP.G8.IP, IP.G9.IP, IP.G10.IP, IP.G11, IP.G12) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = IP.G1.IP,
      "GRADE 2" = IP.G2.IP,
      "GRADE 3" = IP.G3.IP,
      "GRADE 4" = IP.G4.IP,
      "GRADE 5" = IP.G5.IP,
      "GRADE 6" = IP.G6.IP,
      "GRADE 7" = IP.G7.IP,
      "GRADE 8" = IP.G8.IP,
      "GRADE 9" = IP.G9.IP,
      "GRADE 10" = IP.G10.IP,
      "GRADE 11" = IP.G11,
      "GRADE 12" = IP.G12
    ) 
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$ip_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, IP.G1.IP, IP.G2.IP, IP.G3.IP, IP.G4.IP, IP.G5.IP, IP.G6.IP, IP.G7.IP, IP.G8.IP, IP.G9.IP, IP.G10.IP, IP.G11, IP.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "REGION" = BASIC.REGION,
      "GRADE 1" = IP.G1.IP,
      "GRADE 2" = IP.G2.IP,
      "GRADE 3" = IP.G3.IP,
      "GRADE 4" = IP.G4.IP,
      "GRADE 5" = IP.G5.IP,
      "GRADE 6" = IP.G6.IP,
      "GRADE 7" = IP.G7.IP,
      "GRADE 8" = IP.G8.IP,
      "GRADE 9" = IP.G9.IP,
      "GRADE 10" = IP.G10.IP,
      "GRADE 11" = IP.G11,
      "GRADE 12" = IP.G12
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "IP_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(IP_Learners = factor(IP_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = IP_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", IP_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$ip_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, IP.G1.IP, IP.G2.IP, IP.G3.IP, IP.G4.IP, IP.G5.IP, IP.G6.IP, IP.G7.IP, IP.G8.IP, IP.G9.IP, IP.G10.IP, IP.G11, IP.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = IP.G1.IP,
      "GRADE 2" = IP.G2.IP,
      "GRADE 3" = IP.G3.IP,
      "GRADE 4" = IP.G4.IP,
      "GRADE 5" = IP.G5.IP,
      "GRADE 6" = IP.G6.IP,
      "GRADE 7" = IP.G7.IP,
      "GRADE 8" = IP.G8.IP,
      "GRADE 9" = IP.G9.IP,
      "GRADE 10" = IP.G10.IP,
      "GRADE 11" = IP.G11,
      "GRADE 12" = IP.G12
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "IP_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(IP_Learners = factor(IP_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = IP_Learners, y = Count,
                  fill = IP_Learners,
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", IP_Learners,
                               "<br>Count: ", scales::comma(Count)))) +
    geom_bar(stat = "identity", position = "dodge", color = "black") +
    scale_y_continuous(labels = scales::comma) +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom",
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  
  
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$muslim_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, MUSLIM.G1.MUSLIM, MUSLIM.G2.MUSLIM, MUSLIM.G3.MUSLIM, MUSLIM.G4.MUSLIM, MUSLIM.G5.MUSLIM, MUSLIM.G6.MUSLIM, MUSLIM.G7.MUSLIM, MUSLIM.G8.MUSLIM, MUSLIM.G9.MUSLIM, MUSLIM.G10.MUSLIM, MUSLIM.G11, MUSLIM.G12) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = MUSLIM.G1.MUSLIM,
      "GRADE 2" = MUSLIM.G2.MUSLIM,
      "GRADE 3" = MUSLIM.G3.MUSLIM,
      "GRADE 4" = MUSLIM.G4.MUSLIM,
      "GRADE 5" = MUSLIM.G5.MUSLIM,
      "GRADE 6" = MUSLIM.G6.MUSLIM,
      "GRADE 7" = MUSLIM.G7.MUSLIM,
      "GRADE 8" = MUSLIM.G8.MUSLIM,
      "GRADE 9" = MUSLIM.G9.MUSLIM,
      "GRADE 10" = MUSLIM.G10.MUSLIM,
      "GRADE 11" = MUSLIM.G11,
      "GRADE 12" = MUSLIM.G12
    )
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$muslim_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, MUSLIM.G1.MUSLIM, MUSLIM.G2.MUSLIM, MUSLIM.G3.MUSLIM, MUSLIM.G4.MUSLIM, MUSLIM.G5.MUSLIM, MUSLIM.G6.MUSLIM, MUSLIM.G7.MUSLIM, MUSLIM.G8.MUSLIM, MUSLIM.G9.MUSLIM, MUSLIM.G10.MUSLIM, MUSLIM.G11, MUSLIM.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "GRADE 1" = MUSLIM.G1.MUSLIM,
      "GRADE 2" = MUSLIM.G2.MUSLIM,
      "GRADE 3" = MUSLIM.G3.MUSLIM,
      "GRADE 4" = MUSLIM.G4.MUSLIM,
      "GRADE 5" = MUSLIM.G5.MUSLIM,
      "GRADE 6" = MUSLIM.G6.MUSLIM,
      "GRADE 7" = MUSLIM.G7.MUSLIM,
      "GRADE 8" = MUSLIM.G8.MUSLIM,
      "GRADE 9" = MUSLIM.G9.MUSLIM,
      "GRADE 10" = MUSLIM.G10.MUSLIM,
      "GRADE 11" = MUSLIM.G11,
      "GRADE 12" = MUSLIM.G12
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Muslim_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(Muslim_Learners = factor(Muslim_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Muslim_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Muslim_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$muslim_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, MUSLIM.G1.MUSLIM, MUSLIM.G2.MUSLIM, MUSLIM.G3.MUSLIM, MUSLIM.G4.MUSLIM, MUSLIM.G5.MUSLIM, MUSLIM.G6.MUSLIM, MUSLIM.G7.MUSLIM, MUSLIM.G8.MUSLIM, MUSLIM.G9.MUSLIM, MUSLIM.G10.MUSLIM, MUSLIM.G11, MUSLIM.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = MUSLIM.G1.MUSLIM,
      "GRADE 2" = MUSLIM.G2.MUSLIM,
      "GRADE 3" = MUSLIM.G3.MUSLIM,
      "GRADE 4" = MUSLIM.G4.MUSLIM,
      "GRADE 5" = MUSLIM.G5.MUSLIM,
      "GRADE 6" = MUSLIM.G6.MUSLIM,
      "GRADE 7" = MUSLIM.G7.MUSLIM,
      "GRADE 8" = MUSLIM.G8.MUSLIM,
      "GRADE 9" = MUSLIM.G9.MUSLIM,
      "GRADE 10" = MUSLIM.G10.MUSLIM,
      "GRADE 11" = MUSLIM.G11,
      "GRADE 12" = MUSLIM.G12
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Muslim_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(Muslim_Learners = factor(Muslim_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Muslim_Learners, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Muslim_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Muslim_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$displaced_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, DISPLACED.GRADE1.DISPLACED.LEARNER, DISPLACED.GRADE2.DISPLACED.LEARNER, DISPLACED.GRADE3.DISPLACED.LEARNER, DISPLACED.GRADE4.DISPLACED.LEARNER, DISPLACED.GRADE5.DISPLACED.LEARNER, DISPLACED.GRADE6.DISPLACED.LEARNER,DISPLACED.G7.DISPLACED,DISPLACED.G8.DISPLACED,DISPLACED.G9.DISPLACED,DISPLACED.G10.DISPLACED,DISPLACED.G11,DISPLACED.G12) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = DISPLACED.GRADE1.DISPLACED.LEARNER,
      "GRADE 2" = DISPLACED.GRADE2.DISPLACED.LEARNER,
      "GRADE 3" = DISPLACED.GRADE3.DISPLACED.LEARNER,
      "GRADE 4" = DISPLACED.GRADE4.DISPLACED.LEARNER,
      "GRADE 5" = DISPLACED.GRADE5.DISPLACED.LEARNER,
      "GRADE 6" = DISPLACED.GRADE6.DISPLACED.LEARNER,
      "GRADE 7" = DISPLACED.G7.DISPLACED,
      "GRADE 8" = DISPLACED.G8.DISPLACED,
      "GRADE 9" = DISPLACED.G9.DISPLACED,
      "GRADE 10" = DISPLACED.G10.DISPLACED,
      "GRADE 11" = DISPLACED.G11,
      "GRADE 12" = DISPLACED.G12
    )
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$displaced_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, DISPLACED.GRADE1.DISPLACED.LEARNER, DISPLACED.GRADE2.DISPLACED.LEARNER, DISPLACED.GRADE3.DISPLACED.LEARNER, DISPLACED.GRADE4.DISPLACED.LEARNER, DISPLACED.GRADE5.DISPLACED.LEARNER, DISPLACED.GRADE6.DISPLACED.LEARNER,DISPLACED.G7.DISPLACED,DISPLACED.G8.DISPLACED,DISPLACED.G9.DISPLACED,DISPLACED.G10.DISPLACED,DISPLACED.G11,DISPLACED.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "GRADE 1" = DISPLACED.GRADE1.DISPLACED.LEARNER,
      "GRADE 2" = DISPLACED.GRADE2.DISPLACED.LEARNER,
      "GRADE 3" = DISPLACED.GRADE3.DISPLACED.LEARNER,
      "GRADE 4" = DISPLACED.GRADE4.DISPLACED.LEARNER,
      "GRADE 5" = DISPLACED.GRADE5.DISPLACED.LEARNER,
      "GRADE 6" = DISPLACED.GRADE6.DISPLACED.LEARNER,
      "GRADE 7" = DISPLACED.G7.DISPLACED,
      "GRADE 8" = DISPLACED.G8.DISPLACED,
      "GRADE 9" = DISPLACED.G9.DISPLACED,
      "GRADE 10" = DISPLACED.G10.DISPLACED,
      "GRADE 11" = DISPLACED.G11,
      "GRADE 12" = DISPLACED.G12
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Displaced_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(Displaced_Learners = factor(Displaced_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Displaced_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Displaced_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "Region",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$displaced_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, DISPLACED.GRADE1.DISPLACED.LEARNER, DISPLACED.GRADE2.DISPLACED.LEARNER, DISPLACED.GRADE3.DISPLACED.LEARNER, DISPLACED.GRADE4.DISPLACED.LEARNER, DISPLACED.GRADE5.DISPLACED.LEARNER, DISPLACED.GRADE6.DISPLACED.LEARNER,DISPLACED.G7.DISPLACED,DISPLACED.G8.DISPLACED,DISPLACED.G9.DISPLACED,DISPLACED.G10.DISPLACED,DISPLACED.G11,DISPLACED.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "GRADE 1" = DISPLACED.GRADE1.DISPLACED.LEARNER,
      "GRADE 2" = DISPLACED.GRADE2.DISPLACED.LEARNER,
      "GRADE 3" = DISPLACED.GRADE3.DISPLACED.LEARNER,
      "GRADE 4" = DISPLACED.GRADE4.DISPLACED.LEARNER,
      "GRADE 5" = DISPLACED.GRADE5.DISPLACED.LEARNER,
      "GRADE 6" = DISPLACED.GRADE6.DISPLACED.LEARNER,
      "GRADE 7" = DISPLACED.G7.DISPLACED,
      "GRADE 8" = DISPLACED.G8.DISPLACED,
      "GRADE 9" = DISPLACED.G9.DISPLACED,
      "GRADE 10" = DISPLACED.G10.DISPLACED,
      "GRADE 11" = DISPLACED.G11,
      "GRADE 12" = DISPLACED.G12
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Displaced_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(Displaced_Learners = factor(Displaced_Learners, levels = c(
      "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Displaced_Learners, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Displaced_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Displaced_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$als_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("ENROLLEDALS.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "ES" = ENROLLEDALS.ELEM.ALS,
      "JHS" = ENROLLEDALS.JHS.ALS,
      "SHS" = ENROLLEDALS.SHS.ALS
    )
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$als_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, contains("ENROLLEDALS.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "ES" = ENROLLEDALS.ELEM.ALS,
      "JHS" = ENROLLEDALS.JHS.ALS,
      "SHS" = ENROLLEDALS.SHS.ALS
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "ALS_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = ALS_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", ALS_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$als_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("ENROLLEDALS.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "ES" = ENROLLEDALS.ELEM.ALS,
      "JHS" = ENROLLEDALS.JHS.ALS,
      "SHS" = ENROLLEDALS.SHS.ALS
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "ALS_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = ALS_Learners, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = ALS_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", ALS_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$dropout_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, DROPOUT.PREVSY) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "NUMBER OF DROPOUTS (PREVIOUS SY)" = DROPOUT.PREVSY)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$dropout_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, DROPOUT.PREVSY) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "NUMBER OF DROPOUTS (PREVIOUS SY)" = DROPOUT.PREVSY) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$dropout_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, DROPOUT.PREVSY) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "NUMBER OF DROPOUTS (PREVIOUS SY)" = DROPOUT.PREVSY)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sosss_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("SOSSS.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$sosss_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, contains("SOSSS.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sosss_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("SOSSS.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$extension_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("EXTENSION.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$extension_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, contains("EXTENSION.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$extension_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("EXTENSION.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$teacherinventory_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, TEACHING.PERSONNEL.ELEM, TEACHING.PERSONNEL.JHS, TEACHING.PERSONNEL.SHS) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "ES" = TEACHING.PERSONNEL.ELEM,
      "JHS" = TEACHING.PERSONNEL.JHS,
      "SHS" = TEACHING.PERSONNEL.SHS
    )
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$teacherinventory_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, TEACHING.PERSONNEL.ELEM, TEACHING.PERSONNEL.JHS, TEACHING.PERSONNEL.SHS) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "ES" = TEACHING.PERSONNEL.ELEM,
      "JHS" = TEACHING.PERSONNEL.JHS,
      "SHS" = TEACHING.PERSONNEL.SHS
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Number_of_Teaching_Personnel", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Number_of_Teaching_Personnel, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Number_of_Teaching_Personnel,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$teacherinventory_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, TEACHING.PERSONNEL.ELEM, TEACHING.PERSONNEL.JHS, TEACHING.PERSONNEL.SHS) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "ES" = TEACHING.PERSONNEL.ELEM,
      "JHS" = TEACHING.PERSONNEL.JHS,
      "SHS" = TEACHING.PERSONNEL.SHS
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Number_of_Teaching_Personnel", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Number_of_Teaching_Personnel, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Number_of_Teaching_Personnel, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Number_of_Teaching_Personnel,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$classroom_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, NO.CLASSROOM.ELEM, NO.CLASSROOM.SNED.ELEM, NO.CLASSROOM.JHS, NO.CLASSROOM.SNED.JHS, NO.CLASSROOM.SHS) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "ES" = NO.CLASSROOM.ELEM,
      "JHS" = NO.CLASSROOM.JHS,
      "SHS" = NO.CLASSROOM.SHS,
      "SNED-ES" = NO.CLASSROOM.SNED.ELEM,
      "SNED-JHS" = NO.CLASSROOM.SNED.JHS)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$classroom_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, NO.CLASSROOM.ELEM, NO.CLASSROOM.SNED.ELEM, NO.CLASSROOM.JHS, NO.CLASSROOM.SNED.JHS, NO.CLASSROOM.SHS) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "ES" = NO.CLASSROOM.ELEM,
      "JHS" = NO.CLASSROOM.JHS,
      "SHS" = NO.CLASSROOM.SHS,
      "SNED-ES" = NO.CLASSROOM.SNED.ELEM,
      "SNED-JHS" = NO.CLASSROOM.SNED.JHS)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Number_of_Classrooms", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Number_of_Classrooms, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Number_of_Classrooms,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5))
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$classroom_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("NO.CLASSROOM.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "ES" = NO.CLASSROOM.ELEM,
      "JHS" = NO.CLASSROOM.JHS,
      "SHS" = NO.CLASSROOM.SHS,
      "SNED-ES" = NO.CLASSROOM.SNED.ELEM,
      "SNED-JHS" = NO.CLASSROOM.SNED.JHS)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Number_of_Classrooms", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Number_of_Classrooms, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Number_of_Classrooms, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Number_of_Classrooms,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$multigrade_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("MG.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "G1 & G2" = MG.CLASSES.1.2,
      "G3 & G4" = MG.CLASSES.3.4,
      "G5 & G6" = MG.CLASSES.5.6
    )
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$multigrade_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, contains("MG.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "G1 & G2" = MG.CLASSES.1.2,
      "G3 & G4" = MG.CLASSES.3.4,
      "G5 & G6" = MG.CLASSES.5.6
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Multigrade", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Multigrade, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Multigrade,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$multigrade_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("MG.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "G1 & G2" = MG.CLASSES.1.2,
      "G3 & G4" = MG.CLASSES.3.4,
      "G5 & G6" = MG.CLASSES.5.6
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Multigrade", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Multigrade, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Multigrade, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Multigrade,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) +
    coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL) # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$organizedclass_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, CLASS.ORG.BELOW, CLASS.ORG.ABOVE, CLASS.ORG.WITHIN) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "BELOW THE STANDARD" = CLASS.ORG.BELOW,
      "ABOVE THE STANDARD" = CLASS.ORG.ABOVE,
      "WITHIN THE STANDARD" = CLASS.ORG.WITHIN
    )
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$organizedclass_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, CLASS.ORG.BELOW, CLASS.ORG.ABOVE, CLASS.ORG.WITHIN) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "BELOW THE STANDARD" = CLASS.ORG.BELOW,
      "ABOVE THE STANDARD" = CLASS.ORG.ABOVE,
      "WITHIN THE STANDARD" = CLASS.ORG.WITHIN
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Classes_Organized", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    # This is the key change: Convert 'Classes_Organized' to a factor with specific levels
    mutate(Classes_Organized = factor(Classes_Organized, levels = c(
      "BELOW THE STANDARD",
      "WITHIN THE STANDARD",
      "ABOVE THE STANDARD"
    )))
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Classes_Organized, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Classes_Organized,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    scale_fill_manual(values = c(
      "BELOW THE STANDARD" = "blue",
      "WITHIN THE STANDARD" = "green", # Optional: you can set a color for this too
      "ABOVE THE STANDARD" = "red"
    )) +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$organizedclass_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, CLASS.ORG.BELOW, CLASS.ORG.ABOVE, CLASS.ORG.WITHIN) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "BELOW THE STANDARD" = CLASS.ORG.BELOW,
      "ABOVE THE STANDARD" = CLASS.ORG.ABOVE,
      "WITHIN THE STANDARD" = CLASS.ORG.WITHIN
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Classes_Organized", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    # This is the key change: Convert 'Classes_Organized' to a factor with specific levels
    mutate(Classes_Organized = factor(Classes_Organized, levels = c(
      "BELOW THE STANDARD",
      "WITHIN THE STANDARD",
      "ABOVE THE STANDARD"
    )))
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Classes_Organized, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Classes_Organized, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Classes_Organized,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    scale_fill_manual(values = c(
      "BELOW THE STANDARD" = "blue",
      "WITHIN THE STANDARD" = "green", # Optional: you can set a color for this too
      "ABOVE THE STANDARD" = "red"
    )) +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$jhsdeployment_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION,Actual.Teacher.AFA,Actual.Teacher.FCS,Actual.Teacher.IA,Actual.Teacher.ICT) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "AFA" = Actual.Teacher.AFA,
      "FCS" = Actual.Teacher.FCS,
      "IA" = Actual.Teacher.IA,
      "ICT" = Actual.Teacher.ICT)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$jhsdeployment_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION,Actual.Teacher.AFA,Actual.Teacher.FCS,Actual.Teacher.IA,Actual.Teacher.ICT) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "AFA" = Actual.Teacher.AFA,
      "FCS" = Actual.Teacher.FCS,
      "IA" = Actual.Teacher.IA,
      "ICT" = Actual.Teacher.ICT) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Actual_JHS_Teachers_Deployed", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Actual_JHS_Teachers_Deployed, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Actual_JHS_Teachers_Deployed,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$jhsdeployment_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION,Actual.Teacher.AFA,Actual.Teacher.FCS,Actual.Teacher.IA,Actual.Teacher.ICT) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "AFA" = Actual.Teacher.AFA,
      "FCS" = Actual.Teacher.FCS,
      "IA" = Actual.Teacher.IA,
      "ICT" = Actual.Teacher.ICT)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Actual_JHS_Teachers_Deployed", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Actual_JHS_Teachers_Deployed, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Actual_JHS_Teachers_Deployed, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Actual_JHS_Teachers_Deployed,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$lac_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("LAC.OFTEN")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$shifting_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("SHIFTING.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$shifting_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>%
    select(BASIC.REGION, contains("SHIFTING.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$shifting_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.DIVISION, contains("SHIFTING.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL) # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$ldm_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("LDM.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$ldm_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>%
    select(BASIC.REGION, contains("LDM.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$ldm_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.DIVISION, contains("LDM.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$adm_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("ALTERNATIVE.ADM")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$adm_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>%
    select(BASIC.REGION, contains("ALTERNATIVE.ADM")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$adm_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.DIVISION, contains("ALTERNATIVE.ADM")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$nat_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("NAT.K12.CURRICULUM.ALIGN"), -"NAT.K12.CURRICULUM.ALIGN_") %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$nat_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>%
    select(BASIC.REGION, contains("NAT.K12.CURRICULUM.ALIGN"), -"NAT.K12.CURRICULUM.ALIGN_") %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$nat_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.DIVISION, contains("NAT.K12.CURRICULUM.ALIGN"), -"NAT.K12.CURRICULUM.ALIGN_") %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$nat_sufficiency_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION,COMPRE_YES_NAT,YES_NAT,NOT_ADEQ_NAT,NO_NAT) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$nat_sufficiency_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>%
    select(BASIC.REGION, COMPRE_YES_NAT,YES_NAT,NOT_ADEQ_NAT,NO_NAT) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$nat_sufficiency_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.DIVISION,COMPRE_YES_NAT,YES_NAT,NOT_ADEQ_NAT,NO_NAT) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$elec_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION,GRID_ELEC,OFFGRID_ELEC,COMBINED_ELEC,NO_ELEC_) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$elec_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>%
    select(BASIC.REGION,GRID_ELEC,OFFGRID_ELEC,COMBINED_ELEC,NO_ELEC_) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$elec_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.DIVISION,GRID_ELEC,OFFGRID_ELEC,COMBINED_ELEC,NO_ELEC_) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$internet_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION,Broadband_MOOE,WiFi_Plan_MOOE,Mobile_Data,No_Internet_Available) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$internet_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>%
    select(BASIC.REGION,Broadband_MOOE,WiFi_Plan_MOOE,Mobile_Data,No_Internet_Available) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$internet_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.DIVISION,Broadband_MOOE,WiFi_Plan_MOOE,Mobile_Data,No_Internet_Available) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$internet_usage_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION,Combination_Internet,Instructional_Internet,Administrative_Internet,None_Internet) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$internet_usage_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>%
    select(BASIC.REGION,Combination_Internet,Instructional_Internet,Administrative_Internet,None_Internet) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$internet_usage_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.DIVISION,Combination_Internet,Instructional_Internet,Administrative_Internet,None_Internet) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$water_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.REGION,BASIC.DIVISION,GROUNDWATER_WATER,BOTTLED_WATER,MWSS_WATER,WELL_WATER,LOCAL_WATER,SURFACE_WATER,PIPEDL3_WATER) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$water_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>%
    select(BASIC.REGION,GROUNDWATER_WATER,BOTTLED_WATER,MWSS_WATER,WELL_WATER,LOCAL_WATER,SURFACE_WATER,PIPEDL3_WATER) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$water_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v3() %>%
    select(BASIC.DIVISION,GROUNDWATER_WATER,BOTTLED_WATER,MWSS_WATER,WELL_WATER,LOCAL_WATER,SURFACE_WATER,PIPEDL3_WATER) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$rf_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("QUALI.READING.PROFICIENCY.CHANGE")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$rf_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>%
    select(BASIC.REGION, contains("QUALI.READING.PROFICIENCY.CHANGE")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$rf_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.DIVISION, contains("QUALI.READING.PROFICIENCY.CHANGE")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$aral_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION,ARAL.MATH,ARAL.READING,ARAL.SCIENCE) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "PROSPECTIVE ARAL LEARNERS (MATH)" = ARAL.MATH,
      "PROSPECTIVE ARAL LEARNERS (READING)" = ARAL.READING,
      "PROSPECTIVE ARAL LEARNERS (SCIENCE)" = ARAL.SCIENCE)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$aral_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION,ARAL.MATH,ARAL.READING,ARAL.SCIENCE) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "PROSPECTIVE ARAL LEARNERS (MATH)" = ARAL.MATH,
      "PROSPECTIVE ARAL LEARNERS (READING)" = ARAL.READING,
      "PROSPECTIVE ARAL LEARNERS (SCIENCE)" = ARAL.SCIENCE)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$aral_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION,ARAL.MATH,ARAL.READING,ARAL.SCIENCE) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "PROSPECTIVE ARAL LEARNERS (MATH)" = ARAL.MATH,
      "PROSPECTIVE ARAL LEARNERS (READING)" = ARAL.READING,
      "PROSPECTIVE ARAL LEARNERS (SCIENCE)" = ARAL.SCIENCE)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$bully_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION,MENTAL.BULLYING.COUNT,MENTAL.CHILDREN.RIGHT.ORIENTATION) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "INCIDENCE OF BULLYING" = MENTAL.BULLYING.COUNT,
      "ATTENDANCE OF CHILDRENS' RIGHTS ORIENTATION" = MENTAL.CHILDREN.RIGHT.ORIENTATION)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$bully_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION,MENTAL.BULLYING.COUNT,MENTAL.CHILDREN.RIGHT.ORIENTATION) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "INCIDENCE OF BULLYING" = MENTAL.BULLYING.COUNT,
      "ATTENDANCE OF CHILDRENS' RIGHTS ORIENTATION" = MENTAL.CHILDREN.RIGHT.ORIENTATION)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$bully_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION,MENTAL.BULLYING.COUNT,MENTAL.CHILDREN.RIGHT.ORIENTATION) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "INCIDENCE OF BULLYING" = MENTAL.BULLYING.COUNT,
      "ATTENDANCE OF CHILDRENS' RIGHTS ORIENTATION" = MENTAL.CHILDREN.RIGHT.ORIENTATION)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$crla_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, CRLA.DEVELOPING, CRLA.LOW, CRLA.TRANSITIONAL, CRLA.HIGH, CRLA.GRADELEVEL) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "LOW" = CRLA.LOW,
      "DEVELOPING" = CRLA.DEVELOPING,
      "TRANSITIONAL" = CRLA.TRANSITIONAL,
      "HIGH" = CRLA.HIGH,
      "GRADE LEVEL" = CRLA.GRADELEVEL)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$crla_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, CRLA.DEVELOPING, CRLA.LOW, CRLA.TRANSITIONAL, CRLA.HIGH, CRLA.GRADELEVEL) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "LOW" = CRLA.LOW,
      "DEVELOPING" = CRLA.DEVELOPING,
      "TRANSITIONAL" = CRLA.TRANSITIONAL,
      "HIGH" = CRLA.HIGH,
      "GRADE LEVEL" = CRLA.GRADELEVEL)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$crla_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, CRLA.DEVELOPING, CRLA.LOW, CRLA.TRANSITIONAL, CRLA.HIGH, CRLA.GRADELEVEL) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "LOW" = CRLA.LOW,
      "DEVELOPING" = CRLA.DEVELOPING,
      "TRANSITIONAL" = CRLA.TRANSITIONAL,
      "HIGH" = CRLA.HIGH,
      "GRADE LEVEL" = CRLA.GRADELEVEL)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$philiri_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, PHILIRI.FRUSTRATION, PHILIRI.TRANSITIONAL, PHILIRI.INSTRUCTIONAL) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "FRUSTRATION" = PHILIRI.FRUSTRATION,
      "TRANSITIONAL" = PHILIRI.TRANSITIONAL,
      "INSTRUCTIONAL" = PHILIRI.INSTRUCTIONAL)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$philiri_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, PHILIRI.FRUSTRATION, PHILIRI.TRANSITIONAL, PHILIRI.INSTRUCTIONAL) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "FRUSTRATION" = PHILIRI.FRUSTRATION,
      "TRANSITIONAL" = PHILIRI.TRANSITIONAL,
      "INSTRUCTIONAL" = PHILIRI.INSTRUCTIONAL)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$philiri_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, PHILIRI.FRUSTRATION, PHILIRI.TRANSITIONAL, PHILIRI.INSTRUCTIONAL) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "FRUSTRATION" = PHILIRI.FRUSTRATION,
      "TRANSITIONAL" = PHILIRI.TRANSITIONAL,
      "INSTRUCTIONAL" = PHILIRI.INSTRUCTIONAL)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sha_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("SHA.CATEGORY")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$sha_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>%
    select(BASIC.REGION, contains("SHA.CATEGORY")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sha_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.DIVISION, contains("SHA.CATEGORY")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL) # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$feeding_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("SBFP.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$feeding_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, contains("SBFP.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$feeding_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("SBFP.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$years_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("SERVICE.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$years_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, contains("SERVICE.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$years_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("SERVICE.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL) # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$lac_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("LAC.")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$resources_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.REGION, BASIC.DIVISION, contains("RESOURCES.")) %>%
    mutate(across(3:last_col(), as.numeric)) %>%
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>%
    group_by(BASIC.REGION, BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    mutate(RESOURCES.MATH = round((`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` / (`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` + `RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_No`)) * 100, 2)) %>%
    mutate(RESOURCES.HANDWASHING = round((`RESOURCES.REGULAR.HANDWASHING_Yes` / (`RESOURCES.REGULAR.HANDWASHING_Yes` + `RESOURCES.REGULAR.HANDWASHING_No`)) * 100, 2)) %>%
    mutate(RESOURCES.SOAP = round((`RESOURCES.REGULAR.SOAP_Yes` / (`RESOURCES.REGULAR.SOAP_Yes` + `RESOURCES.REGULAR.SOAP_No`)) * 100, 2)) %>%
    mutate(RESOURCES.TVL = round((`RESOURCES.SCHOOL.WITH.TVL_Yes` / (`RESOURCES.SCHOOL.WITH.TVL_Yes` + `RESOURCES.SCHOOL.WITH.TVL_None`)) * 100, 2)) %>% 
    select(1:2,"RESOURCES.MATH","RESOURCES.HANDWASHING","RESOURCES.SOAP","RESOURCES.TVL")
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$resources_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>%
    select(BASIC.REGION, contains("RESOURCES.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    mutate(RESOURCES.MATH = round((`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` / (`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` + `RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_No`)) * 100, 2)) %>%
    mutate(RESOURCES.HANDWASHING = round((`RESOURCES.REGULAR.HANDWASHING_Yes` / (`RESOURCES.REGULAR.HANDWASHING_Yes` + `RESOURCES.REGULAR.HANDWASHING_No`)) * 100, 2)) %>%
    mutate(RESOURCES.SOAP = round((`RESOURCES.REGULAR.SOAP_Yes` / (`RESOURCES.REGULAR.SOAP_Yes` + `RESOURCES.REGULAR.SOAP_No`)) * 100, 2)) %>%
    mutate(RESOURCES.TVL = round((`RESOURCES.SCHOOL.WITH.TVL_Yes` / (`RESOURCES.SCHOOL.WITH.TVL_Yes` + `RESOURCES.SCHOOL.WITH.TVL_None`)) * 100, 2)) %>%
    # mutate(RESOURCES.CHAIR = round((`RESOURCES.CHAIR.FUNCTIONAL` / `RESOURCES.CHAIR.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.DESK = round((`RESOURCES.DESK.FUNCTIONAL` / `RESOURCES.DESK.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.ECART = round((`RESOURCES.ECART.FUNCTIONAL` / `RESOURCES.ECART.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.LAPTOP = round((`RESOURCES.LAPTOP.FUNCTIONAL` / `RESOURCES.LAPTOP.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.TOILET = round((`RESOURCES.FUNCTIONAL.TOILET` / `RESOURCES.NON.FUNCTIONAL.TOILET`) * 100, 2)) %>%
    # mutate(RESOURCES.TV = round((`RESOURCES.TV.FUNCTIONAL` / `RESOURCES.TV.INVENTORY`) * 100, 2))  
    select(1,"RESOURCES.MATH","RESOURCES.HANDWASHING","RESOURCES.SOAP","RESOURCES.TVL") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), mean, na.rm = TRUE)) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$resources_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region_v2() %>%
    select(BASIC.DIVISION, contains("RESOURCES.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    mutate(RESOURCES.MATH = round((`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` / (`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` + `RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_No`)) * 100, 2)) %>%
    mutate(RESOURCES.HANDWASHING = round((`RESOURCES.REGULAR.HANDWASHING_Yes` / (`RESOURCES.REGULAR.HANDWASHING_Yes` + `RESOURCES.REGULAR.HANDWASHING_No`)) * 100, 2)) %>%
    mutate(RESOURCES.SOAP = round((`RESOURCES.REGULAR.SOAP_Yes` / (`RESOURCES.REGULAR.SOAP_Yes` + `RESOURCES.REGULAR.SOAP_No`)) * 100, 2)) %>%
    mutate(RESOURCES.TVL = round((`RESOURCES.SCHOOL.WITH.TVL_Yes` / (`RESOURCES.SCHOOL.WITH.TVL_Yes` + `RESOURCES.SCHOOL.WITH.TVL_None`)) * 100, 2)) %>%
    # mutate(RESOURCES.CHAIR = round((`RESOURCES.CHAIR.FUNCTIONAL` / `RESOURCES.CHAIR.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.DESK = round((`RESOURCES.DESK.FUNCTIONAL` / `RESOURCES.DESK.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.ECART = round((`RESOURCES.ECART.FUNCTIONAL` / `RESOURCES.ECART.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.LAPTOP = round((`RESOURCES.LAPTOP.FUNCTIONAL` / `RESOURCES.LAPTOP.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.TOILET = round((`RESOURCES.FUNCTIONAL.TOILET` / `RESOURCES.NON.FUNCTIONAL.TOILET`) * 100, 2)) %>%
    # mutate(RESOURCES.TV = round((`RESOURCES.TV.FUNCTIONAL` / `RESOURCES.TV.INVENTORY`) * 100, 2))  
    select(1,"RESOURCES.MATH","RESOURCES.HANDWASHING","RESOURCES.SOAP","RESOURCES.TVL") %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~BASIC.DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)# Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$overload_data_table <- DT::renderDT({
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.REGION,BASIC.DIVISION, contains("DO5.OVERLOAD")) %>% 
    mutate(across(3:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.REGION,BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "DIVISION" = BASIC.DIVISION,
      "OVERLOAD PAY RECIPIENTS" = DO5.OVERLOAD.PAY.RECIPIENT)
  
  # You might want to add a check for NULL or empty data if filtered_school_data_division()
  # could return such states and you want to display a message or an empty table.
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    return(DT::datatable(
      data.frame("Message" = "No data available based on current selection."),
      options = list(dom = 't'), # 't' hides all controls, showing only the table body
      rownames = FALSE
    ))
  }
  
  DT::datatable(
    data_to_display,
    options = list(pageLength = 10, scrollX = TRUE),
    filter = 'top',
    selection = 'multiple',
    rownames = FALSE
  )
})

output$overload_regional_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>%
    select(BASIC.REGION, contains("DO5.OVERLOAD")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "OVERLOAD PAY RECIPIENTS" = DO5.OVERLOAD.PAY.RECIPIENT)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$overload_division_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- filtered_cloud_region() %>%
    select(BASIC.DIVISION, contains("DO5.OVERLOAD")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.DIVISION = as.character(BASIC.DIVISION)) %>%
    filter(BASIC.DIVISION != "") %>% 
    group_by(BASIC.DIVISION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "DIVISION" = BASIC.DIVISION,
      "OVERLOAD PAY RECIPIENTS" = DO5.OVERLOAD.PAY.RECIPIENT) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = Sections, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", DIVISION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for stacked bars
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) +
    facet_wrap(~DIVISION) + coord_flip()+
    labs(x = NULL, y = NULL, fill = NULL)
  # Center the plot title # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentDivisionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$enrolment_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,ENROLLMENT.KINDER,ENROLLMENT.G1,ENROLLMENT.G2,ENROLLMENT.G3,ENROLLMENT.G4,ENROLLMENT.G5,ENROLLMENT.G6,ENROLLMENT.G7,ENROLLMENT.G8,ENROLLMENT.G9,ENROLLMENT.G10,ENROLMENT.G11,ENROLMENT.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    rename("REGION" = BASIC.REGION,
           "KINDER" = ENROLLMENT.KINDER,
           "GRADE 1" = ENROLLMENT.G1,
           "GRADE 2" = ENROLLMENT.G2,
           "GRADE 3" = ENROLLMENT.G3,
           "GRADE 4" = ENROLLMENT.G4,
           "GRADE 5" = ENROLLMENT.G5,
           "GRADE 6" = ENROLLMENT.G6,
           "GRADE 7" = ENROLLMENT.G7,
           "GRADE 8" = ENROLLMENT.G8,
           "GRADE 9" = ENROLLMENT.G9,
           "GRADE 10" = ENROLLMENT.G10,
           "GRADE 11" = ENROLMENT.G11,
           "GRADE 12" = ENROLMENT.G12) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Enrolment", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(Enrolment = factor(Enrolment, levels = c(
      "KINDER", "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Enrolment, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Enrolment,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sned_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, ENROLMENT.KINDER.SNED, SPECIAL.NEEDS.G1, SPECIAL.NEEDS.G2, SPECIAL.NEEDS.G3, SPECIAL.NEEDS.G4, SPECIAL.NEEDS.G5, SPECIAL.NEEDS.G6, SPECIAL.NEEDS.G7, SPECIAL.NEEDS.G8, SPECIAL.NEEDS.G9, SPECIAL.NEEDS.G10) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "KINDER" = ENROLMENT.KINDER.SNED,
      "GRADE 1" = SPECIAL.NEEDS.G1,
      "GRADE 2" = SPECIAL.NEEDS.G2,
      "GRADE 3" = SPECIAL.NEEDS.G3,
      "GRADE 4" = SPECIAL.NEEDS.G4,
      "GRADE 5" = SPECIAL.NEEDS.G5,
      "GRADE 6" = SPECIAL.NEEDS.G6,
      "GRADE 7" = SPECIAL.NEEDS.G7,
      "GRADE 8" = SPECIAL.NEEDS.G8,
      "GRADE 9" = SPECIAL.NEEDS.G9,
      "GRADE 10" = SPECIAL.NEEDS.G10
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "SNED_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    mutate(SNED_Learners = factor(SNED_Learners, levels = c(
      "KINDER", "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10")))
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = SNED_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", SNED_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$ip_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, IP.KINDER.IP, IP.G1.IP, IP.G2.IP, IP.G3.IP, IP.G4.IP, IP.G5.IP, IP.G6.IP, IP.G7.IP, IP.G8.IP, IP.G9.IP, IP.G10.IP, IP.G11, IP.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "REGION" = BASIC.REGION,
      "KINDER" = IP.KINDER.IP,
      "GRADE 1" = IP.G1.IP,
      "GRADE 2" = IP.G2.IP,
      "GRADE 3" = IP.G3.IP,
      "GRADE 4" = IP.G4.IP,
      "GRADE 5" = IP.G5.IP,
      "GRADE 6" = IP.G6.IP,
      "GRADE 7" = IP.G7.IP,
      "GRADE 8" = IP.G8.IP,
      "GRADE 9" = IP.G9.IP,
      "GRADE 10" = IP.G10.IP,
      "GRADE 11" = IP.G11,
      "GRADE 12" = IP.G12
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "IP_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(IP_Learners = factor(IP_Learners, levels = c(
      "KINDER", "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = IP_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", IP_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$muslim_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, MUSLIM.KINDER.MUSLIM, MUSLIM.G1.MUSLIM, MUSLIM.G2.MUSLIM, MUSLIM.G3.MUSLIM, MUSLIM.G4.MUSLIM, MUSLIM.G5.MUSLIM, MUSLIM.G6.MUSLIM, MUSLIM.G7.MUSLIM, MUSLIM.G8.MUSLIM, MUSLIM.G9.MUSLIM, MUSLIM.G10.MUSLIM, MUSLIM.G11, MUSLIM.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      'KINDER' = MUSLIM.KINDER.MUSLIM,
      "GRADE 1" = MUSLIM.G1.MUSLIM,
      "GRADE 2" = MUSLIM.G2.MUSLIM,
      "GRADE 3" = MUSLIM.G3.MUSLIM,
      "GRADE 4" = MUSLIM.G4.MUSLIM,
      "GRADE 5" = MUSLIM.G5.MUSLIM,
      "GRADE 6" = MUSLIM.G6.MUSLIM,
      "GRADE 7" = MUSLIM.G7.MUSLIM,
      "GRADE 8" = MUSLIM.G8.MUSLIM,
      "GRADE 9" = MUSLIM.G9.MUSLIM,
      "GRADE 10" = MUSLIM.G10.MUSLIM,
      "GRADE 11" = MUSLIM.G11,
      "GRADE 12" = MUSLIM.G12
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Muslim_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(Muslim_Learners = factor(Muslim_Learners, levels = c(
      "KINDER", "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Muslim_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Muslim_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="stack" for stacked bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$totalenrolment_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  t1 <- cloud  %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%  
    select(BASIC.REGION,ENROLLMENT.KINDER,ENROLLMENT.G1,ENROLLMENT.G2,ENROLLMENT.G3,ENROLLMENT.G4,ENROLLMENT.G5,ENROLLMENT.G6,ENROLLMENT.G7,ENROLLMENT.G8,ENROLLMENT.G9,ENROLLMENT.G10,ENROLMENT.G11,ENROLMENT.G12) %>% mutate(Total.Enrollment = rowSums(select(., 2:ncol(.)))) %>% select(BASIC.REGION,Total.Enrollment)
  
  t2 <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, ENROLMENT.KINDER.SNED, SPECIAL.NEEDS.G1, SPECIAL.NEEDS.G2, SPECIAL.NEEDS.G3, SPECIAL.NEEDS.G4, SPECIAL.NEEDS.G5, SPECIAL.NEEDS.G6, SPECIAL.NEEDS.G7, SPECIAL.NEEDS.G8, SPECIAL.NEEDS.G9, SPECIAL.NEEDS.G10) %>% mutate(Total.SNED = rowSums(select(., 2:ncol(.)))) %>% select(Total.SNED)
  
  t3 <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, IP.KINDER.IP, IP.G1.IP, IP.G2.IP, IP.G3.IP, IP.G4.IP, IP.G5.IP, IP.G6.IP, IP.G7.IP, IP.G8.IP, IP.G9.IP, IP.G10.IP, IP.G11, IP.G12) %>% mutate(Total.IP = rowSums(select(., 2:ncol(.)))) %>% select(Total.IP)
  
  t4 <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, MUSLIM.KINDER.MUSLIM, MUSLIM.G1.MUSLIM, MUSLIM.G2.MUSLIM, MUSLIM.G3.MUSLIM, MUSLIM.G4.MUSLIM, MUSLIM.G5.MUSLIM, MUSLIM.G6.MUSLIM, MUSLIM.G7.MUSLIM, MUSLIM.G8.MUSLIM, MUSLIM.G9.MUSLIM, MUSLIM.G10.MUSLIM, MUSLIM.G11, MUSLIM.G12) %>% mutate(Total.Muslim = rowSums(select(., 2:ncol(.)))) %>% select(Total.Muslim)
  
  t5 <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, DISPLACED.KINDERGARTEN.DISPLACED.LEARNER, DISPLACED.GRADE1.DISPLACED.LEARNER, DISPLACED.GRADE2.DISPLACED.LEARNER, DISPLACED.GRADE3.DISPLACED.LEARNER, DISPLACED.GRADE4.DISPLACED.LEARNER, DISPLACED.GRADE5.DISPLACED.LEARNER, DISPLACED.GRADE6.DISPLACED.LEARNER,DISPLACED.G7.DISPLACED,DISPLACED.G8.DISPLACED,DISPLACED.G9.DISPLACED,DISPLACED.G10.DISPLACED,DISPLACED.G11,DISPLACED.G12) %>% mutate(Total.Displaced = rowSums(select(., 2:ncol(.)))) %>% select(Total.Displaced)
  
  tall <- cbind(t1,t2,t3,t4,t5)
  
  data_to_display <- tall %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "SNED LEARNERS" = Total.SNED,
      "MUSLIM LEARNERS" = Total.Muslim,
      "IP LEARNERS" = Total.IP,
      "DISPLACED LEARNERS" = Total.Displaced,
      "TOTAL LEARNERS" = Total.Enrollment
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Learner_Type", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(Learner_Type = factor(Learner_Type, levels = c(
      "SNED LEARNERS", "MUSLIM LEARNERS", "IP LEARNERS",
      "DISPLACED LEARNERS", "TOTAL LEARNERS"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Learner_Type, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Learner_Type,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "Region",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$displaced_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, DISPLACED.KINDERGARTEN.DISPLACED.LEARNER, DISPLACED.GRADE1.DISPLACED.LEARNER, DISPLACED.GRADE2.DISPLACED.LEARNER, DISPLACED.GRADE3.DISPLACED.LEARNER, DISPLACED.GRADE4.DISPLACED.LEARNER, DISPLACED.GRADE5.DISPLACED.LEARNER, DISPLACED.GRADE6.DISPLACED.LEARNER,DISPLACED.G7.DISPLACED,DISPLACED.G8.DISPLACED,DISPLACED.G9.DISPLACED,DISPLACED.G10.DISPLACED,DISPLACED.G11,DISPLACED.G12) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "KINDER" = DISPLACED.KINDERGARTEN.DISPLACED.LEARNER,
      "GRADE 1" = DISPLACED.GRADE1.DISPLACED.LEARNER,
      "GRADE 2" = DISPLACED.GRADE2.DISPLACED.LEARNER,
      "GRADE 3" = DISPLACED.GRADE3.DISPLACED.LEARNER,
      "GRADE 4" = DISPLACED.GRADE4.DISPLACED.LEARNER,
      "GRADE 5" = DISPLACED.GRADE5.DISPLACED.LEARNER,
      "GRADE 6" = DISPLACED.GRADE6.DISPLACED.LEARNER,
      "GRADE 7" = DISPLACED.G7.DISPLACED,
      "GRADE 8" = DISPLACED.G8.DISPLACED,
      "GRADE 9" = DISPLACED.G9.DISPLACED,
      "GRADE 10" = DISPLACED.G10.DISPLACED,
      "GRADE 11" = DISPLACED.G11,
      "GRADE 12" = DISPLACED.G12
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Displaced_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )  %>%
    mutate(Displaced_Learners = factor(Displaced_Learners, levels = c(
      "KINDER", "GRADE 1", "GRADE 2", "GRADE 3",
      "GRADE 4", "GRADE 5", "GRADE 6",
      "GRADE 7", "GRADE 8", "GRADE 9",
      "GRADE 10", "GRADE 11", "GRADE 12"
    ))) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Displaced_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Displaced_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "Region",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$als_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("ENROLLEDALS.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "ES" = ENROLLEDALS.ELEM.ALS,
      "JHS" = ENROLLEDALS.JHS.ALS,
      "SHS" = ENROLLEDALS.SHS.ALS
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "ALS_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = ALS_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", ALS_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$dropout_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, DROPOUT.PREVSY) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "NUMBER OF DROPOUTS (PREVIOUS SY)" = DROPOUT.PREVSY) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sosss_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("SOSSS.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$extension_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("EXTENSION.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$teacherinventory_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, TEACHING.PERSONNEL.ELEM, TEACHING.PERSONNEL.JHS, TEACHING.PERSONNEL.SHS) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "ES" = TEACHING.PERSONNEL.ELEM,
      "JHS" = TEACHING.PERSONNEL.JHS,
      "SHS" = TEACHING.PERSONNEL.SHS
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Number_of_Teaching_Personnel", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Number_of_Teaching_Personnel, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Number_of_Teaching_Personnel,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$classroom_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, NO.CLASSROOM.ELEM, NO.CLASSROOM.SNED.ELEM, NO.CLASSROOM.JHS, NO.CLASSROOM.SNED.JHS, NO.CLASSROOM.SHS) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "ES" = NO.CLASSROOM.ELEM,
      "JHS" = NO.CLASSROOM.JHS,
      "SHS" = NO.CLASSROOM.SHS,
      "SNED-ES" = NO.CLASSROOM.SNED.ELEM,
      "SNED-JHS" = NO.CLASSROOM.SNED.JHS)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Number_of_Classrooms", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Number_of_Classrooms, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Number_of_Classrooms,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5))
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$multigrade_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("MG.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "G1 & G2" = MG.CLASSES.1.2,
      "G3 & G4" = MG.CLASSES.3.4,
      "G5 & G6" = MG.CLASSES.5.6
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Multigrade", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Multigrade, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Multigrade,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$organizedclass_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, CLASS.ORG.BELOW, CLASS.ORG.ABOVE, CLASS.ORG.WITHIN) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "BELOW THE STANDARD" = CLASS.ORG.BELOW,
      "ABOVE THE STANDARD" = CLASS.ORG.ABOVE,
      "WITHIN THE STANDARD" = CLASS.ORG.WITHIN
    )  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Classes_Organized", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) %>%
    # This is the key change: Convert 'Classes_Organized' to a factor with specific levels
    mutate(Classes_Organized = factor(Classes_Organized, levels = c(
      "BELOW THE STANDARD",
      "WITHIN THE STANDARD",
      "ABOVE THE STANDARD"
    )))
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Classes_Organized, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Classes_Organized,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    scale_fill_manual(values = c(
      "BELOW THE STANDARD" = "blue",
      "WITHIN THE STANDARD" = "green", # Optional: you can set a color for this too
      "ABOVE THE STANDARD" = "red"
    )) +
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$jhsdeployment_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,Actual.Teacher.AFA,Actual.Teacher.FCS,Actual.Teacher.IA,Actual.Teacher.ICT) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "AFA" = Actual.Teacher.AFA,
      "FCS" = Actual.Teacher.FCS,
      "IA" = Actual.Teacher.IA,
      "ICT" = Actual.Teacher.ICT) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Actual_JHS_Teachers_Deployed", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Actual_JHS_Teachers_Deployed, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Actual_JHS_Teachers_Deployed,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$shifting_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("LAC.OFTEN")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename("Annually" = LAC.OFTEN.ANNUALLY,
           "As need arises"= LAC.OFTEN.NEED.ARISES,
           "Once a month" = LAC.OFTEN.ONCE.A.MONTH,
           "Quarterly" = LAC.OFTEN.QUARTERLY,
           "Semi-annually" = LAC.OFTEN.SEMIANNUALLY,
           "Twice a month" = LAC.OFTEN.TWICE.A.MONTH
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "LAC_Sessions", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = LAC_Sessions, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", LAC_Sessions,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$ldm_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("LDM.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$adm_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("ALTERNATIVE.ADM")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$nat_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("NAT.K12.CURRICULUM.ALIGN"), -"NAT.K12.CURRICULUM.ALIGN_") %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "Moderately Aligned" = NAT.K12.CURRICULUM.ALIGN_Moderately_aligned ,
      "Not at all aligned" = NAT.K12.CURRICULUM.ALIGN_Not_at_all_aligned,
      "Slightly Aligned" = NAT.K12.CURRICULUM.ALIGN_Slightly_aligned,
      "Very well Aligned" = NAT.K12.CURRICULUM.ALIGN_Very_well_aligned,
      "Well Aligned" = NAT.K12.CURRICULUM.ALIGN_Well_aligned
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "NAT_alignment_to_Curriculum", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = NAT_alignment_to_Curriculum, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", NAT_alignment_to_Curriculum,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$nat_sufficiency_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, COMPRE_YES_NAT,YES_NAT,NOT_ADEQ_NAT,NO_NAT) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      ""
    )
  pivot_longer(
    cols = 2:last_col(), # Specifies the columns to pivot
    names_to = "Sections", # The new column to hold the original column names
    values_to = "Count" # The new column to hold the values
  )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$elec_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,GRID_ELEC,OFFGRID_ELEC,COMBINED_ELEC,NO_ELEC_) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "GRID" = GRID_ELEC,
      "OFF-GRID" = OFFGRID_ELEC,
      "COMBINED" = COMBINED_ELEC,
      "NO ELECTRICITY" = NO_ELEC_
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Electricity_Source", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Electricity_Source, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Electricity_Source,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$internet_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,Broadband_MOOE,WiFi_Plan_MOOE,Mobile_Data,No_Internet_Available) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "Broadband" = Broadband_MOOE,
      "WiFi Plan" = WiFi_Plan_MOOE,
      "Mobile Data" = Mobile_Data,
      "No Internet Available" = No_Internet_Available 
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Internet_Source", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Internet_Source, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Internet_Source,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$internet_usage_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,Combination_Internet,Instructional_Internet,Administrative_Internet,None_Internet) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "Instructional" = Instructional_Internet,
      "Administrative" = Administrative_Internet,
      "Combination" = Combination_Internet,
      "None" = None_Internet
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Internet_Usage", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Internet_Usage, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Internet_Usage,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$water_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v3 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,GROUNDWATER_WATER,BOTTLED_WATER,MWSS_WATER,WELL_WATER,LOCAL_WATER,SURFACE_WATER,PIPEDL3_WATER) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "Bottled Water" = BOTTLED_WATER,
      "Groundwater" = GROUNDWATER_WATER,
      "Local Water" = LOCAL_WATER,
      "MWSS" = MWSS_WATER,
      "Piped Water" = PIPEDL3_WATER,
      "Surface Water" = SURFACE_WATER,
      "Well Water" = WELL_WATER
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Water_Source", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Water_Source, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Water_Source,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$adm_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("ALTERNATIVE.ADM")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$rf_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("QUALI.READING.PROFICIENCY.CHANGE")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "Declined" = QUALI.READING.PROFICIENCY.CHANGE_Declined,
      "Improved" = QUALI.READING.PROFICIENCY.CHANGE_Improved,
      "Stagnant" = QUALI.READING.PROFICIENCY.CHANGE_Stagnant
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Reading_Proficiency", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Reading_Proficiency, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Reading_Proficiency,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$aral_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,ARAL.MATH,ARAL.READING,ARAL.SCIENCE) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "MATH" = ARAL.MATH,
      "READING" = ARAL.READING,
      "SCIENCE" = ARAL.SCIENCE)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Prospective_ARAL_Learners", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Prospective_ARAL_Learners, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Prospective_ARAL_Learners,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$bully_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION,MENTAL.BULLYING.COUNT,MENTAL.CHILDREN.RIGHT.ORIENTATION) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "INCIDENCE OF BULLYING" = MENTAL.BULLYING.COUNT,
      "ATTENDANCE TO CHILDRENS' RIGHTS ORIENTATION" = MENTAL.CHILDREN.RIGHT.ORIENTATION)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$crla_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, CRLA.DEVELOPING, CRLA.LOW, CRLA.TRANSITIONAL, CRLA.HIGH, CRLA.GRADELEVEL) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "LOW" = CRLA.LOW,
      "DEVELOPING" = CRLA.DEVELOPING,
      "TRANSITIONAL" = CRLA.TRANSITIONAL,
      "HIGH" = CRLA.HIGH,
      "GRADE LEVEL" = CRLA.GRADELEVEL)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "CRLA_Levels", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = CRLA_Levels, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", CRLA_Levels,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$philiri_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, PHILIRI.FRUSTRATION, PHILIRI.TRANSITIONAL, PHILIRI.INSTRUCTIONAL) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "FRUSTRATION" = PHILIRI.FRUSTRATION,
      "TRANSITIONAL" = PHILIRI.TRANSITIONAL,
      "INSTRUCTIONAL" = PHILIRI.INSTRUCTIONAL)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "PhilIRI_Levels", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = PhilIRI_Levels, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", PhilIRI_Levels,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$sha_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("SHA.CATEGORY")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$feeding_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("SBFP.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>% 
    rename(
      "DepEd Beneficiary" = SBFP.BENEFICIARY,
      "Non-DepEd Beneficiary" = SBFP.NO.OF.BENEFICIARIES.NOT.SBFP
    ) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Feeding_Program_Beneficiaries", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Feeding_Program_Beneficiaries, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Feeding_Program_Beneficiaries,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$years_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("SERVICE.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE))  %>%
    rename("Less than 1 year" = SERVICE.X0.TO.1,
           "2-5 years" = SERVICE.X2.TO.5,
           "6-10 years" = SERVICE.X6.TO.10,
           "11-15 years" = SERVICE.X11.TO.15,
           "16-20 years" = SERVICE.X16.TO.20,
           "21-25 years" = SERVICE.X21.TO.25,
           "26-30 years" = SERVICE.X26.TO.30,
           "31-35 years" = SERVICE.X31.TO.35,
           "36-40 years" = SERVICE.X36.TO.40,
           "41-45 years" = SERVICE.X41.TO.45) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Years_in_Service", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Years_in_Service, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Years_in_Service,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$resources_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud_v2 %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("RESOURCES.")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>%
    mutate(RESOURCES.MATH = round((`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` / (`RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_Yes` + `RESOURCES.RECEIVED.SCIENCE.MATH.EQUIPMENT_No`)) * 100, 2)) %>%
    mutate(RESOURCES.HANDWASHING = round((`RESOURCES.REGULAR.HANDWASHING_Yes` / (`RESOURCES.REGULAR.HANDWASHING_Yes` + `RESOURCES.REGULAR.HANDWASHING_No`)) * 100, 2)) %>%
    mutate(RESOURCES.SOAP = round((`RESOURCES.REGULAR.SOAP_Yes` / (`RESOURCES.REGULAR.SOAP_Yes` + `RESOURCES.REGULAR.SOAP_No`)) * 100, 2)) %>%
    mutate(RESOURCES.TVL = round((`RESOURCES.SCHOOL.WITH.TVL_Yes` / (`RESOURCES.SCHOOL.WITH.TVL_Yes` + `RESOURCES.SCHOOL.WITH.TVL_None`)) * 100, 2)) %>%
    # mutate(RESOURCES.CHAIR = round((`RESOURCES.CHAIR.FUNCTIONAL` / `RESOURCES.CHAIR.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.DESK = round((`RESOURCES.DESK.FUNCTIONAL` / `RESOURCES.DESK.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.ECART = round((`RESOURCES.ECART.FUNCTIONAL` / `RESOURCES.ECART.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.LAPTOP = round((`RESOURCES.LAPTOP.FUNCTIONAL` / `RESOURCES.LAPTOP.INVENTORY`) * 100, 2)) %>%
    # mutate(RESOURCES.TOILET = round((`RESOURCES.FUNCTIONAL.TOILET` / `RESOURCES.NON.FUNCTIONAL.TOILET`) * 100, 2)) %>%
    # mutate(RESOURCES.TV = round((`RESOURCES.TV.FUNCTIONAL` / `RESOURCES.TV.INVENTORY`) * 100, 2))  
    select(1,"RESOURCES.MATH","RESOURCES.HANDWASHING","RESOURCES.SOAP","RESOURCES.TVL") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), mean, na.rm = TRUE)) %>% 
    rename("Handwashing" = RESOURCES.HANDWASHING,
           "Soap" = RESOURCES.SOAP,
           "Math" = RESOURCES.MATH,
           "TVL" = RESOURCES.TVL) %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Resources_Data", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    ) 
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = BASIC.REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Resources_Data, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", BASIC.REGION,
                               "<br>Section: ", Resources_Data,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})

output$overload_regional_profile_graph <- renderPlotly({
  # Use the reactive filtered data
  
  data_to_display <- cloud %>% filter(BASIC.REGION == input$cloud_region_profile_filter) %>%
    select(BASIC.REGION, contains("DO5.OVERLOAD")) %>% 
    mutate(across(2:last_col(), as.numeric)) %>% 
    mutate(BASIC.REGION = as.character(BASIC.REGION)) %>%
    filter(BASIC.REGION != "") %>% 
    group_by(BASIC.REGION) %>%
    summarise(across(everything(), sum, na.rm = TRUE)) %>% 
    rename(
      "REGION" = BASIC.REGION,
      "OVERLOAD PAY RECIPIENTS" = DO5.OVERLOAD.PAY.RECIPIENT)  %>% 
    pivot_longer(
      cols = 2:last_col(), # Specifies the columns to pivot
      names_to = "Sections", # The new column to hold the original column names
      values_to = "Count" # The new column to hold the values
    )
  
  current_filtered_data <- data_to_display
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(ggplotly(ggplot() +
                      annotate("text", x = 0.5, y = 0.5, label = "No data for selected regions/divisions") +
                      theme_void()))
  }
  
  # Prepare the data for plotting
  plot_data <- data_to_display
  
  # Create the ggplot
  p <- ggplot(plot_data,
              aes(x = REGION, # Reorder regions based on overall total count for the region
                  y = Count,
                  fill = Sections, # Fill by Clustering.Status for coloring and consistent order
                  text = paste("Region: ", REGION,
                               "<br>Section: ", Sections,
                               "<br>Count: ", scales::comma(Count)))) + # Custom tooltip text
    geom_bar(stat = "identity", position = "dodge", color = "black") + # Changed to position="dodge" for dodgeed bars
    labs(x = "",
         y = "") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis labels as comma-separated numbers
    theme_minimal() +
    theme(axis.text.x = element_text(size = 10, angle = 45, hjust = 1),
          legend.position = "bottom", # Position legend at the bottom
          plot.title = element_text(hjust = 0.5)) # Center the plot title
  
  # Convert ggplot to plotly, ensuring custom text is used for hover
  ggplotly(p, tooltip = "text", source = "cloudenrolmentRegionPlot") %>%
    layout(hoverlabel = list(bgcolor = "white"),
           margin = list(b = 100)) # Increase bottom margin for x-axis labels
})