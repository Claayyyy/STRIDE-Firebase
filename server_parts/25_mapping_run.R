#
# --- MAPPING RUN (REFACTORED FOR ROW-CLICK-TO-ZOOM) ---
#

# --- 1. GATED DATA REACTIVES ---
# These eventReactives create all the data. They are "lazy" and will
# only re-calculate when input$Mapping_Run is clicked AND
# something downstream (a map or table) needs their data.

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
  cat("DATAGEN: data_LMS\n")
  inputs <- gated_Inputs()
  LMS %>%
    filter(LMS == 1) %>%
    left_join(buildablecsv %>% select(SCHOOL.ID,OTHER.REMARKS..Buildable.Space..), by = c("School_ID" = "SCHOOL.ID")) %>% 
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
# ----- Data for Teacher Shortage Map & Table (mainreact1) -----
data_TS <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_TS\n")
  inputs <- gated_Inputs()
  
  # FIX 1: Safety check. If 'Lev' is NULL (because the input is hidden or empty), 
  # return an empty dataframe so the app doesn't crash.
  if (is.null(inputs$Lev) || length(inputs$Lev) == 0) {
    return(df[0, ]) # Returns an empty slice of your main dataframe
  }
  
  df %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1) %>% 
    filter(Legislative.District == inputs$DistRCT1) %>% 
    filter(Level == inputs$Lev) %>%  # FIX 2: Changed 'input$Lev' to 'inputs$Lev'
    arrange(desc(TeacherShortage))
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
  
  NetShortage # Return the whole thing
})

data_SDONetShortage <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SDONetShortage\n")
  inputs <- gated_Inputs()
  
  # Safety check for this one too
  if (is.null(inputs$Lev) || length(inputs$Lev) == 0) {
    return(data.frame(NetShortage = numeric(0))) 
  }
  
  data_NetShortage() %>% 
    filter(Region == inputs$RegRCT) %>% 
    filter(Division == inputs$SDORCT1) %>% 
    filter(Level == inputs$Lev) # FIX: Changed 'Lev' to 'inputs$Lev'
})

data_SDO_VB <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SDO_VB\n")
  inputs <- gated_Inputs()
  SDO[which(SDO$Region==inputs$RegRCT & SDO$Division==inputs$SDORCT1),]
})

data_SDO_VB_Reg <- eventReactive(input$Mapping_Run, {
  cat("DATAGEN: data_SDO_VB_Reg\n")
  inputs <- gated_Inputs()
  SDO[which(SDO$Division==inputs$RegRCT),] # Original code used RegRCT here
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
    filter(Region == input$resource_map_region) %>% # Use direct input
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


# --- 2. MAP PROXY OBSERVERS ---
# Each observe block listens to one or more eventReactive data sources.
# When that data changes (after 'Mapping_Run' is clicked), the
# observe block runs and updates its leafletProxy.

# ----- LMS Map Observer -----
observe({
  mainreactLMS <- data_LMS()
  req(mainreactLMS, nrow(mainreactLMS) > 0)
  cat("MAPPROXY: Updating LMSMapping\n")
  
  values.LMS <- paste(
    "School Name:",mainreactLMS$School_Name,
    "<br>Division:", mainreactLMS$Division,
    "<br>Leg. District:", mainreactLMS$Legislative_District,
    "<br>Number of Classrooms:", mainreactLMS$Instructional_Rooms,
    "<br>Classroom Requirement:", mainreactLMS$CL_Req,
    "<br>Estimated Classroom Shortage:", mainreactLMS$Estimated_CL_Shortage,
    "<br>Buildable Space:", ifelse(mainreactLMS$Buildable_space == 1, "Yes", "No")) %>% lapply(htmltools::HTML)
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactLMS) && "Latitude" %in% colnames(mainreactLMS),
      "Error: LMSMapping data is missing Latitude or Longitude columns."
    )
  )
  
  leafletProxy("LMSMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(
      lng = mainreactLMS$Longitude[1],
      lat = mainreactLMS$Latitude[1],
      zoom = 7
    ) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 12),
      lng = mainreactLMS$Longitude,
      lat = mainreactLMS$Latitude,
      icon = makeAwesomeIcon(icon = "education", library = "glyphicon",
                             markerColor = case_when(
                               (mainreactLMS$Buildable_space == 0 & mainreactLMS$Estimated_CL_Shortage == 0) ~ "gray",
                               mainreactLMS$Buildable_space == 0 ~ "red",
                               mainreactLMS$Buildable_space == 1 ~ "green",
                             )),
      label = values.LMS,
      labelOptions = labelOptions(noHide = F, textsize = "12px", direction = "top")
    )
})

# ----- SHS Map Observer -----
observe({
  mainreactSHS <- data_SHS()
  mainreactind <- data_Ind()
  req(mainreactSHS, nrow(mainreactSHS) > 0, mainreactind)
  cat("MAPPROXY: Updating SHSMapping\n")
  
  values_industry <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactSHS$School.Name,"<br>School ID:",mainreactSHS$SchoolID) %>% lapply(htmltools::HTML)
  values.ind <- paste(mainreactind$Company,"<br>Province:",mainreactind$Province) %>% lapply(htmltools::HTML)
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactSHS) && "Latitude" %in% colnames(mainreactSHS),
      "Error: SHSMapping (Schools) data is missing Latitude or Longitude."
    ),
    need(
      "Longitude" %in% colnames(mainreactind) && "Latitude" %in% colnames(mainreactind),
      "Error: SHSMapping (Industry) data is missing Latitude or Longitude."
    )
  )
  
  leafletProxy("SHSMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(
      lng = mainreactSHS$Longitude[1],
      lat = mainreactSHS$Latitude[1],
      zoom = 7
    ) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactSHS$Longitude,
      lat = mainreactSHS$Latitude,
      icon = makeAwesomeIcon(
        icon = "university",
        library = "fa",
        markerColor = "orange"  
      ),
      label = values_industry,
      labelOptions = labelOptions(
        noHide = FALSE,
        textsize = "12px",
        direction = "top",
        fill = TRUE,
        style = list("border-color" = "rgba(0,0,0,0.5)")
      )
    ) %>%
    addAwesomeMarkers(
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
      label = values.ind,
      labelOptions = labelOptions(
        noHide = FALSE,
        textsize = "12px",
        direction = "top"
      )
    )
})

# ----- CL Map Observer -----
observe({
  mainreactCR <- data_CR()
  req(mainreactCR, nrow(mainreactCR) > 0)
  cat("MAPPROXY: Updating CLMapping\n")
  
  values_classrooom_shortage <- paste(mainreactCR$School.Name,"<br>Total Enrolment:",mainreactCR$Enrolment.2023.2024 ,"<br>Classroom Inventory:", mainreactCR$Instructional.Rooms.2023.2024, "<br>Classroom Shortage:", mainreactCR$Est.CS) %>% lapply(htmltools::HTML)
  values_classrooom_shortage_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactCR$School.Name,"<br>School ID:",mainreactCR$SchoolID,"<br>Enrolment Size:",mainreactCR$TotalEnrolment,"<br>","<br>",strong("CLASSROOM DATA"),"<br>Estimate Classroom Shortage:", mainreactCR$Est.CS,"<br>Type of Ownership:", mainreactCR$OwnershipType,"<br>Shifting:", mainreactCR$Shifting,"<br>Electricity Source:", mainreactCR$ElectricitySource,"<br>Water Source:", mainreactCR$WaterSource) %>% lapply(htmltools::HTML)
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactCR) && "Latitude" %in% colnames(mainreactCR),
      "Error: CLMapping data is missing Latitude or Longitude."
    )
  )
  
  icons <- awesomeIcons(
    icon = "university",
    library = "fa",
    markerColor = case_when(
      suppressWarnings(as.numeric(mainreactCR$Est.CS)) > 0 ~ "red",
      TRUE ~ "green"
    ),
    iconColor = "white"
  )
  
  leafletProxy("CLMapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(
      lng = mainreactCR$Longitude[1],
      lat = mainreactCR$Latitude[1],
      zoom = 7
    ) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactCR$Longitude,
      lat = mainreactCR$Latitude,
      popup = values_classrooom_shortage_popup,
      options = popupOptions(),
      label = values_classrooom_shortage,
      labelOptions = labelOptions(
        noHide = FALSE,
        textsize = "12px",
        direction = "top"
      ),
      icon = icons
    )
})

# ----- AO2 Map Observer -----
observe({
  mainreactNTP <- data_NTP()
  req(mainreactNTP, nrow(mainreactNTP) > 0)
  cat("MAPPROXY: Updating AO2Mapping\n")
  
  values.non_teaching <- mainreactNTP$School.Name %>% lapply(htmltools::HTML)
  values.non_teaching_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactNTP$School.Name,"<br>School ID:",mainreactNTP$SchoolID,"<br>Enrolment Size:",mainreactNTP$TotalEnrolment,"<br>","<br>",strong("TEACHING PERSONNEL DATA"),"<br>Teacher Inventory:", mainreactNTP$TotalTeachers,"<br>Teacher Excess:", mainreactNTP$TeacherExcess,"<br>Teacher Shortage:", mainreactNTP$TeacherShortage,"<br>","<br>",strong("NON-TEACHING PERSONNEL DATA"),"<br>Plantilla Number of AOII:", mainreactNTP$Plantilla.Number,"<br>Clustering Status:", mainreactNTP$Clustering.Status,"<br>PDO I Deployment:", mainreactNTP$PDOI_Deployment) %>% lapply(htmltools::HTML)
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactNTP) && "Latitude" %in% colnames(mainreactNTP),
      "Error: AO2Mapping data is missing Latitude or Longitude."
    )
  )
  
  leafletProxy("AO2Mapping") %>%
    clearMarkers() %>%
    clearMarkerClusters() %>%
    setView(lng = mainreactNTP$Longitude[1], lat = mainreactNTP$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = mainreactNTP$Longitude,
      lat = mainreactNTP$Latitude,
      popup = values.non_teaching_popup,
      options = popupOptions(),
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

# ----- Teacher Shortage Map Observer -----
observe({
  mainreact1 <- data_TS()
  req(mainreact1, nrow(mainreact1) > 0)
  cat("MAPPROXY: Updating TeacherShortage_Mapping\n")
  
  values_teacher_shortage <- paste(mainreact1$School.Name,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage) %>% lapply(htmltools::HTML)
  values_teacher_shortage_popup <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreact1$School.Name,"<br>School ID:",mainreact1$SchoolID,"<br>Enrolment Size:",mainreact1$TotalEnrolment,"<br>","<br>",strong("TEACHING PERSONNEL DATA"),"<br>Teacher Inventory:", mainreact1$TotalTeachers,"<br>Teacher Excess:", mainreact1$TeacherExcess,"<br>Teacher Shortage:", mainreact1$TeacherShortage,"<br>","<br>",strong("SPECIALIZATION DATA"),"<br>English:", mainreact1$English,"<br>Mathematics:", mainreact1$Mathematics,"<br>Science:", mainreact1$Science,"<br>Biological Science:", mainreact1$Biological.Sciences,"<br>Physical Sciences:", mainreact1$Physical.Sciences,"<br>General Education:", mainreact1$General.Ed,"<br>Araling Panlipunan:", mainreact1$Araling.Panlipunan,"<br>TLE:", mainreact1$TLE,"<br>MAPEH:", mainreact1$MAPEH,"<br>Filipino:", mainreact1$Filipino,"<br>ESP:", mainreact1$ESP,"<br>Agriculture:", mainreact1$Agriculture,"<br>ECE:", mainreact1$ECE,"<br>SPED:", mainreact1$SPED) %>% lapply(htmltools::HTML)
  
  validate(
    need(
      "Longitude" %in% colnames(mainreact1) && "Latitude" %in% colnames(mainreact1),
      "Error: TeacherShortage_Mapping data is missing Latitude or Longitude."
    )
  )
  
  leafletProxy("TeacherShortage_Mapping") %>% 
    clearMarkers() %>% 
    clearMarkerClusters() %>% 
    setView(lng = mainreact1$Longitude[1], lat = mainreact1$Latitude[1], zoom = 7) %>% 
    addAwesomeMarkers(clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15), 
                      lng = mainreact1$Longitude, 
                      lat = mainreact1$Latitude, 
                      popup = values_teacher_shortage_popup, 
                      options = popupOptions(), 
                      label = values_teacher_shortage, 
                      labelOptions = labelOptions(noHide = F, textsize = "12px", direction = "top"), 
                      icon = makeAwesomeIcon(icon = "education", library = "glyphicon", 
                                             markerColor = case_when(mainreact1$TeacherShortage > 0 ~ "red", 
                                                                     mainreact1$TeacherExcess > 0 ~ "blue", 
                                                                     (mainreact1$TeacherExcess == 0 & mainreact1$TeacherShortage == 0) ~ "green", 
                                                                     is.na(mainreact1$TeacherShortage) ~ "gray")))
})

# ----- Facilities (EFD) Map Observer -----
observe({
  mainreactEFD <- data_EFD()
  req(mainreactEFD, nrow(mainreactEFD) > 0)
  cat("MAPPROXY: Updating FacMapping\n")
  
  values.efdmasterlist <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactEFD$School.Name,"<br>School ID:",mainreactEFD$SchoolID,"<br>Category:",mainreactEFD$Category,"<br>Funding Year:",mainreactEFD$FundingYear,"<br>Allocation:",mainreactEFD$Allocation) %>% lapply(htmltools::HTML)
  
  color_palette <- colorFactor(
    palette = c("red", "green", "blue"),
    domain = mainreactEFD$FundingCategory,
    levels = levels(mainreactEFD$FundingCategory)
  )
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactEFD) && "Latitude" %in% colnames(mainreactEFD),
      "Error: FacMapping data is missing Latitude or Longitude."
    )
  )
  
  leafletProxy("FacMapping", data = mainreactEFD) %>%
    clearMarkers() %>%
    clearControls() %>%
    setView(lng = mainreactEFD$Longitude[1], lat = mainreactEFD$Latitude[1], zoom = 7) %>%
    addAwesomeMarkers(
      clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15),
      lng = ~Longitude,
      lat = ~Latitude,
      popup = values.efdmasterlist,
      icon = makeAwesomeIcon(
        icon = "education",
        library = "glyphicon",
        markerColor = case_when(mainreactEFD$FundingCategory == "Before 2025" ~ "red", 
                                mainreactEFD$FundingCategory == "2025-2030" ~ "green", 
                                mainreactEFD$FundingCategory == "After 2030" ~ "blue")
      )
    ) %>%
    addLegend(
      "bottomright",
      pal = color_palette,
      values = ~FundingCategory,
      title = "Funding Year",
      opacity = 1
    )
})

# ----- Congestion Map Observer -----
observe({
  mainreactNTP <- data_NTP()
  req(mainreactNTP, nrow(mainreactNTP) > 0)
  cat("MAPPROXY: Updating CongestMapping\n")
  
  color_palette_cong <- colorFactor(
    palette = c("red", "green", "blue"),
    domain = mainreactNTP$Congestion.Index,
    levels = levels(mainreactNTP$Congestion.Index)
  )
  
  values.congest <- paste(strong("SCHOOL INFORMATION"),"<br>School Name:",mainreactNTP$School.Name,"<br>School ID:",mainreactNTP$SchoolID,"<br>Instructional Rooms (2023-2024):",mainreactNTP$Instructional.Rooms.2023.2024,"<br>Enrolment (2023-2024):",mainreactNTP$Enrolment.2023.2024,"<br>Congestion Index:",mainreactNTP$Congestion.Index) %>% lapply(htmltools::HTML)
  
  validate(
    need(
      "Longitude" %in% colnames(mainreactNTP) && "Latitude" %in% colnames(mainreactNTP),
      "Error: CongestMapping data is missing Latitude or Longitude."
    )
  )
  
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
# These reactives take the gated data (e.g., data_LMS()) and
# filter it based on the *current map bounds*, if they exist.
# These will feed the tables.
# IMPORTANT: These reactives *must* include the Latitude and Longitude
# columns for the click-to-zoom observers to work.

# ----- Filtered LMS Data (replaces df1) -----
data_LMS_filtered <- reactive({
  mainreactLMS <- data_LMS()
  req(mainreactLMS)
  
  if (is.null(input$LMSMapping_bounds)) {
    mainreactLMS
  } else {
    bounds <- input$LMSMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(mainreactLMS,
           Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered Teacher Shortage Data (replaces dfreact_TS) -----
data_TS_filtered <- reactive({
  mainreact1 <- data_TS()
  req(mainreact1)
  
  if (is.null(input$TeacherShortage_Mapping_bounds)) {
    mainreact1
  } else {
    bounds <- input$TeacherShortage_Mapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(mainreact1,
           Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered AO2 Data (replaces Ao21) -----
data_AO2_filtered <- reactive({
  mainreactNTP <- data_NTP()
  req(mainreactNTP)
  
  if (is.null(input$AO2Mapping_bounds)) {
    mainreactNTP
  } else {
    bounds <- input$AO2Mapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(mainreactNTP,
           Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered CL Data (replaces dfreact_CL) -----
data_CL_filtered <- reactive({
  mainreactCR <- data_CR()
  req(mainreactCR)
  
  if (is.null(input$CLMapping_bounds)) {
    mainreactCR
  } else {
    bounds <- input$CLMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(mainreactCR,
           Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered SHS Data (replaces dfreact_SHS) -----
data_SHS_filtered <- reactive({
  mainreactSHS <- data_SHS()
  req(mainreactSHS)
  
  if (is.null(input$SHSMapping_bounds)) {
    mainreactSHS
  } else {
    bounds <- input$SHSMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(mainreactSHS,
           Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered Facilities Data (replaces dfreact_fac) -----
data_Fac_filtered <- reactive({
  mainreactEFD <- data_EFD()
  req(mainreactEFD)
  
  if (is.null(input$FacMapping_bounds)) {
    mainreactEFD
  } else {
    bounds <- input$FacMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(mainreactEFD,
           Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})

# ----- Filtered Congestion Data (replaces dfreact_cong) -----
data_Cong_filtered <- reactive({
  mainreactNTP <- data_NTP()
  req(mainreactNTP)
  
  if (is.null(input$CongestMapping_bounds)) {
    mainreactNTP %>% arrange(desc(Congestion.Index))
  } else {
    bounds <- input$CongestMapping_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(mainreactNTP,
           Latitude >= latRng[1] & Latitude <= latRng[2] & Longitude >= lngRng[1] & Longitude <= lngRng[2])
  }
})


# --- 4. TABLE RENDERERS ---
# These are all at the top level. They use the *filtered*
# reactive data (e.g., data_LMS_filtered())
# The `dplyr::select` here *removes* Lat/Lon for display,
# but the click-to-zoom observers will use the filtered reactive,
# which *still has* Lat/Lon.

# ----- LMS Table -----
output$LMSTable <- renderDT(server = FALSE, {
  
  finalLMS <- data_LMS_filtered() %>%
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
    options = list(scrollX = TRUE, pageLength = 10, dom = get_dt_dom('Bfrtip'),
                   buttons = list('csv', 'excel', 'pdf', 'print'), columnDefs = list(list(className = 'dt-center', targets = "_all"))),
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
            options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
})

# ----- AO2 Table -----
output$AO2Table <- DT::renderDT({
  datatable(data_AO2_filtered() %>% 
              select("School.Name","Clustering.Status","PDOI_Deployment") %>% 
              rename("School" = School.Name, "AO II Deployment" = Clustering.Status, "PDOI Deployment" = PDOI_Deployment), 
            rownames = FALSE, 
            filter = 'top', 
            options = list(scrollX = TRUE, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
})

# ----- CL Table -----
output$CLTable <- DT::renderDT(server = FALSE, {
  datatable(data_CL_filtered() %>% 
              select("School.Name","Enrolment.2023.2024","Instructional.Rooms.2023.2024","Est.CS","Buidable_space") %>% 
              rename("School" = School.Name, "Total Enrolment" = Enrolment.2023.2024, "Classroom Inventory" = Instructional.Rooms.2023.2024, "Estimate Classroom Shortage" = Est.CS, "Buildable Space" = Buidable_space), 
            filter = 'top', 
            options = list(scrollX = TRUE,scrollY= "300px", columnDefs = list(list(className = 'dt-center', targets ="_all")), rownames = FALSE, dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
})

# ----- SHS Table -----
output$SHSListTable <- DT::renderDT(server = FALSE, {
  datatable(data_SHS_filtered() %>% 
              select("School.Name", "TotalEnrolment") %>% 
              rename("School" = School.Name, "Total Enrolment" = TotalEnrolment), 
            extension = 'Buttons', 
            rownames = FALSE, 
            options = list(scrollX = TRUE, pageLength = 5, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
})

# ----- Facilities Table -----
output$FacTable <- DT::renderDT(server = FALSE, {
  datatable(data_Fac_filtered() %>% 
              select("Region","Division","School.Name","FundingYear","Allocation") %>%
              rename("School" = School.Name, "Funding Year" = FundingYear),
            extension = 'Buttons',
            rownames = FALSE,
            options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
})

# ----- Congestion Table -----
output$CongestTable <- DT::renderDT(server = FALSE, {
  datatable(data_Cong_filtered() %>% 
              select("Region","Division","School.Name","Instructional.Rooms.2023.2024","Enrolment.2023.2024","Congestion.Index") %>%
              rename("School" = School.Name, "Instructional Rooms" = Instructional.Rooms.2023.2024, "Total Enrolment" = Enrolment.2023.2024, "Congestion Index" = Congestion.Index),
            extension = 'Buttons',
            rownames = FALSE,
            options = list(scrollX = TRUE, pageLength = 10, columnDefs = list(list(className = 'dt-center', targets ="_all")), dom = get_dt_dom('Bfrtip'), buttons = list('csv','excel','pdf','print')))
})


# --- 5. NEW: CLICK-TO-ZOOM OBSERVERS ---
# These are the new blocks to add the zoom functionality.
# They listen for `input$TableName_rows_selected`.
# They use the *filtered data reactive* to find the Lat/Lon
# for the selected row and then command the map to `flyTo`.

# ----- Zoom for LMS Table -----
observeEvent(input$LMSTable_rows_selected, {
  req(input$LMSTable_rows_selected)
  
  # Get the full data that is *currently* in the table
  data_in_table <- data_LMS_filtered()
  
  # Get the specific row that was clicked
  selected_row_data <- data_in_table[input$LMSTable_rows_selected, ]
  
  # Check for Lat/Lon
  validate(
    need(
      "Longitude" %in% colnames(selected_row_data) && "Latitude" %in% colnames(selected_row_data),
      "Zoom Error: Clicked row is missing Lat/Lon."
    )
  )
  
  cat("ZOOM: LMSTable row", input$LMSTable_rows_selected, "\n")
  
  # --- UPDATED: flyTo ---
  leafletProxy("LMSMapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15, # High zoom level
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
  
  # --- UPDATED: flyTo ---
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
  
  # --- UPDATED: flyTo ---
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
  
  # --- UPDATED: flyTo ---
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
  
  # --- UPDATED: flyTo ---
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
  
  # --- UPDATED: flyTo ---
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
  
  # --- UPDATED: flyTo ---
  leafletProxy("CongestMapping") %>%
    flyTo(
      lng = selected_row_data$Longitude,
      lat = selected_row_data$Latitude,
      zoom = 15,
      options = leafletOptions(duration = 0.5)
    )
})


# --- 6. VALUEBOX AND UI RENDERERS ---
# All top-level, using the gated eventReactive data.

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
  # Note: This used df1() which is now data_LMS_filtered()
  # This might be a bug in the original code, as it's on the Teacher Shortage tab
  # but uses LMS data. I will preserve the logic.
  # If this is wrong, change data_LMS_filtered() to data_TS_filtered()
  valueBox(tags$p(strong(sum(data_LMS_filtered()$TeacherExcess)), style = "font-size: 65%;"), subtitle = NULL)
})

output$d <- renderValueBox({
  valueBox(tags$p(strong("-"), style = "font-size: 65%;"), subtitle = NULL)
})

output$f <- renderValueBox({
  sdo_reg <- data_SDO_VB_Reg()
  req(sdo_reg, nrow(sdo_reg) > 0)
  valueBox(tags$p(strong(sdo_reg[1,"FillUpRate"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
})

output$g <- renderValueBox({
  sdo_reg <- data_SDO_VB_Reg()
  req(sdo_reg, nrow(sdo_reg) > 0)
  valueBox(tags$p(strong(sdo_reg[1,"Unfilled"]), style = "font-family: Poppins; font-size: 20px; color: #111111; text-align: center;"), subtitle = NULL)
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
  req(inputs, mainreactSHS, mainreactind)
  
  p(HTML(paste(strong(inputs$RegRCT),"has",strong(nrow(mainreactSHS)),"senior high schools and a total of ",strong(nrow(mainreactind)),"industries composed of",strong(sum(mainreactind$Sector == "Food Establishments")),"industries on Food Establishments, ",strong(sum(mainreactind$Sector == "Professional/Private Services")),"industries on Professional/Private Services, ",strong(sum(mainreactind$Sector == "Transportation")),"industries on Transportation, ",strong(sum(mainreactind$Sector == "Utilities")),"industries on Utilities",", and",strong(sum(mainreactind$Sector == "Retail")),"industries on Retail")), style = "font-family: Century Gothic; font-size: 15px; color: #111111;")
})


# --- 7. ORIGINAL DEBUGGING BLOCK ---
# This is the only block that needs to be inside a "Mapping_Run"
# observer, as its purpose is to run *only* on the click.
# It now calls the eventReactive data sources, which will
# trigger them if they aren't already calculated.

observeEvent(input$Mapping_Run, {
  
  cat("\n\n=============== MAP DATA DEBUGGER (RUN CLICKED) ===============\n")
  
  # --- 1. Check data for LMSMapping ---
  cat("\n--- [1] Data for LMSMapping (data_LMS) ---\n")
  mainreactLMS <- data_LMS() # Pull data
  if (exists("mainreactLMS") && !is.null(mainreactLMS) && nrow(mainreactLMS) > 0) {
    cat("Column Names:\n"); print(colnames(mainreactLMS))
    cat("\nStructure:\n"); print(str(mainreactLMS[, c("School_Name", "Latitude", "Longitude")], list.len = 5))
  } else { cat("Data is NULL or has 0 rows!\n") }
  
  # --- 2. Check data for SHSMapping (Schools) ---
  cat("\n--- [2] Data for SHSMapping (Schools: data_SHS) ---\n")
  mainreactSHS <- data_SHS() # Pull data
  if (exists("mainreactSHS") && !is.null(mainreactSHS) && nrow(mainreactSHS) > 0) {
    cat("Column Names:\n"); print(colnames(mainreactSHS))
    cat("\nStructure:\n"); print(str(mainreactSHS[, c("School.Name", "Latitude", "Longitude")], list.len = 5))
  } else { cat("Data is NULL or has 0 rows!\n") }
  
  # --- 3. Check data for SHSMapping (Industry) ---
  cat("\n--- [3] Data for SHSMapping (Industry: data_Ind) ---\n")
  mainreactind <- data_Ind() # Pull data
  if (exists("mainreactind") && !is.null(mainreactind) && nrow(mainreactind) > 0) {
    cat("Column Names:\n"); print(colnames(mainreactind))
    cat("\nStructure:\n"); print(str(mainreactind[, c("Company", "Latitude", "Longitude")], list.len = 5))
  } else { cat("Data is NULL or has 0 rows!\n") }
  
  # --- 4. Check data for CLMapping ---
  cat("\n--- [4] Data for CLMapping (data_CR) ---\n")
  mainreactCR <- data_CR() # Pull data
  if (exists("mainreactCR") && !is.null(mainreactCR) && nrow(mainreactCR) > 0) {
    cat("Column Names:\n"); print(colnames(mainreactCR))
    cat("\nStructure:\n"); print(str(mainreactCR[, c("School.Name", "Latitude", "Longitude")], list.len = 5))
  } else { cat("Data is NULL or has 0 rows!\n") }
  
  # --- 5. Check data for AO2/Congest Maps ---
  cat("\n--- [5] Data for AO2/Congest Maps (data_NTP) ---\n")
  mainreactNTP <- data_NTP() # Pull data
  if (exists("mainreactNTP") && !is.null(mainreactNTP) && nrow(mainreactNTP) > 0) {
    cat("Column Names:\n"); print(colnames(mainreactNTP))
    cat("\nStructure:\n"); print(str(mainreactNTP[, c("School.Name", "Latitude", "Longitude")], list.len = 5))
  } else { cat("Data is NULL or has 0 rows!\n") }
  
  # --- 6. Check data for TeacherShortage_Mapping ---
  cat("\n--- [6] Data for TeacherShortage_Mapping (data_TS) ---\n")
  mainreact1 <- data_TS() # Pull data
  if (exists("mainreact1") && !is.null(mainreact1) && nrow(mainreact1) > 0) {
    cat("Column Names:\n"); print(colnames(mainreact1))
    cat("\nStructure:\n"); print(str(mainreact1[, c("School.Name", "Latitude", "Longitude")], list.len = 5))
  } else { cat("Data is NULL or has 0 rows!\n") }
  
  # --- 7. Check data for FacMapping ---
  cat("\n--- [7] Data for FacMapping (data_EFD) ---\n")
  mainreactEFD <- data_EFD() # Pull data
  if (exists("mainreactEFD") && !is.null(mainreactEFD) && nrow(mainreactEFD) > 0) {
    cat("Column Names:\n"); print(colnames(mainreactEFD))
    cat("\nStructure:\n"); print(str(mainreactEFD[, c("School.Name", "Latitude", "Longitude")], list.len = 5))
  } else { cat("Data is NULL or has 0 rows!\n") }
  
  cat("\n=============== END DEBUGGING ===============\n\n")
  
})