# data input form

output$STRIDE_data <- renderUI({
  fluidPage(
    theme = bs_theme(
      version = 5,
      base_font = font_google("Poppins")
    ),
    
    # --- CUSTOM CSS FOR FLOATING SIDEBAR ---
    tags$head(
      tags$style(HTML("
     
      #submit:disabled {
        background-color: #cccccc; /* Light gray background */
        border-color: #cccccc;    /* Matching border color */
        color: #666666;          /* Dark gray text for readability */
        cursor: not-allowed;      /* Show a 'not-allowed' mouse cursor */
      }
      .input-error {
        border: 1px solid #dc3545; /* A standard red color */
        box-shadow: 0 0 0.2rem #dc3545; /* Adds a subtle glow */
      }
    "))
    ),
    
    useShinyjs(),
    br(),
    tags$div(
      id = "form_title_bar", # Unique ID for potential custom CSS
      style = "
    background-color: #f0ad4e; /* Deep Blue, matching a professional theme */
    color: white; /* White text for contrast */
    padding: 15px 20px; /* Padding inside the bar */
    margin-bottom: 20px; /* Space below the bar */
    border-radius: 5px; /* Slightly rounded corners for a modern look */
    text-align: center; /* Center the text */
    box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Subtle shadow for depth */
  ",
      h1(
        strong("STRIDE Data Entry Form"),
        style = "
      margin: 0; 
      font-size: 2.5rem;
      /* 💡 NEW: Add the text-shadow property here */
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.4); 
    "  # Ensure no default margin and use a large font
      )
    ),
    
    div(
      id = "form_container",
      
      sidebarLayout(
        
        # The sidebar panel now contains Step 1
        sidebarPanel(
          id = "sidebar", # ID for the CSS to target
          width = 3,      # Adjust width (out of 12)
          h3(strong("School Profile")),
          hr(),
          textInput("school_id", "School ID", placeholder = "e.g. 193849"),
          textInput("school_name", "School Name:", placeholder = "e.g. Juan Dela Cruz Elementary School"),
          selectInput("stride_region", "Region:",
                      choices = c("--- Select a Region ---" = "", "Region I", "Region II", "Region III", "Region IV-A", "MIMAROPA", "Region V", "Region VI", "NIR", "Region VII", "Region VIII", "Region IX", "Region X", "Region XI", "Region XII", "CARAGA", "CAR", "NCR"),
                      selected = NULL),
          uiOutput("stride_division"),
          selectInput("curricular_offering", "Filter Curricular Offering:",
                      choices = c("--- Select a Curricular Offering ---" = "","Purely ES", "Purely JHS", "Purely SHS", "JHS and SHS", "ES and JHS", "All Offering"),
                      selected = NULL)
        ),
        
        # The main panel contains the rest of the form
        mainPanel(
          width = 9, # Adjusted width to complement sidebar
          accordion(
            id = "form_accordion",
            multiple = FALSE,
            
            accordion_panel(
              title = strong("School Information"),
              value = "step1",
              fluidRow(
                textInput("school_head_gn", "Given Name (School Head):", placeholder = "Enter Given Name"),
                textInput("school_head_mn", "Middle Name (School Head):", placeholder = "Enter Middle Name"),
                textInput("school_head_ln", "Last Name (School Head):", placeholder = "Enter Last Name"),
                selectInput("school_head_position", "Plantilla Position:",
                            choices = c("School Principal I","School Principal II","School Principal III")),
                textInput("school_head_contact", "Contact Number", placeholder = "e.g. 09129382923"),
                textInput("school_head_contact_alt", "Alternative Contact Number", placeholder = "e.g. 09122314424"),
                textInput("school_head_email", "DepEd Email Address:", placeholder = "e.g. juan.delacruz@deped.gov.ph"),
                textInput("school_head_email_alt", "Alternative Email Address:", placeholder = "e.g. juan.delacruz@gmail.com")
              )
            ),
            
            accordion_panel(
              title = strong("Enrolment per Grade Level"),
              value = "step2",
              fluidRow(
                column(4, numericInput("g1","Grade 1", value = "")),
                column(4, numericInput("g2","Grade 2", value = "")),
                column(4, numericInput("g3","Grade 3", value = "")),
                column(4, numericInput("g4","Grade 4", value = "")),
                column(4, numericInput("g5","Grade 5", value = "")),
                column(4, numericInput("g6","Grade 6", value = "")),
                column(4, numericInput("g7","Grade 7", value = "")),
                column(4, numericInput("g8","Grade 8", value = "")),
                column(4, numericInput("g9","Grade 9", value = "")),
                column(4, numericInput("g10","Grade 10", value = "")),
                column(4, numericInput("g11","Grade 11", value = "")),
                column(4, numericInput("g12","Grade 12", value = ""))
              )
            ),
            
            accordion_panel(
              title = strong("Organized Classes per Grade Level"),
              value = "step3",
              fluidRow(
                column(4, numericInput("org_g1","Grade 1", value = "")),
                column(4, numericInput("org_g2","Grade 2", value = "")),
                column(4, numericInput("org_g3","Grade 3", value = "")),
                column(4, numericInput("org_g4","Grade 4", value = "")),
                column(4, numericInput("org_g5","Grade 5", value = "")),
                column(4, numericInput("org_g6","Grade 6", value = "")),
                column(4, numericInput("org_g7","Grade 7", value = "")),
                column(4, numericInput("org_g8","Grade 8", value = "")),
                column(4, numericInput("org_g9","Grade 9", value = "")),
                column(4, numericInput("org_g10","Grade 10", value = "")),
                column(4, numericInput("org_g11","Grade 11", value = "")),
                column(4, numericInput("org_g12","Grade 12", value = ""))
              )
            ),
            
            accordion_panel(
              title = strong("Number of Teaching Personnel"),
              value = "step4",
              fluidRow(
                column(4, numericInput("teaching_elem","Total ES Teachers", value = "")),
                column(4, numericInput("teaching_jhs","Total JHS Teachers", value = "")),
                column(4, numericInput("teaching_shs","Total SHS Teachers", value = ""))
              )
            ),
            
            accordion_panel(
              title = strong("School Infrastructure"),
              value = "step5",
              fluidRow(
                column(4, numericInput("instructional_rooms_es","Number of Classrooms for ES", value = "")),
                column(4, numericInput("instructional_rooms_jhs","Number of Classrooms for JHS", value = "")),
                column(4, numericInput("instructional_rooms_shs","Number of Classrooms for SHS", value = "")),
                column(4, numericInput("instructional_rooms_repair","Number of Classrooms for Repair", value = "")),
                column(4, numericInput("buildings","Number of Buildings", value = "")),
                column(4, numericInput("buildings_repair","Number of Buildings for Repair", value = ""))
              )
            ),
            
            accordion_panel(
              title = strong("School Resources"),
              value = "step6",
              fluidRow(
                column(3, numericInput("laptops","Number of Laptops", value = "")),
                column(3, numericInput("laptops_repair","Number of Laptops for Repair", value = "")),
                column(3, numericInput("chairs","Number of Chairs", value = "")),
                column(3, numericInput("chairs_repair","Number of Chairs for Repair", value = "")),
                column(3, numericInput("desk","Number of Desks", value = "")),
                column(3, numericInput("desk_repair","Number of Desks for Repair", value = "")),
                column(3, numericInput("ecart","Number of e-carts", value = "")),
                column(3, numericInput("ecart_repair","Number of e-carts for Repair", value = "")),
                column(3, numericInput("toilet","Number of Toilets", value = "")),
                column(3, numericInput("toilet_repair","Number of Toilets for Repair", value = "")),
                column(3, numericInput("printer","Number of Printers", value = "")),
                column(3, numericInput("printer_repair","Number of Printers for Repair", value = "")),
                column(3, numericInput("tv","Number of TV", value = "")),
                column(3, numericInput("tv_repair","Number of TV for Repair", value = "")),
                column(3, numericInput("science_lab","Number of Science Labs", value = "")),
                column(3, numericInput("computer_lab","Number of Computer Labs", value = "")),
                column(3, numericInput("tvl_lab","Number of TVL Labs", value = ""))
              )
            ),
            
            accordion_panel(
              title = strong("Teacher Specialization"),
              value = "step7",
              fluidRow(
                column(4, numericInput("english","English", value = "")),
                column(4, numericInput("math","Math", value = "")),
                column(4, numericInput("science","Science", value = "")),
                column(4, numericInput("biological_science","Biological Science", value = "")),
                column(4, numericInput("physical_science","Physical Science", value = "")),
                column(4, numericInput("general_education","General Education", value = "")),
                column(4, numericInput("araling_panlipunan","Araling Panlipunan", value = "")),
                column(4, numericInput("tle","TLE", value = "")),
                column(4, numericInput("mapeh","MAPEH", value = "")),
                column(4, numericInput("filipino","Filipino", value = "")),
                column(4, numericInput("esp","ESP", value = "")),
                column(4, numericInput("agriculture","Agriculture", value = "")),
                column(4, numericInput("ece","Early Childhood Education", value = "")),
                column(4, numericInput("sped","SPED", value = ""))
              )
              # REMOVED: Duplicate submit button was here.
            )
          )
        )
      ),
      
      hr(), # Adds a visual separator
      fluidRow(
        column(
          12,
          align = "center",
          # This is the single, centralized submit button. It's disabled initially.
          actionButton("submit", "Submit Form", class = "btn-success btn-lg", icon = icon("check"), disabled = TRUE)
        )
      ),
      br() # Adds some space at the bottom
    ),
    
    # --- Thank You / Confirmation Section (Hidden by default) ---
    hidden(
      div(
        id = "thank_you_section",
        h3("Thank You! 👋"),
        p("Your submission has been recorded successfully."),
        actionButton("start_over", "Submit Another Response")
      )
    )
  )
})

output$stride_division <- renderUI({
  filtered_division <- c(df[df$Region==input$stride_region,"Division"])
  
  selectInput(
    inputId = "stride_divisio2",
    label = "Division:",
    choices = c("--- Select Division ---" = "", filtered_division),
    selected = NULL
  )
})

# Inside server function in Stride1.txt

# Inside server function in Stride1.txt

# Inside server function in Stride1.txt

# Inside server function in Stride1.txt