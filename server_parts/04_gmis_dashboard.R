# 04_gmis_dashboard

updateSelectInput(
  session = session,
  inputId = "position_filter",
  choices = all_positions,
  selected = "Teacher I"
)

# ============================================================
# PLOT 1: OVERALL
# ============================================================

# 1a. Prepare data for Plot 1
dfgmisplot <- reactive({
  # <--- FIX: Use the global dfGMIS, don't read the CSV again
  dfGMIS %>%
    group_by(Old.Region) %>%
    summarise(
      Filled = sum(Total.Filled, na.rm = TRUE),
      Unfilled = sum(Total.Unfilled, na.rm = TRUE),
      .groups = 'drop'
    ) %>%
    rename(Group = Old.Region)
})

# 1b. Render Plot 1
output$overall_GMIS <- renderPlotly({
  # <--- FIX: Use the reactive 'dfgmisplot()' created above
  dfgmis_plot1 <- dfgmisplot() %>%
    pivot_longer(
      cols = c(Filled, Unfilled),
      names_to = "Status",
      values_to = "Count"
    )
  
  p <- plot_ly(
    data = dfgmis_plot1,
    y = ~Group,
    x = ~Count,
    color = ~Status,
    colors = c("Filled" = "#198754", "Unfilled" = "#DC3545"),
    type = "bar",
    orientation = "h"
  ) %>%
    layout(
      barmode = "stack",
      yaxis = list(title = "", categoryorder = "total ascending"),
      xaxis = list(title = "Total Positions"),
      legend = list(title = list(text = "Status")),
      clickmode = "none"
    )
  
  p
})

# 1c & 1d: Click and "Back" observers REMOVED

# 1e. Render dynamic value boxes for Plot 1 (No Change)
output$value_box_1_filled <- renderUI({
  current_data <- dfgmisplot()
  total_filled <- sum(current_data$Filled, na.rm = TRUE)
  value_box(
    title = "Filled (Current View)",
    value = format(total_filled, big.mark = ","),
    showcase = bsicons::bs_icon("person-check"),
    theme = "bg-gradient-success-light"
  )
})

output$value_box_1_unfilled <- renderUI({
  current_data <- dfgmisplot()
  total_unfilled <- sum(current_data$Unfilled, na.rm = TRUE)
  value_box(
    title = "Unfilled (Current View)",
    value = format(total_unfilled, big.mark = ","),
    showcase = bsicons::bs_icon("person-x"),
    theme = "bg-gradient-danger-light"
  )
})


# --- Plot 2: Filtered Regional Plot ---

# 2a. Prepare dfGMIS for Plot 2 (Simplified)
# 2a. Prepare data for Plot 2
data_for_plot2x <- reactive({
  req(input$position_filter) # Good, this prevents errors on startup
  
  # <--- FIX: Start with the global dfGMIS
  filtered_datax <- dfGMIS 
  
  # <--- FIX: Apply the filter logic correctly
  if (input$position_filter != "All") {
    filtered_datax <- filtered_datax %>%
      filter(Position == input$position_filter)
  }
  
  # Now, group the filtered data (which is either "All" or one position)
  filtered_datax %>%
    group_by(Old.Region) %>%
    summarise(
      Filled = sum(Total.Filled, na.rm = TRUE),
      Unfilled = sum(Total.Unfilled, na.rm = TRUE),
      .groups = 'drop'
    ) %>%
    rename(Group = Old.Region)
})

# 2b. Render Plot 2 (This logic was fine, it just needed 'data_for_plot2x' to work)
output$filtered_GMIS <- renderPlotly({
  dfgmis_plot1x <- data_for_plot2x() %>%
    pivot_longer(
      cols = c(Filled, Unfilled),
      names_to = "Status",
      values_to = "Count"
    )
  
  q <- plot_ly(
    data = dfgmis_plot1x,
    y = ~Group,
    x = ~Count,
    color = ~Status,
    colors = c("Filled" = "#198754", "Unfilled" = "#DC3545"),
    type = "bar",
    orientation = "h"
  ) %>%
    layout(
      barmode = "stack",
      yaxis = list(title = "", categoryorder = "total ascending"),
      xaxis = list(title = "Total Positions"),
      showlegend = FALSE,
      clickmode = "none"
    )
  
  q
})

# 2c, 2d, 2e: Click, "Back", and filter observers REMOVED

# 2f. Render dynamic value boxes for Plot 2 (No Change)
output$value_box_2_filled <- renderUI({
  current_data <- data_for_plot2x()
  total_filled <- sum(current_data$Filled, na.rm = TRUE)
  value_box(
    title = "Filled (Filtered View)",
    value = format(total_filled, big.mark = ","),
    showcase = bsicons::bs_icon("person-check"),
    theme = "bg-gradient-success-light"
  )
})

output$value_box_2_unfilled <- renderUI({
  current_data <- data_for_plot2x()
  total_unfilled <- sum(current_data$Unfilled, na.rm = TRUE)
  value_box(
    title = "Unfilled (Filtered View)",
    value = format(total_unfilled, big.mark = ","),
    showcase = bsicons::bs_icon("person-x"),
    theme = "bg-gradient-danger-light"
  )
})