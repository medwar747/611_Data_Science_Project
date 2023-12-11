.PHONY: clean

clean:
	rm -rf derived_data
	rm -rf figures
	rm -rf .created-dirs
	rm -f writeup.html
	
.created-dirs:
	mkdir -p derived_data
	mkdir -p figures
	touch .created-dirs
	
# [1: Data Cleaning]
	
# Clean data by removing outliers and standardizing capitalization
derived_data/chronic1_cleaned.csv: .created-dirs clean_data.R source_data/chronic0_source.csv
	Rscript clean_data.R

# It can be helpful to tinker with a subset small enough for Excel to handle
derived_data/chronic2_sample.csv: .created-dirs subset.R derived_data/chronic1_cleaned.csv
	Rscript subset.R
	
# [2: Data Visualization]
	
# Determine the distribution of how many data of data each user contributed while using the app
figures/figure_days_per_user.png: .created-dirs generate_figure_days_per_user.R derived_data/chronic1_cleaned.csv
	Rscript generate_figure_days_per_user.R
	
# Determine the most prevalent terms reported on days where insomnia was also reported
figures/figure_wordcloud.png: .created-dirs generate_figure_wordcloud.R derived_data/chronic1_cleaned.csv
	Rscript generate_figure_wordcloud.R
	
# [3: Classification and Modeling]

# View the results of principal component analysis	
figures/figure_pca.png: .created-dirs generate_figures_weather_metrics.R derived_data/chronic1_cleaned.csv
	Rscript generate_figures_weather_metrics.R

# View the results of k-means clustering on the full sample data
figures/figure_insomnia_cluster.png: .created-dirs generate_figures_weather_metrics.R derived_data/chronic1_cleaned.csv
	Rscript generate_figures_weather_metrics.R

# View the results of k-means clustering on a subset of the sample data
figures/figure_insomnia_cluster_subset.png: .created-dirs generate_figures_weather_metrics.R derived_data/chronic1_cleaned.csv
	Rscript generate_figures_weather_metrics.R

# View the results of logisitic regression
figures/figure_logistic.png: .created-dirs generate_figures_weather_metrics.R derived_data/chronic1_cleaned.csv
	Rscript generate_figures_weather_metrics.R

# Create the final report!
writeup.html: .created-dirs generate_writeup.R writeup.Rmd figures/figure_days_per_user.png figures/figure_logistic.png figures/figure_insomnia_cluster_subset.png figures/figure_insomnia_cluster.png figures/figure_pca.png figures/figure_wordcloud.png
	Rscript generate_writeup.R