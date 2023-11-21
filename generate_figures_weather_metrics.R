library(tidyverse);
library(aricode);
library(gridExtra);
library(grid);

################################################################################
# Table of Contents
# 0: Preparing Data
# 1: Principal Component Analysis
# 2: Comparison of Clusters: K-Means vs Actual
# 3: [Subset] Comparison of Clusters: K-Means vs Actual
################################################################################

chronic <- read_csv("derived_data/chronic1_cleaned.csv",show_col_types = FALSE);

###############
# 0 Preparing Data
###############

# Indicate which days are reported with insomnia
days_with_insomnia <- chronic %>%
  filter(grepl("insomnia",tolower(trackable_name))) %>%
  group_by(user_id,checkin_date) %>%
  tally() %>%
  mutate(insomnia_indicator=1);

chronic2 <- chronic %>%
  full_join(days_with_insomnia,by=c("user_id","checkin_date")) %>%
  mutate(insomnia_indicator=ifelse(is.na(insomnia_indicator),0,1)) %>%
  filter(trackable_type=="Weather");

# Remove duplicates and missing
chronic3 <- chronic2 %>%
  distinct(user_id, age, sex, country, checkin_date, trackable_type, n, insomnia_indicator, trackable_name, .keep_all=TRUE);

# Reshape dataframe
chronic4 <- chronic3 %>%
  pivot_wider(names_from = trackable_name, values_from = trackable_value) %>%
  filter(!(is.na(Icon) | is.na(Temperature_min) | is.na(Temperature_max) | is.na(Precip_intensity) | is.na(Pressure) | is.na(Humidity)));

###############
# 1: Principal Component Analysis
###############

# Perform PCA
pca_results <- chronic4 %>%
  mutate(Temperature_min_n=as.numeric(Temperature_min), Temperature_max_n=as.numeric(Temperature_max), Precip_intensity_n=as.numeric(Precip_intensity), Pressure_n=as.numeric(Pressure), Humidity_n=as.numeric(Humidity)) %>%
  select(Temperature_min_n, Temperature_max_n, Precip_intensity_n, Pressure_n, Humidity_n) %>%
  prcomp();

n_components <- dim(summary(pca_results)$importance)[2];
pca_variance <- summary(pca_results)$importance[2,1:n_components];

first_two_components <- pca_results$x %>%
  as_tibble() %>%
  select(PC1, PC2) %>%
  mutate(index=1:dim(pca_results$x)[1]);

# Visualize
plot1 <- ggplot(, aes(1:n_components, pca_variance)) +
  geom_point() +
  geom_line() +
  xlab("Number of Components") +
  ylab("Proportion of Variance Explained by Each Principal Component") + 
  ggtitle("How Many Components Really Contribute?");
plot2 <- ggplot(first_two_components, aes(x=PC1, y=PC2)) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  ggtitle("First Two Principal Components");
ggsave(
  "figures/figure_pca.png",
  grid.arrange(plot1, plot2, ncol=2, top=textGrob("Principal Component Analysis of Five Weather Metrics", gp=gpar(fontsize=20,font=2))),
  width = 12,
  height = 6,
  dpi = 300);

###############
# 2: Comparison of Clusters: K-Means vs Actual
###############

# (Plot A) Detect Clusters
kmeans_results <- pca_results$x %>% as_tibble() %>% select(PC1:PC5) %>% kmeans(centers=2);
first_two_components$cluster <- kmeans_results$cluster;

# (Plot B) Assign True Indicators
detached_indicator <- chronic4 %>%
  select(insomnia_indicator);

first_two_components$insomnia_indicator <- detached_indicator$insomnia_indicator;

# Compare
nmi_results <- NMI(chronic4$insomnia_indicator,first_two_components$cluster);

# Visualize
plot1 <- ggplot(first_two_components, aes(x=PC1, y=PC2, color=as.factor(cluster))) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Cluster") +
  ggtitle("K-means on PC1:PC5");
plot2 <- ggplot(first_two_components, aes(x=PC1, y=PC2, color=as.factor(insomnia_indicator))) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Insomnia Indicator") +
  ggtitle("True Identifiers");
ggsave(
  "figures/figure_insomnia_cluster.png",
  grid.arrange(plot1, plot2, ncol=2, top=textGrob("Can We Identify Structure within the First Two Principal Components of Five Weather Metrics?",gp=gpar(fontsize=20,font=2)), bottom=paste("Normalized Mutual Information (NMI):", as.character(nmi_results))),
  width = 16,
  height = 6,
  dpi = 300);

###############
# 3: [Subset] Comparison of Clusters: K-Means vs Actual
###############

# Subset
left_slice <- filter(first_two_components, PC1 <= -50);

# (Plot A) Detect Clusters
kmeans_results2 <- left_slice %>% select(PC1:PC2) %>% kmeans(centers=2);
left_slice$cluster <- kmeans_results2$cluster;

# (Plot B) Assign True Indicators

# Compare
nmi_results2 <- NMI(left_slice$insomnia_indicator,left_slice$cluster);

# Visualize
png("figures/figure_insomnia_cluster_subset.png");
plot1 <- ggplot(left_slice, aes(x=PC1, y=PC2, color=as.factor(cluster))) +
  geom_point() +
  scale_color_manual(values=c("#00bfc4","#f8766d")) +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Cluster") +
  ggtitle("True Identifiers");
plot2 <- ggplot(left_slice, aes(x=PC1, y=PC2, color=as.factor(insomnia_indicator))) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Insomnia Indicator") +
  ggtitle("K-means on PC1(< -50) and PC2(complete)");
ggsave(
  "figures/figure_insomnia_cluster_subset.png",
  grid.arrange(plot1, plot2, ncol=2, top=textGrob("Can We Identify Structure within (a Subset of) the First Two Principal Components?",gp=gpar(fontsize=20,font=2)), bottom=paste("Normalized Mutual Information (NMI):", as.character(nmi_results2))),
  width = 12,
  height = 6,
  dpi = 300);
