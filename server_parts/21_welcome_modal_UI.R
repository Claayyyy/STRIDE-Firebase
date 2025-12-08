# welcome modal interface

# --- Welcome Modal Logic ---
welcome_modal_shown <- reactiveVal(FALSE) # Track if shown this session
current_feature_step <- reactiveVal(1)     # Start at Feature 1

# Observer to show the modal when the user authenticates AND is meant to see mgmt_content
# Observe the user_status reactive value directly
observeEvent(user_status(), {
  # Trigger only when status becomes 'authenticated'
  req(user_status() == "authenticated")
  
  # Get the authenticated username
  current_user <- authenticated_user()
  req(current_user) # Ensure we have a username
  
  # Determine if this user *should* see the mgmt_content
  # This logic mirrors part of your output$page_ui renderUI
  users_db <- user_database() # Assuming user_database() is available here
  user_row <- users_db[users_db$Email_Address == current_user, ]
  
  should_see_mgmt_content <- FALSE
  if (current_user == "guest_user@stride") {
    should_see_mgmt_content <- TRUE # Guest sees mgmt_content
  } else if (nrow(user_row) == 1) {
    station <- user_row$Station[1]
    # Check if the station is one that should see mgmt_content
    # Adjust this list based on your actual roles/stations
    if (station %in% c("Central Office", "Regional Office", "Schools Division Office")) { # Example stations
      should_see_mgmt_content <- TRUE
    }
  }
  
  # Only proceed if this user should see mgmt_content AND the modal hasn't been shown
  req(should_see_mgmt_content, !welcome_modal_shown())
  
  print("Conditions met: Showing Welcome Modal") # For debugging
  
  # Define the UI for the modal content here (using the corrected version)
  welcomeModalUI <- modalDialog(
    title = tagList(
      bsicons::bs_icon("stars"),
      "Welcome to DepEd STRIDE!"
    ),
    size = "xl",
    easyClose = FALSE,
    footer = NULL,
    tagList(
      # --- CSS Section ---
      tags$head(
        tags$style(HTML("
          /* Video header styles specific to modal */
          #welcomeModal .video-container { /* Target elements inside modal */
            position: relative; width: 100%; height: 30vh; /* Adjust height as needed for modal */
            overflow: hidden; color: white; text-align: center;
            border-radius: 5px; /* Optional: round corners */
          }
          #welcomeModal .video-container video { /* Target elements inside modal */
            position: absolute; top: 50%; left: 50%;
            min-width: 100%; min-height: 100%; width: auto; height: auto;
            transform: translate(-50%, -50%); z-index: 0;
          }
          #welcomeModal .video-container::after { /* Target elements inside modal */
            content: ''; position: absolute; inset: 0;
            background: rgba(0, 0, 0, 0.5); z-index: 1;
          }
          #welcomeModal .video-overlay { /* Target elements inside modal */
            position: relative; z-index: 2; top: 50%; transform: translateY(-50%);
          }
          #welcomeModal .video-overlay h1 { /* Target elements inside modal */
            font-size: 4rem; /* Adjusted for modal */ font-weight: 900; letter-spacing: 0.1em;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.7); margin-bottom: 0;
          }
          #welcomeModal .video-overlay h3 { /* Target elements inside modal */
            font-size: 1.5rem; /* Adjusted for modal */ font-weight: 300; letter-spacing: 0.05em;
            text-shadow: 1px 1px 4px rgba(0,0,0,0.7); line-height: 1.2;
          }
          .modal-xl {
  max-width: 95% !important; /* Make it 95% of the screen width */
          }
          .modal-backdrop.show { /* Target the backdrop when it's visible */
            backdrop-filter: blur(5px) !important; /* Apply blur - adjust '5px' as needed */
            /* Optional: Make the backdrop slightly darker/lighter */
            /* background-color: rgba(0, 0, 0, 0.3) !important; */ /* Example: slightly darker semi-transparent black */
          }")) # Correctly closed HTML and tags$style
      ), # Added comma
      
      # --- Video Header ---
      div(
        id = "home_intro_section",
        style = "
    position: relative;
    height: 400px;          /* only the intro section area */
    overflow: hidden;
    border-radius: 20px;
    margin-bottom: 40px;
  ",
        
        # Background Video (only inside this box)
        tags$video(
          src = "home_bg1.mp4",   # ensure it's in www/
          autoplay = NA,
          loop = NA,
          muted = NA,
          playsinline = NA,
          style = "
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      object-fit: cover;
      z-index: 0;
      border-radius: 20px;
    "
        ),
        
        # Overlay description
        div(
          class = "video-description",
          style = "
      position: relative;
      z-index: 2;
      text-align: center;
      color: white;
      padding: 60px 20px;
      background: rgba(0, 0, 0, 0.35);
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      border-radius: 20px;
    ",
          
          h1("Welcome to DepEd STRIDE", style = "font-weight: 700; font-size: 5rem; margin-bottom: 10px;"),
          # p("Strategic Inventory for Deployment Efficiency", style = "font-size: 1.2rem; margin-bottom: 15px;"),
          p("A unified data platform for smarter resource planning, teacher deployment, and infrastructure management.", 
            style = "font-size: 1rem; max-width: 800px; color: #f2f2f2;")
        )
      ),
      
      hr(), # Added comma
      
      # --- Short Description ---
      layout_columns(
        col_widths = 12, # Ensure it takes full width
        # --- Quick Tour Introduction ---
        # --- Quick Tour Introduction (in a Card) ---
        card(
          class = "mb-4 text-center", # Add margin below and center text
          style = "border: none; box-shadow: none; background-color: transparent;", # Make it visually subtle
          card_body(
            h3(bsicons::bs_icon("joystick"), "Before you dive in...", class = "mb-3"),
            p(class = "lead mb-0", "Take a quick tour of STRIDE's key features:") # Added mb-0 to reduce bottom margin
          )
        )), # Added comma), # Added comma
      # The "Take a sneak peek..." text is now implicitly covered by the features below.
      # You could add it back explicitly if desired:
      # div(class = "text-center mb-3",
      #     strong("Take a sneak peek of what STRIDE can do!")
      # ),
      
      # --- Feature Section ---
      # --- Feature Section (Wrapped in Cards) ---
      div(class = "mb-4 p-2",
          layout_column_wrap(
            width = 1, # Still stack features vertically
            
            # --- Feature 1: Analytics ---
            card(
              class = "mb-3", # Add margin between cards
              full_screen = TRUE, # Allow card to be expanded
              card_header(tags$h4("Feature 1: In-depth Analytics")),
              card_body(
                # Content of Feature 1 goes here
                p(em("The dashboard's interactive visualizations support drill-down functionality. Try and click on any of the bars in the bar graph!"), ""), # Added citation placeholder
                layout_columns(
                  col_widths = c(4, 4, 4),
                  uiOutput("card_enrollment"),
                  uiOutput("card_teachers"),
                  uiOutput("card_schools")
                ),
                div(
                  style = "text-align: left; margin-bottom: 5px; margin-top: 10px;",
                  shinyjs::hidden(actionButton("btn_back", "Back One Level", class = "btn-primary btn-sm"))
                ),
                # Inner card for plots can remain or be removed, placing plots directly in body
                card(
                  # Removed inner card_header
                  card_body(
                    layout_columns(
                      col_widths = c(4, 4, 4),
                      plotlyOutput("plotly_enrollment"),
                      plotlyOutput("plotly_teachers"),
                      plotlyOutput("plotly_schools")
                    )
                  )
                ) # End inner card for plots
              ) # End card_body for Feature 1
            ), # End card for Feature 1, Added comma
            
            # --- Feature 2: Mapping ---
            card(
              class = "mb-3",
              full_screen = TRUE,
              card_header(tags$h4("Feature 2: Interactive Mapping")),
              card_body(
                # Content of Feature 2
                p(em("The dashboard's data table is interactively linked to the geospatial display. Click on any of the rows on the table to see its location on the map!"), ""), # Added citation placeholder
                # Inner card for map/table can remain or be removed
                card(
                  card_body(
                    layout_columns(
                      col_widths = c(6,6), # Keeping side-by-side as requested before
                      heights_equal = "row", # Keep heights equal
                      div(style = "height: 100%;", DTOutput("demo_table_2")),
                      leafletOutput("demo_map", height="400px") # Keep height for side-by-side balance
                    )
                  )
                )
              ) # End card_body for Feature 2
            ), # End card for Feature 2, Added comma
            
            # --- Feature 3: Deployment ---
            card(
              class = "mb-3",
              full_screen = TRUE,
              card_header(tags$h4("Feature 3: Data Deployment")),
              card_body(
                # Content of Feature 3
                p(em("The platform features a comprehensive tabular display of school-level data. You can click on the columns to sort the data or search using space below each column. You can also click the floating buttons above the table to download this table into your preferred file type!"), ""), # Added citation placeholder
                # Inner card for reactable can remain or be removed
                card(
                  card_body(
                    tagList(
                      dataTableOutput("feature_3_table"),
                      div(
                        style = "text-align: right; margin-top: 10px;",
                      )
                    )
                  )
                ) # End inner card
              ) # End card_body for Feature 3
            ) # End card for Feature 3
            
          ) # End layout_column_wrap for features
      ), # End feature container div, Added command feature container div, Added comma
      
      div(class = "text-center p-3", # Reduced padding
          h3("Ready to get started?"),
          actionButton("btn_to_dashboard", "Go to the Dashboard", class = "btn-success btn-lg", `data-bs-dismiss` = "modal") # Added attribute to help close modal
      ),
      hr(),# Added citation placeholder # End button div
    ) # End Main tagList
  ) # End modalDialog
  
  showModal(welcomeModalUI)
  welcome_modal_shown(TRUE) # Mark as shown for this session
  
}, ignoreNULL = TRUE, ignoreInit = TRUE) # ignoreInit=TRUE prevents running before user_status is set

# Inside the server function

observeEvent(input$btn_to_dashboard, {
  # First, remove the modal if it's open
  removeModal()
  # Then, navigate to the dashboard tab
  # Assuming 'main_nav' is the ID of your main page_navbar or similar container
  # Adjust 'main_nav' and 'dashboard_tab' if your IDs are different
  # This part might need adjustment based on your *actual* main navigation structure.
  # If the button is *inside* the STRIDE2 UI, you need to navigate *within* STRIDE2.
  # Let's navigate to the "Home" tab within STRIDE2 as an example.
  nav_select(id = "STRIDE2_navbar", selected = "home_tab_main") # Replace STRIDE2_navbar and home_tab_main with actual IDs
  # If the goal is to navigate to a different top-level UI (like STRIDE1), the logic would be different.
  # Based on your original code, it seems you want to navigate *within* the current navbar.
  print("Navigating to dashboard tab after closing modal") # For debugging
  
  # !! IMPORTANT !!: You need to know the actual ID of the `page_navbar`
  #                  within STRIDE2 and the `value` of the target `nav_panel`.
  #                  Replace "STRIDE2_navbar" and "home_tab_main" accordingly.
  #                  If your first real tab after Welcome was "Home", use its value.
})