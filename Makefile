.PHONY: clean

clean:
	rm -rf derived_data
	rm -rf figures
	mkdir -p derived_data
	mkdir -p figures
	
derived_data/chronic1_cleaned.csv: clean_data.R source_data/export.csv
	Rscript clean_data.R
	
derived_data/chronic2_sample.csv: subset.R derived_data/chronic1_cleaned.csv
	Rscript subset.R
	
figures/figure1.png: generate_figure1.R derived_data/chronic1_cleaned.csv
	Rscript generate_figure1.R
	
figures/figure2.png: generate_figure2.R derived_data/chronic1_cleaned.csv
	Rscript generate_figure2.R