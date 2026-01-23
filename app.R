library(tidyverse)
library(DT)
library(dplyr)
library(shiny)
library(shinydashboard)
library(bslib)
library(bsicons)
library(leaflet)
library(htmltools)
library(thematic)
library(arrow)
library(forcats)
library(fontawesome)
library(shinyjs)
library(shinyauthr)
library(httr)
library(scales)
library(tidytext)
library(ggplot2)
library(plotly)
library(readr)
library(geojsonio)
library(shinyWidgets)
library(later)
library(DBI)
library(RPostgres)
library(pool)
library(reactable)
library(reactablefmtr)
library(rintrojs)
library(webshot)
library(tinytex)
library(firebase)
library(blastula)

# ==========================================================
# 1. DATA LOADING & PREPARATION
# ==========================================================
school_data <- reactiveVal(NULL)
uni48k <- read.csv("School-Unique-48k.csv")
df <- read_parquet("School-Level-v2.parquet") 

uni45k <- read_parquet("School-Unique-v2.parquet") %>% 
  mutate(Municipality = stringr::str_to_title(Municipality)) %>% 
  mutate(Leg.Mun = sprintf("%s (%s)", Legislative.District, Municipality)) %>% 
  rename(Est.CS.Depre = Est.CS)

uni <- left_join(uni48k, uni45k, by = "SchoolID") %>% 
  mutate(
    Buildable_Space = case_when(
      tolower(trimws(With_Buildable_space)) == "yes" ~ "Yes",
      tolower(trimws(With_Buildable_space)) == "no" ~ "No",
      TRUE ~ NA_character_
    )
  ) %>%
  select(
    1, 73, 69:72, 74:84, 2:4, 62, 64, 68, 85:116, 123:129, 153:168, 186:197,
    everything()
  )

# --- ADVANCED ANALYTICS SETUP ---
print("--- ADVANCED ANALYTICS: Starting column analysis... ---")
analytics_column_map <- tibble(
  Raw_Name = c("Implementing.Unit", "Modified.COC", "TotalEnrolment", "School.Size.Typology", "Shifting", "OwnershipType", "ElectricitySource", "WaterSource", "Total.Excess", "Total.Shortage", "TotalTeachers", "Classroom.Shortage", "Buildable_Space"),
  Clean_Name = c("Implementing Unit", "Curricular Offering", "Total Enrolment", "School Size", "Shifting", "Ownership Type", "Electricity Source", "Water Source", "Teacher Excess", "Teacher Shortage", "Total Teachers", "Classroom Shortage", "Buildable Space")
)
get_col_type_adv <- function(column) {
  num_unique <- n_distinct(column)
  if (num_unique == 2) "Binary"
  else if (is.numeric(column) && num_unique > 20) "Numeric"
  else if (is.character(column) || is.factor(column) || num_unique <= 20) "Categorical"
  else "Other"
}
types_adv <- sapply(uni[analytics_column_map$Raw_Name], get_col_type_adv)
col_info_adv_static <- analytics_column_map %>% mutate(type = types_adv) %>% filter(!type == "Other")
adv_analytics_choices <- setNames(col_info_adv_static$Raw_Name, col_info_adv_static$Clean_Name)
print("--- ADVANCED ANALYTICS: Column analysis COMPLETE. ---")

# --- LOAD AUXILIARY DATA ---
PrivateSchools <- read.csv("Private Schools Oct.2025.csv") 
IndALL <- read_parquet("IndDistance.ALL2.parquet")
ind <- read_parquet("SHS-Industry.parquet") 
SDO <- read_parquet("SDOFill.parquet") 
DBMProp <- read.csv("DBM-Proposal.csv") 
EFDDB <- read.csv("EFD-DataBuilder-2025.csv")
EFDMP <- read_parquet("EFD-Masterlist.parquet")
EFD_Projects <- read.csv("EFD-ProgramsList-Aug2025.csv") 
LMS <- read_parquet("EFD-LMS-GIDCA-NSBI2023.parquet") %>% 
  left_join(
    uni %>% select(SchoolID, Latitude, Longitude), 
    by = c("School_ID" = "SchoolID")
  ) %>% 
  mutate(
    Region = if_else(Region == "Region IV-B", "MIMAROPA", Region)
  )
geojson_data <- geojson_read("gadm41_PHL_1.json", what = "sp")
geojson_table <- as.data.frame(geojson_data)
regprov <- read.csv("RegProv.Congestion.csv")
geojson_table <- left_join(geojson_table, regprov, by="NAME_1")
buildablecsv <- read.csv("Buildable_LatLong.csv")
cloud <- read_parquet("Cloud_Consolidated.parquet")
cloud_v2 <- read_parquet("Cloud_Consolidated_v2.parquet")
cloud_v3 <- read_parquet("Cloud_Consolidated_v3.parquet")
ThirdLevel <- read.csv("2025-Third Level Officials DepEd-cleaned.csv", stringsAsFactors = FALSE)
dfGMIS <- read.csv("GMIS-FillingUpPerPosition-Oct2025.csv") 
all_available_positions <- unique(dfGMIS$Position)
all_positions <- c("All Positions" = "All", sort(unique(as.character(dfGMIS$Position))))
overall_totals <- dfGMIS %>% summarise(Total.Filled = sum(Total.Filled, na.rm = TRUE), Total.Unfilled = sum(Total.Unfilled, na.rm = TRUE))

# --- FIREBASE CONFIG ---
stride_config <- firebase_config(
  api_key = "AIzaSyCK889hMN-rzQ9f3zz1JufqsGcV-3zBZ0A",
  auth_domain = "stride-64550.firebaseapp.com",
  project_id = "stride-64550",
  storage_bucket = "stride-64550.firebasestorage.app",
  app_id = "1:438486481554:web:fadfd74b2567e8c9c0444b",
  overwrite = TRUE)

# ==========================================================
# 2. UI DEFINITION (Updated with Inline JS)
# ==========================================================
source("ui_parts/01_head_elements.R") 
source("ui_parts/02_page_containers.R") 
source("ui_parts/03_loading_overlay.R")
source("ui_parts/04_footer.R")

ui <- page_fluid(
  shinyjs::useShinyjs(), 
  theme = bs_theme(version = 5, bootswatch = "litera", font_scale = 0.9, base_font = font_google("Alan Sans")),
  ui_head,
  
  # --- 🔴 INLINE JAVASCRIPT FIX (Start) ---
  # This guarantees the listener is registered, even if script.js fails to load.
  # --- 🔴 UPDATED INLINE JAVASCRIPT (Includes Google) ---
  # --- 🔴 UPDATED INLINE JAVASCRIPT (Includes Registration & Firestore) ---
  tags$script(HTML('
    $(document).on("shiny:connected", function() {
        console.log("✅ JS: Shiny Connected. Registering Auth Handlers...");
        
        // 1. SIGN IN Handler
        Shiny.addCustomMessageHandler("firebase-sign_in", function(message) {
          console.log("🔥 JS: Received Email login command.");
          if(typeof showLoader === "function") showLoader("Authenticating...");
          
          firebase.auth().signInWithEmailAndPassword(message.email, message.password)
            .then((userCredential) => {
              var user = userCredential.user;
              Shiny.setInputValue("login_success_manual", {
                email: user.email,
                uid: user.uid,
                provider: "email"
              }, {priority: "event"});
            })
            .catch((error) => {
              console.error("❌ JS: Login Failed", error.message);
              Shiny.setInputValue("login_error_manual", { code: error.code, message: error.message }, {priority: "event"});
              if(typeof hideLoader === "function") hideLoader();
            });
        });

        // 2. CREATE USER Handler (Updated)
Shiny.addCustomMessageHandler("firebase-create_user", function(message) {
  console.log("🔥 JS: Creating user account...", message.email);
  if(typeof showLoader === "function") showLoader("Creating Account...");

  firebase.auth().createUserWithEmailAndPassword(message.email, message.password)
    .then((userCredential) => {
      console.log("✅ JS: Account Created Successfully!");
      var user = userCredential.user;
      
      // AUTO-LOGIN ON SUCCESS
      // This is the signal that actually logs the user into the R dashboard
      Shiny.setInputValue("login_success_manual", {
        email: user.email,
        uid: user.uid,
        provider: "email"
      }, {priority: "event"});
      
    })
    .catch((error) => {
      console.error("❌ JS: Registration Failed", error.message);
      
      if (error.code === "auth/email-already-in-use") {
         // --- CUSTOM POPUP FOR DUPLICATE EMAIL ---
         alert("Registered email already existed, go to log in page to log in your account");
         
         // Send signal to R to switch the UI back to Login
         Shiny.setInputValue("auth-js_switch_to_login", Math.random(), {priority: "event"});
         
      } else {
         // Other errors (weak password, etc.)
         alert("Registration Failed: " + error.message);
      }
      
      if(typeof hideLoader === "function") hideLoader();
    });
});

        // 3. SAVE USER DATA Handler (For Firestore)
        Shiny.addCustomMessageHandler("firebase-save-user", function(data) {
          console.log("🔥 JS: Saving profile data...", data);
          
          var db = firebase.firestore();
          // Use Email as the document ID
          db.collection("users").doc(data.Email_Address).set(data)
            .then(() => {
              console.log("✅ JS: Profile saved to Firestore.");
            })
            .catch((error) => {
              console.error("❌ JS: Firestore Save Error", error);
            });
        });

        // 4. Google Login Handler (RESTRICTED TO DEPED)
        Shiny.addCustomMessageHandler("firebase-google-auth", function(message) {
          console.log("🔥 JS: Received Google login command.");
          if(typeof showLoader === "function") showLoader("Connecting to Google...");

          var provider = new firebase.auth.GoogleAuthProvider();
          
          // 1. UX HINT: Ask Google to prefer the DepEd domain
          provider.setCustomParameters({
            hd: "deped.gov.ph" 
          });

          firebase.auth().signInWithPopup(provider)
            .then((result) => {
              var user = result.user;
              
              // 2. HARD SECURITY CHECK
              // If the email is NOT from DepEd, block it.
              if (!user.email.endsWith("@deped.gov.ph")) {
                 console.error("❌ JS: Restricted Domain. Blocked " + user.email);
                 
                 // Alert the user
                 alert("Access Denied: Only @deped.gov.ph accounts are allowed.");
                 
                 // Immediately Sign Out to prevent access
                 firebase.auth().signOut();
                 
                 // Hide loader and STOP execution (do not send success to R)
                 if(typeof hideLoader === "function") hideLoader();
                 return; 
              }

              // 3. If Valid, Proceed
              console.log("✅ JS: Valid DepEd Google Login:", user.email);
              
              Shiny.setInputValue("login_success_manual", {
                email: user.email,
                uid: user.uid,
                provider: "google"
              }, {priority: "event"});
            })
            .catch((error) => {
              console.error("❌ JS: Google Login Failed", error.message);
              // Handle popup closed by user
              if (error.code !== "auth/popup-closed-by-user") {
                 alert("Login Error: " + error.message);
              }
              if(typeof hideLoader === "function") hideLoader();
            });
        });
        // 5. SAVE GUEST DATA Handler (NEW)
        Shiny.addCustomMessageHandler("firebase-save-guest", function(data) {
          console.log("🔥 JS: Saving GUEST data...", data);
          
          if (typeof firebase === "undefined") return;
          var db = firebase.firestore();
          
          // Generate a unique ID based on timestamp + random number
          var guestId = "guest_" + Date.now() + "_" + Math.floor(Math.random() * 1000);
          
          db.collection("guests").doc(guestId).set(data)
            .then(() => {
              console.log("✅ JS: Guest data saved.");
            })
            .catch((error) => {
              console.error("❌ JS: Guest Save Error", error);
            });
        });
    });
  ')),
  # --- 🔴 INLINE JAVASCRIPT FIX (End) ---
  
  ui_containers,
  ui_loading,
  ui_footer
)



# ==========================================================
# 3. SERVER LOGIC
# ==========================================================
server <- function(input, output, session) {
  
  print("--- SERVER: Starting ---")
  
  # 1. APPLY MANUAL PATCH
  source("00_firebase_patch.R", local = TRUE)
  f <- Firebase$new(stride_config) 
  
  # 2. GLOBAL VARIABLES
  user_status <- reactiveVal("unauthenticated")
  authenticated_user <- reactiveVal(NULL)
  should_show_tour <- reactiveVal(FALSE)
  form_choice <- reactiveVal("login")
  
  # -------------------------------------------------------------
  # 🔥 CRITICAL FIX: PLACEHOLDER FOR LEGACY CODE
  # This prevents crashes in 30_data_input...R which still looks for this function
  user_database <- reactive({
    data.frame(Email_Address = character(), Station = character())
  })
  # -------------------------------------------------------------
  
  # 3. AUTH MODULE (Handles Buttons)
  source("server_parts/29_authentication_module.R", local = TRUE) 
  # In app.R (Server section)
  callModule(authentication_server, "auth", 
             user_status, authenticated_user, f, user_database, should_show_tour)
  
  # ... inside server(input, output, session) ...
  
  # ==========================================================
  # 5. AUTHENTICATION LISTENER (The Return Trip)
  # ==========================================================
  
  # A. Listen for SUCCESS from JavaScript
  observeEvent(input$login_success_manual, {
    req(input$login_success_manual)
    
    user_info <- input$login_success_manual
    print(paste("✅ SERVER: Received Success Signal for:", user_info$email))
    
    # Update Global State
    authenticated_user(user_info$email)
    user_status("authenticated")
    
    # Notify User
    showNotification("Login Successful!", type = "message")
    
    # (Optional) Save to session for persistence
    # session$userData$user <- user_info
  })
  
  # B. Listen for ERRORS from JavaScript
  observeEvent(input$login_error_manual, {
    req(input$login_error_manual)
    
    err_info <- input$login_error_manual
    print(paste("❌ SERVER: Received Error Signal:", err_info$message))
    
    # Ensure status is reset
    user_status("unauthenticated")
    
    # Show error on screen
    showNotification(paste("Login Failed:", err_info$message), type = "error")
  })
  
  # 4. LOGIN PAGE & SWITCHER
  source("server_parts/28_login_page.R", local = TRUE)
  
  # 5. DASHBOARD MODULES
  # Note: One of these files likely calls user_database(), hence the crash.
  source("server_parts/30_data_input_retrieve_data.R", local = TRUE)
  source("server_parts/09_data_input_form.R", local = TRUE)
  
  source("server_parts/04_gmis_dashboard.R", local = TRUE)
  source("server_parts/05_comprehensive_dashboard.R", local = TRUE)
  source("server_parts/02_dashboard_back_button.R", local = TRUE)
  source("server_parts/06_private_schools.R", local = TRUE)
  source("server_parts/07_compredb_mapping.R", local = TRUE)
  source("server_parts/08_priority_divisions.R", local = TRUE)
  source("server_parts/10_stride2_UI.R", local = TRUE)
  source("server_parts/11_erdb_sidebar_mode.R", local = TRUE)
  source("server_parts/12_resource_mapping.R", local = TRUE)
  source("server_parts/13_dynamic_selectInput.R", local = TRUE)
  source("server_parts/14_cloud_multivariable.R", local = TRUE)
  source("server_parts/15_cloud_regional_profile.R", local = TRUE)
  source("server_parts/16_cloud_picker_content.R", local = TRUE)
  source("server_parts/17_efd_infra_dashboard.R", local = TRUE)
  source("server_parts/18_hrod_databuilder.R", local = TRUE)
  source("server_parts/19_third_level_db.R", local = TRUE)
  # source("server_parts/21_welcome_modal_UI.R", local = TRUE)
  source("server_parts/22_quick_school_search.R", local = TRUE)
  source("server_parts/23_plantilla_dynamic_db.R", local = TRUE)
  source("server_parts/24_renderleaflet_resource_mapping.R", local = TRUE)
  source("server_parts/25_mapping_run.R", local = TRUE)
  source("server_parts/26_rows_selected_for_datatables.R", local = TRUE)
  source("server_parts/27_cloud_graphs_and_tables.R", local = TRUE)
  source("server_parts/31_build_your_dashboard.R", local = TRUE)
  source("server_parts/32_guest_mode.R", local = TRUE)
  source("server_parts/34_home.R", local = TRUE)
  source("server_parts/AdvancedAnalytics_Server.R", local = TRUE)
  # source("server_parts/35_quick_tour.R", local = TRUE)
  source("server_parts/99_others.R", local = TRUE)
  
  # Legacy Sections
  source("server_parts/94_resource_mapping_graphs.R", local = TRUE)
  source("server_parts/95_dynamic_panel_dashboard.R", local = TRUE)
  source("server_parts/96_home_old_version.R", local = TRUE)
  source("server_parts/97_home_accordion.R", local = TRUE)
  source("server_parts/98_commented_sections.R", local = TRUE)
  
  print("--- SERVER LOAD COMPLETE ---")
  
  observeEvent(input$goto_dashboard_btn, {
    shinyjs::runjs("window.location.href = 'my_dashboard/index.html';")
  })
}

shinyApp(ui, server)