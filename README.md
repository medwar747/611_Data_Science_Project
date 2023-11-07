# Effects of Chronic Illness on Sleep Quality and Other Lifestyle Indicators

This repository houses an analysis of symptoms from participants with various chronic conditions, as recorded via the Flaredown app. [Click here](https://www.kaggle.com/datasets/flaredown/flaredown-autoimmune-symptom-tracker) to view a summary in Kaggle.

## Interacting with the Project

Be sure to have Git, Docker (Desktop), and RStudio installed before attempting to interact with this project.\
Note: the following instructions are designed for Windows users.\
Note: step 1 need only be executed when interacting with the project for the first time.

#### 1. Cloning the Repository

Open Windows PowerShell and `cd` to the directory where you want the repository to reside. Clone the repository with the following:

```         
git clone https://github.com/medwar747/611_Data_Science_Project.git
```

#### 2. Setting up the Environment

Open the project and note the Dockerfile. The Dockerfile is essential to building a neat and reproducible experience for the user, where needed preliminaries like library installations are executed.

Before invoking Docker, always make sure that:\
- the working directory is set to the directory in which the Dockerfile resides. If you just completed the step 1, you will need to execute `cd 611_Data_Science_Project`. 
- Docker Desktop is running in the background.

##### Building and Running the Docker Container.

Users can build and run the repository container with the script `start-env.sh`. 
With Unix/PowerShell this looks like:

```         
bash start-env.sh
```

#### 3. Accessing the Environment.

Visit <http://localhost:8789> to access the repository environment in RStudio. Both the username and password are "rstudio".

## Project Structure and Flow

Examine the Makefile to see how the Docker container applies the R scripts to the source data to generate reproducible derived datasets, models, and figures.

## Key Outputs

xyz

## Results

xyz
