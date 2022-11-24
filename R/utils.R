get_breaks <- function(
    variable
) {
    if (variable == "harvest_size") {
        breaks <- seq(0, 12, 3)
    } else if (variable %in% c("coin_payout", "partial_coin_payout")) {
        breaks <- seq(0, 4, 1)
    } else if (variable %in% c("differential_coin_payout", "differential_partial_coin_payout")) {
        breaks <- seq(0, 2, 0.5)
    } else if (variable %in% c("bean_value", "partial_bean_value")) {
        breaks <- seq(0, 1, 0.25)
    } else {
        stop("Invalid `variable`")
    }

    return(breaks)
}

get_limits <- function(
    variable
) {
    breaks <- get_breaks(variable)
    limits <- range(breaks)

    return(limits)
}

get_labs <- function(
    variable
) {
    if (variable == "harvest_size") {
        labs <- "Harvest size"
    } else if (variable %in% c("coin_payout", "partial_coin_payout")) {
        labs <- "Coin payout"
    } else if (variable %in% c("differential_coin_payout", "differential_partial_coin_payout")) {
        labs <- "Bean efficiency"
    } else if (variable %in% c("bean_value", "partial_bean_value")) {
        labs <- "Bean value"
    } else {
        stop("Invalid `variable`")
    }

    return(labs)
}
