# cloud regional profile

output$cloud_profile_main_content_area <- renderUI({
  layout_columns(
    col_widths = 12,
    card(
      card_header(strong("Enrolment")),
      layout_columns(
        card(
          card_header("Total Enrolment per Category"),
          plotlyOutput("totalenrolment_regional_profile_graph")),
        card(
          card_header("Enrolment"),
          plotlyOutput("enrolment_regional_profile_graph")),
        card(
          card_header("SNED Learners"),
          plotlyOutput("sned_regional_profile_graph")),
        card(
          card_header("IP Learners"),
          plotlyOutput("ip_regional_profile_graph")),
        card(
          card_header("Muslim Learners"),
          plotlyOutput("muslim_regional_profile_graph")),
        card(
          card_header("Displaced Learners"),
          plotlyOutput("displaced_regional_profile_graph")),
        card(
          card_header("ALS Learners"),
          plotlyOutput("als_regional_profile_graph")),
        card(
          card_header("Dropouts"),
          plotlyOutput("dropout_regional_profile_graph")),
        col_widths = c(4,4,4,4,4,4,4,4)
      )
    ),
    card(
      card_header(strong("Teacher Deployment")),
      layout_columns(
        card(
          card_header("Teacher Inventory"),
          plotlyOutput("teacherinventory_regional_profile_graph")),
        card(
          card_header("JHS Teacher Deployment"),
          plotlyOutput("jhsdeployment_regional_profile_graph")),
        card(
          card_header("Teacher Overload"),
          plotlyOutput("overload_regional_profile_graph")),
        card(
          card_header("Multigrade Teachers"),
          plotlyOutput("multigrade_regional_profile_graph")),
        card(
          card_header("Years in Service"),
          plotlyOutput("years_regional_profile_graph")),
        col_widths = c(4,4,4,4,4,4)
      )
    ),
    card(
      card_header(strong("Classroom Data")),
      layout_columns(
        card(
          card_header("Classroom Data"),
          plotlyOutput("classroom_regional_profile_graph")),
        card(
          card_header("Resources Data"),
          plotlyOutput("resources_regional_profile_graph")),
        card(
          card_header("Shifting"),
          plotlyOutput("shifting_regional_profile_graph")),
        card(
          card_header("Organized Class"),
          plotlyOutput("organizedclass_regional_profile_graph")),
        card(
          card_header("Electricity"),
          plotlyOutput("elec_regional_profile_graph")),
        card(
          card_header("Water"),
          plotlyOutput("water_regional_profile_graph")),
        card(
          card_header("Internet"),
          plotlyOutput("internet_regional_profile_graph")),
        card(
          card_header("Internet Usage"),
          plotlyOutput("internet_usage_regional_profile_graph")),
        col_widths = c(4,4,4,4,4,4,4,4)
      )
    ),
    card(
      card_header(strong("Remediation")),
      layout_columns(
        card(
          card_header("Reading Proficiency"),
          plotlyOutput("rf_regional_profile_graph")),
        card(
          card_header("ARAL"),
          plotlyOutput("aral_regional_profile_graph")),
        card(
          card_header("CRLA"),
          plotlyOutput("crla_regional_profile_graph")),
        card(
          card_header("PhilIRI"),
          plotlyOutput("philiri_regional_profile_graph")),
        # card(
        #   card_header("NAT"),
        #   plotlyOutput("nat_regional_profile_graph")),
        # card(
        #   card_header("NAT Sufficiency"),
        #   plotlyOutput("nat_sufficiency_regional_profile_graph")),
        col_widths = c(4,4,4,4)
      )
    ),
    card(
      card_header(strong("Child Protection")),
      layout_columns(
        card(
          card_header("Bullying"),
          plotlyOutput("bully_regional_profile_graph")),
        card(
          card_header("Feeding Program Recipients"),
          plotlyOutput("feeding_regional_profile_graph")),
        col_widths = c(4,4,4,4)
      )
    ))
})
