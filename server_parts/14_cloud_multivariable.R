# cloud multi-variable view


output$cloud_graph_1 <- renderUI({
  req(input$cloud_category_picker_1)
  
  switch(input$cloud_category_picker_1,
         "cloud_enrolment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("enrolment_regional_graph", height = 500))))
           )
         },
         "cloud_sned" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("sned_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ip" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ip_regional_graph", height = 500)))
             )
           )
         },
         "cloud_muslim" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("muslim_regional_graph", height = 500)))
             )
           )
         },
         "cloud_displaced" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("displaced_regional_graph", height = 500)))
             )
           )
         },
         "cloud_als" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("als_regional_graph", height = 500)))
             )
           )
         },
         "cloud_dropout" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("dropout_regional_graph", height = 500)))
             )
           )
         },
         "cloud_teacherinventory" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("teacherinventory_regional_graph", height = 500)))
             )
           )
         },
         "cloud_classroom" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("classroom_regional_graph", height = 500)))
             )
           )
         },
         "cloud_multigrade" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("multigrade_regional_graph", height = 500)))
             )
           )
         },
         "cloud_organizedclass" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("organizedclass_regional_graph", height = 500)))
             )
           )
         },
         "cloud_jhsdeployment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("jhsdeployment_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shifting" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shifting_regional_graph", height = 500)))
             )
           )
         },
         "cloud_LDM" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ldm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_adm" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("adm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ARAL" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("aral_regional_graph", height = 500)))
             )
           )
         },
         "cloud_crla" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("crla_regional_graph", height = 500)))
             )
           )
         },
         "cloud_philiri" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("philiri_regional_graph", height = 500)))
             )
           )
         },
         "cloud_initiatives" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("initiatives_regional_graph", height = 500)))
             )
           )
         },
         "cloud_moi" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("moi_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sosss" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sosss_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shsimplem" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shsimplem_regional_graph", height = 500)))
             )
           )
         },
         "cloud_overload" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("overload_regional_graph", height = 500)))
             )
           )
         },
         "cloud_resources" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("resources_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat_sufficiency" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_sufficiency_regional_graph", height = 500)))
             )
           )
         },
         "cloud_rf" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("rf_regional_graph", height = 500)))
             )
           )
         },
         "cloud_lac" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("lac_regional_graph", height = 500)))
             )
           )
         },
         "cloud_feeding" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("feeding_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sha" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sha_regional_graph", height = 500)))
             )
           )
         },
         "cloud_childprotection" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("childprotection_regional_graph", height = 500)))
             )
           )
         },
         "cloud_support" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("support_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("extension_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("school_count_regional_graph", height = 500)))
             )
           )
         },
         "cloud_years" = {
           tagList(
             layout_columns(
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("years_regional_graph", height = 500)))
             )
           )
         },
         "cloud_elec" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("elec_regional_graph", height = 500)))
             )
           )
         },
         "cloud_water" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("water_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet_usage" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_usage_regional_graph", height = 500)))
             )
           )
         },
         "cloud_bully" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("bully_regional_graph", height = 500)))
             )
           )
         }
         
  )
})

output$cloud_graph_2 <- renderUI({
  req(input$cloud_category_picker_2)
  
  switch(input$cloud_category_picker_2,
         "cloud_enrolment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("enrolment_regional_graph", height = 500))))
           )
         },
         "cloud_sned" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("sned_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ip" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ip_regional_graph", height = 500)))
             )
           )
         },
         "cloud_muslim" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("muslim_regional_graph", height = 500)))
             )
           )
         },
         "cloud_displaced" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("displaced_regional_graph", height = 500)))
             )
           )
         },
         "cloud_als" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("als_regional_graph", height = 500)))
             )
           )
         },
         "cloud_dropout" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("dropout_regional_graph", height = 500)))
             )
           )
         },
         "cloud_teacherinventory" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("teacherinventory_regional_graph", height = 500)))
             )
           )
         },
         "cloud_classroom" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("classroom_regional_graph", height = 500)))
             )
           )
         },
         "cloud_multigrade" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("multigrade_regional_graph", height = 500)))
             )
           )
         },
         "cloud_organizedclass" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("organizedclass_regional_graph", height = 500)))
             )
           )
         },
         "cloud_jhsdeployment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("jhsdeployment_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shifting" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shifting_regional_graph", height = 500)))
             )
           )
         },
         "cloud_LDM" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ldm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_adm" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("adm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ARAL" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("aral_regional_graph", height = 500)))
             )
           )
         },
         "cloud_crla" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("crla_regional_graph", height = 500)))
             )
           )
         },
         "cloud_philiri" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("philiri_regional_graph", height = 500)))
             )
           )
         },
         "cloud_initiatives" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("initiatives_regional_graph", height = 500)))
             )
           )
         },
         "cloud_moi" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("moi_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sosss" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sosss_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shsimplem" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shsimplem_regional_graph", height = 500)))
             )
           )
         },
         "cloud_overload" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("overload_regional_graph", height = 500)))
             )
           )
         },
         "cloud_resources" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("resources_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat_sufficiency" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_sufficiency_regional_graph", height = 500)))
             )
           )
         },
         "cloud_rf" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("rf_regional_graph", height = 500)))
             )
           )
         },
         "cloud_lac" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("lac_regional_graph", height = 500)))
             )
           )
         },
         "cloud_feeding" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("feeding_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sha" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sha_regional_graph", height = 500)))
             )
           )
         },
         "cloud_childprotection" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("childprotection_regional_graph", height = 500)))
             )
           )
         },
         "cloud_support" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("support_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("extension_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("school_count_regional_graph", height = 500)))
             )
           )
         },
         "cloud_years" = {
           tagList(
             layout_columns(
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("years_regional_graph", height = 500)))
             )
           )
         },
         "cloud_elec" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("elec_regional_graph", height = 500)))
             )
           )
         },
         "cloud_water" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("water_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet_usage" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_usage_regional_graph", height = 500)))
             )
           )
         },
         "cloud_bully" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("bully_regional_graph", height = 500)))
             )
           )
         }
         
  )
})

output$cloud_graph_3 <- renderUI({
  req(input$cloud_category_picker_3)
  
  switch(input$cloud_category_picker_3,
         "cloud_enrolment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("enrolment_regional_graph", height = 500))))
           )
         },
         "cloud_sned" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("sned_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ip" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ip_regional_graph", height = 500)))
             )
           )
         },
         "cloud_muslim" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("muslim_regional_graph", height = 500)))
             )
           )
         },
         "cloud_displaced" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("displaced_regional_graph", height = 500)))
             )
           )
         },
         "cloud_als" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("als_regional_graph", height = 500)))
             )
           )
         },
         "cloud_dropout" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("dropout_regional_graph", height = 500)))
             )
           )
         },
         "cloud_teacherinventory" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("teacherinventory_regional_graph", height = 500)))
             )
           )
         },
         "cloud_classroom" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("classroom_regional_graph", height = 500)))
             )
           )
         },
         "cloud_multigrade" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("multigrade_regional_graph", height = 500)))
             )
           )
         },
         "cloud_organizedclass" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("organizedclass_regional_graph", height = 500)))
             )
           )
         },
         "cloud_jhsdeployment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("jhsdeployment_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shifting" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shifting_regional_graph", height = 500)))
             )
           )
         },
         "cloud_LDM" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ldm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_adm" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("adm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ARAL" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("aral_regional_graph", height = 500)))
             )
           )
         },
         "cloud_crla" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("crla_regional_graph", height = 500)))
             )
           )
         },
         "cloud_philiri" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("philiri_regional_graph", height = 500)))
             )
           )
         },
         "cloud_initiatives" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("initiatives_regional_graph", height = 500)))
             )
           )
         },
         "cloud_moi" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("moi_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sosss" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sosss_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shsimplem" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shsimplem_regional_graph", height = 500)))
             )
           )
         },
         "cloud_overload" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("overload_regional_graph", height = 500)))
             )
           )
         },
         "cloud_resources" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("resources_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat_sufficiency" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_sufficiency_regional_graph", height = 500)))
             )
           )
         },
         "cloud_rf" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("rf_regional_graph", height = 500)))
             )
           )
         },
         "cloud_lac" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("lac_regional_graph", height = 500)))
             )
           )
         },
         "cloud_feeding" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("feeding_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sha" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sha_regional_graph", height = 500)))
             )
           )
         },
         "cloud_childprotection" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("childprotection_regional_graph", height = 500)))
             )
           )
         },
         "cloud_support" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("support_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("extension_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("school_count_regional_graph", height = 500)))
             )
           )
         },
         "cloud_years" = {
           tagList(
             layout_columns(
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("years_regional_graph", height = 500)))
             )
           )
         },
         "cloud_elec" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("elec_regional_graph", height = 500)))
             )
           )
         },
         "cloud_water" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("water_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet_usage" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_usage_regional_graph", height = 500)))
             )
           )
         },
         "cloud_bully" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("bully_regional_graph", height = 500)))
             )
           )
         }
         
  )
})

output$cloud_graph_4 <- renderUI({
  req(input$cloud_category_picker_4)
  
  switch(input$cloud_category_picker_4,
         "cloud_enrolment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("enrolment_regional_graph", height = 500))))
           )
         },
         "cloud_sned" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("sned_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ip" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ip_regional_graph", height = 500)))
             )
           )
         },
         "cloud_muslim" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("muslim_regional_graph", height = 500)))
             )
           )
         },
         "cloud_displaced" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("displaced_regional_graph", height = 500)))
             )
           )
         },
         "cloud_als" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("als_regional_graph", height = 500)))
             )
           )
         },
         "cloud_dropout" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("dropout_regional_graph", height = 500)))
             )
           )
         },
         "cloud_teacherinventory" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("teacherinventory_regional_graph", height = 500)))
             )
           )
         },
         "cloud_classroom" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("classroom_regional_graph", height = 500)))
             )
           )
         },
         "cloud_multigrade" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("multigrade_regional_graph", height = 500)))
             )
           )
         },
         "cloud_organizedclass" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("organizedclass_regional_graph", height = 500)))
             )
           )
         },
         "cloud_jhsdeployment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("jhsdeployment_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shifting" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shifting_regional_graph", height = 500)))
             )
           )
         },
         "cloud_LDM" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ldm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_adm" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("adm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ARAL" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("aral_regional_graph", height = 500)))
             )
           )
         },
         "cloud_crla" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("crla_regional_graph", height = 500)))
             )
           )
         },
         "cloud_philiri" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("philiri_regional_graph", height = 500)))
             )
           )
         },
         "cloud_initiatives" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("initiatives_regional_graph", height = 500)))
             )
           )
         },
         "cloud_moi" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("moi_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sosss" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sosss_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shsimplem" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shsimplem_regional_graph", height = 500)))
             )
           )
         },
         "cloud_overload" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("overload_regional_graph", height = 500)))
             )
           )
         },
         "cloud_resources" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("resources_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat_sufficiency" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_sufficiency_regional_graph", height = 500)))
             )
           )
         },
         "cloud_rf" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("rf_regional_graph", height = 500)))
             )
           )
         },
         "cloud_lac" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("lac_regional_graph", height = 500)))
             )
           )
         },
         "cloud_feeding" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("feeding_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sha" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sha_regional_graph", height = 500)))
             )
           )
         },
         "cloud_childprotection" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("childprotection_regional_graph", height = 500)))
             )
           )
         },
         "cloud_support" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("support_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("extension_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("school_count_regional_graph", height = 500)))
             )
           )
         },
         "cloud_years" = {
           tagList(
             layout_columns(
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("years_regional_graph", height = 500)))
             )
           )
         },
         "cloud_elec" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("elec_regional_graph", height = 500)))
             )
           )
         },
         "cloud_water" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("water_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet_usage" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_usage_regional_graph", height = 500)))
             )
           )
         },
         "cloud_bully" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("bully_regional_graph", height = 500)))
             )
           )
         }
         
  )
})

output$cloud_graph_5 <- renderUI({
  req(input$cloud_category_picker_5)
  
  switch(input$cloud_category_picker_5,
         "cloud_enrolment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("enrolment_regional_graph", height = 500))))
           )
         },
         "cloud_sned" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("sned_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ip" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ip_regional_graph", height = 500)))
             )
           )
         },
         "cloud_muslim" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("muslim_regional_graph", height = 500)))
             )
           )
         },
         "cloud_displaced" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("displaced_regional_graph", height = 500)))
             )
           )
         },
         "cloud_als" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("als_regional_graph", height = 500)))
             )
           )
         },
         "cloud_dropout" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("dropout_regional_graph", height = 500)))
             )
           )
         },
         "cloud_teacherinventory" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("teacherinventory_regional_graph", height = 500)))
             )
           )
         },
         "cloud_classroom" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("classroom_regional_graph", height = 500)))
             )
           )
         },
         "cloud_multigrade" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("multigrade_regional_graph", height = 500)))
             )
           )
         },
         "cloud_organizedclass" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("organizedclass_regional_graph", height = 500)))
             )
           )
         },
         "cloud_jhsdeployment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("jhsdeployment_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shifting" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shifting_regional_graph", height = 500)))
             )
           )
         },
         "cloud_LDM" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ldm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_adm" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("adm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ARAL" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("aral_regional_graph", height = 500)))
             )
           )
         },
         "cloud_crla" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("crla_regional_graph", height = 500)))
             )
           )
         },
         "cloud_philiri" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("philiri_regional_graph", height = 500)))
             )
           )
         },
         "cloud_initiatives" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("initiatives_regional_graph", height = 500)))
             )
           )
         },
         "cloud_moi" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("moi_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sosss" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sosss_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shsimplem" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shsimplem_regional_graph", height = 500)))
             )
           )
         },
         "cloud_overload" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("overload_regional_graph", height = 500)))
             )
           )
         },
         "cloud_resources" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("resources_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat_sufficiency" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_sufficiency_regional_graph", height = 500)))
             )
           )
         },
         "cloud_rf" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("rf_regional_graph", height = 500)))
             )
           )
         },
         "cloud_lac" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("lac_regional_graph", height = 500)))
             )
           )
         },
         "cloud_feeding" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("feeding_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sha" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sha_regional_graph", height = 500)))
             )
           )
         },
         "cloud_childprotection" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("childprotection_regional_graph", height = 500)))
             )
           )
         },
         "cloud_support" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("support_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("extension_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("school_count_regional_graph", height = 500)))
             )
           )
         },
         "cloud_years" = {
           tagList(
             layout_columns(
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("years_regional_graph", height = 500)))
             )
           )
         },
         "cloud_elec" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("elec_regional_graph", height = 500)))
             )
           )
         },
         "cloud_water" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("water_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet_usage" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_usage_regional_graph", height = 500)))
             )
           )
         },
         "cloud_bully" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("bully_regional_graph", height = 500)))
             )
           )
         }
         
  )
})

output$cloud_graph_6 <- renderUI({
  req(input$cloud_category_picker_6)
  
  switch(input$cloud_category_picker_6,
         "cloud_enrolment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("enrolment_regional_graph", height = 500))))
           )
         },
         "cloud_sned" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("sned_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ip" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ip_regional_graph", height = 500)))
             )
           )
         },
         "cloud_muslim" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("muslim_regional_graph", height = 500)))
             )
           )
         },
         "cloud_displaced" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("displaced_regional_graph", height = 500)))
             )
           )
         },
         "cloud_als" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("als_regional_graph", height = 500)))
             )
           )
         },
         "cloud_dropout" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("dropout_regional_graph", height = 500)))
             )
           )
         },
         "cloud_teacherinventory" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("teacherinventory_regional_graph", height = 500)))
             )
           )
         },
         "cloud_classroom" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("classroom_regional_graph", height = 500)))
             )
           )
         },
         "cloud_multigrade" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("multigrade_regional_graph", height = 500)))
             )
           )
         },
         "cloud_organizedclass" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("organizedclass_regional_graph", height = 500)))
             )
           )
         },
         "cloud_jhsdeployment" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("jhsdeployment_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shifting" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shifting_regional_graph", height = 500)))
             )
           )
         },
         "cloud_LDM" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("ldm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_adm" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("adm_regional_graph", height = 500)))
             )
           )
         },
         "cloud_ARAL" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("aral_regional_graph", height = 500)))
             )
           )
         },
         "cloud_crla" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("crla_regional_graph", height = 500)))
             )
           )
         },
         "cloud_philiri" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("philiri_regional_graph", height = 500)))
             )
           )
         },
         "cloud_initiatives" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("initiatives_regional_graph", height = 500)))
             )
           )
         },
         "cloud_moi" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("moi_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sosss" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sosss_regional_graph", height = 500)))
             )
           )
         },
         "cloud_shsimplem" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("shsimplem_regional_graph", height = 500)))
             )
           )
         },
         "cloud_overload" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("overload_regional_graph", height = 500)))
             )
           )
         },
         "cloud_resources" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("resources_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_regional_graph", height = 500)))
             )
           )
         },
         "cloud_nat_sufficiency" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("nat_sufficiency_regional_graph", height = 500)))
             )
           )
         },
         "cloud_rf" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("rf_regional_graph", height = 500)))
             )
           )
         },
         "cloud_lac" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("lac_regional_graph", height = 500)))
             )
           )
         },
         "cloud_feeding" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("feeding_regional_graph", height = 500)))
             )
           )
         },
         "cloud_sha" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("sha_regional_graph", height = 500)))
             )
           )
         },
         "cloud_childprotection" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("childprotection_regional_graph", height = 500)))
             )
           )
         },
         "cloud_support" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("support_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("extension_regional_graph", height = 500)))
             )
           )
         },
         "cloud_extension" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional  Data"),
                                plotlyOutput("school_count_regional_graph", height = 500)))
             )
           )
         },
         "cloud_years" = {
           tagList(
             layout_columns(
               # Changed to plotlyOutput
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("years_regional_graph", height = 500)))
             )
           )
         },
         "cloud_elec" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("elec_regional_graph", height = 500)))
             )
           )
         },
         "cloud_water" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("water_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_regional_graph", height = 500)))
             )
           )
         },
         "cloud_internet_usage" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("internet_usage_regional_graph", height = 500)))
             )
           )
         },
         "cloud_bully" = {
           tagList(
             layout_columns(
               card(full_screen = TRUE,
                    card_header(strong("Regional Data"),
                                plotlyOutput("bully_regional_graph", height = 500)))
             )
           )
         }
         
  )
})