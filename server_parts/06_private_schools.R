# 06_private_schools

# --- PRIVATE SCHOOLS DRILLDOWN GRAPH (NEW) ---

private_drilldown <- reactiveVal(list(level = "region", filter = NULL))

# Filtered dataset depending on drilldown
filtered_private_data <- reactive({
  state <- private_drilldown()
  data <- PrivateSchools
  
  if (state$level == "region" && !is.null(state$filter)) {
    data <- data %>% filter(Region == state$filter)
  } else if (state$level == "division" && !is.null(state$filter)) {
    data <- data %>% filter(Division == state$filter)
  } else if (state$level == "district" && !is.null(state$filter)) {
    data <- data %>% filter(Legislative.District == state$filter)
  }
  
  data
})

# --- Total Private Schools ---
output$total_private_schools_box <- renderUI({
  total <- nrow(filtered_private_data())
  card(
    style = "background-color: #FFFFFF;",
    card_header("Total Private Schools", class = "text-center"),
    card_body(tags$h3(scales::comma(total),
                      style = "text-align:center; font-weight:700; color:#17428C;"))
  )
})

output$total_private_seats_box <- renderUI({
  total_seats <- sum(filtered_private_data()$Seats, na.rm = TRUE)
  card(
    style = "background-color: #FFFFFF;",
    card_header("Total Seats in Private Schools", class = "text-center"),
    card_body(tags$h3(scales::comma(total_seats),
                      style = "text-align:center; font-weight:700; color:#17428C;"))
  )
})

output$private_schools_count_plot <- renderPlotly({
  state <- private_drilldown()
  data <- PrivateSchools
  
  if (state$level == "region") {
    df <- data %>%
      group_by(Region) %>%
      summarise(PrivateSchools = n()) %>%
      arrange(desc(PrivateSchools))    # highest first
    title <- "Number of Private Schools per Region"
    ycol <- ~Region
  } else if (state$level == "division") {
    df <- data %>%
      filter(Region == state$filter) %>%
      group_by(Division) %>%
      summarise(PrivateSchools = n()) %>%
      arrange(desc(PrivateSchools))
    title <- paste("Number of Private Schools in", state$filter)
    ycol <- ~Division
  } else {
    df <- data %>%
      filter(Division == state$filter) %>%
      group_by(Legislative.District) %>%
      summarise(PrivateSchools = n()) %>%
      arrange(desc(PrivateSchools))
    title <- paste("Private Schools by Legislative District in", state$filter)
    ycol <- ~`Legislative.District`
  }
  
  plot_ly(
    df,
    y = ycol,
    x = ~PrivateSchools,
    type = "bar",
    color = I("#17428C"),
    text = ~scales::comma(PrivateSchools),
    textposition = "outside",
    source = "private_school_drill"
  ) %>%
    layout(
      title = list(text = title, x = 0, font = list(size = 18, family = "Poppins")),
      xaxis = list(title = "Number of Private Schools"),
      yaxis = list(title = "", automargin = TRUE),
      margin = list(l = 130, r = 50, t = 60, b = 40),
      showlegend = FALSE,
      height = 600
    )
})

output$private_schools_seats_plot <- renderPlotly({
  state <- private_drilldown()
  data <- PrivateSchools
  
  if (state$level == "region") {
    df <- data %>%
      group_by(Region) %>%
      summarise(TotalSeats = sum(Seats, na.rm = TRUE)) %>%
      arrange(desc(TotalSeats))
    title <- "Number of Seats in Private Schools per Region"
    ycol <- ~Region
  } else if (state$level == "division") {
    df <- data %>%
      filter(Region == state$filter) %>%
      group_by(Division) %>%
      summarise(TotalSeats = sum(Seats, na.rm = TRUE)) %>%
      arrange(desc(TotalSeats))
    title <- paste("Number of Seats in Private Schools in", state$filter)
    ycol <- ~Division
  } else {
    df <- data %>%
      filter(Division == state$filter) %>%
      group_by(Legislative.District) %>%
      summarise(TotalSeats = sum(Seats, na.rm = TRUE)) %>%
      arrange(desc(TotalSeats))
    title <- paste("Seats in Private Schools by Legislative District in", state$filter)
    ycol <- ~`Legislative.District`
  }
  
  plot_ly(
    df,
    y = ycol,
    x = ~TotalSeats,
    type = "bar",
    orientation = "h",
    color = I("#1D75BC"),
    text = ~scales::comma(TotalSeats),
    textposition = "outside",
    source = "private_seats_drill"
  ) %>%
    layout(
      title = list(text = title, x = 0, font = list(size = 18, family = "Poppins")),
      xaxis = list(title = "Number of Seats"),
      yaxis = list(title = "", autorange = "reversed"),
      margin = list(l = 130, r = 50, t = 60, b = 40),
      showlegend = FALSE,
      height = 600
    )
})

# === Drilldown on click ===
observeEvent(event_data("plotly_click", source = "private_school_drill"), {
  click <- event_data("plotly_click", source = "private_school_drill")$y
  if (is.null(click)) return()
  state <- private_drilldown()
  if (state$level == "region") {
    private_drilldown(list(level = "division", filter = click))
  } else if (state$level == "division") {
    private_drilldown(list(level = "district", filter = click))
  }
})

observeEvent(event_data("plotly_click", source = "private_seats_drill"), {
  click <- event_data("plotly_click", source = "private_seats_drill")$y
  if (is.null(click)) return()
  state <- private_drilldown()
  if (state$level == "region") {
    private_drilldown(list(level = "division", filter = click))
  } else if (state$level == "division") {
    private_drilldown(list(level = "district", filter = click))
  }
})

# === Back button ===
observeEvent(input$private_back, {
  state <- private_drilldown()
  if (state$level == "district") {
    parent <- PrivateSchools %>% filter(Division == state$filter) %>%
      slice(1) %>% pull(Region)
    private_drilldown(list(level = "division", filter = parent))
  } else if (state$level == "division") {
    private_drilldown(list(level = "region", filter = NULL))
  }
})