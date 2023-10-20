library(tidyverse);

chronic <- read_csv("derived_data/chronic1_cleaned.csv",show_col_types = FALSE);

# Count how many data points each user contributed
unique_subjects <- chronic %>%
  group_by(user_id,sex) %>%
  tally() %>%
  arrange(desc(n));

unique_subjects <- unique_subjects %>% filter(!is.na(sex));

# Examine the relationship between sex and data points contributed per user
png("figures/figure1.png");
ggplot(unique_subjects, aes(x = n, fill = sex)) +
  geom_histogram(binwidth = .5, position = "identity", alpha = 0.5, color = "black") +
  scale_x_log10(labels = scales::number_format(accuracy = 1), breaks = 10^seq(0, 4, by = 1)) +
  scale_y_continuous(breaks = seq(0, 10000, by = 1000)) +
  labs(title = "Distribution of The Number of Data Points Contributed by Each User",
       x = "Data Points Per User",
       y = "Frequency of Occurrence",
       fill = "Sex");
dev.off()
