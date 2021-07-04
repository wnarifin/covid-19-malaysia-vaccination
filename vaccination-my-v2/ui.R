# ui.R
library(shiny)
library(shinythemes)
library(shinydashboard)

library(DT)
library(tidyverse)

library(plotly)
library(scales)

source("data.R")

ui <- dashboardPage(
  dashboardHeader(title = "Vaksinasi COVID-19 Malaysia", titleWidth = 250),
  dashboardSidebar(width = 250,
                   sidebarMenu(
                     menuItem("Graf", tabName = "graf", icon = icon("chart-line")),
                     menuItem("Data", tabName = "data", icon = icon("table"))
                   )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "graf",
              fluidRow(
                box(plotlyOutput(outputId = "carta", height = 800), width = 8,
                    title = h3("Graf Vaksinasi di Malaysia")),

                box(width = 4, title = h3("Pilihan data"),
                    
                    dateRangeInput(inputId = "dates", label = h4("Pilih tarikh"),
                                   format = "dd-mm-yyyy",
                                   min = min(vaksin_my_all$date),
                                   max = max(vaksin_my_all$date),
                                   start = min(vaksin_my_all$date),
                                   end = max(vaksin_my_all$date)),
                    
                    selectInput(inputId = "state", label = h4("Pilih negeri"),
                                choices = states, selected = 1))
              )),
      
      tabItem(tabName = "data",
              fluidRow(
                box(DT::dataTableOutput(outputId = "table"),
                    width = 12, title = h3("Data penuh vaksinasi"))
              ))
      )
  )
)