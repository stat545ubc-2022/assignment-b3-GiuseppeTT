################################################################################
# Define functions
## Plot coin payout for one bean
plot_coin_payout <- function(
    cards,
    bean_name,
    x_variable
) {
    y_variable <- "coin_payout"

    plot <-
        cards |>
        filter(name == bean_name) |>
        ggplot(aes(x = .data[[x_variable]], y = .data[[y_variable]])) +
        geom_step(
            aes(x = .data[[x_variable]], y = .data[[y_variable]], group = name),
            data = cards,
            linewidth = LINE_WIDTH / 2,
            alpha = ALL_CARDS_ALPHA
        ) +
        geom_step(linewidth = LINE_WIDTH) +
        scale_x_continuous(
            breaks = get_breaks(x_variable),
            limits = get_limits(x_variable)
        ) +
        scale_y_continuous(
            breaks = get_breaks(y_variable),
            limits = get_limits(y_variable)
        ) +
        theme_bw(FONT_SIZE) +
        labs(
            x = get_labs(x_variable),
            y = get_labs(y_variable)
        )

    return(plot)
}

## Plot bean efficiency for one bean
plot_bean_efficiency <- function(
    cards,
    bean_name,
    x_variable
) {
    y_variable <- "differential_partial_coin_payout"

    plot <-
        cards |>
        filter(name == bean_name) |>
        ggplot(aes(x = .data[[x_variable]], y = .data[[y_variable]])) +
        geom_step(
            aes(x = .data[[x_variable]], y = .data[[y_variable]], group = name),
            data = cards,
            linewidth = LINE_WIDTH / 2,
            alpha = ALL_CARDS_ALPHA
        ) +
        geom_step(linewidth = LINE_WIDTH) +
        scale_x_continuous(
            breaks = get_breaks(x_variable),
            limits = get_limits(x_variable)
        ) +
        scale_y_continuous(
            breaks = get_breaks(y_variable),
            limits = get_limits(y_variable)
        ) +
        theme_bw(FONT_SIZE) +
        labs(
            x = get_labs(x_variable),
            y = get_labs(y_variable)
        )

    return(plot)
}

## Plot bean value for one bean
plot_bean_value <- function(
    cards,
    bean_name,
    x_variable
) {
    y_variable <- "partial_bean_value"

    cards <-
        cards |>
        filter(.data[[x_variable]] > 0)

    plot <-
        cards |>
        filter(name == bean_name) |>
        ggplot(aes(x = .data[[x_variable]], y = .data[[y_variable]])) +
        geom_step(
            aes(x = .data[[x_variable]], y = .data[[y_variable]], group = name),
            data = cards,
            linewidth = LINE_WIDTH / 2,
            alpha = ALL_CARDS_ALPHA
        ) +
        geom_step(linewidth = LINE_WIDTH) +
        scale_x_continuous(
            breaks = get_breaks(x_variable),
            limits = get_limits(x_variable)
        ) +
        scale_y_continuous(
            breaks = get_breaks(y_variable),
            labels = scales::label_percent(suffix = "V"),
            limits = get_limits(y_variable)
        ) +
        theme_bw(FONT_SIZE) +
        labs(
            x = get_labs(x_variable),
            y = get_labs(y_variable)
        )

    return(plot)
}

## Generate table with summary statistics for one bean
table_statistics <- function(
    results,
    bean_name
) {
    table <-
        results |>
        filter(name == bean_name) |>
        select(
            `First bean value` = first_bean_value,
            `Mean of bean value` = mean_bean_value,
            `Bean value per harvest size` = harvest_slope_bean_value,
            `Bean value per coin payout` = coin_slope_bean_value
        ) |>
        pivot_longer(everything(), names_to = "Statistic", values_to = "Value") |>
        gt() |>
        fmt(where(is.numeric), fns = scales::label_percent(suffix = "V")) |>
        tab_options(table.width = "100%")

    return(table)
}
