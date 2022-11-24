################################################################################
# Define functions
## Read raw data
read_cards <- function(
    cards_path,
    column_types
) {
    cards <-
        cards_path |>
        read_csv(col_types = column_types)

    return(cards)
}

## Auxiliary function for generating harvest sizes in `augment_card` function
sequence_harvest_sizes <- function(
    bean_prices
) {
    max_bean_price <- max(bean_prices, na.rm = TRUE)

    harvest_sizes <- seq(from = 0, to = max_bean_price)

    return(harvest_sizes)
}

## Calculate probability of drawing the card
calculate_last_drawing_probability <- function(
    harvest_sizes,
    count
) {
    harvest_sizes <- harvest_sizes - 1  # Exclude last card
    drawing_probabilities <- (count - harvest_sizes) / (TOTAL_CARD_COUNT - harvest_sizes)

    return(drawing_probabilities)
}

## Auxiliary function for removing NAs in a vector
remove_missing <- function(
    x
) {
    x <- x[!is.na(x)]

    return(x)
}

## Auxiliary function for calculating coin payout of a card given the harverst size
coin_payout_calculator <- function(
    bean_prices
) {
    coin_payouts <- which(!is.na(bean_prices))
    bean_prices <- remove_missing(bean_prices)

    calculate_coin_payout <- approxfun(
        x = c(0, bean_prices),
        y = c(0, coin_payouts),
        method = "constant",
        rule = 2
    )

    return(calculate_coin_payout)
}

## Auxiliary function for calculating partial coin payout of a card given the harverst size
partial_coin_payout_calculator <- function(
    bean_prices
) {
    coin_payouts <- which(!is.na(bean_prices))
    bean_prices <- remove_missing(bean_prices)

    calculate_partial_coin_payout <- approxfun(
        x = c(0, bean_prices),
        y = c(0, coin_payouts),
        method = "linear",
        rule = 2
    )

    return(calculate_partial_coin_payout)
}

## Calculate coint payout of a card
calculate_coin_payout <- function(
    harvest_sizes,
    bean_prices
) {
    calculate_coin_payout <- coin_payout_calculator(bean_prices)
    coin_payouts <- calculate_coin_payout(harvest_sizes)

    return(coin_payouts)
}

## Calculate partial coint payout of a card
calculate_partial_coin_payout <- function(
    harvest_sizes,
    bean_prices
) {
    calculate_partial_coin_payout <- partial_coin_payout_calculator(bean_prices)
    partial_coin_payouts <- calculate_partial_coin_payout(harvest_sizes)

    return(partial_coin_payouts)
}

## Calculate differential coint payout of a card
calculate_differential_coin_payout <- function(
    coin_payouts
) {
    differential_coin_payouts <- c(0, diff(coin_payouts))

    return(differential_coin_payouts)
}

## Calculate differential partial coint payout of a card
calculate_differential_partial_coin_payout <- function(
    partial_coin_payouts
) {
    differential_partial_coin_payouts <- c(0, diff(partial_coin_payouts))

    return(differential_partial_coin_payouts)
}

## One of the main functions
## Calculate bean value of a card
calculate_bean_value <- function(
    drawing_probabilities,
    differential_coin_payouts
) {
    bean_values <- drawing_probabilities * differential_coin_payouts

    return(bean_values)
}

## One of the main functions
## Calculate partial bean value of a card
calculate_patial_bean_value <- function(
    drawing_probabilities,
    differential_partial_coin_payouts
) {
    partial_bean_values <- drawing_probabilities * differential_partial_coin_payouts

    return(partial_bean_values)
}

## One of the main functions
## It takes the data of a card (row of cards dataset) and augments it to include
## useful statistics such as coin payout per harverst size
augment_card <- function(
    card
) {
    bean_prices <- c(card$`1`, card$`2`, card$`3`, card$`4`)

    harvest_sizes <- sequence_harvest_sizes(bean_prices)

    drawing_probabilities <- calculate_last_drawing_probability(harvest_sizes, card$count)

    coin_payouts <- calculate_coin_payout(harvest_sizes, bean_prices)
    partial_coin_payouts <- calculate_partial_coin_payout(harvest_sizes, bean_prices)

    differential_coin_payouts <- calculate_differential_coin_payout(coin_payouts)
    differential_partial_coin_payouts <- calculate_differential_partial_coin_payout(partial_coin_payouts)

    bean_values <- calculate_bean_value(drawing_probabilities, differential_coin_payouts)
    partial_bean_values <- calculate_patial_bean_value(drawing_probabilities, differential_partial_coin_payouts)

    data <- tibble(
        name = card$name,
        count = card$count,
        harvest_size = harvest_sizes,
        last_drawing_probability = drawing_probabilities,
        coin_payout = coin_payouts,
        partial_coin_payout = partial_coin_payouts,
        differential_coin_payout = differential_coin_payouts,
        differential_partial_coin_payout = differential_partial_coin_payouts,
        bean_value = bean_values,
        partial_bean_value = partial_bean_values
    )

    return(data)
}

## One of the main functions
## It applies `augment_card` to the whole dataset `cards` (original data
## obtained from Bohnanza's wikipedia article)
process_cards <- function(
    raw_cards
) {
    cards <- raw_cards

    cards <-
        cards |>
        transpose() |>
        map(augment_card) |>
        bind_rows()

    cards <-
        cards |>
        mutate(name = str_glue("{name} ({count})")) |>
        mutate(name = factor(name)) |>
        mutate(name = fct_reorder(name, count, .desc = TRUE))

    cards <-
        cards |>
        mutate(bean_value = bean_value / max(bean_value)) |>
        mutate(partial_bean_value = partial_bean_value / max(partial_bean_value))

    cards <-
        cards |>
        arrange(name, harvest_size)

    return(cards)
}

## Auxliary function of getting the bean names of the cards dataset
extract_bean_names <- function(
    cards
) {
    bean_names <-
        cards |>
        pull(name) |>
        levels()

    return(bean_names)
}
