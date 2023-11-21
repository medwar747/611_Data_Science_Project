#!/bin/bash
docker build . -t medwar;
docker run --rm -e PASSWORD=rstudio -v "$(pwd):/home/rstudio/work" -p 8789:8787 -it medwar;