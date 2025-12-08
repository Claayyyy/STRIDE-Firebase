# third level dashboard

filtered_third <- reactive({
  df <- ThirdLevel %>%
    filter(STRAND %in% input$ThirdLevel_Strands) %>%
    mutate(across(
      c(STRAND, BUREAU.SERVICE, OFFICE, NAME, POSITION, DESIGNATION, TELEPHONE.NUMBER, DEPED.EMAIL),
      ~ ifelse(is.na(.) | . == "", "-", .)
    ))
  
  print(head(df))
  df
  
})

output$ThirdLevel_Table <- DT::renderDT(server = FALSE, {
  
  
  datatable(
    filtered_third() %>%
      select(
        STRAND,
        OFFICE,
        BUREAU.SERVICE,
        NAME,
        POSITION,
        DESIGNATION,
        TELEPHONE.NUMBER,
        DEPED.EMAIL
      ),
    extension = 'Buttons',
    filter = 'top',
    options = list(
      scrollX = TRUE,
      autoWidth = TRUE,
      fixedColumns = list(leftColumns = 5),
      pageLength = 10,
      columnDefs = list(list(className = 'dt-center', targets = "_all")),
      dom = get_dt_dom('Bfrtip'),
      buttons = list(
        list(extend = "csv", exportOptions = list(modifier = list(page = "all"))),
        list(extend = "excel", exportOptions = list(modifier = list(page = "all"))),
        list(extend = "print", exportOptions = list(modifier = list(page = "all")))
      )
    )
    
    
  )
})