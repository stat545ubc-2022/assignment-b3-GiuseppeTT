################################################################################
# Load packages required to define the pipeline
library(targets)
library(tarchetypes)

################################################################################
# Set options
## Set targets (pipeline) options
tar_option_set(
    ## List packages that your targets need to run
    packages = c(
        "tidyverse",
        "gt",
        "broom"
    )
)

## Set `targets::tar_make_clustermq()` configuration (okay to leave alone)
options(clustermq.scheduler = "multicore")

## Set `targets::tar_make_future()` configuration (okay to leave alone)
future::plan(future.callr::callr)

################################################################################
# Source R scripts in the `R/` folder with your custom functions
tar_source()

################################################################################
# Define targets (pipeline)

## Targets to read, clean and augment data
data_targets <- list(
    tar_file(
        cards_path,
        RAW_DATA_PATH
    ),
    tar_target(
        cards_column_types,
        RAW_COLUMN_TYPES
    ),
    tar_target(
        raw_cards,
        read_cards(cards_path, cards_column_types)
    ),
    tar_target(
        cards,
        process_cards(raw_cards)
    ),
    tar_target(
        bean_names,
        extract_bean_names(cards)
    )
)

## Targets for modelling (calculating a lot of useful statistics based on linear regression)
modelling_targets <- list(
    tar_target(
        results,
        model_cards(cards)
    )
)

## Join all targets
all_targets <- list(
    data_targets,
    modelling_targets
)
