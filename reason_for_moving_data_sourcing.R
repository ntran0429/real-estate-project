library(ipumsr)
library(tidyverse)

api_key <- Sys.getenv("ipums_api_key")
set_ipums_api_key(api_key)


my_extract_definition <- define_extract_cps(
  description = "reason for moving to another state extract", 
  samples = c("cps2017_03s", "cps2018_03s", "cps2019_03s"
            , "cps2020_03s", "cps2022_03s", "cps2023_03s"), 
  variables = c("WHYMOVE", "MIGSTA1", "MIGRATE1"),
  data_structure = "rectangular",
  data_format = "csv",
  case_select_who = "individuals"
)

# WHYMOVE - primary reason for moving, for people who lived in a different residence a year ago.
# MIGRATE1 - Movers across various geographic boundaries--county, state, and country. 
# MIGSTA1 - State of previous residence

# In WHYMOVE, the codes relate to family, work, housing, education, climate, and health. 



data <- my_extract_definition |>
  submit_extract() |>
  wait_for_extract() |>
  download_extract() |>
  read_ipums_micro()














# initial exploring
hist(data$WHYMOVE)

# 2017-2020 and 2022
table(data_movers_only$WHYMOVE)


# table aggregate by 2022 only
table(data_movers_only[data_movers_only$YEAR == 2022, ]$WHYMOVE)

# now create proportion table
prop.table(table(data_movers_only$WHYMOVE)) * 100




# remove rows where WHYMOVE is 0 
# and MIGSTA1 is not 91 or 99
data_movers_only <- data |>
  filter(WHYMOVE != 0) |> # remove NIU cases
  filter(MIGRATE1 == 5) |> # filter for movers between states only
  filter(!(MIGSTA1 == 91 | MIGSTA1 == 99)) # remove NIU and Same house cases

movers_copy <- data_movers_only


# histogram of sample data
ggplot(data_movers_only, aes(x = WHYMOVE)) +
  geom_bar() +
  labs(title = "Reason for Moving to Another State",
       x = "Reason",
       y = "Count")



# histogram of weighted data
ggplot(data_movers_only, aes(x = WHYMOVE, weight = ASECWT)) +
  geom_bar() +
  labs(title = "Reason for Moving to Another State",
       x = "Reason",
       y = "Count")

# How many people moved for each reason in year 2022? (weighted)
data_movers_only |> 
  group_by(WHYMOVE) |>
  filter(YEAR == 2022) |>
  summarise(count = sum(ASECWT))


# this matches the sample data queried on the online tool (unweighted)
# https://sda.cps.ipums.org/sdaweb/analysis/exec?formid=tbf&sdaprog=tables&dataset=all_march_samples&sec508=false&row=migsta1&column=whymove&filters=year%282017-2020%2C+2022%29%2C+migrate1%285%29&weightlist=sdawt&rowpct=on&cflevel=95&unweightedn=on&weightedn=on&color=on&ch_type=stackedbar&ch_color=yes&ch_width=600&ch_height=400&ch_orientation=vertical&ch_effects=use2D&decpcts=1&decse=1&decwn=1&decstats=2&csvformat=no&csvfilename=tables.csv
data_movers_only |> 
  group_by(WHYMOVE) |>
  filter(YEAR %in% c("2017", "2018", "2019", "2020", "2022")) |>
  summarise(count = n())



# How many people moved for each reason by state in year 2022? (weighted)
data_movers_only |> 
  summarize(count = sum(ASECWT)
            , .by = c(YEAR, WHYMOVE, MIGSTA1))


movers_weighted <-
  data_movers_only |> 
  summarize(count = sum(ASECWT)
            , .by = c(YEAR, WHYMOVE, MIGSTA1))


movers_weighted$YEAR <- as.character(movers_weighted$YEAR)
movers_weighted$WHYMOVE <- as_factor(movers_weighted$WHYMOVE)
movers_weighted$MIGSTA1 <- as_factor(movers_weighted$MIGSTA1)







# export csv file
write_csv(data, "./raw data/moving_reason_by_state_raw.csv")
write_csv(data_movers_only, "./cleansed data/moving_reason_by_state.csv")
write_csv(movers_weighted, "./cleansed data/moving_reason_by_state_weighted.csv")

