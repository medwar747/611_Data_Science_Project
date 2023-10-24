## Effects of Chronic Illness on Sleep Quality and Other Lifestyle Indicators

This repository houses an analysis of symptoms from participants with various chronic conditions, as recorded via the Flaredown app. [Click here](https://www.kaggle.com/datasets/flaredown/flaredown-autoimmune-symptom-tracker) to view a summary in Kaggle.

## Setting up the Environment

The included Dockerfile is essential to building a neat and reproducible experience for the user, where needed preliminaries like library installations are executed.

Before invoking Docker, always make sure that the working directory is set to the path at which the project resides.

Repository users will need to be familiar with three steps in order to use this repository:

##### 0. Building the Docker Container.

First-time users can build the repository container in unix by running:

```         
docker build . -t medwar
```

##### 1a. Running the Docker Container.

After the container has been built (any time in the past), it can be run with:

```  
docker run --rm -e PASSWORD=rstudio -v "$(pwd):/home/rstudio/work" -p 8789:8787 -it medwar
```

##### 1b. Accessing the Environment.

Visiting <http://localhost:8789> will allow you to access and interact with the repository environment in RStudio. Both the username and password are "rstudio".

## Project Structure and Flow

Examine the Makefile to see how the Docker container applies the R scripts to the source data to generate reproducible derived datasets, models, and figures.

## Key Outputs

xyz

## Results

xyz
