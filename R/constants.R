################################################################################
# Define constants
## Specific
TOTAL_CARD_COUNT <- 154

## Data
RAW_DATA_PATH <- here::here("data/cards.csv")
RAW_COLUMN_TYPES <- readr::cols(
    name = readr::col_character(),
    count = readr::col_double(),
    `1` = readr::col_double(),
    `2` = readr::col_double(),
    `3` = readr::col_double(),
    `4` = readr::col_double()
)

## Plotting
LINE_WIDTH <- 3
FONT_SIZE <- 22
ALL_CARDS_ALPHA <- 0.05
