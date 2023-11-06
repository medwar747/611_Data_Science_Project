library(tidyverse);

chronic <- read_csv("derived_data/chronic1_cleaned.csv",show_col_types = FALSE);

chronic_insomnia <- chronic %>% filter(trackable_name=="Insomnia" & !is.na(trackable_name));

# Determine how many days user experienced insomnia
user_day_insomnia <- chronic_insomnia %>%
  group_by(user_id,checkin_date,trackable_name) %>%
  tally() %>%
  arrange(desc(n));
user_day_insomnia_count <- user_day_insomnia %>%
  group_by(user_id) %>%
  tally() %>%
  arrange(desc(n));
user_day_insomnia_count <- user_day_insomnia_count %>% rename(numerator = n);

# Determine how many days user recorded data
user_day_record <- chronic %>%
  group_by(user_id,checkin_date) %>%
  tally() %>%
  arrange(desc(n));
user_day_record_count <- user_day_record %>%
  group_by(user_id) %>%
  tally() %>%
  arrange(desc(n));
user_day_record_count <- user_day_record_count %>% rename(denominator = n);

# Determine user age
user_age <- chronic_insomnia %>%
  group_by(user_id,age) %>%
  tally() %>%
  arrange(desc(n)) %>%
  select(-n);

# Calculate Proportion
plot_data <- user_day_record_count %>%
  right_join(user_day_insomnia_count, by="user_id") %>%
  inner_join(user_age, by="user_id") %>%
  mutate(prop=numerator/denominator);

png("figures/figure2_insomnia_vs_age.png");
ggplot(plot_data, aes(x = age, y = prop)) +
  geom_point() +
  labs(title = "Does Insomnia Occurrence Change with Age?",
       subtitle = "From the Population of Users Who Reported at Least One Instance of Insomnia",
       x = "Age",
       y = "Proportion of Recorded Days with Insomnia") +
  geom_jitter(width = 0.05, height = 0.05);
dev.off()
