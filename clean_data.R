library(tidyverse);

chronic <- read_csv("source_data/export.csv",show_col_types = FALSE);

# user_id

# age
chronic <- chronic %>% mutate(age = ifelse(!(0<=age & age<=150), NA, age));

# sex
chronic <- chronic %>% mutate(sex = ifelse(sex=="doesnt_say", NA, sex));
chronic <- chronic %>% mutate(sex= str_to_title(sex));

# country

#checkin_date

# trackable_id
chronic <- subset(chronic, select = -trackable_id);

# trackable_type

# trackable_name
chronic <- chronic %>% mutate(trackable_name= str_to_title(trackable_name));

#trackable_value
chronic <- chronic %>% mutate(trackable_value= str_to_title(trackable_value));

write_csv(chronic,"derived_data/chronic1_cleaned.csv");