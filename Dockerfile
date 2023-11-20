FROM rocker/verse
RUN apt update && apt install -y man-db && rm -rf /var/lib/apt/lists/*
RUN yes|unminimize
RUN Rscript --no-restore --no-save -e "install.packages('data.table')"
RUN Rscript --no-restore --no-save -e "install.packages('tidytext')"
RUN Rscript --no-restore --no-save -e "install.packages('textmineR')"
RUN Rscript --no-restore --no-save -e "install.packages('hunspell')"
RUN Rscript --no-restore --no-save -e "install.packages('devtools')"
RUN Rscript --no-restore --no-save -e "library('devtools'); install_github('lchiffon/wordcloud2')"
RUN Rscript --no-restore --no-save -e "install.packages('htmlwidgets')"
RUN Rscript --no-restore --no-save -e "install.packages('aricode')"
RUN Rscript --no-restore --no-save -e "install.packages('gridExtra')"
RUN Rscript --no-restore --no-save -e "install.packages('grid')"