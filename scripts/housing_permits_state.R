# library(devtools)
# devtools::install_github("everetr/houser")
library(houser)
library(tidyverse)

# Download annual data for one geography, two years.
bps_get(path = "./raw data", geography = "state", years = c(2017,2018,2019,2021,2022))


# import txt files
housing_permits_2017 <- bps_read('./raw data/raw datast2017a.txt')
housing_permits_2018 <- bps_read('./raw data/raw datast2018a.txt')
housing_permits_2019 <- bps_read('./raw data/raw datast2019a.txt')
housing_permits_2021 <- bps_read('./raw data/raw datast2021a.txt')
housing_permits_2022 <- bps_read('./raw data/raw datast2022a.txt')

# for each housing_permits dfs, 
# select only State Name, 1-unit Units, 2-units Units, 3-4 units Units, 5+ units Units
housing_permits_2017 <- housing_permits_2017 %>% 
  select(`State Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)

housing_permits_2018 <- housing_permits_2018 %>%
  select(`State Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)

housing_permits_2019 <- housing_permits_2019 %>%
  select(`State Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)

housing_permits_2021 <- housing_permits_2021 %>%
  select(`State Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)

housing_permits_2022 <- housing_permits_2022 %>%
  select(`State Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)


# for each df, add a year column indicating its corresponding year
housing_permits_2017 <- housing_permits_2017 %>% 
  mutate(year = 2017)
housing_permits_2018 <- housing_permits_2018 %>% 
  mutate(year = 2018)
housing_permits_2019 <- housing_permits_2019 %>%
  mutate(year = 2019)
housing_permits_2021 <- housing_permits_2021 %>%
  mutate(year = 2021)
housing_permits_2022 <- housing_permits_2022 %>%
  mutate(year = 2022)


# combine all dfs into one
housing_permits <- bind_rows(housing_permits_2017, 
                             housing_permits_2018, 
                             housing_permits_2019, 
                             housing_permits_2021, 
                             housing_permits_2022)

# write to csv
write_csv(housing_permits, "./cleansed data/housing_permits_state.csv")

