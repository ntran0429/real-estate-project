library(tidycensus)
library(tidyverse)

key = Sys.getenv("CENSUS_API_KEY")
census_api_key(key, install = TRUE)



# Get poverty data for metropolitan areas
poverty_data <- get_acs(geography = "metropolitan statistical area/micropolitan statistical area", 
                        table = "S1901", 
                        survey = "acs1",
                        year = 2022)

# Create a mapping table
code_mapping <- c(
  "001" = "Total",
  "002" = "Less than $10,000",
  "003" = "$10,000 to $14,999",
  "004" = "$15,000 to $24,999",
  "005" = "$25,000 to $34,999",
  "006" = "$35,000 to $49,999",
  "007" = "$50,000 to $74,999",
  "008" = "$75,000 to $99,999",
  "009" = "$100,000 to $149,999",
  "010" = "$150,000 to $199,999",
  "011" = "$200,000 or more",
  "012" = "Median income (dollars)",
  "013" = "Mean income (dollars)",
  "014" = "Household income in the past 12 months",
  "015" = "Family income in the past 12 months",
  "016" = "Nonfamily income in the past 12 months"
)

# keep the last three digits of 'variable' in poverty_data
poverty_data$variable <- substr(poverty_data$variable, start = 11, stop = 13)


# Apply the mapping to your variable
poverty_data$label <- code_mapping[poverty_data$variable]
poverty_data$variable <- NULL


# remove rows with 'Micro' in NAME column
poverty_wo_micro <- poverty_data %>% 
  filter(!str_detect(NAME, "Micro"))


# for each value in NAME column, keep the first 13 rows
poverty <- poverty_wo_micro %>% 
  group_by(NAME) %>% 
  slice(1:13) %>%
  ungroup()

# for each value in NAME column, sum up the values in 'estimate' column
# from row 2 to row 11
poverty_rate <- poverty %>% 
  group_by(NAME) %>% 
  mutate(total = sum(estimate[2:5]))


# modify the code right above by aggregating the data like in sql
poverty_rate <- poverty %>% 
  group_by(NAME) %>% 
  summarise(poverty_rate = sum(estimate[2:5]))


# export poverty_rate to a csv file
write_csv(poverty_rate, "./cleansed data/poverty_rate.csv")





























