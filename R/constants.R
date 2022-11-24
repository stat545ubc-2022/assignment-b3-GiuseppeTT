################################################################################
# Define constants
## Specific
TOTAL_CARD_COUNT <- 154  # Total number of cards in the game

## Data
RAW_DATA_PATH <- here::here("data/cards.csv")  # Path to the raw data
RAW_COLUMN_TYPES <- readr::cols(               # Column types of the raw data
    name = readr::col_character(),
    count = readr::col_double(),
    `1` = readr::col_double(),
    `2` = readr::col_double(),
    `3` = readr::col_double(),
    `4` = readr::col_double()
)

## Plotting
LINE_WIDTH <- 3          # Line width for plotting
FONT_SIZE <- 22          # Font size for plotting
ALL_CARDS_ALPHA <- 0.05  # Color alpha when plotting all cards on the background
