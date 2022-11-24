# Bohnanza dashboard

## Choice of assignment and features

I choose **Option B** "Create your own shiny app with three features, and deploy it" for my assignment.

For the three demanded features, I chose:

- **Feature 1:** Developed the dashboard using the `{shinydashboard}` R package, which adds extra features to Shiny in order to be able to easily create a dashboard
- **Feature 2:** Allow the user to change the plots and tables by changing the x axis variable and the card being analyzed. You can check that on "Bean analysis" tab (third tab) on the dashboard.
- **Feature 3:** Allow the user to easily download the data used in the analysis. You can check that on the "Data" tab (fourth tab) on the dashboard.

## Description

Hi and welcome to my STAT 545 Assignment B-3 project, in which I develop a shiny dashboard. Here, I present a full analysis of the board game Bohnanza. More specifically, I analyze the value of each bean (card type).

If you are not familiar with Bohnanza, I recommend you read [its wikipedia article](https://en.wikipedia.org/wiki/Bohnanza). The main thing you need to know is that there are many different beans (card types) you must plant (play) to earn coins. Moreover, the rarity and payout changes between beans. Thus, it is interesting to know the value of each bean.

You can check the dashboard online on shinyapps.io by clicking on the following link: https://giuseppett.shinyapps.io/assignment-b3-giuseppett/

## Acknowledgement

The original data used to create this dashboard was obtained from the [Bohnanza's wikipedia article](https://en.wikipedia.org/wiki/Bohnanza).

## How to run (locally)

Assuming you have all dependencies installed, simply run the script `run.R`. You can do that on your terminal with

```bash
Rscript run.R
```

## How to deploy

Assuming you have all dependencies installed and {rsconnect} configured, simply run the script `deploy.R`. You can do that on your terminal with

```bash
Rscript deploy.R
```

> **Note:** For more instructions, follow the [rsconnect tutorial](https://shiny.rstudio.com/articles/shinyapps.html)

## Project structure

```
├── .git/                               # [Git ignored] [Auto generated] Git files
├── _targets/                           # [Git ignored] [Auto generated] Pipeline data
├── R/                                  # Holds R files with the constants and functions necessary to run the pipeline and dashboard
├── data/                               # Holds the data
├── rsconnect/shinyapps.io/giuseppett/  # [Auto generated] rsconnect files for deployment to shinyapps.io
├── .gitignore                          # List of files ignored by git
├── _debug.R                            # [Git ignored] An auxiliary script for debugging, like a whiteboard
├── _targets.R                          # Define pipeline for {targets} in order to read data, clean, augment and model it
├── README.md                           # This very file you are reading
├── app.R                               # Define dashboard
├── app.R                               # Auxiliary R script to deploy the app to shinyapps.io
└── run.R                               # Auxiliary R script to serve the app locally
```
