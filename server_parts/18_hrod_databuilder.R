# HROD DATA BUILDER

output$HROD_Table <- DT::renderDT(server = FALSE, {
  all_regions <- unique(uni$Region)
  all_divisions <- unique(uni$Division)
  
  all_regions_selected <- length(input$DataBuilder_HROD_Region) == length(all_regions)
  all_divisions_selected <- length(input$DataBuilder_SDO) == length(all_divisions)
  
  filtered_uni <- reactive({
    if (all_regions_selected && all_divisions_selected) {
      return(uni)
    } else {
      uni %>%
        filter(Region %in% input$DataBuilder_HROD_Region) %>%
        filter(Division %in% input$DataBuilder_SDO)
    }
  })
  
  datatable(
    filtered_uni() %>%
      mutate(across(where(is.character), ~ str_replace_all(., "ñ", "n"))) %>%
      mutate(across(18:43, ~ if_else(. == 0, "-", as.character(.)))) %>%
      # Removed input$EFD_Data_Toggles from selection
      select(Region, School.Name, SchoolID, Division, District,
             input$School_Data_Toggles,
             input$Teaching_Data_Toggles,
             input$NTP_Data_Toggles,
             input$Enrolment_Data_Toggles,
             input$Specialization_Data_Toggles,
             input$Infrastructure_Data_Toggles) %>%
      arrange(desc(District)),
    extension = 'Buttons',
    filter = 'top',
    options = list(
      scrollX = TRUE,
      fixedColumns = list(leftColumns = 6),
      pageLength = 10,
      columnDefs = list(list(className = 'dt-center', targets = "_all")),
      rownames = FALSE,
      dom = get_dt_dom('Bfrtip'),
      buttons = list(
        list(extend = "csv", exportOptions = list(modifier = list(page = "all"))),
        list(extend = "excel", exportOptions = list(modifier = list(page = "all"))),
        list(extend = "print", exportOptions = list(modifier = list(page = "all")))
      )
    )
  )
})


output$DataBuilder_HROD_SDO <- renderUI({
  
  divisions_vector <- uni %>% 
    filter(Region %in% input$DataBuilder_HROD_Region) %>%
    pull(Division)
  
  # Ensure divisions are unique and sorted
  sorted_unique_divisions <- sort(unique(divisions_vector))
  
  # Create the final choices list
  choices_list <- c(sorted_unique_divisions)
  
  # Check if there are any divisions to display
  if (length(choices_list) > 1) {
    pickerInput(
      inputId = "DataBuilder_SDO",
      label = "Select a Division:",
      choices = choices_list,
      selected = choices_list,
      multiple = TRUE,
      options = pickerOptions(
        actionsBox = TRUE,
        liveSearch = TRUE,
        header = "Select Categories",
        title = "No Category Selected",
        selectedTextFormat = "count > 3",
        dropupAuto = FALSE,
        dropup = FALSE
      ),
      choicesOpt = list()
    )
  } else {
    # Return NULL if there are no divisions to display.
    return(NULL)
  }
})