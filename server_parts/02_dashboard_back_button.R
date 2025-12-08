current_region <- reactiveVal(NULL)
current_division <- reactiveVal(NULL)

output$backButtonUI <- renderUI({
  # Only show the button if a region is currently selected
  if (!is.null(current_region()) || !is.null(current_division())) {
    actionButton("go_back", "⬅️ Back")
  }
})

observeEvent(input$go_back, {
  
  # Step 1: If we are viewing a Division breakdown, go back to the Region breakdown
  if (!is.null(current_division())) {
    current_division(NULL)
    cat("State change: Returned to Region view.\n")
  } 
  
  # Step 2: Else, if we are viewing a Region breakdown, go back to the Overall view
  else if (!is.null(current_region())) {
    current_region(NULL)
    cat("State change: Returned to Overall view.\n")
  }
  
  # Note: You do not need an 'else' block, as the button won't be visible 
  # unless one of these reactive values is set (thanks to renderUI).
})