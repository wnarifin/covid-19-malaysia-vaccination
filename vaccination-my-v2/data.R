# Data
vaksin_my = read.csv("https://raw.githubusercontent.com/CITF-Malaysia/citf-public/main/vaccination/vax_malaysia.csv")
vaksin_my = data.frame(vaksin_my["date"], state = "Malaysia", subset(vaksin_my, select = dose1_daily:total_cumul))
vaksin_my_state = read.csv("https://raw.githubusercontent.com/CITF-Malaysia/citf-public/main/vaccination/vax_state.csv")
vaksin_my_state
vaksin_my$date = as.Date(vaksin_my$date)
vaksin_my_state$date = as.Date(vaksin_my_state$date)
vaksin_my_all = rbind(vaksin_my, vaksin_my_state)
vaksin_my_all = dplyr::arrange(vaksin_my_all, date, state)
states = unique(vaksin_my_all$state)
states = as.character(states)