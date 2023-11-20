library(tidyverse);
library(data.table);
library(tidytext);
library(textmineR);
library(wordcloud);
library(hunspell);
library(devtools);
library(wordcloud2);
library(htmlwidgets);

chronic <- read_csv("derived_data/chronic1_cleaned.csv",show_col_types = FALSE);

days_with_insomnia <- chronic %>%
  filter(trackable_name=="Insomnia") %>%
  group_by(user_id,checkin_date) %>%
  tally();

chronic_insomnia_days <- chronic %>% right_join(days_with_insomnia,by=c("user_id","checkin_date"));

of_interest <- chronic_insomnia_days %>%
  filter(trackable_type=="Tag" | trackable_type=="Food" | (trackable_type=="Weather" & trackable_name=="Icon")) %>%
  mutate(trackable_name=ifelse(trackable_name=="Icon",trackable_value,trackable_name)) %>%
  select(trackable_name);

#############################################################################################
#                                       Clean Data
#############################################################################################

# Simplify Case
pre_data <- mutate(of_interest,trackable_name=tolower(trackable_name));

# Remove Missing
data <- filter(pre_data,!(is.na(trackable_name)));

# Remove Tokens
noise <- tibble(word=c("insomnia"));
data <- data %>% anti_join(noise);

# Count
name_freq <- data %>%
  group_by(trackable_name) %>%
  tally() %>%
  arrange(desc(n));

#############################################################################################
#                                 Generate Word Cloud
#############################################################################################
wc <-wordcloud2(name_freq,size=1,gridSize=10);
wc;
saveWidget(wc,"wc.html", selfcontained = F);
