library(houser)
library(tidyverse)

# Download annual data for one geography, two years.


# import txt files
permits_2017 <- bps_read('./raw data/ma2017a.txt')
permits_2018 <- bps_read('./raw data/ma2018a.txt')
permits_2019 <- bps_read('./raw data/ma2019a.txt')
permits_2021 <- bps_read('./raw data/ma2021a.txt')
permits_2022 <- bps_read('./raw data/ma2022a.txt')




housing_permits_2017 <- permits_2017 %>% 
  select(`CBSA Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)
housing_permits_2018 <- permits_2018 %>%
  select(`CBSA Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)
housing_permits_2019 <- permits_2019 %>%
  select(`CBSA Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)
housing_permits_2021 <- permits_2021 %>%
  select(`CBSA Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)
housing_permits_2022 <- permits_2022 %>%
  select(`CBSA Name`, `1-unit Units`, `2-units Units`, `3-4 units Units`, `5+ units Units`)


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
write_csv(housing_permits, "./cleansed data/housing_permits_metro.csv")
