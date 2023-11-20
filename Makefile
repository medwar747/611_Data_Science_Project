.PHONY: clean

clean:
	rm -rf derived_data
	rm -rf figures
	rm -rf .created-dirs
	
.created-dirs:
	mkdir -p derived_data
	mkdir -p figures
	touch .created-dirs
	
derived_data/chronic1_cleaned.csv: clean_data.R source_data/chronic0_source.csv
	Rscript clean_data.R

# It can be helpful to tinker with a subset small enough for Excel to handle
derived_data/chronic2_sample.csv: subset.R derived_data/chronic1_cleaned.csv
	Rscript subset.R
	
figures/figure_days_per_user.png: generate_figure_days_per_user.R derived_data/chronic1_cleaned.csv
	Rscript generate_figure_days_per_user.R
	
figures/figure_insomnia_vs_age.png: generate_figure_insomnia_vs_age.R derived_data/chronic1_cleaned.csv
	Rscript generate_figure_insomnia_vs_age.R
	
figures/figure_wordcloud.html: generate_figure_wordcloud.R derived_data/chronic1_cleaned.csv
	Rscript generate_figure_wordcloud.R
	
figures/figure_pca.png: generate_figures_weather_metrics.R derived_data/chronic1_cleaned.csv
	Rscript generate_figures_weather_metrics.R
	
figures/figure_insomnia_cluster.png: generate_figures_weather_metrics.R derived_data/chronic1_cleaned.csv
	Rscript generate_figures_weather_metrics.R
	
figures/figure_insomnia_cluster_subset.png: generate_figures_weather_metrics.R derived_data/chronic1_cleaned.csv
	Rscript generate_figures_weather_metrics.R