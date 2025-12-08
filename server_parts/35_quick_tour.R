# server_parts/35_quick_tour.R

# 1. Define the Tour Steps
stride_tour_steps <- data.frame(
  element = c(
    "#STRIDE2_navbar",
    # Target the Dashboard Dropdown
    "a[data-value='dashboard_menu']", 
    # Target the Quick Search Tab (using the ID we just added)
    "a[data-value='quick_search_tab']",
    # Target the Resource Mapping Tab
    "a[data-value='resource_mapping_tab']",
    # Target the Quick Start Button
    "#quick_start_btn" 
  ),
  intro = c(
    # 1. Welcome
    "<strong>Welcome to STRIDE!</strong><br>This platform unifies school data, human resources, and infrastructure planning into one strategic view.",
    
    # 2. Dashboard Menu
    "<strong>Interactive Dashboards</strong><br>Access the <em>Education Resource Dashboard</em> here. <br><br>Use it to visualize <strong>Teacher Shortages</strong>, <strong>Classroom Gaps</strong>, and <strong>Enrolment Trends</strong>. You can drill down from Region to Division levels.",
    
    # 3. Quick Search
    "<strong>Quick School Search</strong><br>Need data on a specific school?<br><br>Use this tab to search by <strong>School Name or ID</strong>. It instantly pulls up the school's profile, location map, and resource inventory.",
    
    # 4. Resource Mapping
    "<strong>Resource Mapping</strong><br>Perform geospatial analysis here.<br><br>Select a resource type (e.g., <em>Last Mile Schools</em> or <em>New Construction</em>) to see how they are distributed across the map.",
    
    # 5. Quick Start / Help
    "<strong>Need Help?</strong><br>Click here anytime to open the <strong>User Manual</strong>, view the <strong>Glossary</strong> of terms, or check the <strong>FAQs</strong>."
  ),
  position = c("bottom", "right", "bottom", "bottom", "left")
)

# 2. Trigger Logic (Runs on Login)
observeEvent(user_status(), {
  
  # Check if user is authenticated
  req(user_status() == "authenticated")
  
  # Delay start to ensure UI is rendered
  shinyjs::delay(1500, {
    
    rintrojs::introjs(
      session, 
      options = list(
        steps = stride_tour_steps,
        "nextLabel" = "Next >",
        "prevLabel" = "< Back",
        "skipLabel" = "Skip Tour",
        "doneLabel" = "Get Started",
        "showStepNumbers" = "false",
        "showBullets" = "false" 
      )
    )
    
  })
})