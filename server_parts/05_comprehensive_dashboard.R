# 05_comprehensive_dashboard

drilldown_state <- reactiveVal(list(
  region = NULL, 
  division = NULL, 
  legislative_district = NULL,
  last_clicked_source = NULL  # <--- NEW FIELD
))

# --- Plotly Source IDs ---
# (This vector also remains the same)
# --- Event Handling: CORRECTED APPROACH ---

# This list maps your source IDs to the dataframe they use
# We'll use this in the table logic later
source_to_data_map <- list(
  "drilldown_source_1" = "uni",
  "drilldown_source_2" = "LMS",
  "drilldown_source_3" = "LMS",
  "drilldown_source_4" = "df",
  "drilldown_source_5" = "uni"
)

# Get the names of the sources from the map
drilldown_sources <- names(source_to_data_map)

# We use lapply to loop over our vector of source IDs.
lapply(drilldown_sources, function(source_id) {
  
  # Each observer listens to ONE specific source_id
  observeEvent(event_data("plotly_click", source = source_id), {
    
    click_data <- event_data("plotly_click", source = source_id)
    
    if (is.null(click_data) || is.null(click_data$y)) {
      return()
    }
    
    current_state <- drilldown_state()
    
    # --- DRILL-DOWN LOGIC ---
    
    # Level 1: National -> Region
    if (is.null(current_state$region)) {
      drilldown_state(list(
        region = click_data$y,  
        division = NULL, 
        legislative_district = NULL,
        last_clicked_source = source_id  # <--- SET SOURCE
      ))
      
      # Level 2: Region -> Division
    } else if (is.null(current_state$division)) {
      drilldown_state(list(
        region = current_state$region, 
        division = click_data$y,     
        legislative_district = NULL,
        last_clicked_source = source_id  # <--- SET SOURCE
      ))
      
      # Level 3: Division -> Legislative District
    } else if (is.null(current_state$legislative_district)) { 
      drilldown_state(list(
        region = current_state$region,               
        division = current_state$division,           
        legislative_district = click_data$y,
        last_clicked_source = source_id  # <--- SET SOURCE
      ))
    }
    
  }) # End of observeEvent
}) # End of lapply


# --- !!! IMPORTANT: RESET BUTTON !!! ---
# You must ALSO update your reset button (if you have one)
# to clear this new state field.
#
# observeEvent(input$resetButton, {
#   drilldown_state(list(
#     region = NULL, 
#     division = NULL, 
#     legislative_district = NULL,
#     last_clicked_source = NULL  # <--- RESET THIS FIELD
#   ))
# })

#hr
observeEvent(input$reset_hr, {
  state <- drilldown_state()
  
  if (!is.null(state$district)) {
    drilldown_state(list(region = state$region, division = state$division, district = NULL))
  } else if (!is.null(state$division)) {
    drilldown_state(list(region = state$region, division = NULL, district = NULL))
  } else if (!is.null(state$region)) {
    drilldown_state(list(region = NULL, division = NULL, district = NULL))
  }
})

#basicinfo
observeEvent(input$reset_basicinfo, {
  state <- drilldown_state()
  
  if (!is.null(state$district)) {
    drilldown_state(list(region = state$region, division = state$division, district = NULL))
  } else if (!is.null(state$division)) {
    drilldown_state(list(region = state$region, division = NULL, district = NULL))
  } else if (!is.null(state$region)) {
    drilldown_state(list(region = NULL, division = NULL, district = NULL))
  }
})

#infra
observeEvent(input$reset_infra, {
  state <- drilldown_state()
  
  if (!is.null(state$district)) {
    drilldown_state(list(region = state$region, division = state$division, district = NULL))
  } else if (!is.null(state$division)) {
    drilldown_state(list(region = state$region, division = NULL, district = NULL))
  } else if (!is.null(state$region)) {
    drilldown_state(list(region = NULL, division = NULL, district = NULL))
  }
})

#financial
observeEvent(input$reset_financial, {
  state <- drilldown_state()
  
  if (!is.null(state$district)) {
    drilldown_state(list(region = state$region, division = state$division, district = NULL))
  } else if (!is.null(state$division)) {
    drilldown_state(list(region = state$region, division = NULL, district = NULL))
  } else if (!is.null(state$region)) {
    drilldown_state(list(region = NULL, division = NULL, district = NULL))
  }
})

#monitoring
observeEvent(input$reset_monitoring, {
  state <- drilldown_state()
  
  if (!is.null(state$district)) {
    drilldown_state(list(region = state$region, division = state$division, district = NULL))
  } else if (!is.null(state$division)) {
    drilldown_state(list(region = state$region, division = NULL, district = NULL))
  } else if (!is.null(state$region)) {
    drilldown_state(list(region = NULL, division = NULL, district = NULL))
  }
})

#ppas
observeEvent(input$reset_ppas, {
  state <- drilldown_state()
  
  if (!is.null(state$district)) {
    drilldown_state(list(region = state$region, division = state$division, district = NULL))
  } else if (!is.null(state$division)) {
    drilldown_state(list(region = state$region, division = NULL, district = NULL))
  } else if (!is.null(state$region)) {
    drilldown_state(list(region = NULL, division = NULL, district = NULL))
  }
})

# --- Reactive Data Filtering ---
filtered_data_uni_erdb <- reactive({
  state <- drilldown_state()
  data <- uni
  if (!is.null(state$region)) {
    data <- data %>% filter(Region == state$region)
  }
  if (!is.null(state$division)) {
    data <- data %>% filter(Division == state$division)
  }
  data
})

filtered_data_df_erdb <- reactive({
  state <- drilldown_state()
  data <- df
  if (!is.null(state$region)) {
    data <- data %>% filter(Region == state$region)
  }
  if (!is.null(state$division)) {
    data <- data %>% filter(Division == state$division)
  }
  data
})

filtered_data_LMS_erdb <- reactive({
  # 1. Access drilldown state and initial data
  state <- drilldown_state()
  data <- LMS 
  
  # 2. Apply filtering based on drilldown state
  if (!is.null(state$region)) {
    data <- data %>% filter(Region == state$region)
  }
  if (!is.null(state$division)) {
    data <- data %>% filter(Division == state$division)
  }
  data
})

# --- Value Box Rendering using shinydashboard::renderValueBox ---

# Note: Ensure the 'comma' function (likely from the 'scales' package) is available.
# library(shinydashboard) 
# library(scales) 

# Corrected and Enhanced renderInfoBox Functions (Server-Side)

# Note: Ensure the 'comma' function (from the 'scales' package) is available.
# library(shinydashboard) 
# library(scales) 

# 1. Total Schools
# Corrected and Enhanced renderValueBox Functions (Server-Side)
# Note: Requires the 'scales' package for comma()

# Helper function to define the modern value_box without an icon
make_value_box_no_icon <- function(title, value, color_class, text_color = "#212529") {
  bslib::value_box(
    title = title,
    
    # 1. Make the value significantly bigger and bold
    value = tags$span(value, style = "font-size: 2.5rem; font-weight: bold;"),
    
    # Showcase element (icon) is completely removed here ⬅️
    
    # Use 'full_screen' for a nice aesthetic hover-to-expand feature
    full_screen = TRUE,
    
    # 2. Use 'theme' for the color scheme and text color
    theme = bslib::value_box_theme(bg = color_class, fg = text_color)
  )
}

# ---------------------------------------------------------------------------

# 1. Total Schools (White box)
# 1. Total Schools Count
# 1. Total Schools
output$total_schools_erdb <- renderUI({
  total <- nrow(filtered_data_uni_erdb())
  
  bslib::card(
    style = "background-color: #FFFFFF;",
    bslib::card_header("Total Schools Count", class = "text-center"),
    bslib::card_body(
      tags$h3(scales::comma(total), style = "text-align: center; font-weight: 700;")
    )
  )
})

# 2. Total Enrolment
output$total_enrolment_erdb <- renderUI({
  count <- sum(filtered_data_uni_erdb()$TotalEnrolment, na.rm = TRUE)
  
  bslib::card(
    style = "background-color: #FFFFFF;",
    bslib::card_header("Total Student Enrolment", class = "text-center"),
    bslib::card_body(
      tags$h3(scales::comma(count), style = "text-align: center; font-weight: 700;")
    )
  )
})

# 3. Total Classrooms
output$total_classrooms_erdb <- renderUI({
  count <- sum(filtered_data_LMS_erdb()$Instructional_Rooms, na.rm = TRUE)
  
  bslib::card(
    style = "background-color: #FFFFFF;",
    bslib::card_header("Available Classrooms", class = "text-center"),
    bslib::card_body(
      tags$h3(scales::comma(count), style = "text-align: center; font-weight: 700;")
    )
  )
})

# 4. Total Classroom Shortage (Light Orange Warning)
output$total_classroom_shortage_erdb <- renderUI({
  shortage <- sum(filtered_data_LMS_erdb()$Estimated_CL_Shortage, na.rm = TRUE)
  
  bslib::card(
    style = "background-color: #FFE5CC;",
    bslib::card_header("Classroom Shortage", class = "text-center"),
    bslib::card_body(
      tags$h3(scales::comma(shortage), style = "text-align: center; font-weight: 700;")
    )
  )
})

# 5. Total Last Mile Schools
output$total_LMS_erdb <- renderUI({
  count <- filtered_data_LMS_erdb() %>%
    filter(LMS == 1) %>%
    nrow()
  
  bslib::card(
    style = "background-color: #FFFFFF;",
    bslib::card_header("Total Last Mile Schools", class = "text-center"),
    bslib::card_body(
      tags$h3(scales::comma(count), style = "text-align: center; font-weight: 700;")
    )
  )
})

# 6. Total Teacher Shortage (Light Red Critical Warning)
output$total_teacher_shortage_erdb <- renderUI({
  shortage <- sum(filtered_data_df_erdb()$TeacherShortage, na.rm = TRUE)
  
  bslib::card(
    style = "background-color: #F8D7DA;",
    bslib::card_header("Teacher Shortage", class = "text-center"),
    bslib::card_body(
      tags$h3(scales::comma(shortage), style = "text-align: center; font-weight: 700;")
    )
  )
})

# 7. School Principal Shortage
output$SP_Shortage_erdb <- renderUI({
  data_uni <- filtered_data_uni_erdb()
  # Assuming the logic for 'count' remains correct for your purpose
  count <- sum(data_uni$Designation != "School Principal", na.rm = TRUE)
  
  bslib::card(
    # The style here correctly applies to the whole card, including text
    style = "background-color: #FFF3CD; color: #664D03;", 
    bslib::card_header("School Principal Shortage", class = "text-center"),
    bslib::card_body(
      tags$h3(scales::comma(count), style = "text-align: center; font-weight: 700;")
    )
  )
})

# --- Plot Rendering ---

# Total Schools Plot (Drilldown)
output$totalschools_plot_erdb <- renderPlotly({
  state <- drilldown_state()
  
  if (is.null(state$region)) {
    # National View -> Group by Region
    plot_data <- uni %>%
      group_by(Region) %>%
      summarise(TotalSchools = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$TotalSchools, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Region,                # Flipped: Category on Y-axis
      x = ~TotalSchools,          # Flipped: Value on X-axis
      type = 'bar', 
      source = "drilldown_source_1",
      text = ~TotalSchools,       # Added: Text label value
      texttemplate = '%{x:,.0f}', # Added: Format text (comma, 0 decimals)
      textposition = 'outside'    # Added: Place text outside bar
    ) %>%
      layout(
        title = "Total Schools by Region", 
        xaxis = list(title = "Number of Schools", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped to xaxis
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped to yaxis, removed tickangle, added autorange
      )
    
  } else if (is.null(state$division)) {
    # Regional View -> Group by Division
    plot_data <- uni %>%
      filter(Region == state$region) %>%
      group_by(Division) %>%
      summarise(TotalSchools = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$TotalSchools, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Division,              # Flipped: Category on Y-axis
      x = ~TotalSchools,          # Flipped: Value on X-axis
      type = 'bar', 
      source = "drilldown_source_1",
      text = ~TotalSchools,       # Added
      texttemplate = '%{x:,.0f}', # Added
      textposition = 'outside'    # Added
    ) %>%
      layout(
        title = paste("Schools in", state$region), 
        xaxis = list(title = "Number of Schools", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
    
  } else {
    # Divisional View -> Group by Legislative District
    plot_data <- uni %>%
      filter(Region == state$region, Division == state$division) %>%
      group_by(Legislative.District) %>%
      summarise(TotalSchools = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$TotalSchools, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Legislative.District,  # Flipped: Category on Y-axis
      x = ~TotalSchools,          # Flipped: Value on X-axis
      type = 'bar',
      text = ~TotalSchools,       # Added
      texttemplate = '%{x:,.0f}', # Added
      textposition = 'outside'    # Added
    ) %>% 
      layout(
        title = paste("Schools in", state$division), 
        xaxis = list(title = "Number of Schools", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "Legislative District", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
  }
  p
})

# By Curricular Offering (Pie Chart) - No changes
output$curricular_plot_erdb <- renderPlotly({
  state <- drilldown_state()
  
  # 1. Filter data based on drill-down state
  plot_data <- if (is.null(state$region)) {
    uni # National view: use all data
  } else if (is.null(state$division)) {
    uni %>% filter(Region == state$region) # Regional view
  } else {
    uni %>% filter(Region == state$region, Division == state$division) # Divisional view
  }
  
  # 2. Generate pie chart data from the (potentially filtered) data
  pie_data <- plot_data %>%
    group_by(Modified.COC) %>%
    summarise(Count = n(), .groups = 'drop')
  
  # 3. Define title based on state
  title_text <- if (is.null(state$region)) {
    "By Curricular Offering (National)"
  } else if (is.null(state$division)) {
    paste("By Curricular Offering (", state$region, ")")
  } else {
    paste("By Curricular Offering (", state$division, ")")
  }
  
  plot_ly(data = pie_data, labels = ~Modified.COC, values = ~Count, type = 'pie', textinfo = 'percent', insidetextorientation = 'radial') %>%
    layout(title = title_text, showlegend = TRUE, xaxis = list(title = "", tickangle = -45))
})

# By School Size Typology (Bar Chart)
output$typology_plot_erdb <- renderPlotly({
  state <- drilldown_state()
  
  # 1. Filter data based on drill-down state (UNCHANGED)
  plot_data <- if (is.null(state$region)) {
    uni # National view
  } else if (is.null(state$division)) {
    uni %>% filter(Region == state$region) # Regional view
  } else {
    uni %>% filter(Region == state$region, Division == state$division) # Divisional view
  }
  
  # 2. Generate bar chart data (UNCHANGED)
  typology_data <- plot_data %>%
    group_by(School.Size.Typology) %>%
    summarise(Count = n(), .groups = 'drop')
  
  max_schools <- max(typology_data$Count, na.rm = TRUE)
  
  # 3. Define title based on state (UNCHANGED)
  title_text <- if (is.null(state$region)) {
    "By School Size (National)"
  } else if (is.null(state$division)) {
    paste("By School Size (", state$region, ")")
  } else {
    paste("By School Size (", state$division, ")")
  }
  
  # 4. Create and customize the plot (MODIFIED)
  plot_ly(
    data = typology_data,
    y = ~School.Size.Typology,  # Flipped: Category on Y-axis
    x = ~Count,                 # Flipped: Value on X-axis
    type = 'bar',
    text = ~Count,              # Added: Use Count for text
    texttemplate = '%{x:,.0f}',  # Added: Format text
    textposition = 'outside',   # Added: Place text outside
    hovertemplate = paste(
      "%{y}, %{x:,}", # Flipped: Use y for category, x for value
      "<extra></extra>" 
    )
  ) %>%
    layout(
      title = title_text,
      yaxis = list(              # Swapped to yaxis
        title = "", categoryorder = "total descending", autorange = "reversed"),
      xaxis = list(              # Swapped to xaxis
        title = "Number of Schools",
        tickformat = ",",
        range = c(0, max_schools *1.15)
      )
    )
})

# === Total Enrollment Drilldown Graph (Basic Information Section) ===
output$total_enrollment_plot_erdb <- renderPlotly({
  state <- drilldown_state()
  
  # 1️⃣ Filter based on drilldown level
  plot_data <- if (is.null(state$region)) {
    uni
  } else if (is.null(state$division)) {
    uni %>% filter(Region == state$region)
  } else {
    uni %>% filter(Region == state$region, Division == state$division)
  }
  
  # 2️⃣ Summarize by current level
  plot_summary <- if (is.null(state$region)) {
    plot_data %>%
      group_by(group_col = Region) %>%
      summarise(
        ES = sum(as.numeric(ES.Enrolment), na.rm = TRUE),
        JHS = sum(as.numeric(JHS.Enrolment), na.rm = TRUE),
        SHS = sum(as.numeric(SHS.Enrolment), na.rm = TRUE),
        .groups = "drop"
      )
  } else if (is.null(state$division)) {
    plot_data %>%
      group_by(group_col = Division) %>%
      summarise(
        ES = sum(as.numeric(ES.Enrolment), na.rm = TRUE),
        JHS = sum(as.numeric(JHS.Enrolment), na.rm = TRUE),
        SHS = sum(as.numeric(SHS.Enrolment), na.rm = TRUE),
        .groups = "drop"
      )
  } else {
    plot_data %>%
      group_by(group_col = Legislative.District) %>%
      summarise(
        ES = sum(as.numeric(ES.Enrolment), na.rm = TRUE),
        JHS = sum(as.numeric(JHS.Enrolment), na.rm = TRUE),
        SHS = sum(as.numeric(SHS.Enrolment), na.rm = TRUE),
        .groups = "drop"
      )
  }
  
  # 3️⃣ Build stacked bar plot
  plot_ly(plot_summary, source = "drilldown_source_5") %>%
    add_bars(y = ~group_col, x = ~ES, name = "ES", orientation = "h", marker = list(color = "#4e79a7")) %>%
    add_bars(y = ~group_col, x = ~JHS, name = "JHS", orientation = "h", marker = list(color = "#f28e2b")) %>%
    add_bars(y = ~group_col, x = ~SHS, name = "SHS", orientation = "h", marker = list(color = "#e15759")) %>%
    layout(
      barmode = "stack",
      title = if (is.null(state$region)) {
        "Total Enrollment by Region"
      } else if (is.null(state$division)) {
        paste("Total Enrollment by Division (", state$region, ")")
      } else {
        paste("Total Enrollment by Legislative District (", state$division, ")")
      },
      xaxis = list(title = "Enrollment", tickformat = ","),
      yaxis = list(title = "", categoryorder = "total ascending", autorange = "reversed"),
      legend = list(orientation = "h", x = 0.3, y = -0.15)
    )
})

# LMS Plot
output$LMS_plot_erdb <- renderPlotly({
  state <- drilldown_state()
  
  if (is.null(state$region)) {
    # National View -> Group by Region
    plot_data <- LMS %>% # Using base LMS data
      filter(LMS == 1) %>% # Applying original filter
      group_by(Region) %>%
      summarise(Count = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$Count, na.rm = TRUE)
    
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Region,                # Flipped
      x = ~Count,                 # Flipped
      type = 'bar', 
      source = "drilldown_source_3",
      text = ~Count,              # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>%
      layout(
        title = "LMS by Region", 
        xaxis = list(title = "Number of LMS", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
    
  } else if (is.null(state$division)) {
    # Regional View -> Group by Division
    plot_data <- LMS %>% # Using base LMS data
      filter(LMS == 1, Region == state$region) %>% # Applying filters
      group_by(Division) %>%
      summarise(Count = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$Count, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Division,              # Flipped
      x = ~Count,                 # Flipped
      type = 'bar', 
      source = "drilldown_source_3",
      text = ~Count,              # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>%
      layout(
        title = paste("LMS in", state$region), 
        xaxis = list(title = "Number of LMS", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
    
  } else {
    # Divisional View -> Group by Legislative District
    plot_data <- LMS %>% # Using base LMS data
      filter(LMS == 1, Region == state$region, Division == state$division) %>% # Applying filters
      group_by(Legislative.District) %>%
      summarise(Count = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$Count, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Legislative.District,  # Flipped
      x = ~Count,                 # Flipped
      type = 'bar',
      text = ~Count,              # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>% 
      layout(
        title = paste("LMS in", state$division), 
        xaxis = list(title = "Number of LMS", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "Legislative District", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
  }
  p
})

# Teacher Shortage Plot
output$teachershortage_plot_erdb <- renderPlotly({
  state <- drilldown_state()
  
  if (is.null(state$region)) {
    # National View -> Group by Region
    plot_data <- df %>% # Using base df data
      group_by(Region) %>%
      summarise(TotalShortage = sum(TeacherShortage, na.rm = TRUE), .groups = 'drop')
    
    max_schools <- max(plot_data$TotalShortage, na.rm = TRUE)
    
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Region,                # Flipped
      x = ~TotalShortage,         # Flipped
      type = 'bar', 
      source = "drilldown_source_4",
      text = ~TotalShortage,      # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>%
      layout(
        title = "Teacher Shortage by Region", 
        xaxis = list(title = "Total Teacher Shortage", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
    
  } else if (is.null(state$division)) {
    # Regional View -> Group by Division
    plot_data <- df %>% # Using base df data
      filter(Region == state$region) %>%
      group_by(Division) %>%
      summarise(TotalShortage = sum(TeacherShortage, na.rm = TRUE), .groups = 'drop')
    
    max_schools <- max(plot_data$TotalShortage, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Division,              # Flipped
      x = ~TotalShortage,         # Flipped
      type = 'bar', 
      source = "drilldown_source_4",
      text = ~TotalShortage,      # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>%
      layout(
        title = paste("Teacher Shortage in", state$region), 
        xaxis = list(title = "Total Teacher Shortage", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
    
  } else {
    # Divisional View -> Group by Legislative District
    plot_data <- df %>% # Using base df data
      filter(Region == state$region, Division == state$division) %>%
      group_by(Legislative.District) %>%
      summarise(TotalShortage = sum(TeacherShortage, na.rm = TRUE), .groups = 'drop')
    
    max_schools <- max(plot_data$TotalShortage, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Legislative.District,  # Flipped
      x = ~TotalShortage,         # Flipped
      type = 'bar',
      text = ~TotalShortage,      # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>% 
      layout(
        title = paste("Teacher Shortage in", state$division), 
        xaxis = list(title = "Total Teacher Shortage", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "Legislative District", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
  }
  p
})

# Principal Shortage Plot
output$principalshortage_plot_erdb <- renderPlotly({
  state <- drilldown_state()
  
  if (is.null(state$region)) {
    # National View -> Group by Region
    plot_data <- uni %>% # Using base uni data
      filter(Designation != "School Principal") %>% # Applying original filter
      group_by(Region) %>%
      summarise(Count = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$Count, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Region,                # Flipped
      x = ~Count,                 # Flipped
      type = 'bar', 
      source = "drilldown_source_5",
      text = ~Count,              # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>%
      layout(
        title = "Schools w/o Principal by Region", 
        xaxis = list(title = "Number of Schools", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
    
  } else if (is.null(state$division)) {
    # Regional View -> Group by Division
    plot_data <- uni %>% # Using base uni data
      filter(Designation != "School Principal", Region == state$region) %>% # Applying filters
      group_by(Division) %>%
      summarise(Count = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$Count, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Division,              # Flipped
      x = ~Count,                 # Flipped
      type = 'bar', 
      source = "drilldown_source_5",
      text = ~Count,              # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>%
      layout(
        title = paste("Schools w/o Principal in", state$region), 
        xaxis = list(title = "Number of Schools", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
    
  } else {
    # Divisional View -> Group by Legislative District
    plot_data <- uni %>% # Using base uni data
      filter(Designation != "School Principal", Region == state$region, Division == state$division) %>% # Applying filters
      group_by(Legislative.District) %>%
      summarise(Count = n(), .groups = 'drop')
    
    max_schools <- max(plot_data$Count, na.rm = TRUE)
    
    p <- plot_ly(
      data = plot_data, 
      y = ~Legislative.District,  # Flipped
      x = ~Count,                 # Flipped
      type = 'bar',
      text = ~Count,              # Added
      texttemplate = '%{x:,.0f}',# Added
      textposition = 'outside'   # Added
    ) %>% 
      layout(
        title = paste("Schools w/o Principal in", state$division), 
        xaxis = list(title = "Number of Schools", tickformat = ",", range = c(0, max_schools * 1.15)), # Swapped
        yaxis = list(title = "Legislative District", categoryorder = "total descending", autorange = "reversed") # Swapped
      )
  }
  p
})

output$Teaching_Deployment_Division_Graph1 <- renderPlotly({
  # --- Use the full dataset ---
  current_filtered_data <- df
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(plotly_empty() %>% 
             layout(title = "No data for selected regions/divisions"))
  }
  
  # --- Prepare data for plotting ---
  plot_data <- current_filtered_data %>%
    group_by(Division) %>%
    summarise(Count = sum(as.numeric(TeacherShortage), na.rm = TRUE), .groups = 'drop') %>%
    arrange(desc(Count)) %>%
    slice_head(n = 20)
  
  # --- Create native Plotly chart ---
  max_count <- max(plot_data$Count, na.rm = TRUE)
  
  p <- plot_ly(
    data = plot_data,
    y = ~reorder(Division, Count), # Division on Y-axis, sorted ascending (plotly reverses)
    x = ~Count,                    # Count on X-axis
    type = 'bar',
    source = "teachingDeploymentDivisionPlot",
    name = "Teacher Shortage",
    # Use Plotly attributes for text labels
    text = ~scales::comma(Count),
    texttemplate = '%{text}',
    textposition = 'outside',
    # Custom hovertext
    hovertemplate = paste(
      "Division: %{y}<br>",
      "Teacher Shortage: %{x:,0f}<extra></extra>"
    )
  ) %>%
    layout(
      title = list(text = "Top 20 Divisions by Teacher Shortage (Teaching Deployment)", 
                   x = 0.5, font = list(size = 14, family = "sans-serif")),
      xaxis = list(title = "Teacher Shortage", tickformat = ",", 
                   range = c(0, max_count * 1.15)),
      yaxis = list(title = "", categoryorder = "total ascending"), # Plotly reverses the order by default
      hoverlabel = list(bgcolor = "white"),
      margin = list(l = 100) # Left margin for division names
    )
  
  return(p)
})

output$Classroom_Shortage_Division_Graph2 <- renderPlotly({
  # Use the reactive filtered data
  current_filtered_data <- LMS
  
  # --- Empty Data Handling ---
  if (nrow(current_filtered_data) == 0) {
    return(plotly_empty() %>% 
             layout(title = "No data for selected regions/divisions"))
  }
  
  # Prepare the data for plotting
  plot_data <- current_filtered_data %>%
    group_by(Division) %>%
    summarise(Count = sum(as.numeric(Estimated_CL_Shortage), na.rm = TRUE), .groups = 'drop') %>%
    arrange(desc(Count)) %>%
    slice_head(n = 20)
  
  # --- Create native Plotly chart ---
  max_count <- max(plot_data$Count, na.rm = TRUE)
  
  p <- plot_ly(
    data = plot_data,
    y = ~reorder(Division, Count), # Division on Y-axis, sorted ascending
    x = ~Count,                    # Count on X-axis
    type = 'bar',
    source = "classroomShortageRegionPlot",
    name = "Classroom Shortage",
    # Use Plotly attributes for text labels
    text = ~scales::comma(Count),
    texttemplate = '%{text}',
    textposition = 'outside',
    # Custom hovertext
    hovertemplate = paste(
      "Division: %{y}<br>",
      "Classroom Shortage: %{x:,0f}<extra></extra>"
    )
  ) %>%
    layout(
      title = list(text = "Top 20 Divisions by Classroom Shortage", 
                   x = 0.5, font = list(size = 14, family = "sans-serif")),
      xaxis = list(title = "Classroom Shortage", tickformat = ",", 
                   range = c(0, max_count * 1.15)),
      yaxis = list(title = "", categoryorder = "total ascending"),
      hoverlabel = list(bgcolor = "white"),
      margin = list(l = 100)
    )
  
  return(p)
})

output$LMS_Division_Graph2 <- renderPlotly({
  full_data <- LMS %>%
    rename(
      "With Buildable Space" = Buildable_space,
      "With Excess Classrooms" = With_Excess,
      "Without Classroom Shortage" = Without_Shortage,
      "Last Mile Schools" = LMS,
      "GIDCA" = GIDCA,
      "With Shortage" = With_Shortage
    ) %>%
    pivot_longer(13:18, names_to = "Type", values_to = "Count")
  
  # --- Keep only "Last Mile Schools" and aggregate all regions ---
  plot_data <- full_data %>%
    filter(Type == "Last Mile Schools") %>%
    group_by(Division) %>%
    summarise(
      Count = sum(as.numeric(Count), na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(desc(Count)) %>%
    slice_head(n = 20)
  
  # --- Create native Plotly chart ---
  max_count <- max(plot_data$Count, na.rm = TRUE)
  
  p <- plot_ly(
    data = plot_data,
    y = ~reorder(Division, Count), # Division on Y-axis, sorted ascending
    x = ~Count,                    # Count on X-axis
    type = 'bar',
    source = "LMSDivisionPlot", # Changed source for uniqueness
    name = "Last Mile Schools",
    # Use Plotly attributes for text labels
    text = ~scales::comma(Count),
    texttemplate = '%{text}',
    textposition = 'outside',
    # Custom hovertext
    hovertemplate = paste(
      "Division: %{y}<br>",
      "Count: %{x:,0f}<extra></extra>"
    )
  ) %>%
    layout(
      title = list(text = "Top 20 Divisions by Last Mile Schools", 
                   x = 0.5, font = list(size = 14, family = "sans-serif")),
      xaxis = list(title = "Number of Last Mile Schools", tickformat = ",", 
                   range = c(0, max_count * 1.15)),
      yaxis = list(title = "", categoryorder = "total ascending"),
      hoverlabel = list(bgcolor = "white"),
      margin = list(l = 100)
    ) %>%
    style(hoverinfo = "text")
  
  return(p)
})