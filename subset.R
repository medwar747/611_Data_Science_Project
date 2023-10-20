library(tidyverse);

input <- read_csv("derived_data/chronic1_cleaned.csv",show_col_types = FALSE);

unique_subjects <- input %>%
                    group_by(user_id) %>%
                    tally() %>%
                    arrange(desc(n));

sampled_subjects <- unique_subjects[,1] %>%
                    pull() %>% 
                    sample(5000, replace=FALSE, prob=NULL) %>%
                    as_tibble() %>%
                    rename(user_id=value);

output <- input %>% right_join(sampled_subjects, by="user_id");

write_csv(output,"derived_data/chronic2_sample.csv");