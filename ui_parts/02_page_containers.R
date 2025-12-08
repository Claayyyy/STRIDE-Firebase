# ui_parts/02_page_containers.R

ui_containers <- tagList(
  # 💡 CRITICAL FIX: The dynamic container for login/main app UI
  uiOutput("page_ui"),
  
  shinyjs::hidden(
    div(
      id = "main_content",
      uiOutput("STRIDE1"))),
  
  shinyjs::hidden(
    div(
      id = "mgmt_content",
      uiOutput("STRIDE2"))),
  
  
  shinyjs::hidden(
    div(
      id = "data_input_content",
      uiOutput("STRIDE_data")))
)