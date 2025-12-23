#
# --- MAPPING RUN (REFACTORED: CRASH-PROOFED LMS & TAB FIXES) ---
#

# --- 1. GATED DATA REACTIVES ---

# ----- Base Inputs -----
gated_Inputs <- eventReactive(input$Mapping_Run, {
  list(
    RegRCT = input$resource_map_region,
    SDORCT1 = input$Resource_SDO,
    DistRCT1 = input$Resource_LegDist,
    Lev = input$resource_map_level,
    TypeEFD = input$EFD_Type
  )
})

# ----- Data for LMS Map & Table (mainreactLMS) -----
data_LMS <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_LMS (Joining with 'uni')\n")
  inputs <- gated_Inputs()
  
  # 1. Prepare Base LMS Data
  LMS %>%
    filter(LMS == 1) %>%
    left_join(buildablecsv %>% select(SCHOOL.ID, OTHER.REMARKS..Buildable.Space..), 
              by = c("School_ID" = "SCHOOL.ID")) %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1)
})

# ----- Data for LMS ValueBoxes -----
data_LMS_reg <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_LMS_reg\n")
  inputs <- gated_Inputs()
  LMS %>%
    filter(LMS == 1) %>%
    left_join(buildablecsv %>% select(SCHOOL.ID,OTHER.REMARKS..Buildable.Space..), by = c("School_ID" = "SCHOOL.ID")) %>% 
    filter(Region == inputs$RegRCT)
})

data_LMS_div <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_LMS_div\n")
  inputs <- gated_Inputs()
  LMS %>%
    filter(LMS == 1) %>%
    left_join(buildablecsv %>% select(SCHOOL.ID,OTHER.REMARKS..Buildable.Space..), by = c("School_ID" = "SCHOOL.ID")) %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1)
})


# ----- Data for Teacher Shortage Map & Table (mainreact1) -----
data_TS <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_TS\n")
  inputs <- gated_Inputs()
  
  if (is.null(inputs$Lev) || length(inputs$Lev) == 0) {
    return(df[0, ]) 
  }
  
  df %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1) %>% 
    filter(Legislative.District == inputs$DistRCT1) %>% 
    filter(Level == inputs$Lev)
})

# ----- Data for Teacher Shortage ValueBoxes -----
data_NetShortage <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_NetShortage\n")
  NetShortage <- df %>% select(Region,Division,Level,TeacherShortage,TeacherExcess) %>%
    pivot_longer(cols = c(TeacherShortage, TeacherExcess), names_to = "Inventory", values_to = "Count") %>% 
    mutate(Count=as.numeric(Count)) %>% 
    na.omit(Count) %>% 
    group_by(Region, Division,Level, Inventory) %>% 
    summarize(Count = sum(Count)) %>% 
    pivot_wider(names_from = "Inventory", values_from = "Count") %>% 
    mutate(NetShortage=TeacherShortage-TeacherExcess) %>% 
    mutate(NetShortage = ifelse(NetShortage < 0, 0, NetShortage))
  
  NetShortage 
})

data_SDONetShortage <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SDONetShortage\n")
  inputs <- gated_Inputs()
  
  if (is.null(inputs$Lev) || length(inputs$Lev) == 0) {
    return(data.frame(NetShortage = numeric(0))) 
  }
  
  data_NetShortage() %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1) %>% 
    filter(Level == inputs$Lev)
})

data_SDO_VB <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SDO_VB\n")
  inputs <- gated_Inputs()
  SDO[which(SDO$Region==inputs$RegRCT & SDO$Division==inputs$SDORCT1),]
})

data_SDO_VB_Reg <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SDO_VB_Reg\n")
  inputs <- gated_Inputs()
  SDO[which(SDO$Region == inputs$RegRCT), ] 
})


# ----- Data for AO2/Congest Map & Table (mainreactNTP) -----
data_NTP <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_NTP\n")
  inputs <- gated_Inputs()
  uni %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1) %>% 
    filter(Legislative.District == inputs$DistRCT1)
})

# ----- Data for ValueBoxes (mainreactreg, mainreactdiv) -----
data_reg <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_reg\n")
  inputs <- gated_Inputs()
  df %>% filter(Region == inputs$RegRCT)
})

data_div <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_div\n")
  inputs <- gated_Inputs()
  df %>% filter(Region == inputs$RegRCT) %>% filter(Division == inputs$SDORCT1)
})

# ----- Data for CL Map & Table (mainreactCR) -----
data_CR <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_CR\n")
  inputs <- gated_Inputs()
  uni %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1) %>% 
    filter(Legislative.District == inputs$DistRCT1) %>% 
    distinct(SchoolID, .keep_all = TRUE) %>% 
    arrange(desc(SBPI))
})

# ----- Data for CL ValueBoxes -----
data_CR_reg <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_CR_reg\n")
  inputs <- gated_Inputs()
  LMS %>% filter(Region == inputs$RegRCT)
})

data_CR_div <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_CR_div\n")
  inputs <- gated_Inputs()
  LMS %>% filter(Region == inputs$RegRCT) %>% filter(Division == inputs$SDORCT1)
})


# ----- Data for SHS Map & Table (mainreactSHS) -----
data_SHS <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SHS\n")
  inputs <- gated_Inputs()
  df %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1) %>% 
    filter(Legislative.District == inputs$DistRCT1) %>% 
    filter(Level == "SHS") %>% 
    distinct(SchoolID, .keep_all = TRUE)
})

# ----- Data for SHS Map (Industry) (mainreactind) -----
data_Ind <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_Ind\n")
  inputs <- gated_Inputs()
  ind %>% filter(Region == inputs$RegRCT)
})

# ----- Data for SHS ValueBoxes -----
data_SHS_count_univ <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SHS_count_univ\n")
  inputs <- gated_Inputs()
  mainvalue <- df %>% 
    filter(Region == input$resource_map_region) %>% 
    filter(Level == "SHS")
  
  return(nrow(mainvalue))
})


# ----- Data for EFD (Fac) Map & Table (mainreactEFD) -----
data_EFD <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_EFD\n")
  inputs <- gated_Inputs()
  EFDMP %>% 
    filter(!is.na(Old.Region), Old.Region != "") %>% 
    filter(!is.na(Latitude), !is.na(Longitude)) %>% 
    mutate(Latitude = as.numeric(Latitude),
           Allocation = dollar(Allocation, prefix = "₱")) %>%
    distinct(SchoolID, FundingYear, Allocation, Category, .keep_all = TRUE) %>%
    arrange(FundingYear) %>%
    filter(Region == inputs$RegRCT) %>%
    filter(Division == inputs$SDORCT1) %>%
    filter(Category %in% inputs$TypeEFD) %>% 
    mutate(FundingCategory = factor(
      case_when(
        FundingYear < 2025 ~ "Before 2025",
        (FundingYear >= 2025 & FundingYear <= 2030) ~ "2025-2030",
        FundingYear > 2030 ~ "After 2030"
      ),
      levels = c("Before 2025", "2025-2030", "After 2030")
    ))
})


# --- 2. MAP PROXY OBSERVERS (STRICT BUTTON TRIGGER ONLY) ---

# ==============================================================================
# PATTERN EXPLANATION:
# We only use "Observer A" which listens to the data_X() reactives.
# Since data_X() are eventReactive(input$Mapping_Run, ...), these observers
# will ONLY fire when the 'Mapping Run' button is pressed and data is ready.
# ==============================================================================

# ----- LMS Map -----
observeEvent(data_LMS(), {
  map_data <- data_LMS()
  req(map_data, nrow(map_data) > 0)
  req("Latitude" %in% names(map_data), "Longitude" %in% names(map_data))
  
  cat("MAPPROXY: LMS Mapping Triggered by Button\n")
  
  leafletProxy("LMSMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(lng = map_data$Longitude[1], lat = map_data$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 12),
      lng = map_data$Longitude,
      lat = map_data$Latitude,
      icon = makeAwesomeIcon(icon = "education", library = "glyphicon",
                             markerColor = case_when(
                               (map_data$Buildable_space == 0 & map_data$Estimated_CL_Shortage == 0) ~ "gray",
                               map_data$Buildable_space == 0 ~ "red",
                               map_data$Buildable_space == 1 ~ "green",
                             )),
      label = paste("School Name:",map_data$School_Name) %>% lapply(htmltools::HTML)
    )
})

# ----- SHS Map -----
observeEvent(data_SHS(), {
  mainreactSHS <- data_SHS()
  mainreactind <- data_Ind() # Included here as part of SHS run logic
  req(mainreactSHS, nrow(mainreactSHS) > 0)
  
  cat("MAPPROXY: SHS Mapping Triggered by Button\n")
  
  values_industry <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactSHS$School.Name,"<br>School ID:",mainreactSHS$SchoolID) %>% lapply(htmltools::HTML)
  
  proxy <- leafletProxy("SHSMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(lng = mainreactSHS$Longitude[1], lat = mainreactSHS$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactSHS$Longitude,
      lat = mainreactSHS$Latitude,
      icon = makeAwesomeIcon(icon = "university", library = "fa", markerColor = "orange"),
      label = values_industry
    )
  
  # Add Industries if they exist
  if (!is.null(mainreactind) && nrow(mainreactind) > 0) {
    values.ind <- paste(mainreactind$Company,"<br>Province:",mainreactind$Province) %>% lapply(htmltools::HTML)
    proxy %>% addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 12),
      lng = mainreactind$Longitude,
      lat = mainreactind$Latitude,
      icon = makeAwesomeIcon(
        icon = "cog",
        library = "fa",
        markerColor = dplyr::case_when(
          mainreactind$Sector == "Manufacturing and Engineering"     ~ "red",
          mainreactind$Sector == "Hospitality and Tourism"           ~ "orange",
          mainreactind$Sector == "Professional/Private Services"     ~ "purple",
          mainreactind$Sector == "Public Administration"             ~ "green",
          mainreactind$Sector == "Business and Finance"              ~ "blue",
          mainreactind$Sector == "Agriculture and Agri-business"     ~ "pink",
          TRUE                                                      ~ "gray"
        )
      ),
      label = values.ind
    )
  }
})

# ----- CL Map -----
observeEvent(data_CR(), {
  mainreactCR <- data_CR()
  req(mainreactCR, nrow(mainreactCR) > 0)
  
  cat("MAPPROXY: CL Mapping Triggered by Button\n")
  
  values_classrooom_shortage <- paste(mainreactCR$School.Name,"<br>Total Enrolment:",mainreactCR$Enrolment.2023.2024 ,"<br>Classroom Inventory:", mainreactCR$Instructional.Rooms.2023.2024, "<br>Classroom Shortage:", mainreactCR$Classroom.Shortage) %>% lapply(htmltools::HTML)
  values_classrooom_shortage_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactCR$School.Name,"<br>School ID:",mainreactCR$SchoolID,"<br>Enrolment Size:",mainreactCR$TotalEnrolment,"<br>","<br>",strong("CLASSROOM DATA"),"<br>Estimate Classroom Shortage:", mainreactCR$Classroom.Shortage,"<br>Type of Ownership:", mainreactCR$OwnershipType,"<br>Shifting:", mainreactCR$Shifting,"<br>Electricity Source:", mainreactCR$ElectricitySource,"<br>Water Source:", mainreactCR$WaterSource) %>% lapply(htmltools::HTML)
  
  leafletProxy("CLMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(lng = mainreactCR$Longitude[1], lat = mainreactCR$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactCR$Longitude,
      lat = mainreactCR$Latitude,
      popup = values_classrooom_shortage_popup,
      label = values_classrooom_shortage,
      labelOptions = labelOptions(noHide = FALSE, textsize = "12px", direction = "top"),
      icon = awesomeIcons(
        icon = "university",
        library = "fa",
        markerColor = case_when(suppressWarnings(as.numeric(mainreactCR$Classroom.Shortage)) > 0 ~ "red", TRUE ~ "green"),
        iconColor = "white"
      )
    )
})

# ----- AO2 Map -----
observeEvent(data_NTP(), {
  mainreactNTP <- data_NTP()
  req(mainreactNTP, nrow(mainreactNTP) > 0)
  
  cat("MAPPROXY: AO2 Mapping Triggered by Button\n")
  
  values.non_teaching <- mainreactNTP$School.Name %>% lapply(htmltools::HTML)
  values.non_teaching_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactNTP$School.Name,"<br>School ID:",mainreactNTP$SchoolID,"<br>Enrolment Size:",mainreactNTP$TotalEnrolment,"<br>","<br>",strong("TEACHING PERSONNEL DATA"),"<br>Teacher Inventory:", mainreactNTP$TotalTeachers,"<br>Teacher Excess:", mainreactNTP$TeacherExcess,"<br>Teacher Shortage:", mainreactNTP$TeacherShortage,"<br>","<br>",strong("NON-TEACHING PERSONNEL DATA"),"<br>Plantilla Number of AOII:", mainreactNTP$Plantilla.Number,"<br>Clustering Status:", mainreactNTP$Clustering.Status,"<br>PDO I Deployment:", mainreactNTP$PDOI_Deployment) %>% lapply(htmltools::HTML)
  
  leafletProxy("AO2Mapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(lng = mainreactNTP$Longitude[1], lat = mainreactNTP$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactNTP$Longitude,
      lat = mainreactNTP$Latitude,
      popup = values.non_teaching_popup,
      label = values.non_teaching,
      labelOptions = labelOptions(noHide = FALSE, textsize = "12px", direction = "top"),
      icon = makeAwesomeIcon(
        icon = "user",
        library = "fa",
        markerColor = case_when(
          mainreactNTP$Clustering.Status %in% c("Dedicated","Clustered") & mainreactNTP$PDOI_Deployment == "With PDO I" ~ "green",
          mainreactNTP$Clustering.Status %in% c("Dedicated","Clustered") & mainreactNTP$PDOI_Deployment == "Without PDO I" ~ "orange",
          mainreactNTP$Clustering.Status == "None Deployed" & mainreactNTP$PDOI_Deployment == "With PDO I" ~ "orange",
          mainreactNTP$Clustering.Status == "None Deployed" & mainreactNTP$PDOI_Deployment == "Without PDO I" ~ "red",
          TRUE ~ "lightgray"
        )
      )
    )
})

# ----- Teacher Shortage Map -----
observeEvent(data_TS(), {
  mainreact1 <- data_TS()
  req(mainreact1, nrow(mainreact1) > 0)
  
  cat("MAPPROXY: TeacherShortage Mapping Triggered by Button\n")
  
  values_teacher_shortage <- paste(mainreact1$School.Name,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage) %>% lapply(htmltools::HTML)
  values_teacher_shortage_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreact1$School.Name,"<br>School ID:",mainreact1$SchoolID,"<br>Enrolment Size:",mainreact1$TotalEnrolment,"<br>","<br>",strong("TEACHING PERSONNEL DATA"),"<br>Teacher Inventory:", mainreact1$TotalTeachers,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage,"<br>","<br>",strong("SPECIALIZATION DATA"),"<br>English:", mainreact1$English,"<br>Mathematics:", mainreact1$Mathematics,"<br>Science:", mainreact1$Science,"<br>Biological Science:", mainreact1$Biological.Sciences,"<br>Physical Sciences:", mainreact1$Physical.Sciences,"<br>General Education:", mainreact1$General.Ed,"<br>Araling Panlipunan:", mainreact1$Araling.Panlipunan,"<br>TLE:", mainreact1$TLE,"<br>MAPEH:", mainreact1$MAPEH,"<br>Filipino:", mainreact1$Filipino,"<br>ESP:", mainreact1$ESP,"<br>Agriculture:", mainreact1$Agriculture,"<br>ECE:", mainreact1$ECE,"<br>SPED:", mainreact1$SPED) %>% lapply(htmltools::HTML)
  
  leafletProxy("TeacherShortage_Mapping") %>% 
    clearMarkers() %>% 
    clearMarkerClusters() %>% 
    setView(lng = mainreact1$Longitude[1], lat = mainreact1$Latitude[1], zoom = 7) %>% 
    addAwesomeMarkers(clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15), 
                      lng = mainreact1$Longitude, 
                      lat = mainreact1$Latitude, 
                      popup = values_teacher_shortage_popup, 
                      label = values_teacher_shortage, 
                      labelOptions = labelOptions(noHide = F, textsize = "12px", direction = "top"), 
                      icon = makeAwesomeIcon(icon = "education", library = "glyphicon", 
                                             markerColor = case_when(mainreact1$TeacherShortage > 0 ~ "red", 
                                                                     mainreact1$TeacherExcess > 0 ~ "blue", 
                                                                     (mainreact1$TeacherExcess == 0 & mainreact1$TeacherShortage == 0) ~ "green", 
                                                                     is.na(mainreact1$TeacherShortage) ~ "gray")))
})

# ----- Facilities (EFD) Map Observer -----
observeEvent(data_EFD(), {
  mainreactEFD <- data_EFD()
  req(mainreactEFD, nrow(mainreactEFD) > 0)
  
  cat("MAPPROXY: Facilities Mapping Triggered by Button\n")
  
  values.efdmasterlist <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactEFD$School.Name,"<br>School ID:",mainreactEFD$SchoolID,"<br>Category:",mainreactEFD$Category,"<br>Funding Year:",mainreactEFD$FundingYear,"<br>Allocation:",mainreactEFD$Allocation) %>% lapply(htmltools::HTML)
  color_palette <- colorFactor(palette = c("red", "green", "blue"), domain = mainreactEFD$FundingCategory, levels = levels(mainreactEFD$FundingCategory))
  
  leafletProxy("FacMapping", data = mainreactEFD) %>%
    clearMarkers() %>%
    clearControls() %>%
    setView(lng = mainreactEFD$Longitude[1], lat = mainreactEFD$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = ~Longitude,
      lat = ~Latitude,
      label = values.efdmasterlist, 
      
      # Optional: Customize how the hover box looks
      labelOptions = labelOptions(
        noHide = FALSE,
        direction = "auto",
        textsize = "12px",
        style = list(
          "font-weight" = "bold",
          "padding" = "3px 8px",
          "border-radius" = "5px"
        )
      ),
      
      # --- FIX: Moved this to a new line so it is not commented out ---
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = case_when(
          mainreactEFD$FundingCategory == "Before 2025" ~ "red", 
          mainreactEFD$FundingCategory == "2025-2030" ~ "green", 
          mainreactEFD$FundingCategory == "After 2030" ~ "blue"
        )
      )
    ) %>% # <--- Ensure this closing parenthesis matches addAwesomeMarkers
    addLegend("bottomright", pal = color_palette, values = ~FundingCategory, title = "Funding Year", opacity = 1)
})

# ----- Congestion Map Observer -----
observeEvent(data_NTP(), {
  mainreactNTP <- data_NTP()
  req(mainreactNTP, nrow(mainreactNTP) > 0)
  
  cat("MAPPROXY: Congestion Mapping Triggered by Button\n")
  
  values.congest <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactNTP$School.Name,"<br>School ID:",mainreactNTP$SchoolID,"<br>Instructional Rooms (2023-2024):",mainreactNTP$Instructional.Rooms.2023.2024,"<br>Enrolment (2023-2024):",mainreactNTP$Enrolment.2023.2024,"<br>Congestion Index:",mainreactNTP$Congestion.Index) %>% lapply(htmltools::HTML)
  
  leafletProxy("CongestMapping", data = mainreactNTP) %>%
    clearMarkers() %>%
    clearControls() %>%
    setView(lng = mainreactNTP$Longitude[1], lat = mainreactNTP$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = ~Longitude,
      lat = ~Latitude,
      label = values.congest,
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = case_when(mainreactNTP$Congestion.Index >= 0 & mainreactNTP$Congestion.Index < 0.25 ~ "green", 
                                mainreactNTP$Congestion.Index >= 0.25 & mainreactNTP$Congestion.Index < 0.5 ~ "green", 
                                mainreactNTP$Congestion.Index >= 0.5 & mainreactNTP$Congestion.Index < 0.75 ~ "orange",
                                mainreactNTP$Congestion.Index >= 0.75 ~ "red")))
})

# --- 3. MAP-BOUNDS FILTERED REACTIVES ---

# ----- Filtered LMS Data (CRASH PROOF) -----
data_LMS_filtered <- reactive({
  mainreactLMS <- data_LMS()
  req(mainreactLMS)
  
  # 1. BOUNDS CHECK: Only filter if bounds exist AND lat/lon cols exist
  if (is.null(input$LMSMapping_bounds) || !"Latitude" %in% names(mainreactLMS) || !"Longitude" %in% names(mainreactLMS)) {
    return(mainreactLMS)
  }
  
  bounds <- input$LMSMapping_bounds
  latRng <- range(bounds$north, bounds$south)
  lngRng <- range(bounds$east, bounds$west)
  
  # 2. USE FILTER: Safe filtering that won't crash if NA
  mainreactLMS %>%
    filter(
      !is.na(Latitude), !is.na(Longitude),
      Latitude >= latRng[1], Latitude <= latRng[2],
      Longitude >= lngRng[1], Longitude <= lngRng[2]
    )
})

# ----- Filtered Teacher Shortage Data -----
data_TS_filtered <- reactive({
  mainreact1 <- data_TS()
  req(mainreact1)
  
  if (is.null(input$TeacherShortage_Mapping_bounds)) {
    mainreact1
  } else {
    bounds <- input$TeacherShortage_Mapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    subset(mainreact1, Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered AO2 Data -----
data_AO2_filtered <- reactive({
  mainreactNTP <- data_NTP()
  req(mainreactNTP)
  
  if (is.null(input$AO2Mapping_bounds)) {
    mainreactNTP
  } else {
    bounds <- input$AO2Mapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    subset(mainreactNTP, Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered CL Data -----
data_CL_filtered <- reactive({
  mainreactCR <- data_CR()
  req(mainreactCR)
  
  if (is.null(input$CLMapping_bounds)) {
    mainreactCR
  } else {
    bounds <- input$CLMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    subset(mainreactCR, Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered SHS Data -----
data_SHS_filtered <- reactive({
  mainreactSHS <- data_SHS()
  req(mainreactSHS)
  
  if (is.null(input$SHSMapping_bounds)) {
    mainreactSHS
  } else {
    bounds <- input$SHSMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    subset(mainreactSHS, Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered Facilities Data -----
data_Fac_filtered <- reactive({
  mainreactEFD <- data_EFD()
  req(mainreactEFD)
  
  if (is.null(input$FacMapping_bounds)) {
    mainreactEFD
  } else {
    bounds <- input$FacMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    subset(mainreactEFD, Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered Congestion Data -----
data_Cong_filtered <- reactive({
  mainreactNTP <- data_NTP()
  req(mainreactNTP)
  
  if (is.null(input$CongestMapping_bounds)) {
    mainreactNTP %>% arrange(desc(Congestion.Index))
  } else {
    bounds <- input$CongestMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    subset(mainreactNTP, Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})


# --- 4. TABLE RENDERERS ---

# ----- LMS Table -----
output$LMSTable <- renderDT(server = FALSE, {
  
  # Safely handle missing columns if filter failed
  data_src <- data_LMS_filtered()
  
  # Ensure display columns exist or create dummies to prevent render crash
  if(!"School_Name" %in% names(data_src)) data_src$School_Name <- "N/A"
  
  finalLMS <- data_src %>%
    dplyr::mutate(
      Buildable_space = dplyr::if_else(Buildable_space == 1, "Yes", "No")
    ) %>%
    dplyr::select(
      School_Name,
      Total_Enrollment,
      Instructional_Rooms,
      Estimated_CL_Shortage,
      Buildable_space
    ) %>%
    dplyr::rename(
      "School Name" = School_Name,
      "Total Enrolment" = Total_Enrollment,
      "Classrooms Inventory" = Instructional_Rooms,
      "Classroom Shortage" = Estimated_CL_Shortage,
      "Buildable Space" = Buildable_space
    )
  
  datatable(
    finalLMS,
    options = list(
      scrollX = TRUE, 
      pageLength = 10, 
      dom = 'Bfrtip', 
      buttons = list('csv', 'excel', 'pdf', 'print'), 
      columnDefs = list(list(className = 'dt-center', targets = "_all"))
    ),
    selection = "single",
    extension = 'Buttons',
    rownames = FALSE,
    callback = JS("window.dispatchEvent(new Event('resize'));")
  )
})

# ----- Teacher Shortage Table -----
output$TeacherShortage_Table <- DT::renderDT(server = FALSE, {
  datatable(data_TS_filtered() %>% 
              select("School.Name","TeacherShortage","TeacherExcess") %>% 
              rename("School" = School.Name, "Shortage" = TeacherShortage, "Excess" = TeacherExcess), 
            extension = 'Buttons', 
            rownames = FALSE, 
            options = list(
              scrollX = TRUE, 
              pageLength = 10, 
              columnDefs = list(list(className = 'dt-center', targets ="_all")), 
              dom = 'Bfrtip',
              buttons = list('csv','excel','pdf','print')
            ))
})

# ----- AO2 Table -----
output$AO2Table <- DT::renderDT({
  datatable(data_AO2_filtered() %>% 
              select("School.Name","Clustering.Status","PDOI_Deployment") %>% 
              rename("School" = School.Name, "AO II Deployment" = Clustering.Status, "PDOI Deployment" = PDOI_Deployment), 
            rownames = FALSE, 
            filter = 'top', 
            options = list(
              scrollX = TRUE, 
              columnDefs = list(list(className = 'dt-center', targets ="_all")), 
              dom = 'Bfrtip',
              buttons = list('csv','excel','pdf','print')
            ))
})

# ----- CL Table -----
output$CLTable <- DT::renderDT(server = FALSE, {
  datatable(data_CL_filtered() %>% 
              select("School.Name","Enrolment.2023.2024","Instructional.Rooms.2023.2024","Classroom.Shortage","Buidable_space") %>% 
              rename("School" = School.Name, "Total Enrolment" = Enrolment.2023.2024, "Classroom Inventory" = Instructional.Rooms.2023.2024, "Estimate Classroom Shortage" = Classroom.Shortage, "Buildable Space" = Buidable_space), 
            filter = 'top', 
            options = list(
              scrollX = TRUE,
              scrollY= "300px", 
              columnDefs = list(list(className = 'dt-center', targets ="_all")), 
              rownames = FALSE, 
              dom = 'Bfrtip',
              buttons = list('csv','excel','pdf','print')
            ))
})

# ----- SHS Table -----
output$SHSListTable <- DT::renderDT(server = FALSE, {
  datatable(data_SHS_filtered() %>% 
              select("School.Name", "TotalEnrolment") %>% 
              rename("School" = School.Name, "Total Enrolment" = TotalEnrolment), 
            extension = 'Buttons', 
            rownames = FALSE, 
            options = list(
              scrollX = TRUE, 
              pageLength = 5, 
              columnDefs = list(list(className = 'dt-center', targets ="_all")), 
              dom = 'Bfrtip', 
              buttons = list('csv','excel','pdf','print')
            ))
})

# ----- Facilities Table -----
output$FacTable <- DT::renderDT(server = FALSE, {
  datatable(data_Fac_filtered() %>% 
              select("Region","Division","School.Name","FundingYear","Allocation") %>%
              rename("School" = School.Name, "Funding Year" = FundingYear),
            extension = 'Buttons',
            rownames = FALSE,
            options = list(
              scrollX = TRUE, 
              pageLength = 10, 
              columnDefs = list(list(className = 'dt-center', targets ="_all")), 
              dom = 'Bfrtip',
              buttons = list('csv','excel','pdf','print')
            ))
})

# ----- Congestion Table -----
output$CongestTable <- DT::renderDT(server = FALSE, {
  datatable(data_Cong_filtered() %>% 
              select("Region","Division","School.Name","Instructional.Rooms.2023.2024","Enrolment.2023.2024","Congestion.Index") %>%
              rename("School" = School.Name, "Instructional Rooms" = Instructional.Rooms.2023.2024, "Total Enrolment" = Enrolment.2023.2024, "Congestion Index" = Congestion.Index),
            extension = 'Buttons',
            rownames = FALSE,
            options = list(
              scrollX = TRUE, 
              pageLength = 10, 
              columnDefs = list(list(className = 'dt-center', targets ="_all")), 
              dom = 'Bfrtip',
              buttons = list('csv','excel','pdf','print')
            ))
})


# --- 5. CLICK-TO-ZOOM OBSERVERS (SAFE) ---

# ----- Zoom for LMS Table -----
observeEvent(input$LMSTable_rows_selected, {
  req(input$LMSTable_rows_selected)
  data_in_table <- data_LMS_filtered()
  
  # Pre-flight check: Do columns exist?
  if (!all(c("Latitude", "Longitude") %in% names(data_in_table))) {
    return() # Silent fail is better than crash
  }
  
  selected_row_data <- data_in_table[input$LMSTable_rows_selected, ]
  
  # Row check: Are coords valid?
  if (is.na(selected_row_data$Latitude) || is.na(selected_row_data$Longitude)) {
    showNotification("This school has no mapped location.", type = "warning")
    return()
  }
  
  cat("ZOOM: LMSTable row", input$LMSTable_rows_selected, "\n")
  
  leafletProxy("LMSMapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15, 
      options = leafletOptions(duration = 0.5)
    )
})

# ----- Zoom for Teacher Shortage Table -----
observeEvent(input$TeacherShortage_Table_rows_selected, {
  req(input$TeacherShortage_Table_rows_selected)
  data_in_table <- data_TS_filtered()
  selected_row_data <- data_in_table[input$TeacherShortage_Table_rows_selected, ]
  
  validate(need("Longitude" %in% colnames(selected_row_data) && "Latitude" %in% colnames(selected_row_data), "Zoom Error."))
  cat("ZOOM: TeacherShortage_Table row", input$TeacherShortage_Table_rows_selected, "\n")
  
  leafletProxy("TeacherShortage_Mapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15,
      options = leafletOptions(duration = 0.5)
    )
})

# ----- Zoom for AO2 Table -----
observeEvent(input$AO2Table_rows_selected, {
  req(input$AO2Table_rows_selected)
  data_in_table <- data_AO2_filtered()
  selected_row_data <- data_in_table[input$AO2Table_rows_selected, ]
  
  validate(need("Longitude" %in% colnames(selected_row_data) && "Latitude" %in% colnames(selected_row_data), "Zoom Error."))
  cat("ZOOM: AO2Table row", input$AO2Table_rows_selected, "\n")
  
  leafletProxy("AO2Mapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15,
      options = leafletOptions(duration = 0.5)
    )
})

# ----- Zoom for CL Table -----
observeEvent(input$CLTable_rows_selected, {
  req(input$CLTable_rows_selected)
  data_in_table <- data_CL_filtered()
  selected_row_data <- data_in_table[input$CLTable_rows_selected, ]
  
  validate(need("Longitude" %in% colnames(selected_row_data) && "Latitude" %in% colnames(selected_row_data), "Zoom Error."))
  cat("ZOOM: CLTable row", input$CLTable_rows_selected, "\n")
  
  leafletProxy("CLMapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15,
      options = leafletOptions(duration = 0.5)
    )
})

# ----- Zoom for SHS Table -----
observeEvent(input$SHSListTable_rows_selected, {
  req(input$SHSListTable_rows_selected)
  data_in_table <- data_SHS_filtered()
  selected_row_data <- data_in_table[input$SHSListTable_rows_selected, ]
  
  validate(need("Longitude" %in% colnames(selected_row_data) && "Latitude" %in% colnames(selected_row_data), "Zoom Error."))
  cat("ZOOM: SHSListTable row", input$SHSListTable_rows_selected, "\n")
  
  leafletProxy("SHSMapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15,
      options = leafletOptions(duration = 0.5)
    )
})

# ----- Zoom for Facilities Table -----
observeEvent(input$FacTable_rows_selected, {
  req(input$FacTable_rows_selected)
  data_in_table <- data_Fac_filtered()
  selected_row_data <- data_in_table[input$FacTable_rows_selected, ]
  
  validate(need("Longitude" %in% colnames(selected_row_data) && "Latitude" %in% colnames(selected_row_data), "Zoom Error."))
  cat("ZOOM: FacTable row", input$FacTable_rows_selected, "\n")
  
  leafletProxy("FacMapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15,
      options = leafletOptions(duration = 0.5)
    )
})

# ----- Zoom for Congestion Table -----
observeEvent(input$CongestTable_rows_selected, {
  req(input$CongestTable_rows_selected)
  data_in_table <- data_Cong_filtered()
  selected_row_data <- data_in_table[input$CongestTable_rows_selected, ]
  
  validate(need("Longitude" %in% colnames(selected_row_data) && "Latitude" %in% colnames(selected_row_data), "Zoom Error."))
  cat("ZOOM: CongestTable row", input$CongestTable_rows_selected, "\n")
  
  leafletProxy("CongestMapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15,
      options = leafletOptions(duration = 0.5)
    )
})


# --- 6. VALUEBOX AND UI RENDERERS ---

# ----- Teacher Shortage ValueBoxes -----
output$a <- renderValueBox({
  sdo_data <- data_SDO_VB()
  req(sdo_data, nrow(sdo_data) > 0)
  valueBox(tags$p(strong(sdo_data[1,"FillUpRate"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$b <- renderValueBox({
  sdo_data <- data_SDO_VB()
  req(sdo_data, nrow(sdo_data) > 0)
  valueBox(tags$p(strong(sdo_data[1,"Unfilled"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$e <- renderValueBox({
  sdo_net <- data_SDONetShortage()
  req(sdo_net)
  valueBox(tags$p(strong(sdo_net$NetShortage), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$c <- renderValueBox({
  # FIX: Use data_TS_filtered() instead of data_LMS_filtered()
  # because TeacherExcess is in the Teacher Shortage dataset.
  req(data_TS_filtered())
  valueBox(tags$p(strong(sum(data_TS_filtered()$TeacherExcess, na.rm=TRUE)), style = "font-size: 65%;"), subtitle = NULL)
})

output$d <- renderValueBox({
  valueBox(tags$p(strong("-"), style = "font-size: 65%;"), subtitle = NULL)
})

output$f <- renderValueBox({
  sdo_reg <- data_SDO_VB_Reg()
  # Safety check: ensure we actually have a row
  if(nrow(sdo_reg) > 0) {
    val <- sdo_reg[1,"FillUpRate"]
  } else {
    val <- "N/A"
  }
  valueBox(tags$p(strong(val), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$g <- renderValueBox({
  sdo_reg <- data_SDO_VB_Reg()
  if(nrow(sdo_reg) > 0) {
    val <- sdo_reg[1,"Unfilled"]
  } else {
    val <- "N/A"
  }
  valueBox(tags$p(strong(val), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

# ----- AO2 ValueBoxes -----
output$Single <- renderValueBox({
  valueBox(strong(sum(data_div()$Clustering.Status == "NOT CLUSTERED")), subtitle = strong("Number of Unclustered Schools (Division)"), icon = icon("users"), color = "green")
})

output$Cluster <- renderValueBox({
  valueBox(strong(sum(data_div()$Clustering.Status == "CLUSTERED")), subtitle = strong("Number of Clustered Schools (Division)"), icon = icon("school"), color = "green")
})

output$Outlier <- renderValueBox({
  valueBox(strong(sum(data_div()$Clustering.Status == "Outlier")), subtitle = strong("Number of Outlier Schools (Division)"), icon = icon("school"), color = "green")
})

output$SingleR <- renderValueBox({
  valueBox(strong(sum(data_reg()$Clustering.Status == "NOT CLUSTERED")), subtitle = strong("Number of Unclustered Schools (Region)"), icon = icon("users"), color = "navy")
})

output$ClusterR <- renderValueBox({
  valueBox(strong(sum(data_reg()$Clustering.Status == "CLUSTERED")), subtitle = strong("Number of Clustered Schools (Region)"), icon = icon("school"), color = "navy")
})

output$OutlierR <- renderValueBox({
  valueBox(strong(sum(data_reg()$Clustering.Status == "Outlier")), subtitle = strong("Number of Outlier Schools (Region)"), icon = icon("school"), color = "navy")
})

output$f2 <- renderValueBox({
  valueBox(tags$p(strong(sum(data_reg()$Clustering.Status == "Clustered")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$g2 <- renderValueBox({
  valueBox(tags$p(strong(sum(data_reg()$Clustering.Status == "Dedicated")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$a2 <- renderValueBox({
  valueBox(tags$p(strong(sum(data_div()$Clustering.Status == "Clustered")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$b2 <- renderValueBox({
  valueBox(tags$p(strong(sum(data_div()$Clustering.Status == "Dedicated")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$e2 <- renderValueBox({
  valueBox(tags$p(strong(sum(data_NTP()$Clustering.Status == "Clustered")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$h2 <- renderValueBox({
  valueBox(tags$p(strong(sum(data_NTP()$Clustering.Status == "Dedicated")), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

# ----- CL ValueBoxes -----
output$ROCRShort <- renderValueBox({
  valueBox(tags$p(strong(sum(data_CR_reg()$Estimated_CL_Shortage, na.rm = TRUE)), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$SDOCRShort <- renderValueBox({
  valueBox(tags$p(strong(sum(data_CR_div()$Estimated_CL_Shortage, na.rm = TRUE)), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

# ----- LMS ValueBoxes -----
output$LMS_Total_Region <- renderValueBox({
  total_region_lms <- nrow(data_LMS_reg())
  valueBox(
    tags$p(
      strong(scales::comma(total_region_lms)),
      style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"),
    subtitle = NULL
  )
})

output$LMS_Total_Division <- renderValueBox({
  total_division_lms <- nrow(data_LMS_div())
  valueBox(
    tags$p(
      strong(scales::comma(total_division_lms)),
      style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"),
    subtitle = NULL
  )
})

# ----- SHS ValueBoxes -----
output$SHSCount <- renderValueBox({
  valueBox(tags$p(strong(nrow(data_SHS())), style = "font-size: 100%; text-align: center;"), subtitle = NULL)})

output$SHSCountUniv <- renderValueBox({
  valueBox(tags$p(strong(data_SHS_count_univ()), style = "font-size: 100%; text-align: center;"), subtitle = NULL)})

output$IndCount <- renderValueBox({
  valueBox(tags$p(strong(nrow(data_Ind())), style = "font-size: 100%; text-align: center;"), subtitle = NULL)})

output$assessmentSHS <- renderUI({
  # Need inputs, data_SHS, and data_Ind
  inputs <- gated_Inputs()
  mainreactSHS <- data_SHS()
  mainreactind <- data_Ind()
  req(inputs, mainreactSHS)
  
  # Handle empty industry data for text generation
  ind_count <- if(is.null(mainreactind)) 0 else nrow(mainreactind)
  
  # Helper to safely sum if column exists
  safe_sum_sector <- function(sec) {
    if(is.null(mainreactind) || nrow(mainreactind) == 0) return(0)
    sum(mainreactind$Sector == sec, na.rm=TRUE)
  }
  
  p(HTML(paste(strong(inputs$RegRCT),"has",strong(nrow(mainreactSHS)),"senior high schools and a total of ",strong(ind_count),"industries composed of",strong(safe_sum_sector("Food Establishments")),"industries on Food Establishments, ",strong(safe_sum_sector("Professional/Private Services")),"industries on Professional/Private Services, ",strong(safe_sum_sector("Transportation")),"industries on Transportation, ",strong(safe_sum_sector("Utilities")),"industries on Utilities",", and",strong(safe_sum_sector("Retail")),"industries on Retail")), style = "font-family: Century Gothic; font-size: 15px; color: #111111;")
})


# --- 7. DEBUGGING BLOCK (SAFE) ---
observeEvent(input$Mapping_Run, {
  
  cat("\n\n=============== MAP DATA DEBUGGER (RUN CLICKED) ===============\n")
  
  # Helper function to safely print structure
  safe_str <- function(data, name) {
    cat(paste0("\n--- Data for ", name, " ---\n"))
    if (exists("data") && !is.null(data) && nrow(data) > 0) {
      cat("Column Names:\n"); print(colnames(data))
      
      # Check for Lat/Lon existence before subsetting
      cols_to_check <- c("Latitude", "Longitude")
      cols_present <- cols_to_check[cols_to_check %in% colnames(data)]
      
      # If specific name cols exist, add them
      if("School_Name" %in% colnames(data)) cols_present <- c("School_Name", cols_present)
      if("School.Name" %in% colnames(data)) cols_present <- c("School.Name", cols_present)
      if("Company" %in% colnames(data))     cols_present <- c("Company", cols_present)
      
      cat("\nStructure (Safe Subset):\n")
      if(length(cols_present) > 0) {
        print(str(data[, cols_present, drop=FALSE], list.len = 5))
      } else {
        print(str(data, list.len = 5))
      }
    } else { 
      cat("Data is NULL or has 0 rows!\n") 
    }
  }
  
  # --- Run Checks ---
  safe_str(data_LMS(), "LMSMapping")
  safe_str(data_SHS(), "SHSMapping (Schools)")
  safe_str(data_Ind(), "SHSMapping (Industry)")
  safe_str(data_CR(),  "CLMapping")
  safe_str(data_NTP(), "AO2/Congest Maps")
  safe_str(data_TS(),  "TeacherShortage_Mapping")
  safe_str(data_EFD(), "FacMapping")
  
  cat("\n=============== END DEBUGGING ===============\n\n")
})