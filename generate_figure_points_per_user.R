library(tidyverse);

chronic <- read_csv("derived_data/chronic1_cleaned.csv",show_col_types = FALSE);

# Count how many data points each user contributed
days_per_user <- chronic %>%
  group_by(user_id,checkin_date) %>%
  tally() %>%
  arrange(desc(n)) %>%
  select(-n) %>%
  group_by(user_id) %>%
  tally() %>%
  arrange(desc(n));

png("figures/figure1_days_per_user.png");
ggplot(days_per_user, aes(x = n)) +
  geom_histogram(binwidth = 0.25, color = "black", fill="white") +
  scale_x_log10(labels = scales::number_format(accuracy = 1), breaks = 10^seq(0, 4, by = 0.25)) +
  scale_y_continuous(breaks = seq(0, 20000, by = 2000)) +
  labs(title = "Distribution of The Number of Days Recorded by Each User",
       x = "Days of Data Contributed by a User",
       y = "Frequency of Occurrence");
dev.off()