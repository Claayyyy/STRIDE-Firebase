# home accordion style



#   # --- Scroll to and open the corresponding accordion when a card is clicked ---
#   # ================================================================
#   # ========== CARD CLICK ACTIONS (scroll + open exact accordion) ==========
#   # ================================================================
#   
#   observeEvent(input$select_hr, {
#     runjs("
#     $('#home_accordion .accordion-collapse').removeClass('show');
#     $('#home_accordion .accordion-button').addClass('collapsed').attr('aria-expanded', 'false');
#     var section = $('#hr_section').closest('.accordion-collapse');
#     var header = section.prev('.accordion-header').find('.accordion-button');
#     section.addClass('show');
#     header.removeClass('collapsed').attr('aria-expanded', 'true');
#     $('html, body').animate({ scrollTop: $('#hr_section').offset().top - 100 }, 600);
#   ")
#   })
#   
#   observeEvent(input$select_school, {
#     runjs("
#     $('#home_accordion .accordion-collapse').removeClass('show');
#     $('#home_accordion .accordion-button').addClass('collapsed').attr('aria-expanded', 'false');
#     var section = $('#school_section').closest('.accordion-collapse');
#     var header = section.prev('.accordion-header').find('.accordion-button');
#     section.addClass('show');
#     header.removeClass('collapsed').attr('aria-expanded', 'true');
#     $('html, body').animate({ scrollTop: $('#school_section').offset().top - 100 }, 600);
#   ")
#   })
#   
#   observeEvent(input$select_classroom, {
#     runjs("
#     $('#home_accordion .accordion-collapse').removeClass('show');
#     $('#home_accordion .accordion-button').addClass('collapsed').attr('aria-expanded', 'false');
#     var section = $('#classroom_section').closest('.accordion-collapse');
#     var header = section.prev('.accordion-header').find('.accordion-button');
#     section.addClass('show');
#     header.removeClass('collapsed').attr('aria-expanded', 'true');
#     $('html, body').animate({ scrollTop: $('#classroom_section').offset().top - 100 }, 600);
#   ")
#   })
#   
#   observeEvent(input$select_financial, {
#     runjs("
#     $('#home_accordion .accordion-collapse').removeClass('show');
#     $('#home_accordion .accordion-button').addClass('collapsed').attr('aria-expanded', 'false');
#     var section = $('#financial_section').closest('.accordion-collapse');
#     var header = section.prev('.accordion-header').find('.accordion-button');
#     section.addClass('show');
#     header.removeClass('collapsed').attr('aria-expanded', 'true');
#     $('html, body').animate({ scrollTop: $('#financial_section').offset().top - 100 }, 600);
#   ")
#   })
#   
#   observeEvent(input$select_monitoring, {
#     runjs("
#     $('#home_accordion .accordion-collapse').removeClass('show');
#     $('#home_accordion .accordion-button').addClass('collapsed').attr('aria-expanded', 'false');
#     var section = $('#monitoring_section').closest('.accordion-collapse');
#     var header = section.prev('.accordion-header').find('.accordion-button');
#     section.addClass('show');
#     header.removeClass('collapsed').attr('aria-expanded', 'true');
#     $('html, body').animate({ scrollTop: $('#monitoring_section').offset().top - 100 }, 600);
#   ")
#   })
#   
#   observeEvent(input$select_ppas, {
#     runjs("
#     $('#home_accordion .accordion-collapse').removeClass('show');
#     $('#home_accordion .accordion-button').addClass('collapsed').attr('aria-expanded', 'false');
#     var section = $('#ppas_section').closest('.accordion-collapse');
#     var header = section.prev('.accordion-header').find('.accordion-button');
#     section.addClass('show');
#     header.removeClass('collapsed').attr('aria-expanded', 'true');
#     $('html, body').animate({ scrollTop: $('#ppas_section').offset().top - 100 }, 600);
#   ")
#   })
#   
#   # ================================================================
#   # ========== BACK TO TOP BUTTON BEHAVIOR ==========
#   # ================================================================
#   
# 
#   observeEvent(input$scroll_top, {
#     runjs("window.scrollTo({ top: 0, behavior: 'smooth' });")
#   })
#   
#   # ================================================================
#   # ========== DRILLDOWN SOURCES (HOME PANEL INCLUDED) ==========
#   # ================================================================
#   
#   source_to_data_map <- list(
#     "drilldown_source_1" = "uni",
#     "drilldown_source_2" = "LMS",
#     "drilldown_source_3" = "LMS",
#     "drilldown_source_4" = "df",
#     "drilldown_source_5" = "uni",
#     
#     # 🆕 Home Panel Sources
#     "drilldown_source_home" = "uni",          # Total Schools
#     "drilldown_source_home_LMS" = "LMS",      # Last Mile Schools
#     "drilldown_source_home_infra" = "LMS"     # Classroom Shortage
#   )
#   
#   drilldown_sources <- names(source_to_data_map)
#   
#   # --- Track Region / Division / District
#   drilldown_state <- reactiveVal(list(region = NULL, division = NULL, district = NULL))
#   
#   lapply(drilldown_sources, function(source_id) {
#     observeEvent(event_data("plotly_click", source = source_id), {
#       click_data <- event_data("plotly_click", source = source_id)
#       if (!is.null(click_data)) {
#         y_val <- click_data$y
#         
#         # 🧭 Region → Division → District
#         state <- drilldown_state()
#         
#         if (is.null(state$region)) {
#           # First click = Region
#           drilldown_state(list(region = y_val, division = NULL, district = NULL))
#           
#         } else if (is.null(state$division)) {
#           # Second click = Division
#           drilldown_state(list(region = state$region, division = y_val, district = NULL))
#           
#         } else if (is.null(state$district)) {
#           # Third click = District
#           drilldown_state(list(region = state$region, division = state$division, district = y_val))
#           
#         } else {
#           # Reset (after 3 levels)
#           drilldown_state(list(region = NULL, division = NULL, district = NULL))
#         }
#       }
#     })
#   })
#   
#   
#   # ================================================================
# # ========== FINANCIAL PLACEHOLDERS (UI ONLY) ============
# # ================================================================
# 
# output$fin_total_budget_allocation <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Total Budget Allocation", class = "text-center"),
#     bslib::card_body(
#       tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#     )
#   )
# })
# 
# output$fin_total_mooe_utilization <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Total MOOE Utilization", class = "text-center"),
#     bslib::card_body(
#       tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#     )
#   )
# })
# 
# output$fin_total_capital_outlay <- renderUI({
#   bslib::card(
#     style = "background-color: #FFFFFF;",
#     bslib::card_header("Total Capital Outlay", class = "text-center"),
#     bslib::card_body(
#       tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#     )
#   )
# })
#   # ================================================================
#   # ========== HUMAN RESOURCE PLACEHOLDERS (UI ONLY) ============
#   # ================================================================
#   
#   output$hr_total_central_office <- renderUI({
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Number of Central Office Personnel", class = "text-center"),
#       bslib::card_body(
#         tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#       )
#     )
#   })
#   
#   output$hr_total_ro_personnel <- renderUI({
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Number of RO Personnel", class = "text-center"),
#       bslib::card_body(
#         tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#       )
#     )
#   })
#   
#   output$hr_total_sdo_personnel <- renderUI({
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Number of SDO Personnel", class = "text-center"),
#       bslib::card_body(
#         tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#       )
#     )
#   })
#   
#   output$hr_total_teaching_personnel <- renderUI({
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Number of Teaching Personnel", class = "text-center"),
#       bslib::card_body(
#         tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#       )
#     )
#   })
#   
#   output$hr_total_nonteaching_personnel <- renderUI({
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Number of Non-teaching Personnel", class = "text-center"),
#       bslib::card_body(
#         tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#       )
#     )
#   })
#   
#   output$hr_total_teaching_related_personnel <- renderUI({
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Number of Teaching-related Personnel", class = "text-center"),
#       bslib::card_body(
#         tags$h3("—", style = "text-align: center; font-weight: 700; color: #999;")
#       )
#     )
#   })
#   # ================================================================
#   # ========== INFRASTRUCTURE VALUE BOXES (HOME) ============
#   # ================================================================
#   
#   # 1. Total Number of Classrooms
#   output$total_classrooms_home <- renderUI({
#     total <- sum(filtered_data_LMS_erdb()$Instructional_Rooms, na.rm = TRUE)
#     
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Number of Classrooms", class = "text-center"),
#       bslib::card_body(
#         tags$h3(scales::comma(total), style = "text-align: center; font-weight: 700;")
#       )
#     )
#   })
#   
#   # 2. Total Number of Schools with Classroom Shortage
#   output$schools_with_shortage_home <- renderUI({
#     shortage_count <- filtered_data_LMS_erdb() %>%
#       filter(Estimated_CL_Shortage > 0) %>%
#       nrow()
#     
#     bslib::card(
#       style = "background-color: #FFE5CC;",
#       bslib::card_header("Schools with Classroom Shortage", class = "text-center"),
#       bslib::card_body(
#         tags$h3(scales::comma(shortage_count), style = "text-align: center; font-weight: 700;")
#       )
#     )
#   })
#   
#   # 3. Total Number of Schools with Classroom Excess
#   output$schools_with_excess_home <- renderUI({
#     excess_count <- filtered_data_LMS_erdb() %>%
#       filter(Estimated_CL_Excess > 0) %>%
#       nrow()
#     
#     bslib::card(
#       style = "background-color: #E0F7FA;",  # light teal for positive
#       bslib::card_header("Schools with Classroom Excess", class = "text-center"),
#       bslib::card_body(
#         tags$h3(scales::comma(excess_count), style = "text-align: center; font-weight: 700;")
#       )
#     )
#   })
#   
#   # 4. Total Number of Schools with Classroom Balance
#   output$schools_with_balance_home <- renderUI({
#     balance_count <- filtered_data_LMS_erdb() %>%
#       filter(Estimated_CL_Shortage == 0 & Estimated_CL_Excess == 0) %>%
#       nrow()
#     
#     bslib::card(
#       style = "background-color: #E8F5E9;",  # light green
#       bslib::card_header("Schools with Classroom Balance", class = "text-center"),
#       bslib::card_body(
#         tags$h3(scales::comma(balance_count), style = "text-align: center; font-weight: 700;")
#       )
#     )
#   })
#   
#   # 5. Total Number of Classrooms Needing Repairs
#   output$classrooms_needing_repair_home <- renderUI({
#     repair_count <- sum(filtered_data_LMS_erdb()$Rooms_Needing_Repairs, na.rm = TRUE)
#     
#     bslib::card(
#       style = "background-color: #FFF3CD; color: #664D03;",
#       bslib::card_header("Classrooms Needing Repairs", class = "text-center"),
#       bslib::card_body(
#         tags$h3(scales::comma(repair_count), style = "text-align: center; font-weight: 700;")
#       )
#     )
#   })
#   
#   # --- Classroom Shortage Drilldown (Infrastructure Accordion in Home Panel) ---
#   output$classroomshortage_plot_home <- renderPlotly({
#     state <- drilldown_state()
#     
#     if (is.null(state$region)) {
#       # National View -> Group by Region
#       plot_data <- LMS %>%
#         group_by(Region) %>%
#         summarise(TotalShortage = sum(Estimated_CL_Shortage, na.rm = TRUE), .groups = 'drop')
#       
#       max_schools <- max(plot_data$TotalShortage, na.rm = TRUE)
#       
#       p <- plot_ly(
#         data = plot_data, 
#         y = ~Region,
#         x = ~TotalShortage,
#         type = 'bar',
#         source = "drilldown_source_home_infra",
#         text = ~TotalShortage,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = "Classroom Shortage by Region", 
#           xaxis = list(title = "Total Shortage", tickformat = ",", range = c(0, max_schools * 1.15)),
#           yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed")
#         )
#       
#     } else if (is.null(state$division)) {
#       # Regional View -> Group by Division
#       plot_data <- LMS %>%
#         filter(Region == state$region) %>%
#         group_by(Division) %>%
#         summarise(TotalShortage = sum(Estimated_CL_Shortage, na.rm = TRUE), .groups = 'drop')
#       
#       max_schools <- max(plot_data$TotalShortage, na.rm = TRUE)
#       
#       p <- plot_ly(
#         data = plot_data, 
#         y = ~Division,
#         x = ~TotalShortage,
#         type = 'bar',
#         source = "drilldown_source_home_infra",
#         text = ~TotalShortage,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = paste("Classroom Shortage in", state$region),
#           xaxis = list(title = "Total Shortage", tickformat = ",", range = c(0, max_schools * 1.15)),
#           yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed")
#         )
#       
#     } else {
#       # Divisional View -> Group by Legislative District
#       plot_data <- LMS %>%
#         filter(Region == state$region, Division == state$division) %>%
#         group_by(Legislative.District) %>%
#         summarise(TotalShortage = sum(Estimated_CL_Shortage, na.rm = TRUE), .groups = 'drop')
#       
#       max_schools <- max(plot_data$TotalShortage, na.rm = TRUE)
#       
#       p <- plot_ly(
#         data = plot_data,
#         y = ~Legislative.District,
#         x = ~TotalShortage,
#         type = 'bar',
#         text = ~TotalShortage,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = paste("Classroom Shortage in", state$division),
#           xaxis = list(title = "Total Shortage", tickformat = ",", range = c(0, max_schools * 1.15)),
#           yaxis = list(title = "Legislative District", categoryorder = "total descending", autorange = "reversed")
#         )
#     }
#     p
#   })
#   
#   # ================================================================
#   # ========== BASIC INFO: SCHOOL VISUALIZATIONS (HOME) ============
#   # ================================================================
#   output$total_schools_home <- renderUI({
#     total <- nrow(filtered_data_uni_erdb())  # reuse your existing filtered data
#     
#     bslib::card(
#       style = "background-color: #FFFFFF;",
#       bslib::card_header("Total Schools Count", class = "text-center"),
#       bslib::card_body(
#         tags$h3(
#           scales::comma(total),
#           style = "text-align: center; font-weight: 700;"
#         )
#       )
#     )
#   })
#   # ========== TOTAL SCHOOLS PLOT ==========
#   output$totalschools_plot_home <- renderPlotly({
#     state <- drilldown_state()
#     
#     if (is.null(state$region)) {
#       plot_data <- uni %>%
#         group_by(Region) %>%
#         summarise(TotalSchools = n(), .groups = 'drop')
#       
#       p <- plot_ly(
#         data = plot_data,
#         y = ~Region,
#         x = ~TotalSchools,
#         type = 'bar',
#         source = "drilldown_source_home",  # ✅ Keep source for Region
#         text = ~TotalSchools,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = "Total Schools by Region",
#           xaxis = list(title = "Number of Schools"),
#           yaxis = list(title = "", autorange = "reversed")
#         )
#       
#     } else if (is.null(state$division)) {
#       plot_data <- uni %>%
#         filter(Region == state$region) %>%
#         group_by(Division) %>%
#         summarise(TotalSchools = n(), .groups = 'drop')
#       
#       p <- plot_ly(
#         data = plot_data,
#         y = ~Division,
#         x = ~TotalSchools,
#         type = 'bar',
#         source = "drilldown_source_home",  # ✅ KEEP SAME SOURCE
#         text = ~TotalSchools,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = paste("Schools in", state$region),
#           xaxis = list(title = "Number of Schools"),
#           yaxis = list(title = "", autorange = "reversed")
#         )
#       
#     } else {
#       plot_data <- uni %>%
#         filter(Region == state$region, Division == state$division) %>%
#         group_by(Legislative.District) %>%
#         summarise(TotalSchools = n(), .groups = 'drop')
#       
#       p <- plot_ly(
#         data = plot_data,
#         y = ~Legislative.District,
#         x = ~TotalSchools,
#         type = 'bar',
#         source = "drilldown_source_home",  # ✅ KEEP SAME SOURCE
#         text = ~TotalSchools,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = paste("Schools in", state$division),
#           xaxis = list(title = "Number of Schools"),
#           yaxis = list(title = "Legislative District", autorange = "reversed")
#         )
#     }
#     
#     p
#   })
#   
#   
#   # ========== CURRICULAR OFFERING PLOT ==========
#   output$curricular_plot_home <- renderPlotly({
#     state <- drilldown_state()
#     
#     plot_data <- if (is.null(state$region)) {
#       uni
#     } else if (is.null(state$division)) {
#       uni %>% filter(Region == state$region)
#     } else {
#       uni %>% filter(Region == state$region, Division == state$division)
#     }
#     
#     pie_data <- plot_data %>%
#       group_by(Modified.COC) %>%
#       summarise(Count = n(), .groups = 'drop')
#     
#     title_text <- if (is.null(state$region)) {
#       "By Curricular Offering (National)"
#     } else if (is.null(state$division)) {
#       paste("By Curricular Offering (", state$region, ")")
#     } else {
#       paste("By Curricular Offering (", state$division, ")")
#     }
#     
#     plot_ly(
#       data = pie_data,
#       labels = ~Modified.COC,
#       values = ~Count,
#       type = 'pie',
#       textinfo = 'percent',
#       insidetextorientation = 'radial'
#     ) %>%
#       layout(title = title_text, showlegend = TRUE)
#   })
#   
#   # ========== LAST MILE SCHOOLS PLOT ==========
#   output$LMS_plot_home <- renderPlotly({
#     state <- drilldown_state()
#     
#     if (is.null(state$region)) {
#       # --- NATIONAL VIEW ---
#       plot_data <- LMS %>%
#         filter(LMS == 1) %>%
#         group_by(Region) %>%
#         summarise(Count = n(), .groups = 'drop')
#       
#       max_schools <- max(plot_data$Count, na.rm = TRUE)
#       
#       p <- plot_ly(
#         data = plot_data, 
#         y = ~Region,
#         x = ~Count,
#         type = 'bar',
#         source = "drilldown_source_home",   # ✅ SAME SOURCE AS WORKING CHART
#         text = ~Count,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = "Last Mile Schools by Region",
#           xaxis = list(title = "Number of LMS", tickformat = ",", range = c(0, max_schools * 1.15)),
#           yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed")
#         )
#       
#     } else if (is.null(state$division)) {
#       # --- REGIONAL VIEW ---
#       plot_data <- LMS %>%
#         filter(LMS == 1, Region == state$region) %>%
#         group_by(Division) %>%
#         summarise(Count = n(), .groups = 'drop')
#       
#       max_schools <- max(plot_data$Count, na.rm = TRUE)
#       
#       p <- plot_ly(
#         data = plot_data, 
#         y = ~Division,
#         x = ~Count,
#         type = 'bar',
#         source = "drilldown_source_home",   # ✅ SAME SOURCE
#         text = ~Count,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = paste("LMS in", state$region),
#           xaxis = list(title = "Number of LMS", tickformat = ",", range = c(0, max_schools * 1.15)),
#           yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed")
#         )
#       
#     } else {
#       # --- DIVISIONAL VIEW (drilldown to district) ---
#       plot_data <- LMS %>%
#         filter(LMS == 1, Region == state$region, Division == state$division) %>%
#         group_by(Legislative.District) %>%
#         summarise(Count = n(), .groups = 'drop')
#       
#       max_schools <- max(plot_data$Count, na.rm = TRUE)
#       
#       p <- plot_ly(
#         data = plot_data, 
#         y = ~Legislative.District,
#         x = ~Count,
#         type = 'bar',
#         source = "drilldown_source_home",   # ✅ SAME SOURCE
#         text = ~Count,
#         texttemplate = '%{x:,.0f}',
#         textposition = 'outside'
#       ) %>%
#         layout(
#           title = paste("LMS in", state$division),
#           xaxis = list(title = "Number of LMS", tickformat = ",", range = c(0, max_schools * 1.15)),
#           yaxis = list(title = "Legislative District", categoryorder = "total descending", autorange = "reversed")
#         )
#     }
#     
#     p
#   })
#   
#   
#   # ========== TYPOLOGY PLOT ==========
#   output$typology_plot_home <- renderPlotly({
#     state <- drilldown_state()
#     
#     plot_data <- if (is.null(state$region)) {
#       uni
#     } else if (is.null(state$division)) {
#       uni %>% filter(Region == state$region)
#     } else {
#       uni %>% filter(Region == state$region, Division == state$division)
#     }
#     
#     typology_data <- plot_data %>%
#       group_by(School.Size.Typology) %>%
#       summarise(Count = n(), .groups = 'drop')
#     
#     max_schools <- max(typology_data$Count, na.rm = TRUE)
#     
#     title_text <- if (is.null(state$region)) {
#       "By School Size (National)"
#     } else if (is.null(state$division)) {
#       paste("By School Size (", state$region, ")")
#     } else {
#       paste("By School Size (", state$division, ")")
#     }
#     
#     plot_ly(
#       data = typology_data,
#       y = ~School.Size.Typology,
#       x = ~Count,
#       type = 'bar',
#       text = ~Count,
#       texttemplate = '%{x:,.0f}',
#       textposition = 'outside'
#     ) %>%
#       layout(
#         title = title_text,
#         yaxis = list(title = "", categoryorder = "total descending", autorange = "reversed"),
#         xaxis = list(title = "Number of Schools", tickformat = ",", range = c(0, max_schools * 1.15))
#       )
#   })