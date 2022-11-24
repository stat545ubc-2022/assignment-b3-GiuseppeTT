################################################################################
# Load packages for app
library(tidyverse)
library(gt)
library(broom)

library(targets)

library(shiny)
library(shinydashboard)

################################################################################
# Source R scripts in the `R/` folder with your custom functions
tar_source()

################################################################################
# Load data
tar_make()

cards <- tar_read(cards)
bean_names <- tar_read(bean_names)
results <- tar_read(results)

################################################################################
# Define UI
header <- dashboardHeader(
    title = "Bohnanza"
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Introduction", tabName = "introduction"),
        menuItem("Modelling summary", tabName = "modelling_summary"),
        menuItem("Bean analysis", tabName = "bean_analysis")
    )
)

introduction_tab <- tabItem(tabName = "introduction",
    tags$style("#shiny-tab-introduction {font-size: 24px;}"),
    markdown("
    **Introduction**

    TODO.

    **Value formula**

    In this dashboard you are going to see a lot of references to \"bean value\". The bean value of a card is essentially how much \"value\" it is going to add to your game if you get the card by chance, that is, by directly drawing it or obtaining it by trading with someone who is going to draw it.

    A good starting point for measuring the value of a card is to calculate how much closer you are going to be to obtain one more coin by planting the card. This is called \"bean efficiency\" in this dashboard. For instance, 10 Coffee Beans (24) awards you 3 coins, but 12 awards 4 coins. Thus, if you have 10 Coffe Beans (24), the value of one more (totalling 11) Coffe Bean (24) could be defined as 0.5 coin.

    In my opinion, an even better way to measure value is to factor in the probability of drawing a card so it balances rare cards that awards a lot of coins with common cards that awards few coins. In summary, the formula that I used to measure bean value of a card is

    \\<probability of drawing the card\\> * \\<bean efficiency of the card\\>

    A quick technical detail, when printing and plotting the bean values, I divide them by the maximum measured value so that comparisons are easier to make. Besides, the scale of the bean value is pratically meanless.

    **Conclusions**

    - In general, cards are well balanced.
    - Coccoa bean (4) is garbage. It gives too few coins for the probability of drawing. Besides, Garden Bean (6) dominates it.
    - Soy Bean (12) can be harvested at any time because its bean efficiency is essentially constant (and bean value is decadent).
    ")
)

modelling_summary_tab <- tabItem(tabName = "modelling_summary",
    fluidRow(
        column(width = 6,
            box(
                title = "First bean value plot",
                width = NULL,
                plotOutput("first_bean_value_plot", height = 350)
            )
        ),
        column(width = 6,
            box(
                title = "Mean of bean value plot",
                width = NULL,
                plotOutput("mean_bean_value_plot", height = 350)
            )
        )
    ),
    fluidRow(
        column(width = 6,
            box(
                title = "Bean value per harvest size plot",
                width = NULL,
                plotOutput("harvest_slope_bean_value_plot", height = 350)
            )
        ),
        column(width = 6,
            box(
                title = "Bean value per coin payout plot",
                width = NULL,
                plotOutput("coin_slope_bean_value_plot", height = 350)
            )
        )
    )
)

bean_analysis_tab <- tabItem(tabName = "bean_analysis",
    fluidRow(
        column(width = 6,
            box(
                title = "Coin payout plot",
                width = NULL,
                plotOutput("coin_payout_plot", height = 350)
            )
        ),
        column(width = 3,
            box(
                title = "Controls",
                width = NULL,
                height = 350 + 63,
                selectInput(
                    "bean_name",
                    "Bean card:",
                    bean_names
                ),
                selectInput(
                    "x_variable",
                    "X axis:",
                    c("Harvest size" = "harvest_size", "Coin payout" = "partial_coin_payout")
                )
            ),
        ),
        column(width = 3,
            box(
                title = "Statistics",
                width = NULL,
                height = 350 + 63,
                gt_output("statistics_table")
            )
        )
    ),
    fluidRow(
        column(width = 6,
            box(
                title = "Bean efficiency plot",
                width = NULL,
                plotOutput("bean_efficiency_plot", height = 350)
            )
        ),
        column(width = 6,
            box(
                title = "Bean value plot",
                width = NULL,
                plotOutput("bean_value_plot", height = 350)
            )
        )
    )
)

body <- dashboardBody(tabItems(
    introduction_tab,
    modelling_summary_tab,
    bean_analysis_tab
))

ui <- dashboardPage(header, sidebar, body)

################################################################################
# Define server
server <- function(
    input,
    output
) {
    # Introduction tab
    #

    # Modelling summary tab
    output$first_bean_value_plot <- renderPlot({
        plot_first_bean_value(results)
    })

    output$mean_bean_value_plot <- renderPlot({
        plot_mean_bean_value(results)
    })

    output$harvest_slope_bean_value_plot <- renderPlot({
        plot_harvest_slope_bean_value(results)
    })

    output$coin_slope_bean_value_plot <- renderPlot({
        plot_coin_slope_bean_value(results)
    })

    # Bean analysis tab
    output$coin_payout_plot <- renderPlot({
        plot_coin_payout(cards, input$bean_name, "harvest_size")
    })

    output$bean_efficiency_plot <- renderPlot({
        plot_bean_efficiency(cards, input$bean_name, input$x_variable)
    })

    output$bean_value_plot <- renderPlot({
        plot_bean_value(cards, input$bean_name, input$x_variable)
    })

    output$statistics_table <- render_gt({
        table_statistics(results, input$bean_name)
    })
}

################################################################################
# Create app
shinyApp(ui, server)
