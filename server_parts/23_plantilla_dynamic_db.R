# --- SERVER LOGIC FOR PLANTILLA POSITIONS ---

# --- Shared global drilldown state (applies to ALL cards) ---
# MOVED: These MUST be outside the observe block to persist.
plantilla_drill_state <- reactiveVal(list(region = NULL))
plantilla_trigger <- reactiveVal(0)

# --- NEW: Create a master list of all locations ---
all_locations <- distinct(dfGMIS, GMIS.Region, GMIS.Division)

# --- SERVER Code (to modify in 23_plantilla_dynamic_db.R) ---
#
# INSTRUCTIONS:
# Replace the 'observeEvent(input$plantilla_presets, ...)' block
# from last time with this new, improved version.

# --- CRITICAL STEPS: Define your lists ---

# 1. Define the master position list (from your data)
#    (You must define this for the code to work)
#    Example: 
# all_available_positions <- unique(dfGMIS$Position.Title) 
req(all_available_positions) # Ensures this variable exists

# 2. NEW: Define the *default* selection for your pickerInput
#    This MUST match the 'selected' value you defined in your 
#    'pickerInput(inputId = "selected_positions", ...)' in your UI.R file.
#    This is what the picker will revert to when no presets are checked.
#
#    --- EXAMPLES ---
#    If your picker starts empty:
default_plantilla_selection <- character(0)
#
#    If your picker starts with "Teacher I" selected:
# default_plantilla_selection <- c("Teacher I")
#
#    If your picker starts with all Teacher types selected:
# default_plantilla_selection <- c("Teacher I", "Teacher II", "Teacher III")

# --- Observer for Plantilla Position Presets ---
observeEvent(input$plantilla_presets, {
  
  # Make sure the master position list is available
  req(all_available_positions) 
  
  selected_presets <- input$plantilla_presets
  
  # --- LOGIC CHANGE ---
  # Start with the default selection.
  # This is the key change to "retain the initial selected".
  positions_to_select <- default_plantilla_selection
  
  # --- 1. Handle the case where presets ARE checked ---
  # If any boxes are checked, add them to the default list.
  if (!is.null(selected_presets)) {
    
    # --- 2. Handle the Special "Teacher" Case ---
    if ("Teacher" %in% selected_presets) {
      teacher_positions <- all_available_positions[
        all_available_positions %in% c("Teacher I", "Teacher II", "Teacher III")
      ]
      positions_to_select <- c(positions_to_select, teacher_positions)
    }
    
    # --- 3. Handle all OTHER presets ---
    # These find any position *containing* the text
    other_presets <- selected_presets[!selected_presets %in% "Teacher"]
    
    if (length(other_presets) > 0) {
      for (preset in other_presets) {
        # Use grepl() to find positions that *contain* the preset text
        matched_positions <- all_available_positions[
          grepl(preset, all_available_positions, ignore.case = TRUE)
        ]
        positions_to_select <- c(positions_to_select, matched_positions)
      }
    }
  }
  
  # --- 4. Finalize and Update the Picker ---
  # Get the final unique list (combines default + presets)
  final_selection <- unique(positions_to_select)
  
  updatePickerInput(
    session,
    inputId = "selected_positions",
    selected = final_selection
  )
  
}, ignoreNULL = FALSE, ignoreInit = TRUE) # End of preset observer

observe({
  req(input$selected_positions)
  
  # --- Render Dynamic Cards Layout ---
  # --- Render Dynamic Cards Layout ---
  output$dynamic_positions_ui <- renderUI({
    req(input$selected_positions)
    
    cards <- lapply(input$selected_positions, function(pos) {
      plot_id <- paste0("plot_", gsub(" ", "_", pos))
      vbox_id <- paste0("vbox_", gsub(" ", "_", pos))
      
      card(
        full_screen = TRUE,
        class = "shadow-sm p-2",
        card_header(
          h4(pos, class = "m-0 pt-1")
        ),
        card_body(
          
          # --- 1. EXISTING TOTAL POSITION CARD (Center Aligned) ---
          layout_columns(
            col_widths = list(4, offset = 4), 
            uiOutput(vbox_id)
          ),
          
          # --- FIX: Replace layout_columns with fluidRow and column(width=6) ---
          fluidRow(
            # --- Total Filled Card (Width 6) ---
            column(
              width = 6, 
              bslib::value_box(
                # *** ADD CSS CLASS AND max_height ***
                class = "no-scroll-card",
                max_height = "120px", # Use a smaller height
                
                # *** USE H6 FOR TITLE AND SMALLER PADDING ***
                title = tags$h6("Total Filled", style = "color:#FFFFFF; font-weight: bold; margin-bottom: 0;"),
                
                # The value output is defined below, ensure the style is compact there too
                value = uiOutput(paste0("filled_count_ui_", gsub(" ", "_", pos))),
                
                # showcase = bsicons::bs_icon("person-check-fill"),
                theme = "primary", 
                full_screen = FALSE
              )
            ),
            # --- Total Unfilled Card (Width 6) ---
            column(
              width = 6, 
              bslib::value_box(
                # *** ADD CSS CLASS AND max_height ***
                class = "no-scroll-card",
                max_height = "120px", # Use a smaller height
                
                # *** USE H6 FOR TITLE AND SMALLER PADDING ***
                title = tags$h6("Total Unfilled", style = "color: #FFFFFF; font-weight: bold; margin-bottom: 0;"),
                
                # The value output is defined below, ensure the style is compact there too
                value = uiOutput(paste0("unfilled_count_ui_", gsub(" ", "_", pos))),
                
                # showcase = bsicons::bs_icon("person-dash-fill"),
                theme = "danger",
                full_screen = FALSE
              )
            )
          ),
          # --- END OF FIXED CARDS ROW ---
          
          # --- 3. EXISTING PLOT ---
          plotlyOutput(plot_id, height = "450px")
        )
      )
    })
    
    # --- FIX 1: Replaced layout_column_wrap with do.call ---
    # This is the robust, base-R way to "splice" a list of arguments (your cards)
    # into a function call (layout_column_wrap).
    do.call(
      layout_column_wrap,
      c(
        list(width = 1/3, heights_equal = "row"), # First args
        cards                                    # The list of cards to splice
      )
    )
    # --- End of Fix 1 ---
    
  })
  
  # --- Generate Each Card’s Logic ---
  lapply(input$selected_positions, function(pos) {
    plot_id <- paste0("plot_", gsub(" ", "_", pos))
    vbox_id <- paste0("vbox_", gsub(" ", "_", pos))
    source_id <- paste0("drilldown_source_", gsub(" ", "_", pos))
    
    df_sub <- reactive({
      
      # 1. Create a scaffold for *this* position against *all* locations
      pos_scaffold <- all_locations %>% mutate(Position = pos)
      
      # 2. Get the *actual* data for this position
      actual_data <- dfGMIS %>% 
        filter(Position == pos) %>%
        select(Position, GMIS.Region, GMIS.Division, Total.Filled, Total.Unfilled)
      
      # 3. Join them. The scaffold ensures all locations are present.
      pos_scaffold %>%
        left_join(actual_data, by = c("Position", "GMIS.Region", "GMIS.Division")) %>%
        # 4. Replace NAs with 0s for counts
        mutate(
          Total.Filled = replace_na(Total.Filled, 0),
          Total.Unfilled = replace_na(Total.Unfilled, 0)
        )
    })
    
    # --- Value Box ---
    # --- Value Box ---
    output[[vbox_id]] <- renderUI({
      
      
      # 1. Read the global drill state to make this reactive update when the state changes.
      trigger <- plantilla_trigger() # Read the trigger to force re-render
      state <- plantilla_drill_state()
      if (is.null(state)) state <- list(region = NULL)
      
      # 2. Get the base data for the current position
      data_to_summarize <- df_sub()
      
      title_context <- "Total Positions"
      
      # 3. Filter the data if a Region has been selected (i.e., drilled down)
      if (!is.null(state$region)) {
        data_to_summarize <- data_to_summarize %>%
          filter(GMIS.Region == state$region)
        
        # Update the title to reflect the current view
        title_context <- paste("Total Positions in", state$region)
      } else {
        title_context <- paste("Total Positions")
      }
      
      # 4. Calculate the total from the (now possibly filtered) data
      total <- data_to_summarize %>%
        summarise(total = sum(Total.Filled + Total.Unfilled, na.rm = TRUE)) %>%
        pull(total)
      
      card(
        class = "border-2 border-primary-subtle", # A simple, light border
        card_body(
          class = "text-center p-2", # Center text, add padding
          # 5. Update the displayed title
          h5(paste(title_context, "-", pos), class = "card-title mb-1"),
          h3(formatC(total, format = "d", big.mark = ","), class = "card-text")
        )
      )
    })
    # =========================================================
    # --- NEW: Value Box (Total Filled) ---
    # =========================================================
    # The output ID must match the one used in renderUI: filled_count_ui_[POS]
    output[[paste0("filled_count_ui_", gsub(" ", "_", pos))]] <- renderUI({
      
      # 1. Read the global drill state to make this reactive update.
      trigger <- plantilla_trigger() 
      state <- plantilla_drill_state()
      if (is.null(state)) state <- list(region = NULL)
      
      # 2. Get the base data for the current position
      data_to_summarize <- df_sub()
      
      # 3. Filter the data if a Region has been selected (i.e., drilled down)
      if (!is.null(state$region)) {
        data_to_summarize <- data_to_summarize %>%
          filter(GMIS.Region == state$region)
      }
      
      # 4. Calculate the total Filled count (using your existing data column)
      total_filled <- data_to_summarize %>%
        summarise(total = sum(Total.Filled, na.rm = TRUE)) %>% 
        pull(total)
      
      # *** UPDATED: Use h4 tag and smaller font size (1.6em) for compact look ***
      tags$h4(
        format(total_filled, big.mark = ","),
        style = "font-size: 21.6px; font-weight: bold; margin: 0; padding-top: 5px; color:white;"
      )
    })
    
    # =========================================================
    # --- NEW: Value Box (Total Unfilled) ---
    # =========================================================
    # The output ID must match the one used in renderUI: unfilled_count_ui_[POS]
    output[[paste0("unfilled_count_ui_", gsub(" ", "_", pos))]] <- renderUI({
      
      # 1. Read the global drill state to make this reactive update.
      trigger <- plantilla_trigger() 
      state <- plantilla_drill_state()
      if (is.null(state)) state <- list(region = NULL)
      
      # 2. Get the base data for the current position
      data_to_summarize <- df_sub()
      
      # 3. Filter the data if a Region has been selected (i.e., drilled down)
      if (!is.null(state$region)) {
        data_to_summarize <- data_to_summarize %>%
          filter(GMIS.Region == state$region)
      }
      
      # 4. Calculate the total Unfilled count (using your existing data column)
      total_unfilled <- data_to_summarize %>%
        summarise(total = sum(Total.Unfilled, na.rm = TRUE)) %>% 
        pull(total)
      
      # *** UPDATED: Use h4 tag and smaller font size (1.6em) for compact look ***
      tags$h4(
        format(total_unfilled, big.mark = ","),
        style = "font-size: 21.6px; font-weight: bold; margin: 0; padding-top: 5px; color: white;"
      )
    })
    # --- Plot with Global Drilldown ---
    # --- Plot with Global Drilldown ---
    # --- Plot with Global Drilldown ---
    output[[plot_id]] <- renderPlotly({
      trigger <- plantilla_trigger()  # re-render when drilldown changes
      state <- plantilla_drill_state()
      if (is.null(state)) state <- list(region = NULL)
      
      df <- df_sub()
      
      # --- LEVEL 1: Region View ---
      if (is.null(state$region)) {
        plot_data <- df %>%
          group_by(GMIS.Region) %>%
          summarise(
            Filled = sum(Total.Filled, na.rm = TRUE),
            Unfilled = sum(Total.Unfilled, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          tidyr::pivot_longer(cols = c(Filled, Unfilled),
                              names_to = "Type", values_to = "Count")
        y_formula <- ~GMIS.Region
        
        # --- LEVEL 2: GMIS.Division View ---
      } else {
        plot_data <- df %>%
          filter(GMIS.Region == state$region) %>%
          group_by(GMIS.Division) %>%
          summarise(
            Filled = sum(Total.Filled, na.rm = TRUE),
            Unfilled = sum(Total.Unfilled, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          tidyr::pivot_longer(cols = c(Filled, Unfilled),
                              names_to = "Type", values_to = "Count")
        y_formula <- ~GMIS.Division
      }
      
      # Handle empty data
      if (nrow(plot_data) == 0) {
        return(plot_ly() %>% layout(title = title_txt))
      }
      
      # --- FIX 2: Correct max_val calculation for STACKED bars ---
      # We must now sum the counts for each bar (Region/GMIS.Division) 
      # to find the true maximum for the x-axis.
      
      # Get the name of the y-axis variable (e.g., "GMIS.Region" or "GMIS.Division")
      # --- Get the name of the y-axis variable (e.g., "GMIS.Region" or "GMIS.Division") ---
      y_var_name <- all.vars(y_formula)  
      
      # --- FIX: Define the data used for totals based on the drill state ---
      data_for_totals <- if (is.null(state$region)) {
        df # Level 1: Use all data (already filtered by Position)
      } else {
        df %>% filter(GMIS.Region == state$region) # Level 2: Filter by clicked Region
      }
      
      # Now summarize the correctly filtered data_for_totals
      total_counts <- data_for_totals %>%
        group_by(!!sym(y_var_name)) %>%
        summarise(
          TotalFilled = sum(Total.Filled, na.rm = TRUE),
          TotalUnfilled = sum(Total.Unfilled, na.rm = TRUE),
          TotalCount = TotalFilled + TotalUnfilled,
          # Guard against division by zero
          FillingRate = ifelse(TotalCount == 0, 0, TotalFilled / TotalCount), 
          .groups = "drop"
        )
      # --- End of Change 1 ---
      
      max_val <- max(total_counts$TotalCount, na.rm = TRUE)
      final_max <- if (max_val <= 0) 10 else (max_val * 1.3) 
      
      color_map <- c("Filled" = "#007BFF", "Unfilled" = "#FF0000")
      
      plot_ly(
        data = plot_data,
        y = y_formula,
        x = ~Count,
        color = ~Type,
        colors = color_map,
        type = 'bar',
        orientation = 'h',
        source = source_id,
        text = ~Count,
        texttemplate = '%{x:,.0f}',
        textposition = 'inside'
      ) %>%
        layout(
          barmode = 'stack',
          xaxis = list(
            title = "Number of Positions", 
            range = c(0, final_max*1.25),
            tickformat = ',.0f'
          ),
          yaxis = list(
            title = "", 
            categoryorder = "total descending", 
            autorange = "reversed"
          ),
          legend = list(
            orientation = 'h',
            xanchor = 'center',
            x = 0.5,
            yanchor = 'bottom',
            y = 1.02
          )
        ) %>%
        
        # --- CHANGE 2: Update add_text to include the Filling Rate ---
        add_text(
          data = total_counts,
          y = as.formula(paste0("~`", y_var_name, "`")),
          x = ~TotalCount,
          # --- UPDATED: Forcing white color with HTML span tag ---
          text = ~paste0(
            "<span style='color: #FFFFFF;'>", 
            formatC(TotalCount, format = "d", big.mark = ","),
            " (",
            scales::percent(FillingRate, accuracy = 1),
            ")",
            "</span>"
          ),
          textposition = "middle right",
          showlegend = FALSE,
          inherit = FALSE,
          hoverinfo = 'none',
          
          # We need to remove the "weight = 'bold'" from textfont so the HTML color applies correctly.
          # We will put the bold tag around the TotalCount number for clarity.
          # textfont = list(color = '#FFFFFF', size = 11) 
          # Note: The 'weight = bold' is complex to mix with HTML, 
          # so we'll adjust the text string slightly instead:
        )
    })
    
    # --- Drilldown Handler (Global Sync) ---
    observeEvent(event_data("plotly_click", source = source_id), {
      click_data <- event_data("plotly_click", source = source_id)
      if (is.null(click_data)) return()
      
      cat_clicked <- click_data$y
      if (is.null(cat_clicked)) return()
      
      current_state <- isolate(plantilla_drill_state())
      if (is.null(current_state)) current_state <- list(region = NULL)
      
      # Only allow 1 drilldown level: Region -> GMIS.Division
      if (is.null(current_state$region)) {
        plantilla_drill_state(list(region = as.character(cat_clicked)))
        plantilla_trigger(plantilla_trigger() + 1)
      }
    }, ignoreNULL = TRUE, ignoreInit = TRUE)
  })
  
  # --- ONE BACK BUTTON (GLOBAL) ---
  # This observer can also be moved outside the main observe block.
  # It doesn't need to be recreated every time.
  observeEvent(input$btn_back_drilldown, {
    state <- isolate(plantilla_drill_state())
    if (!is.null(state$region)) {
      plantilla_drill_state(list(region = NULL))
      plantilla_trigger(plantilla_trigger() + 1)
    }
  })
})
# =========================================================
# --- PLANTILLA REPORT GENERATOR (Fixed for dfGMIS) ---
# =========================================================

output$generate_report_plantilla <- downloadHandler(
  filename = function() {
    paste("Plantilla_Report_", Sys.Date(), ".html", sep = "")
  },
  content = function(file) {
    # 1. Notify User
    id <- showNotification("Generating Plantilla Report...", duration = NULL, closeButton = FALSE)
    on.exit(removeNotification(id), add = TRUE)
    
    # 2. Prepare Template
    tempReport <- file.path(tempdir(), "report.Rmd")
    # Make sure report.Rmd is in your app directory so it can be copied
    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    
    # 3. GET SELECTIONS & STATE
    # We use the Picker Input because that holds the final list of selected positions
    selected_pos <- input$selected_positions
    state <- plantilla_drill_state()
    if (is.null(state)) state <- list(region = NULL)
    
    # 4. PROCESS DATA
    # Since Plantilla doesn't have a single reactive, we rebuild the data from dfGMIS
    final_report_data <- data.frame()
    
    # Determine grouping (Region vs Division) based on drill-down
    group_col <- "GMIS.Region"
    current_level <- "Region"
    
    if (!is.null(state$region)) {
      group_col <- "GMIS.Division"
      current_level <- "Division"
    }
    
    # Loop through each selected position to calculate Filled/Unfilled stats
    for (pos in selected_pos) {
      
      # A. Filter the raw data for this Position
      d <- dfGMIS %>% filter(Position == pos)
      
      # B. Filter by Region if drilled down
      if (!is.null(state$region)) {
        d <- d %>% filter(GMIS.Region == state$region)
      }
      
      # C. Summarize (Filled vs Unfilled)
      # We create TWO entries for the report: one for Filled, one for Unfilled
      summ <- d %>%
        group_by(.data[[group_col]]) %>%
        summarise(
          Filled = sum(Total.Filled, na.rm=TRUE),
          Unfilled = sum(Total.Unfilled, na.rm=TRUE)
        ) %>%
        rename(Category = .data[[group_col]])
      
      # Create "Filled" rows
      f_rows <- summ %>% 
        select(Category, Value = Filled) %>% 
        mutate(Metric = paste(pos, "(Filled)"))
      
      # Create "Unfilled" rows
      u_rows <- summ %>% 
        select(Category, Value = Unfilled) %>% 
        mutate(Metric = paste(pos, "(Unfilled)"))
      
      # Combine
      final_report_data <- bind_rows(final_report_data, f_rows, u_rows)
    }
    
    # 5. PREPARE PARAMETERS
    # Create the list of metric names for the report titles
    all_metrics <- unique(final_report_data$Metric)
    metric_names_list <- setNames(as.list(all_metrics), all_metrics)
    
    params_list <- list(
      data = final_report_data,
      metrics = all_metrics,
      state = list(
        level = current_level,
        region = state$region,
        division = NULL,
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