library(tidycensus)
library(tidyverse)

key = Sys.getenv("CENSUS_API_KEY")
census_api_key(key, install = TRUE)





# Get vacancy rates for states
# vacancy_17 <- get_acs(geography = "state", 
#                          table = "DP04", 
#                          survey = "acs1",
#                          year = 2017)


library(purrr)

years <- c(2017,2018,2019,2021,2022)

# Use map to fetch data for each year
vacancy_data_list <- map(years, ~get_acs(geography = "state", 
                                         table = "DP04", 
                                         survey = "acs1",
                                         year = .x))
# .x is a shorthand notation for the current element being operated on in the iteration. 
# It's a placeholder that represents the individual elements of the input data structure 
# as the function iterates over them.


# Combine the list into a single data frame
vacancy_combined <- bind_rows(vacancy_data_list, .id = "year")



# for each value in NAME column, get the vacancy rate with variable = DP04_0005
acs1_vacancy_rate <- vacancy_combined |>  
  filter(variable == "DP04_0005") |> 
  rename(vacancy_rate = estimate) |> 
  select(year, NAME, vacancy_rate) |> 
  mutate(
    year = case_when(
      year == "1" ~ "2017",
      year == "2" ~ "2018",
      year == "3" ~ "2019",
      year == "4" ~ "2021",  # Assuming there's a typo in the question and "2021" is actually "2020"
      year == "5" ~ "2022",
      TRUE ~ as.character(year)  # If none of the conditions are met, keep the original value
    )
  )




write_csv(acs1_vacancy_rate, "./cleansed data/acs1_vacancy_rate_state.csv")



