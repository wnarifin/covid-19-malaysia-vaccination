# Data ====
vaksin_my = read.csv("https://raw.githubusercontent.com/CITF-Malaysia/citf-public/main/vaccination/vax_malaysia.csv")
vaksin_my = data.frame(vaksin_my["date"], state = "Malaysia", subset(vaksin_my, select = dose1_daily:total_cumul))
vaksin_my_state = read.csv("https://raw.githubusercontent.com/CITF-Malaysia/citf-public/main/vaccination/vax_state.csv")
tail(vaksin_my_state)
pop_my_state = read.csv("https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/static/population.csv")
pop_my_state

# Wrangle ====

# combine malaysia & state data
vaksin_my$date = as.Date(vaksin_my$date)
vaksin_my_state$date = as.Date(vaksin_my_state$date)
vaksin_my_all = rbind(vaksin_my, vaksin_my_state)
vaksin_my_all$state = as.character(vaksin_my_all$state)  # ensure correct name arrangement
vaksin_my_all = dplyr::arrange(vaksin_my_all, date, state)
head(vaksin_my_all)
str(vaksin_my_all)
vaksin_my_all$state = as.factor(vaksin_my_all$state)
str(vaksin_my_all)

# standardize pop data
pop_my_state$state = as.character(pop_my_state$state)
pop_my_state = dplyr::arrange(pop_my_state, state)
str(pop_my_state)
pop_my_state$state = as.factor(pop_my_state$state)
str(pop_my_state)

# save state names for UI
states = unique(vaksin_my_all$state)
states = as.character(states)

# additional stats
target_my_state = pop_my_state
now_info = subset(vaksin_my_all, date == max(date))  # latest cumul count
pop_my_state$state == now_info$state  # correct arrangement
target_my_state$target_80pc = .8 * target_my_state$pop
target_my_state$now_dose2 = now_info$dose2_cumul / target_my_state$pop * 100
target_my_state$now_dose1 = now_info$dose1_cumul / target_my_state$pop * 100
target_my_state$target_80pc_18 = .8 * target_my_state$pop_18
target_my_state$now_dose2_18 = now_info$dose2_cumul / target_my_state$pop_18 * 100
target_my_state$now_dose1_18 = now_info$dose1_cumul / target_my_state$pop_18 * 100
target_my_state

# data for display, Malay
vaksin_my_all_malay = tibble(vaksin_my_all)
names(vaksin_my_all_malay)
vaksin_my_all_malay = rename(vaksin_my_all_malay, c(Tarikh = date,
                                                    Negeri = state,
                                                    "Dos 1 Harian" = dose1_daily,
                                                    "Dos 2 Harian" = dose2_daily,
                                                    "Jumlah Vaksinasi Harian" = total_daily,
                                                    "Jumlah Telah Divaksinasi Dos 1" = dose1_cumul,
                                                    "Jumlah Telah Divaksinasi Dos 2" = dose2_cumul,
                                                    "Jumlah Vaksinasi Keseluruhan" = total_cumul))
tail(vaksin_my_all_malay)
