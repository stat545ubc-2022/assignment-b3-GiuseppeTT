# Bohnanza dashboard

## Description

TODO.

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
