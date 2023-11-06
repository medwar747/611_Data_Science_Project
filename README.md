# Effects of Chronic Illness on Sleep Quality and Other Lifestyle Indicators

This repository houses an analysis of symptoms from participants with various chronic conditions, as recorded via the Flaredown app. [Click here](https://www.kaggle.com/datasets/flaredown/flaredown-autoimmune-symptom-tracker) to view a summary in Kaggle.

## Interacting with the Project

Be sure to have Git, Docker (Desktop), and RStudio installed before attempting to interact with this project.\
Note: the following instructions are designed for Windows users.\
Note: steps 1-2a need only be executed when interacting with the project for the first time.

#### 1. Cloning the Repository

Open Windows PowerShell and `cd` to the directory where you want the repository to reside. Clone the repository with the following:

```         
git clone https://github.com/medwar747/611_Data_Science_Project.git
```

#### 2. Setting up the Environment

Open the project and note the Dockerfile. The Dockerfile is essential to building a neat and reproducible experience for the user, where needed preliminaries like library installations are executed.

Before invoking Docker, always make sure that:\
- the working directory is set to the directory in which the Dockerfile resides. If you just completed the step 1, you will need to execute `cd 611_Data_Science_Project`.\
- Docker Desktop is running in the background.

##### a. Building the Docker Container.

First-time users can build the repository container with Unix/PowerShell:

```         
docker build . -t medwar
```

##### b. Running the Docker Container.

After the container has been built (any time in the past), it can be run after invoking `bash` with Unix/PowerShell:

```         
docker run --rm -e PASSWORD=rstudio -v "$(pwd):/home/rstudio/work" -p 8789:8787 -it medwar
```

#### 3. Accessing the Environment.

Visit <http://localhost:8789> to access and interact with the repository environment in RStudio. Both the username and password are "rstudio".

## Project Structure and Flow

Examine the Makefile to see how the Docker container applies the R scripts to the source data to generate reproducible derived datasets, models, and figures.

## Key Outputs

xyz

## Results

xyz
