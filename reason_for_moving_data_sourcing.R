library(ipumsr)
library(tidyverse)

api_key <- Sys.getenv("ipums_api_key")
set_ipums_api_key(api_key)


my_extract_definition <- define_extract_cps(
  description = "reason for moving to another state extract", 
  samples = c("cps2017_03s", "cps2018_03s", 
            "cps2019_03s", "cps2020_03s", "cps2022_03s"), 
  variables = c("WHYMOVE", "MIGSTA1"),
  data_structure = "rectangular",
  data_format = "csv",
  case_select_who = "individuals"
)

data <- my_extract_definition |>
  submit_extract() |>
  wait_for_extract() |>
  download_extract() |>
  read_ipums_micro()


hist(data$WHYMOVE)

# remove rows where WHYMOVE is 0 
# and MIGSTA1 is not 91 or 99
# delete columns that are not WHYMOVE and MIGSTA1
data_movers_only <- data |>
  filter(WHYMOVE != 0) |>
  filter(!(MIGSTA1 == 91 | MIGSTA1 == 99)) |> 
  select(YEAR, WHYMOVE, MIGSTA1)


ggplot(data_movers_only, aes(x = WHYMOVE)) +
  geom_bar() +
  labs(title = "Reason for Moving to Another State",
       x = "Reason Code",
       y = "Count")



# 2017-2020 and 2022
table(data_movers_only$WHYMOVE)


# table aggregate by 2022 only
table(data_movers_only[data_movers_only$YEAR == 2022, ]$WHYMOVE)

# now create proportion table
prop.table(table(data_movers_only$WHYMOVE))



# plot proportion table
prop.table(table(data_movers_only$WHYMOVE)) |>
  as.data.frame() |>
  ggplot(aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity") +
  labs(title = "Reason for Moving to Another State",
       x = "Reason Code",
       y = "Proportion")


# filter for MIGSTA1 == 1 and WHYMOVE == 1
# MIGSTA1 == 1 is the state code for Alabama
# WHYMOVE == 1 is the reason code for job
# data_movers_only |>
#   filter(MIGSTA1 == 1) |>
#   filter(WHYMOVE == 1)
