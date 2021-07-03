sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem('Table Vaksin', tabName = 'Results'),
    menuItem("Plot Vaksin", tabName = 'Plot')
    ),
  
  dateRangeInput(inputId = "dates", label = h3("Pilih tarikh"),
                 format = "dd-mm-yyyy",
                 min = min(vaksin_my$date),
                 max = max(vaksin_my$date),
                 start = min(vaksin_my$date),
                 end = max(vaksin_my$date)),
  
  selectInput(inputId = "state", 
              label = h3("Pilih negeri"),
              choices = states, selected = 1)
)
  



body <-  dashboardBody(
  tabItems(
    tabItem(tabName = 'Plot',
            fluidRow(
              box(title = 'Chart',
                  plotlyOutput('carta',
                               height = '500px',
                               width = '600px')
              ),
            )
    ),
    tabItem(tabName = 'Results',
            fluidRow(
              column(title = 'Table',
                     DT::dataTableOutput(outputId = "all_results"),
                     width = 12)),
    )
  )
)


dashboardPage(
  dashboardHeader(title = 'COVID-19 Vaccination in Malaysia'),
  sidebar,
  body
)

