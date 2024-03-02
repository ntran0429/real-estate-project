library(tidycensus)
library(tidyverse)

key = Sys.getenv("CENSUS_API_KEY")
census_api_key(key, install = TRUE)



# Get vacancy rates for metropolitan areas
vacancy_metro <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area", 
                        table = "DP04", 
                        survey = "acs5",
                        year = 2022)

# for each value in NAME column, get the vacancy rate with variable = DP04_0005
vacancy_rate_metro <- vacancy_metro |>  
  filter(variable == "DP04_0005") |> 
  filter(!str_detect(NAME, "Micro")) |> 
  filter(!str_detect(NAME, "Micro")) |> 
  rename(vacancy_rate = estimate) |> 
  select(-variable)


# Get vacancy rates for states
vacancy_state <- get_acs(geography = "state", 
                         table = "DP04", 
                         survey = "acs5",
                         year = 2022)

# for each value in NAME column, get the vacancy rate with variable = DP04_0005
vacancy_rate_state <- vacancy_state |>  
  filter(variable == "DP04_0005") |> 
  rename(vacancy_rate = estimate) |> 
  select(-variable)


# export to csv's
write_csv(vacancy_rate_state, "./cleansed data/acs5_1822_vacancy_rate_state.csv")
write_csv(vacancy_rate_metro, "./cleansed data/acs5_1822_vacancy_rate_metro.csv")













