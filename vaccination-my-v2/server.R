# server.R

#source("data.R")

# Plot
server <- function(input, output) {
  output$table <- DT::renderDataTable({
    DT::datatable(vaksin_my_all)
  })
  
  output$carta <- renderPlotly({
    colors = c("Dos 1" = "red", "Dos 2" = "blue")
    vaksin_my_sub = subset(vaksin_my_all, date >= input$dates[1] & date <= input$dates[2] & state == input$state)
    sel1 = vaksin_my_sub$dose1_cumul
    sel2 = vaksin_my_sub$dose2_cumul
    plot_vaksin = 
      ggplot(vaksin_my_sub, aes(x = date)) +
      geom_line(aes(y = sel1, color = "Dos 1"), size = 2) +
      geom_line(aes(y = sel2, color = "Dos 2"), size = 2) +
      scale_x_date(date_breaks = "28 day", date_labels = "%d/%m/%y") +
      scale_y_continuous(labels = label_comma()) +
      labs(x = "Tarikh", y = "Jumlah Kumulatif", 
           title = paste0("Jumlah Kumulatif Vaksinasi di ", input$state, " pada ", format(input$dates[2], "%d/%m/%Y")),
           color = "Vaksinasi") +
      # annotate(geom = "text", x = input$dates[1] + 3, y = min(sel2) + 0.02*max(sel2),
      #          label = comma(max(sel2))) +
      # annotate(geom = "text", x = input$dates[1] + 3, y = min(sel1) + 0.02*max(sel2),
      #          label = comma(max(sel1))) +
      annotate(geom = "text", x = input$dates[2] - 3, y = max(sel2) + 0.02*max(sel2),
               label = comma(max(sel2))) +
      annotate(geom = "text", x = input$dates[2] - 3, y = max(sel1) + 0.02*max(sel2),
               label = comma(max(sel1))) +
      # annotate(geom = "text", x = input$dates[1] + 3, y = max(sel2), label = input$state) # for debug purpose
      theme_light()
    ggplotly(plot_vaksin)
  })
}