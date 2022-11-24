################################################################################
# Define functions
model_cards <- function(
    cards
) {
    results <-
        cards |>
        filter(partial_coin_payout > 0) |>
        nest_by(name)

    results <-
        results |>
        mutate(count = data |> pull(count) |> first())

    results <-
        results |>
        mutate(first_bean_value = data |> pull(partial_bean_value) |> first())

    results <-
        results |>
        mutate(mean_bean_value = data |> pull(partial_bean_value) |> mean())

    results <-
        results |>
        mutate(harvest_model = list(lm(partial_bean_value ~ harvest_size, data = data))) |>
        mutate(harvest_model_summary = list(tidy(harvest_model))) |>
        mutate(harvest_slope_bean_value = harvest_model_summary |> filter(term == "harvest_size") |> pull(estimate))

    results <-
        results |>
        mutate(coin_model = list(lm(partial_bean_value ~ partial_coin_payout, data = data))) |>
        mutate(coin_model_summary = list(tidy(coin_model))) |>
        mutate(coin_slope_bean_value = coin_model_summary |> filter(term == "partial_coin_payout") |> pull(estimate))

    results <-
        results |>
        select(
            name,
            count,
            first_bean_value,
            mean_bean_value,
            harvest_slope_bean_value,
            coin_slope_bean_value
        ) |>
        ungroup() |>
        arrange(name)

    return(results)
}

plot_first_bean_value <- function(
    results
) {
    plot <-
        results |>
        ggplot(aes(x = fct_rev(name), y = first_bean_value)) +
        geom_col() +
        scale_y_continuous(
            labels = scales::label_percent(suffix = "V"),
            expand = expansion(mult = c(0, 0.05))
        ) +
        coord_flip() +
        theme_bw(FONT_SIZE) +
        labs(
            x = NULL,
            y = "First bean value"
        )

    return(plot)
}

plot_mean_bean_value <- function(
    results
) {
    plot <-
        results |>
        ggplot(aes(x = fct_rev(name), y = mean_bean_value)) +
        geom_col() +
        scale_y_continuous(
            labels = scales::label_percent(suffix = "V"),
            expand = expansion(mult = c(0, 0.05))
        ) +
        coord_flip() +
        theme_bw(FONT_SIZE) +
        labs(
            x = NULL,
            y = "Mean of bean value"
        )

    return(plot)
}

plot_harvest_slope_bean_value <- function(
    results
) {
    plot <-
        results |>
        ggplot(aes(x = fct_rev(name), y = harvest_slope_bean_value)) +
        geom_col() +
        geom_hline(yintercept = 0, linewidth = LINE_WIDTH) +
        scale_y_continuous(
            labels = scales::label_percent(suffix = "V")
        ) +
        coord_flip() +
        theme_bw(FONT_SIZE) +
        labs(
            x = NULL,
            y = "Bean value per harvest size"
        )

    return(plot)
}

plot_coin_slope_bean_value <- function(
    results
) {
    plot <-
        results |>
        ggplot(aes(x = fct_rev(name), y = coin_slope_bean_value)) +
        geom_col() +
        geom_hline(yintercept = 0, linewidth = LINE_WIDTH) +
        scale_y_continuous(
            labels = scales::label_percent(suffix = "V")
        ) +
        coord_flip() +
        theme_bw(FONT_SIZE) +
        labs(
            x = NULL,
            y = "Bean value per coin payout"
        )

    return(plot)
}
