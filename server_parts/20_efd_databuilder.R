# EFD data builder


observeEvent(input$EFD_Region, {
  region_data <- EFDDB %>% filter(Region == input$EFD_Region)
  
  divs <- sort(unique(region_data$Division))
  updatePickerInput(session, "EFD_Division", choices = divs, selected = divs[1])
  
  lds <- sort(unique(region_data$Legislative.District))
  updatePickerInput(session, "EFD_LD", choices = lds, selected = lds[1])
}, ignoreNULL = TRUE, ignoreInit = FALSE)

# When Division changes
observeEvent(input$EFD_Division, {
  req(input$EFD_Region)
  
  div_data <- EFDDB %>%
    filter(Region == input$EFD_Region, Division %in% input$EFD_Division)
  
  lds <- sort(unique(div_data$Legislative.District))
  updatePickerInput(session, "EFD_LD", choices = lds, selected = lds[1])
}, ignoreNULL = TRUE)

# When Legislative District changes (Barangay logic removed)
observeEvent(input$EFD_LD, {
  req(input$EFD_Region)
}, ignoreNULL = TRUE)

# Reactive filter logic
filtered_EFD_reactive <- reactive({
  df <- EFDDB
  
  # Region (single)
  if (!is.null(input$EFD_Region) && nzchar(input$EFD_Region)) {
    df <- df %>% filter(Region == input$EFD_Region)
  }
  
  # Division (multi)
  if (!is.null(input$EFD_Division) && length(input$EFD_Division) > 0) {
    df <- df %>% filter(Division %in% input$EFD_Division)
  }
  
  # Legislative District (multi)
  if (!is.null(input$EFD_LD) && length(input$EFD_LD) > 0) {
    df <- df %>% filter(Legislative.District %in% input$EFD_LD)
  }
  
  df
})

# --- Render DT (with robust "-" replacement for blanks/NA/#N/A) ---
output$EFD_Table <- DT::renderDT(server = FALSE, {
  df <- filtered_EFD_reactive()
  
  if (is.null(df) || !is.data.frame(df) || nrow(df) == 0) {
    return(datatable(data.frame(Message = "No data available for current selection.")))
  }
  
  # Handle toggle columns safely
  selected_cols <- if (!is.null(input$EFD_Toggles) && length(input$EFD_Toggles) > 0) {
    intersect(input$EFD_Toggles, names(df))
  } else {
    character(0)
  }
  
  # Ensure no list columns break the table
  df <- df %>%
    mutate(across(where(is.list), ~ sapply(., function(x) {
      if (length(x) == 0) return(NA)
      paste(as.character(x), collapse = ", ")
    })))
  
  # Base columns (Barangay still visible)
  base_cols <- c("Region", "Division", "Legislative.District", "Barangay", "School.Name", "SchoolID")
  base_cols <- base_cols[base_cols %in% names(df)]
  
  # ✅ Replace NA, blank, or any form of "#N/A" (case-insensitive) with "-"
  df <- df %>%
    mutate(across(
      everything(),
      ~ {
        val <- trimws(as.character(.))  # clean spaces and coerce to text
        ifelse(
          is.na(val) | val == "" | grepl("^#N/A$", val, ignore.case = TRUE),
          "-",
          val
        )
      }
    ))
  
  # Prepare final display
  display_df <- df %>%
    mutate(across(where(is.character), ~ stringr::str_replace_all(., "ñ", "n"))) %>%
    select(all_of(base_cols), any_of(selected_cols))
  
  datatable(
    display_df,
    extension = 'Buttons',
    filter = 'top',
    options = list(
      scrollX = TRUE,
      fixedColumns = list(leftColumns = 4),
      pageLength = 10,
      columnDefs = list(list(className = 'dt-center', targets = "_all")),
      rownames = FALSE,
      dom = 'Bfrtip',
      buttons = list(
        list(extend = "csv", exportOptions = list(modifier = list(page = "all"))),
        list(extend = "excel", exportOptions = list(modifier = list(page = "all"))),
        list(extend = "print", exportOptions = list(modifier = list(page = "all")))
      )
    )
  )
})