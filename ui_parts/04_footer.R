# ui_parts/04_footer.R

ui_footer <- shinyjs::hidden(
  tags$footer(
    id = "app_footer",
    class = "app-footer",
    
    # Container to stack the items vertically
    div(
      style = "display: flex; flex-direction: column; align-items: center; gap: 5px;",
      
      # 1. Existing Copyright / Data Source Line
      tags$span(
        "© Based on GMIS (October 2025) and eBEIS (SY 2024–2025)",
        style = "font-weight: 600;"
      ),
      
      # 2. New Contact Information Line
      div(
        style = "font-size: 0.9em; color: #666; display: flex; gap: 15px; align-items: center;",
        
        # Email
        tags$span(
          bsicons::bs_icon("envelope-fill", size = "0.9em"), 
          " support.stride@deped.gov.ph" # <-- Replace with actual email
        ),

        # Vertical Separator
        tags$span("|", style = "color: #ccc;"),

        # Phone
        tags$a(
          href = "https://docs.google.com/forms/d/e/1FAIpQLSeMF0ovtg7LlrcRTBRiSszknestVcIPiGx7eXVNPV8_7HYFlQ/viewform?usp=dialog",
          target = "_blank",
          style = "color: inherit; text-decoration: none; cursor: pointer;", # Optional: keeps text styling consistent
          bsicons::bs_icon("file-earmark-text", size = "0.9em"), # Icon for form/report
          " User Concern Form"
        )
      )
    )
  )
)