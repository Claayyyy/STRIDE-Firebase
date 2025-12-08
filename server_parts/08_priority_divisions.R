# priority divisions

priority_data_reactive <- reactive({
  
  # --- Data Preparation (Your existing code) ---
  priority_df <- df %>%
    group_by(Division) %>%
    summarise(Count_TeacherShortage = sum(as.numeric(TeacherShortage), na.rm = TRUE), .groups = 'drop') %>%
    arrange(desc(Count_TeacherShortage)) %>%
    mutate(Rank_TeacherShortage = row_number())
  
  priority_classroom <- LMS %>%
    group_by(Division) %>%
    summarise(Count_ClassroomShortage = sum(as.numeric(Estimated_CL_Shortage), na.rm = TRUE), .groups = 'drop') %>%
    arrange(desc(Count_ClassroomShortage)) %>%
    mutate(Rank_ClassroomShortage = row_number())
  
  priority_SP <- uni %>% 
    filter(Designation != "School Principal") %>% 
    group_by(Division) %>%
    summarise(Count_SPShortage = n(), .groups = 'drop') %>%
    arrange(desc(Count_SPShortage)) %>%
    mutate(Rank_SPShortage = row_number())
  
  priority_LMS <- LMS %>%
    rename(
      "With Buildable Space" = Buildable_space,
      "With Excess Classrooms" = With_Excess,
      "Without Classroom Shortage" = Without_Shortage,
      "Last Mile Schools" = LMS,
      "GIDCA" = GIDCA,
      "With Shortage" = With_Shortage
    ) %>%
    pivot_longer(starts_with(c("With_", "Without_", "Last Mile", "GIDCA")), names_to = "Type", values_to = "Count") %>%
    filter(Type == "Last Mile Schools") %>%
    group_by(Division) %>%
    summarise(
      Count_LastMileSchools = sum(as.numeric(Count), na.rm = TRUE),
      .groups = "drop"
    ) %>%
    arrange(desc(Count_LastMileSchools)) %>%
    mutate(Rank_LastMileSchools = row_number())
  
  combined_df <- full_join(
    priority_df,
    priority_classroom,
    by = "Division"
  )
  
  full_priority_div <- full_join(
    combined_df,
    priority_LMS,
    by = "Division"
  )
  
  data_to_display <- full_join(
    full_priority_div,
    priority_SP,
    by = "Division"
  ) %>%
    left_join(uni %>% select(Region,Division), by = "Division") %>%
    distinct() %>%
    
    # Handle blank/NA Regions
    mutate(Region = if_else(is.na(Region) | Region == "", "BARMM", Region)) %>%
    
    rename(
      "Teacher Shortage" = Count_TeacherShortage,
      "Teacher Shortage Rank" = Rank_TeacherShortage,
      "Classroom Shortage" = Count_ClassroomShortage,
      "Classroom Shortage Rank" = Rank_ClassroomShortage,
      "Last Mile Schools" = Count_LastMileSchools,
      "Last Mile Schools Rank" = Rank_LastMileSchools,
      "School Principal Shortage" = Count_SPShortage,
      "School Principal Shortage Rank" = Rank_SPShortage
    ) %>%
    select(
      Region,
      Division,
      "Teacher Shortage",
      "School Principal Shortage",
      "Classroom Shortage",
      "Last Mile Schools",
      "Teacher Shortage Rank",
      "School Principal Shortage Rank",
      "Classroom Shortage Rank",
      "Last Mile Schools Rank"
    ) %>%
    arrange(Division)
  
  # Return the final data frame
  return(data_to_display)
})


# --- B. MODIFIED: Your renderReactable ---
# This is now much simpler. It just GETS the data
# from the reactive expression above.

output$priority_division_erdb <- DT::renderDataTable({
  
  # Get the data from our reactive expression
  data_to_display <- priority_data_reactive()
  
  # --- Custom Rank Formatting Function (Stays here) ---
  add_rank_suffix <- function(rank) {
    if (is.null(rank) || is.na(rank)) {
      return("-") # We will replace NAs later, but this handles explicit NULLs
    }
    rank_int <- as.integer(rank)
    formatted_rank <- paste0(
      rank_int,
      case_when(
        rank_int %in% c(11, 12, 13) ~ "th",
        rank_int %% 10 == 1 ~ "st",
        rank_int %% 10 == 2 ~ "nd",
        rank_int %% 10 == 3 ~ "rd",
        TRUE ~ "th"
      )
    )
    return(formatted_rank)
  }
  
  # --- Handle Empty Data Case ---
  if (is.null(data_to_display) || nrow(data_to_display) == 0) {
    # Return a simple table with the message
    return(
      DT::datatable(
        data.frame("Message" = "No data available based on current selection."),
        rownames = FALSE,
        options = list(
          dom = 't', # 't' = table only, no filter/search
          ordering = FALSE
        )
      )
    )
  }
  
  # --- Data Pre-processing (Replaces reactable's 'cell' and 'na') ---
  # Define column groups for manipulation
  rank_cols <- c("Teacher Shortage Rank", "School Principal Shortage Rank", 
                 "Classroom Shortage Rank", "Last Mile Schools Rank")
  na_dash_cols <- c("Teacher Shortage", "School Principal Shortage", 
                    "Classroom Shortage", "Last Mile Schools")
  
  # Apply formatting *before* passing to DT
  processed_data <- data_to_display %>%
    # Apply the rank suffix function (replicates 'cell = ...')
    # We use sapply to apply the function to each element
    dplyr::mutate(across(all_of(rank_cols), ~sapply(., add_rank_suffix))) %>%
    
    # Convert data columns to character *before* replacing NAs
    dplyr::mutate(across(all_of(na_dash_cols), as.character)) %>%
    
    # Replace NAs with "-" (replicates 'na = "-"')
    dplyr::mutate(across(all_of(c(na_dash_cols, rank_cols)), ~tidyr::replace_na(., "-")))
  
  
  # --- Column Definitions for DT ---
  # Get column names and 0-based indices for 'columnDefs'
  col_names <- colnames(processed_data)
  
  # Find indices for all columns (for centering)
  all_col_indices <- seq_along(col_names) - 1
  
  # Find indices for rank columns (for width)
  rank_col_indices <- which(col_names %in% rank_cols) - 1
  
  # Build the columnDefs list
  col_defs <- list(
    # Center-align ALL columns (replicates 'align = "center"')
    list(targets = all_col_indices, className = 'dt-center'),
    
    # Set specific widths for rank columns (replicates 'width = 120')
    list(targets = rank_col_indices, width = '120px')
  )
  
  
  # --- DT::datatable Output ---
  DT::datatable(
    processed_data,
    
    # --- Features ---
    filter = 'top',                 # <-- 'filterable = TRUE'
    rownames = FALSE,
    extensions = c('Buttons', 'FixedColumns'), # Add FixedColumns for 'sticky'
    
    # --- Options List ---
    options = list(
      # --- Layout & Features ---
      # 'l'=length, 'B'=buttons, 'f'=filter, 'r'=processing, 't'=table, 'i'=info, 'p'=pagination
      dom = get_dt_dom('lBfrtip'),
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), # Download buttons
      ordering = TRUE,              # <-- 'sortable = TRUE' (default)
      
      # --- Pagination ---
      pageLength = 15,              # <-- 'defaultPageSize = 15'
      lengthMenu = c(15, 25, 50, 100), # <-- 'pageSizeOptions'
      
      # --- Fixed Columns (Sticky) ---
      scrollX = TRUE,               # <-- Required for FixedColumns
      fixedColumns = list(
        leftColumns = 2             # <-- 'sticky = "left"' for Region & Division
      ),
      
      # --- Column Definitions ---
      columnDefs = col_defs,
      
      # --- Other ---
      # 'sortNALast' is not a direct DT feature.
      # By converting NAs to "-", they will sort as strings (e.g., at the end).
      language = list(
        search = "Search all columns:" # Replicates 'searchable = TRUE' label
      )
    )
  )
})

# --- C. NEW: Add the downloadHandler ---
# This powers the button you made in the UI.
# It uses the SAME reactive data.

# output$download_priority_data <- downloadHandler(
#   
#   # This sets the name of the file the user will download
#   filename = function() {
#     paste0("priority-division-data-", Sys.Date(), ".csv")
#   },
#   
#   # This function writes the data to the file
#   content = function(file) {
#     # Get the data from our reactive expression
#     data_for_csv <- priority_data_reactive()
#     
#     # Write the data to the 'file' path
#     # NOTE: The downloaded CSV will have the raw data
#     # (e.g., numeric ranks "1", "2", not "1st", "2nd")
#     # which is usually what users want for export.
#     readr::write_csv(data_for_csv, file)
#   }
# )