# ui.R
library(shiny)
library(shinythemes)
library(shinydashboard)

library(DT)
library(tidyverse)

library(plotly)
library(scales)

source("data.R")

header = dashboardHeader(title = "Vaksinasi COVID-19 Malaysia", titleWidth = 300)

sidebar = dashboardSidebar(width = 300, disable = F,
                           sidebarMenu(
                             menuItem("Graf Mengikut Lokasi", tabName = "graf", icon = icon("chart-line")),
                             menuItem("Lihat Data Terperinci", tabName = "data", icon = icon("table")),
                             
                             dateRangeInput(inputId = "dates", label = h4("Pilih tarikh"),
                                            format = "dd-mm-yyyy",
                                            min = min(vaksin_my_all$date),
                                            max = max(vaksin_my_all$date),
                                            start = min(vaksin_my_all$date),
                                            end = max(vaksin_my_all$date)),
                             selectInput(inputId = "state", label = h4("Pilih lokasi"),
                                         choices = states, selected = "Malaysia"),
                             
                             menuItem("Tentang Kami dan Sumber Data", tabName = "about", icon = icon("info"))
                           ))

body = dashboardBody(
  # tags$head(tags$style(HTML('
  #   .main-header .logo {
  #     font-family: "Georgia", Times, "Times New Roman", serif;
  #   }
  #   
  #   h3 {
  #     font-family: "Georgia", Times, "Times New Roman", serif;
  #   }
  #   
  # '))),
  
  tabItems(
    tabItem(tabName = "graf",
            fluidRow(
              box(title = "Graf Vaksinasi",
                  width = 8, status = "success", solidHeader = T,
                  
                  plotlyOutput(outputId = "carta", height = 750)),
              
              # box(title = "Perincian",
              #     width = 4, status = "success", solidHeader = T,
              #     
              #     dateRangeInput(inputId = "dates", label = h4("Pilih tarikh"),
              #                    format = "dd-mm-yyyy",
              #                    min = min(vaksin_my_all$date),
              #                    max = max(vaksin_my_all$date),
              #                    start = min(vaksin_my_all$date),
              #                    end = max(vaksin_my_all$date)),
              #     
              #     selectInput(inputId = "state", label = h4("Pilih lokasi"),
              #                 choices = states, selected = "Malaysia")),
              
              # box(title = "Statistik",
              #     width = 4, status = "success", solidHeader = T,
              #     
              #     htmlOutput("info")),
              
              valueBoxOutput("location", width = 4),
              
              # box(title = "Jumlah Populasi Umum",
              #     width = 4, status = "primary", solidHeader = T, 
              #     
              #     htmlOutput("info1")),
              
              infoBoxOutput("info1a", width = 4),
              
              valueBoxOutput("infoDos1", width = 2),
              valueBoxOutput("infoDos2", width = 2),
              
              # box(title = "Jumlah Populasi 18 Tahun Ke Atas",
              #     width = 4, status = "primary", solidHeader = T, 
              #     
              #     htmlOutput("info2")),
              
              infoBoxOutput("info2a", width = 4),
              
              valueBoxOutput("infoDos1_18", width = 2),
              valueBoxOutput("infoDos2_18", width = 2)
              
            )
    ),
    
    tabItem(tabName = "data",
            fluidRow(
              box(title = "Data penuh vaksinasi",
                  width = 12, status = "success", solidHeader = T,
                  DT::dataTableOutput(outputId = "table"))
            )
    ),
    
    tabItem(tabName = "about",
            fluidRow(
              box(title = "Tentang Kami",
                  width = 6, status = "success", solidHeader = T,
                  HTML("<p>Papan Pemuka Vaksinasi Interaktif ini merupakan salah satu inisiatif <i>Epidemiology 
                  Modelling Team</i>, Pusat Pengajian Sains Perubatan, Universiti Sains Malaysia.</p>
                       <p>Papan pemuka ini dibina oleh:</p>
                       <ul>
                       <li><a href=https://wnarifin.github.io/>Dr. Wan Nor Arifin</a></li>
                       <li><a href=https://myanalytics.com.my/>Assoc. Prof. Dr. Kamarul Imran Musa</a></li></ul>
                       <p>Papan pemuka ini dibina menggunakan <a href=https://rstudio.github.io/shinydashboard/index.html>R Shiny Dashboard</a>.</p>"),
                  ),
              box(title = "Sumber Data",
                  width = 6, status = "success", solidHeader = T,
                  p("Kami mengucapkan setinggi-tinggi penghargaan kepada Kementerian Kesihatan Malaysia, MoSTI dan COVID-19 Immunisation Task Force atas perkongsian data terbuka."),
                  tags$ul(tags$li(tags$a(href="https://github.com/MoH-Malaysia/covid19-public", "Open data on COVID-19 in Malaysia")),
                          tags$li(tags$a(href="https://github.com/CITF-Malaysia/citf-public", "Open data on Malaysia's National Covid-​19 Immunisation Programme")))
                  )
            )
    )
  )
)

ui <- dashboardPage(header,
                    sidebar,
                    body,
                    skin = "green")