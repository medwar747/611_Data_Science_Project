FROM rocker/verse
RUN apt update && apt install -y man-db && rm -rf /var/lib/apt/lists/*
RUN yes|unminimize
RUN Rscript --no-restore --no-save -e "install.packages('data.table')"
RUN Rscript --no-restore --no-save -e "install.packages('tidytext')"
RUN Rscript --no-restore --no-save -e "install.packages('textmineR')"
RUN Rscript --no-restore --no-save -e "install.packages('hunspell')"
RUN Rscript --no-restore --no-save -e "install.packages('wordcloud')"
RUN Rscript --no-restore --no-save -e "install.packages('aricode')"
RUN Rscript --no-restore --no-save -e "install.packages('gridExtra')"
RUN Rscript --no-restore --no-save -e "install.packages('grid')"
RUN Rscript --no-restore --no-save -e "install.packages('RColorBrewer')"
RUN Rscript --no-restore --no-save -e "install.packages('rmarkdown')"