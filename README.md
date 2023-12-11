# Associations between Daily Weather Conditions and Daily Insomnia Status

This repository houses an analysis of data from participants with various chronic conditions, as recorded via the Flaredown app. [Click here](https://www.kaggle.com/datasets/flaredown/flaredown-autoimmune-symptom-tracker) to view a summary in Kaggle. While analyses will focus on the relationship between insomnia and five weather metrics, the data is a rich collection of symptoms, medications, and conditions.

## Interacting with the Project

Be sure to have Git, Docker (Desktop), and RStudio installed before attempting to interact with this project.\
Note: The following instructions are designed for Windows users.\
Note: Step 1 need only be executed when interacting with the project for the first time.

#### 1. Cloning the Repository

Open Windows PowerShell and `cd` to the directory where you want the repository to reside. Clone the repository with the following:

```         
git clone https://github.com/medwar747/611_Data_Science_Project.git
```

#### 2. Setting up the Environment

Open the project and note the Dockerfile. The Dockerfile is essential to building a neat and reproducible experience for the user, where needed preliminaries like library installations are executed.

Before invoking Docker, always make sure that: - the working directory is set to the directory in which the Dockerfile resides. If you just completed the step 1, you will need to execute `cd 611_Data_Science_Project`. - Docker Desktop is running in the background.

##### Building and Running the Docker Container.

Users can build and run the repository container with the script `start-env.sh`. With Unix/PowerShell this looks like:

```         
bash start-env.sh
```

#### 3. Accessing the Environment.

Visit <http://localhost:8789> to access the repository environment in RStudio. Both the username and password are "rstudio".

In the RStudio Terminal, execute `cd work`. From this terminal you can make any of the project outputs; to make the final report and all its dependencies, execute `make writeup.html`.

## Project Structure and Flow

Examine the Makefile to see how the Docker container applies the R scripts to the source data to generate reproducible derived datasets, figures, and models.

In summary, there are three stages of code that together generate a comprehensive report. First, the data is cleaned by standardizing capitalization and removing outliers. A data sample is also made available for use in contexts with limited memory (MS Excel, etc). Second, figures are generated that help understand the data beyond simple descriptive statistics of available variables--see the wordcloud below! Finally, a series of figures are generated to asses the feasibility of classifying insomnia status based on weather conditions.

## Key Outputs

The below two figures represent the essence of the project; weather may be the most precise and prevalent type of data in the dataset, but does it lead us to clinically and statistically meaningful insight?

![](./GitHub_static_figures/figure_wordcloud.png)

![](./GitHub_static_figures/figure_logistic.png)

Refer to the write up for a detailed explanation of how these figures answer our central question.

Michael V. Edwards, 10Dec2023
