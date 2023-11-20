library(tidyverse);

chronic <- read_csv("derived_data/chronic1_cleaned.csv",show_col_types = FALSE);

# Tabulate unique user days
unique_user_days <- chronic %>%
  group_by(user_id,checkin_date) %>%
  tally() %>%
  select(-n);

# Indicate which days have insomnia
insomnia_status_of_days <- chronic %>%
  filter(grepl("insomnia",tolower(trackable_name))) %>%
  group_by(user_id,age,checkin_date) %>%
  tally() %>%
  select(-n) %>%
  mutate(insomnia_indicator=1) %>%
  full_join(unique_user_days,by=c("user_id","checkin_date")) %>%
  mutate(insomnia_indicator=ifelse(is.na(insomnia_indicator),0,1)) %>%
  group_by(user_id);


# A: Count how many days of insomnia a user reports
user_insomnia_count <- tibble(aggregate(insomnia_status_of_days$insomnia_indicator, by=list(user_id=insomnia_status_of_days$user_id), FUN=sum));

# B: Count how many days each user contributed
days_per_user <- chronic %>%
  group_by(user_id,age,checkin_date) %>%
  tally() %>%
  arrange(desc(n)) %>%
  select(-n) %>%
  group_by(user_id,age) %>%
  tally() %>%
  arrange(desc(n));

# A+B
plot_data <- full_join(user_insomnia_count,days_per_user,by=c("user_id")) %>%
  mutate(prop=x/n) %>%
  filter(age>=18) %>%
  filter(n>=10);

# Display
png("figures/figure2_insomnia_vs_age.png");
ggplot(plot_data, aes(x = age, y = prop)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Does Insomnia Occurrence in Adults Change with Age?",
       subtitle = "From the Population of Users with at Least Ten Days of Data",
       x = "Age",
       y = "Proportion of Recorded Days with Insomnia") +
  geom_jitter(width = 0.025, height = 0.025) +
  scale_x_continuous(breaks = seq(18, 98, by = 5)) +
  geom_text(aes(label = paste("p=",as.character(round(summary(lm(prop~age,plot_data))$coefficients[2,4],2)))),
            x = 62, y = 0.15, hjust = 0, vjust = 0, color = "blue");
dev.off()
