library(tidyverse);
library(data.table);
library(tidytext);
library(textmineR);
library(hunspell);
library(wordcloud);
library(RColorBrewer);

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
noise <- tibble(trackable_name=c("insomnia"));
data <- data %>% anti_join(noise);

# Count
name_freq <- data %>%
  group_by(trackable_name) %>%
  tally() %>%
  arrange(desc(n));

#############################################################################################
#                                 Generate Word Cloud
#############################################################################################
# acorn <- floor(10000*runif(1));
set.seed(1076);
png("figures/figure_wordcloud.png",width=10,height=10,units="in",res=1200);
wordcloud(words=name_freq$trackable_name, freq=name_freq$n, min.freq=3, max.word=75, colors=c("#1D91C0","#238443","#6A51A3","#EF6548","#A63603","#41AB5D","#00441B","#08306B"), scale=c(5,1.5));
dev.off();




