# EFD Dashboard 

filtered_divisions_choices <- reactive({
  req(input$selected_region)

  divisions <- EFD_Projects %>%
    filter(Region %in% input$selected_region) %>%
    distinct(Division) %>%
    pull(Division) %>%
    sort()

  return(divisions)
})

observeEvent(filtered_divisions_choices(), {
  # Get the currently selected division(s) from the input
  current_selected <- input$selected_division
  
  # Get the new available choices for divisions from the reactive expression
  new_choices <- filtered_divisions_choices()
  
  # Determine what should be selected
  selected_value <- NULL # Initialize selected_value to NULL
  
  # Logic for determining the selected value:
  if (length(new_choices) > 0) {
    # If there are new choices available:
    if (!is.null(current_selected) && all(current_selected %in% new_choices)) {
      # Case 1: If something was previously selected AND all previous selections are still valid among the new choices,
      # then keep those previous selections. This handles changes in region filters while preserving user intent.
      selected_value <- current_selected
    } else {
      # Case 2: If there's nothing previously selected, OR if the previous selections are no longer valid
      # (e.g., region filter changed and old divisions are gone),
      # then default to selecting ALL of the new available choices. This is crucial for the initial load.
      selected_value <- new_choices
    }
  }
  # Case 3: If new_choices is empty (e.g., no region selected that has divisions),
  # selected_value remains NULL, which correctly results in "Nothing selected".
  
  # Update the picker input with the determined choices and selection
  updatePickerInput(
    session = session,
    inputId = "selected_division",
    choices = new_choices,
    selected = new_choices
  )
}, ignoreNULL = FALSE, ignoreInit = FALSE) # Ensure ignoreInit is FALSE to run on app start

# Reactive expression for filtered data (by Category, Region AND Division)
filtered_data <- reactive({
  req(input$selected_category, input$selected_region, input$selected_division)
  
  data_filtered <- EFD_Projects %>% 
    filter(Category %in% input$selected_category) %>%
    filter(Region %in% input$selected_region) %>%
    filter(Division %in% input$selected_division) 
  
  print("--- filtered_data() Check ---")
  print("Categories selected in input:")
  print(input$selected_category)
  print("Regions selected in input:")
  print(input$selected_region) 
  print("Divisions selected in input:") 
  print(input$selected_division)      
  print("Head of filtered_data():")
  print(head(data_filtered))
  print("Unique categories in filtered_data():")
  print(length(unique(data_filtered$Category)))
  print("Rows in filtered_data():")
  print(nrow(data_filtered))
  print("-----------------------------")
  return(data_filtered)
})

filtered_data2 <- reactive({
  req(input$selected_category, input$selected_region, input$selected_division)
  
  data_filtered <- EFD_Pipeline %>%
    mutate(Allocation = as.numeric(Allocation)) %>% 
    filter(FundingYear <= 2030) %>% 
    filter(Category %in% input$selected_category) %>%
    filter(Region %in% input$selected_region) %>%
    filter(Division %in% input$selected_division) 
  
  print("--- filtered_data() Check ---")
  print("Categories selected in input:")
  print(input$selected_category)
  print("Regions selected in input:")
  print(input$selected_region) 
  print("Divisions selected in input:") 
  print(input$selected_division)      
  print("Head of filtered_data():")
  print(head(data_filtered))
  print("Unique categories in filtered_data():")
  print(length(unique(data_filtered$Category)))
  print("Rows in filtered_data():")
  print(nrow(data_filtered))
  print("-----------------------------")
  return(data_filtered)
})

filtered_data3 <- reactive({
  req(input$selected_category, input$selected_region, input$selected_division)
  
  data_filtered <- EFD_Projects %>% 
    filter(Category %in% input$selected_category) %>%
    filter(Region %in% input$selected_region) %>%
    filter(Division %in% input$selected_division) 
  
  print("--- filtered_data() Check ---")
  print("Categories selected in input:")
  print(input$selected_category)
  print("Regions selected in input:")
  print(input$selected_region) 
  print("Divisions selected in input:") 
  print(input$selected_division)      
  print("Head of filtered_data():")
  print(head(data_filtered))
  print("Unique categories in filtered_data():")
  print(length(unique(data_filtered$Category)))
  print("Rows in filtered_data():")
  print(nrow(data_filtered))
  print("-----------------------------")
  return(data_filtered)
})

# Get unique funding years for dynamic value boxes
alloc_filter <- EFD_Projects
unique_funding_years <- sort(unique(alloc_filter$FundingYear))

# Get unique categories and regions for filter choices (initial load)
all_categories <- sort(unique(alloc_filter$Category))
all_regions <- sort(unique(alloc_filter$Region))
all_divisions <- sort(unique(alloc_filter$Division)) # All divisions for initial selection

# --- Render Value Boxes for Each Funding Year (using renderText for value) ---
lapply(unique_funding_years, function(year) {
  output[[paste0("vb_total_alloc_", year)]] <- renderText({
    total_alloc_for_year <- filtered_data() %>%
      filter(FundingYear == year) %>%
      summarise(Total = sum(Allocation, na.rm = TRUE)) %>%
      pull(Total)
    paste0(scales::comma(total_alloc_for_year))
  })
})

# --- Plot 1: Allocation per Category per FundingYear (Grouped Bar Graph) ---
output$allocationStackedBar <- renderPlotly({
  # Define the custom color palette
  category_colors <- c(
    "ALS-CLC" = "#E41A1C",
    "Electrification" = "#FF7F00",
    "Gabaldon" = "#4DAF4A",
    "Health" = "#1B9E77",
    "LMS" = "#17BECF",
    "New Construction" = "#A6CEE3",
    "QRF" = "#984EA3",
    "Repairs" = "#F781BF",
    "SPED-ILRC" = "#FDBF6F", # You can choose any color here, this is an example
    "LIH" = "#CAB2D6"       # And another one for LIH
  )
  
  if (nrow(filtered_data3()) == 0) {
    return(ggplotly(ggplot() + annotate("text", x = 0.5, y = 0.5, label = "No data for selected categories/regions/divisions") + theme_void()))
  }
  
  plot_data_stacked <- filtered_data3() %>% 
    group_by(FundingYear, Category) %>%
    summarise(TotalAllocation = sum(Allocation, na.rm = TRUE), .groups = 'drop') %>%
    ungroup() %>%
    # Calculate percentage of each category within its FundingYear
    group_by(FundingYear) %>%
    mutate(
      TotalAllocationYear = sum(TotalAllocation, na.rm = TRUE),
      Percentage = (TotalAllocation / TotalAllocationYear) * 100
    ) %>%
    ungroup()
  
  plot_data_totals <- plot_data_stacked %>% 
    group_by(FundingYear) %>% 
    summarise(GrandTotalAllocation = sum(TotalAllocation, na.rm = TRUE), .groups = 'drop')
  
  p <- ggplot(plot_data_stacked, aes(x = factor(FundingYear), y = TotalAllocation, fill = Category,
                                     text = paste("Year: ", FundingYear,
                                                  "<br>Category: ", Category,
                                                  "<br>Allocation: PhP ", scales::dollar(round(TotalAllocation,2), prefix = "₱"),
                                                  "<br>Percentage: ", round(Percentage, 2), "%"), # <--- ADDED PERCENTAGE HERE
                                     key = paste(FundingYear, Category, "allocation"))) +
    geom_bar(stat = "identity", position = "stack", color = "black", size = 0.25, size = 0.25) +
    geom_text(data = plot_data_totals,
              aes(x = factor(FundingYear), y = GrandTotalAllocation * 1.05, label = scales::dollar(GrandTotalAllocation, prefix = "₱")), # Modified line
              inherit.aes = FALSE,
              size = 3.5,
              color = "black") +
    labs(title = "Total Allocation per Category per Funding Year", x = "Funding Year", y = "Total Allocation (PhP)", fill = "BEFF Allocation") +
    scale_y_continuous(labels = scales::comma) +
    scale_fill_manual(values = category_colors) +
    theme_minimal() +
    theme(legend.position = "bottom")
  
  ggplotly(p, tooltip = "text", source = "stackedBarPlot") %>% layout(hoverlabel = list(bgcolor = "white"))
})

# --- Plot 3: Allocation Trend per Category per FundingYear (Line Graph) ---
output$allocationTrendLine <- renderPlotly({
  # Define the custom color palette
  category_colors <- c(
    "ALS-CLC" = "#E41A1C",
    "Electrification" = "#FF7F00",
    "Gabaldon" = "#4DAF4A",
    "Health" = "#1B9E77",
    "LMS" = "#17BECF",
    "New Construction" = "#A6CEE3",
    "QRF" = "#984EA3",
    "Repairs" = "#F781BF",
    "SPED-ILRC" = "#FDBF6F", # You can choose any color here, this is an example
    "LIH" = "#CAB2D6"       # And another one for LIH
  )
  
  if (nrow(filtered_data3()) == 0) {
    return(ggplotly(ggplot() + annotate("text", x = 0.5, y = 0.5, label = "No data for selected categories/regions/divisions") + theme_void()))
  }
  
  plot_data_trend <- filtered_data3() %>% 
    group_by(FundingYear, Category) %>%
    summarise(TotalAllocation = sum(Allocation, na.rm = TRUE), .groups = 'drop') %>%
    ungroup()
  
  p <- ggplot(plot_data_trend, aes(x = FundingYear, y = TotalAllocation, color = Category, group = Category,
                                   text = paste("Year: ", FundingYear,
                                                "<br>Category: ", Category,
                                                "<br>Allocation: PhP ", scales::comma(TotalAllocation)))) +
    geom_line(size = 1) +
    geom_point(size = 2) + # Removed aes(color = Category) here as it's already defined globally in ggplot()
    labs(title = "Allocation Trend per Category", x = "Funding Year", y = "Total Allocation (PhP)") +
    scale_y_continuous(labels = scales::comma) +
    scale_x_continuous(breaks = min(plot_data_trend$FundingYear):max(plot_data_trend$FundingYear)) +
    scale_color_manual(values = category_colors) + # <--- ADDED CUSTOM COLORS HERE
    theme_minimal() +
    theme(legend.position = "bottom")
  
  ggplotly(p, tooltip = "text") %>% layout(hoverlabel = list(bgcolor = "white"))
})

# --- NEW PLOT: Average Completion per Category per Funding Year (Bar Graph) ---
output$completionByCategoryPlot <- renderPlotly({
  # Define the custom color palette based on your image
  category_colors <- c(
    "ALS-CLC" = "#E41A1C",       # Red
    "Electrification" = "#FF7F00",   # Orange
    "Gabaldon" = "#4DAF4A",       # Green
    "Health" = "#1B9E77",         # Darker Teal-Green
    "LMS" = "#17BECF",            # Teal
    "New Construction" = "#A6CEE3", # Light Blue
    "QRF" = "#984EA3",           # Purple
    "Repairs" = "#F781BF"        # Pink
  )
  
  filtered_data_no_2025 <- filtered_data3() %>%
    filter(FundingYear != 2025)
  
  if (nrow(filtered_data_no_2025) == 0) {
    return(plotly_empty() %>% layout(title = "No data available for selected filters."))
  }
  
  completion_threshold <- 0.0001
  
  category_yearly_avg <- filtered_data_no_2025 %>%
    group_by(FundingYear, Category) %>%
    summarise(AverageCompletion = mean(Completion, na.rm = TRUE), .groups = 'drop') %>%
    filter(AverageCompletion > completion_threshold)
  
  if (nrow(category_yearly_avg) == 0) {
    return(plotly_empty() %>% layout(title = "No data available after filtering for non-zero completion."))
  }
  
  plot_data <- category_yearly_avg %>%
    mutate(FundingYear = factor(FundingYear, levels = sort(unique(FundingYear)))) %>%
    mutate(Category = factor(Category)) %>%
    arrange(FundingYear)
  
  plot_ly(plot_data, x = ~FundingYear, y = ~AverageCompletion, color = ~Category,
          colors = category_colors, # <--- ADDED CUSTOM COLORS HERE
          type = 'bar',
          marker = list(line = list(color = 'black', width = 1)),
          text = ~paste("Year: ", FundingYear, "<br>Category: ", Category, "<br>Avg Completion: ", scales::percent(AverageCompletion, accuracy = 1)),
          hoverinfo = "text",
          source = "completionPlot",
          key = ~paste(FundingYear, Category, "completion")
  ) %>%
    layout(title = "Average Completion per Category per Year",
           xaxis = list(title = "Funding Year", type = "category",
                        categoryorder = "array", categoryarray = levels(plot_data$FundingYear)),
           yaxis = list(title = "Average Completion (%)", tickformat = ".0%", range = c(0, 1)),
           barmode = 'group',
           legend = list(traceorder = "reversed")
    )
})

output$PipelinePrograms <- renderPlotly({
  # Define the custom color palette
  category_colors <- c(
    "ALS-CLC" = "#E41A1C",        # Red
    "Electrification" = "#FF7F00",    # Orange
    "Gabaldon" = "#4DAF4A",      # Green
    "Health" = "#1B9E77",         # Darker Teal-Green
    "LMS" = "#17BECF",            # Teal
    "New Construction" = "#A6CEE3", # Light Blue
    "QRF" = "#984EA3",            # Purple
    "Repairs" = "#F781BF"         # Pink
  )
  
  # Filter data for FundingYear 2026 onwards
  filtered_data_2026_onwards <- filtered_data2() %>%
    filter(FundingYear >= 2026)
  
  # Check if there's any data after filtering
  if (nrow(filtered_data_2026_onwards) == 0) {
    # Changed to ggplotly and annotate for consistency with allocationStackedBar
    return(ggplotly(ggplot() + annotate("text", x = 0.5, y = 0.5, label = "No data available for 2026 onwards.") + theme_void()))
  }
  
  # Summarize data: Sum Allocation per year and category
  pipeline_programs_summary <- filtered_data_2026_onwards %>%
    group_by(FundingYear, Category) %>%
    summarise(TotalAllocation = sum(Allocation, na.rm = TRUE), .groups = 'drop') %>%
    # Calculate percentage of each category within its FundingYear
    group_by(FundingYear) %>%
    mutate(
      TotalAllocationYear = sum(TotalAllocation, na.rm = TRUE),
      Percentage = (TotalAllocation / TotalAllocationYear) * 100
    ) %>%
    ungroup()
  
  # Check if there's any data after summarization
  if (nrow(pipeline_programs_summary) == 0) {
    # Changed to ggplotly and annotate for consistency
    return(ggplotly(ggplot() + annotate("text", x = 0.5, y = 0.5, label = "No pipeline program data available after aggregation.") + theme_void()))
  }
  
  # Prepare data for plotting (Factor levels for x-axis order)
  plot_data_pipeline <- pipeline_programs_summary %>%
    mutate(FundingYear = factor(FundingYear, levels = sort(unique(FundingYear))))
  # Category already factor from group_by or assumed from previous step. No need for explicit mutate(Category = factor(Category)) if it's already a factor.
  
  # Create the ggplot object
  p <- ggplot(plot_data_pipeline, aes(x = FundingYear, y = TotalAllocation, fill = Category,
                                      text = paste("Year: ", FundingYear,
                                                   "<br>Category: ", Category,
                                                   "<br>Total Allocation: PhP ", scales::comma(TotalAllocation),
                                                   "<br>Percentage: ", round(Percentage, 2), "%"),
                                      key = paste(FundingYear, Category, "pipeline"))) +
    geom_bar(stat = "identity", position = "stack") + # Stacked bar chart
    labs(title = "Total Allocation for Pipeline Programs per Category per Year (2026 Onwards)",
         x = "Funding Year",
         y = "Total Allocation (PhP)") +
    scale_y_continuous(labels = scales::comma) + # Format y-axis as currency with commas
    scale_fill_manual(values = category_colors) + # Apply custom colors
    theme_minimal() + # Minimal theme
    theme(legend.position = "bottom") # Place legend at the bottom
  
  # Convert ggplot to plotly, specifying tooltip to use the 'text' aesthetic
  ggplotly(p, tooltip = "text", source = "pipelinePlot") %>% layout(hoverlabel = list(bgcolor = "white"))
})

# --- Reactive Values to store the latest click data ---
rv <- reactiveValues(
  latest_click_key = NULL,
  latest_click_type = NULL 
)

# Observer for allocation plot clicks
observeEvent(event_data("plotly_click", source = "stackedBarPlot"), {
  click_data <- event_data("plotly_click", source = "stackedBarPlot")
  if (!is.null(click_data)) {
    rv$latest_click_key <- click_data$key
    rv$latest_click_type <- "allocation"
  }
})

# Observer for completion plot clicks
observeEvent(event_data("plotly_click", source = "completionPlot"), {
  click_data <- event_data("plotly_click", source = "completionPlot")
  if (!is.null(click_data)) {
    rv$latest_click_key <- click_data$key
    rv$latest_click_type <- "completion"
  }
})

# In your server.R file, after your output$PipelinePrograms definition

# Define a reactiveValues object to store click data (if you don't have one already)
# This should be defined once at the top of your server function:
# rv <- reactiveValues(latest_click_key = NULL, latest_click_type = NULL)

observeEvent(event_data("plotly_click", source = "pipelinePlot"), { # <--- Changed source to "pipelinePlot"
  click_data <- event_data("plotly_click", source = "pipelinePlot") # <--- Changed source
  if (!is.null(click_data)) {
    # The 'key' attribute you defined in plot_ly is passed here
    # For PipelinePrograms, your key is ~paste(FundingYear, Category, "pipeline")
    rv$latest_click_key <- click_data$key
    rv$latest_click_type <- "pipeline" # <--- Set type to "pipeline" for this graph
    
    # Optional: Print click data to console for debugging
    # print("Click on PipelinePrograms plot:")
    # print(click_data)
    # print(paste("Clicked Key:", click_data$key))
  }
})

# Your existing output$PipelinePrograms definition would be above this observeEvent
# output$PipelinePrograms <- renderPlotly({ ... })

# --- Reactive Table Data based on Plotly Click (Updated for Multiple Sources) ---
output$projectDetailTable <- DT::renderDT(server = TRUE, {
  # Initialize table_to_display with the pre-filtered data
  table_to_display <- filtered_data3()
  
  # Only apply additional filters if a plot segment has been clicked
  if (!is.null(rv$latest_click_key) && !is.null(rv$latest_click_type)) {
    clicked_key <- rv$latest_click_key
    clicked_type <- rv$latest_click_type
    
    clicked_split <- strsplit(as.character(clicked_key), " ")[[1]]
    
    if (length(clicked_split) >= 3) {
      clicked_year <- as.numeric(clicked_split[1])
      clicked_category <- paste(clicked_split[2:(length(clicked_split)-1)], collapse = " ")
      
      # Now, apply specific filters to the ALREADY-FILTERED data
      if (clicked_type == "completion") {
        table_to_display <- table_to_display %>%
          filter(FundingYear == clicked_year, Category == clicked_category, FundingYear != 2025)
      } else if (clicked_type == "allocation") {
        table_to_display <- table_to_display %>%
          filter(FundingYear == clicked_year, Category == clicked_category)
      } else if (clicked_type == "pipeline") {
        table_to_display <- table_to_display %>%
          filter(FundingYear == clicked_year, Category == clicked_category, FundingYear >= 2026)
      }
    }
  }
  
  table_to_display <- table_to_display %>%
    select(Region, Division, SchoolName, FundingYear, Category, Allocation, Completion)
  
  if (nrow(table_to_display) == 0) {
    return(DT::datatable(data.frame(Message = "No project data available for this selection."), options = list(dom = 't')))
  }
  
  DT::datatable(table_to_display %>% mutate(FundingYear = as.character(FundingYear)),
                options = list(
                  pageLength = 10),
                filter = 'top',
                rownames = FALSE
  ) %>%
    formatCurrency('Allocation', currency = 'PhP') %>%
    formatPercentage('Completion', digits = 1)
})
# =========================================================
# --- INFRASTRUCTURE REPORT GENERATOR (Fixed) ---
# =========================================================

output$generate_report_infra <- downloadHandler(
  filename = function() {
    # File name changes based on the active panel
    tab_name <- gsub(" ", "_", input$infra_tabs)
    paste("Infrastructure_", tab_name, "_Report_", Sys.Date(), ".html", sep = "")
  },
  content = function(file) {
    # 1. Notify
    id <- showNotification("Generating Report...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id), add = TRUE)
    
    # 2. Template
    tempReport <- file.path(tempdir(), "report.Rmd")
    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    
    # 3. FILTER DATA
    data_infra <- EFD_Projects
    
    if (!is.null(input$selected_region) && length(input$selected_region) > 0) {
      data_infra <- data_infra %>% filter(Region %in% input$selected_region)
    }
    
    if (!is.null(input$selected_division) && length(input$selected_division) > 0) {
      data_infra <- data_infra %>% filter(Division %in% input$selected_division)
    }
    
    # 4. PREPARE METRICS (Based on Active Panel)
    final_report_data <- data.frame()
    active_panel <- input$infra_tabs # Gets "Allocation Overview" or "Completion Overview"
    
    # --- LOGIC SWITCH ---
    if (active_panel == "Allocation Overview") {
      
      # Metric A: Category
      metric_a <- data_infra %>%
        group_by(Category) %>%
        summarise(Value = sum(Allocation, na.rm = TRUE)) %>%
        mutate(Metric = "Total Allocation by Category") %>%
        ungroup()
      
      # Metric B: Year
      metric_b <- data_infra %>%
        group_by(FundingYear) %>%
        summarise(Value = sum(Allocation, na.rm = TRUE)) %>%
        mutate(Category = as.character(FundingYear)) %>%
        mutate(Metric = "Total Allocation by Year") %>%
        select(Category, Metric, Value) %>%
        ungroup()
      
      final_report_data <- bind_rows(metric_a, metric_b)
      
    } else if (active_panel == "Completion Overview") {
      
      # Metric C: Completion
      metric_c <- data_infra %>%
        group_by(Category) %>%
        summarise(Value = mean(Completion, na.rm = TRUE)) %>%
        mutate(Metric = "Average Completion Rate (%)") %>%
        ungroup()
      
      final_report_data <- metric_c
    }
    
    # 5. PARAMETERS
    all_metrics <- unique(final_report_data$Metric)
    metric_names_list <- setNames(as.list(all_metrics), all_metrics)
    
    current_region <- if(is.null(input$selected_region)) "All Regions" else paste(input$selected_region, collapse=", ")
    current_div <- if(is.null(input$selected_division)) "All Divisions" else paste(input$selected_division, collapse=", ")
    
    params_list <- list(
      data = final_report_data,
      metrics = all_metrics,
      state = list(
        level = paste("Custom Selection -", active_panel),
        region = current_region,
        division = current_div,
        municipality = NULL
      ),
      metric_names = metric_names_list
    )
    
    # 6. RENDER
    rmarkdown::render(
      tempReport,
      output_file = file,
      params = params_list,
      envir = new.env(parent = globalenv())
    )
  }
)