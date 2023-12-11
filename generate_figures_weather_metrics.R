library(tidyverse);
library(aricode);
library(gridExtra);
library(grid);
library(scatterplot3d);

################################################################################
# Table of Contents
# 0: Preparing Data
# 1: Principal Component Analysis
# 2: Comparison of Clusters: K-Means vs Actual
# 3: [Subset] Comparison of Clusters: K-Means vs Actual
# 4: Logistic Regression
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
plot1A <- ggplot(, aes(1:n_components, pca_variance)) +
  geom_point() +
  geom_line() +
  xlab("Number of Components") +
  ylab("Proportion of Variance Explained by Each Principal Component") + 
  ggtitle("How Many Components Really Contribute?");
plot1B <- ggplot(first_two_components, aes(x=PC1, y=PC2)) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  ggtitle("First Two Principal Components");
ggsave(
  "figures/figure_pca.png",
  grid.arrange(plot1A, plot1B, ncol=2, top=textGrob("Principal Component Analysis of Five Weather Metrics", gp=gpar(fontsize=20,font=2))),
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
plot2A <- ggplot(first_two_components, aes(x=PC1, y=PC2, color=as.factor(cluster))) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Cluster") +
  ggtitle("K-means on PC1:PC5");
plot2B <- ggplot(first_two_components, aes(x=PC1, y=PC2, color=as.factor(insomnia_indicator))) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Insomnia Indicator") +
  ggtitle("True Identifiers");
ggsave(
  "figures/figure_insomnia_cluster.png",
  grid.arrange(plot2A, plot2B, ncol=2, top=textGrob("Can We Identify Structure within the First Two Principal Components of Five Weather Metrics?",gp=gpar(fontsize=20,font=2)), bottom=paste("Normalized Mutual Information (NMI):", as.character(nmi_results))),
  width = 16,
  height = 7,
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
plot3A <- ggplot(left_slice, aes(x=PC1, y=PC2, color=as.factor(cluster))) +
  geom_point() +
  scale_color_manual(values=c("#00bfc4","#f8766d")) +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Cluster") +
  ggtitle("K-means on PC1(< -50) and PC2(complete)");
plot3B <- ggplot(left_slice, aes(x=PC1, y=PC2, color=as.factor(insomnia_indicator))) +
  geom_point() +
  xlab("PC1") +
  ylab("PC2") + 
  labs(color = "Insomnia Indicator") +
  ggtitle("True Identifiers");
ggsave(
  "figures/figure_insomnia_cluster_subset.png",
  grid.arrange(plot3A, plot3B, ncol=2, top=textGrob("Can We Identify Structure within (a Subset of) the First Two Principal Components?",gp=gpar(fontsize=20,font=2)), bottom=paste("Normalized Mutual Information (NMI):", as.character(nmi_results2))),
  width = 12,
  height = 6,
  dpi = 300);

###############
# 4: Logistic Regression
###############

model <- glm(insomnia_indicator~PC1+PC2, data=first_two_components, family=binomial);
model_table <- summary(model)$coefficients;
if (model_table[2,4] < 0.0001) {
  p1 <- "<0.0001";
} else {
  p1 <- as.character(round(model_table[2,4],3));
}
if (model_table[3,4] < 0.0001) {
  p2 <- "<0.0001";
} else {
  p2 <- as.character(round(model_table[3,4],3));
}

predicted_data <- tibble(predictions=predict(model, select(first_two_components,c(PC1,PC2)), type="response"));

# Verify by Hand
# predicted_data2 <- mutate(first_two_components, insomnia_measure=(exp(-2.1329278+0.0030721*PC1+0.0008527*PC2))/(1+exp(-2.1329278+0.0030721*PC1+0.0008527*PC2)));

pre_plot4_data_a <- rename(select(first_two_components,c(PC1,PC2,insomnia_indicator)),insomnia_measure=insomnia_indicator);
pre_plot4_data_b <- tibble(PC1=first_two_components$PC1, PC2=first_two_components$PC2, insomnia_measure=predicted_data$predictions);
plot4_data <- rbind(pre_plot4_data_a,pre_plot4_data_b);
plot4_data$colors[plot4_data$insomnia_measure==0] <- "#00bfc4";
plot4_data$colors[plot4_data$insomnia_measure==1] <- "#f8766d";
plot4_data$colors[0 < plot4_data$insomnia_measure & plot4_data$insomnia_measure < 1] <- "#000000";
plot4_data$group[plot4_data$insomnia_measure==0] <- 0
plot4_data$group[plot4_data$insomnia_measure==1] <- 1;
plot4_data$group[0 < plot4_data$insomnia_measure & plot4_data$insomnia_measure < 1] <- 2;

png("figures/figure_logistic.png",width=10,height=7,units="in",res=1200);
scatterplot3d(select(plot4_data,c(PC1,PC2,insomnia_measure)),
                       pch = 16,
                       angle=15,
                       color=plot4_data$colors,
                       main="Does Logistic Regression Detect a Relationship \nBetween Insomnia Status and the First Two Principal Components of Weather Metrics?",
                       xlab = paste("PC1 [p=",p1,"]"),
                       ylab = paste("PC2 [p=",p2,"]"),
                       zlab = "Insomnia Indicators and Regression Predictions");
legend("right", legend = c("Did Not Report Insomnia","Reported Insomnia","Model Prediction Surface"),
       col =  c("#00bfc4", "#f8766d", "#000000"), 
       pch = c(16, 17, 18), 
       inset = 0.1, xpd = TRUE, horiz = TRUE);
dev.off();


