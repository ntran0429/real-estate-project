library(tidycensus)
library(tidyverse)

key = Sys.getenv("CENSUS_API_KEY")
census_api_key(key, install = TRUE)



# Get vacancy rates for metropolitan areas
# vacancy_metro <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area", 
#                          table = "DP04", 
#                          survey = "acs5",
#                          year = 2022)

# for each value in NAME column, get the vacancy rate with variable = DP04_0005
# vacancy_rate_metro <- vacancy_metro |>  
#   filter(variable == "DP04_0005") |> 
#   filter(!str_detect(NAME, "Micro")) |> 
#   rename(vacancy_rate = estimate) |> 
#   select(-variable)


library(purrr)

years <- c(2017,2018,2019,2021,2022)

# Use map to fetch data for each year
vacancy_data_list <- map(years, ~get_acs(geography = "metropolitan statistical area/micropolitan statistical area", 
                                         table = "DP04", 
                                         survey = "acs1",
                                         year = .x))

# Combine the list into a single data frame
vacancy_combined <- bind_rows(vacancy_data_list, .id = "year")



# for each value in NAME column, get the vacancy rate with variable = DP04_0005
acs1_vacancy_metro <- vacancy_combined |>  
  filter(variable == "DP04_0005") |> 
  filter(!str_detect(NAME, "Micro")) |> 
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




write_csv(acs1_vacancy_metro, "./cleansed data/acs1_vacancy_rate_metro.csv")
