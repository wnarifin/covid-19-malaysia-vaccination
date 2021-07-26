# server.R

#source("data.R")

# Plot
server <- function(input, output) {
  output$table <- DT::renderDataTable({
    vaksin_my_sub_malay = subset(vaksin_my_all_malay, Tarikh >= input$dates[1] & Tarikh <= input$dates[2] & Negeri == input$state)
    DT::datatable(vaksin_my_sub_malay)
  })
  
  output$carta <- renderPlotly({
    colors = c("Dos 1" = "navy", "Dos 2" = "#5cb85c")  # navy/#3c8dbc, limegreen/#5cb85c
    vaksin_my_sub = subset(vaksin_my_all, date >= input$dates[1] & date <= input$dates[2] & state == input$state)
    vaksin_my_sub$Tarikh = vaksin_my_sub$date  # just to make tooltip label looks nicer
    Dos1 = vaksin_my_sub$dose1_cumul
    Dos2 = vaksin_my_sub$dose2_cumul
    `Dos 1` = Dos1  # just to make tooltip label looks nicer
    `Dos 2` = Dos2
    date_offset = (input$dates[2] - input$dates[1])/2
    plot_vaksin = 
      ggplot(vaksin_my_sub, aes(x = Tarikh)) +
      # geom_line(aes(y = sel1, colour = "Dos 1", text = paste("Dos 1:", sel1)), size = 2) +
      # geom_line(aes(y = sel2, colour = "Dos 2", text = paste("Dos 2:", sel2)), size = 2) +
      geom_line(aes(y = `Dos 1`, colour = "Dos 1"), size = 1.5) +
      geom_line(aes(y = `Dos 2`, colour = "Dos 2"), size = 1.5) +
      scale_x_date(date_breaks = "28 day", date_labels = "%d/%m/%y") +
      # ylim(0, round(target_my_state$pop[target_my_state$state == input$state], -3)) +
      scale_y_continuous(labels = label_comma(), limits = c(0, round(target_my_state$pop[target_my_state$state == input$state], -3))) +
      geom_hline(yintercept = target_my_state$target_80pc[target_my_state$state == input$state], linetype = "dotdash") +
      annotate(geom = "text", y = 1.02*target_my_state$target_80pc[target_my_state$state == input$state], 
               x = input$dates[1] + date_offset, label = "80% Populasi (Umum)") +
      geom_hline(yintercept = target_my_state$target_80pc_18[target_my_state$state == input$state], linetype = "dashed") +
      annotate(geom = "text", y = target_my_state$target_80pc_18[target_my_state$state == input$state] + 0.02*target_my_state$target_80pc[target_my_state$state == input$state], 
               x = input$dates[1] + date_offset, label = "80% Populasi (18 Tahun Ke Atas)") +
      labs(x = "Tarikh", y = "Jumlah Kumulatif Vaksinasi", 
           title = paste0("Jumlah Kumulatif Vaksinasi di ", input$state, " sehingga ", format(input$dates[2], "%d/%m/%Y")),
           color = "Vaksinasi") +
      annotate(geom = "text", x = input$dates[2] - 3, y = max(Dos2) + 0.02*target_my_state$pop[target_my_state$state == input$state],
               label = comma(max(Dos2))) +
      annotate(geom = "text", x = input$dates[2] - 3, y = max(Dos1) + 0.02*target_my_state$pop[target_my_state$state == input$state],
               label = comma(max(Dos1))) +
      scale_colour_manual(values = colors) +
      # annotate(geom = "text", x = input$dates[1] + 3, y = max(sel2), label = input$state) # for debug purpose
      theme_classic()
    ggplotly(plot_vaksin, tooltip = c("y", "Tarikh"))
  })
  
  # output$info <- renderUI({
  #   HTML(paste0("<h4>Populasi ", input$state, ":</h4><h4>", comma(target_my_state$pop[target_my_state$state == input$state]), " (Umum)</h4><h4>",
  #               comma(target_my_state$pop_18[target_my_state$state == input$state]), " (18 tahun ke atas)</h4>")
  #               # "<h4>Dos Pertama:<h4><h4>", round(target_my_state$now_dose1[target_my_state$state == input$state],1), "% (Umum) / ",
  #               # round(target_my_state$now_dose1_18[target_my_state$state == input$state],1), "% (18 tahun ke atas)</h4><hr>",
  #               # "<h4>Lengkap Kedua-dua Dos:</h4><h4>", round(target_my_state$now_dose2[target_my_state$state == input$state],1), "% (Umum) / ",
  #               # round(target_my_state$now_dose2_18[target_my_state$state == input$state],1), "% (18 tahun ke atas)</h4>")
  #   )
  # })
  
  output$location <- renderValueBox({
    valueBox(
      HTML(paste0("<center><h3>", toupper(input$state),"</h3></center>")), "",
      color = "green"
    )
  })
  
  # output$info1 <- renderUI({
  #   HTML(paste0("<h4 style=font-weight:bold;>", input$state, ": ", comma(target_my_state$pop[target_my_state$state == input$state]), "</h4>"))
  # })
  
  output$info1a <- renderInfoBox({
    infoBox(
      HTML(paste0("<h4>Umum</h4>")),
      paste0(comma(target_my_state$pop[target_my_state$state == input$state]), " penduduk"),
      color = "black", fill = FALSE, icon = icon("users")
    )
  })
  
  # output$info2 <- renderUI({
  #   HTML(paste0("<h4 style=font-weight:bold;>", input$state, ": ", comma(target_my_state$pop_18[target_my_state$state == input$state]), "</h4>"))
  # })
  
  output$info2a <- renderInfoBox({
    infoBox(
      HTML(paste0("<h4>18 Tahun Ke Atas</h4>")),
      paste0(comma(target_my_state$pop_18[target_my_state$state == input$state]), " penduduk"),
      color = "black", fill = FALSE, icon = icon("users")
    )
  })
  
  output$infoDos1 <- renderValueBox({
    valueBox(
      paste0(round(target_my_state$now_dose1[target_my_state$state == input$state],1), "%"), "Mendapat Dos Pertama", icon = icon("syringe"),
      color = "navy"
    )
  })
  
  output$infoDos2 <- renderValueBox({
    valueBox(
      paste0(round(target_my_state$now_dose2[target_my_state$state == input$state],1), "%"), "Lengkap Kedua-dua Dos", icon = icon("syringe"),
      color = "green"
    )
  })
  
  output$infoDos1_18 <- renderValueBox({
    valueBox(
      paste0(round(target_my_state$now_dose1_18[target_my_state$state == input$state],1), "%"), "Mendapat Dos Pertama", icon = icon("syringe"),
      color = "navy"
    )
  })
  
  output$infoDos2_18 <- renderValueBox({
    valueBox(
      paste0(round(target_my_state$now_dose2_18[target_my_state$state == input$state],1), "%"), "Lengkap Kedua-dua Dos", icon = icon("syringe"),
      color = "green"
    )
  })
}