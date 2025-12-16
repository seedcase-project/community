# pak::pak("rostools/samwise", ask = FALSE)

library(tidyverse)
library(samwise)

overview <- read_surveys("gh_intro", "overview")
feedback <- read_surveys("gh_intro", "feedback-quantitative")

plot_overview_community <- function(data) {
  data |>
    plot_overview() +
    scale_fill_manual(values = rep("#196440", 14)) +
    facet_grid(
      cols = vars(date),
      rows = vars(question),
      scales = "free",
      space = "free_y",
      axes = "all_y",
      labeller = ggplot2::label_wrap_gen(width = 10)
    ) +
    theme(
      panel.border = element_rect(color = "grey85")
    )
}

save_plot_feedback <- function(data) {
  ggsave(
    filename = glue::glue("feedback-{unique(data$date)}.svg"),
    plot = plot_feedback(data) +
      scale_x_continuous(breaks = seq(0, 12, by = 2))
  )
}

# Get numbers for workshop
overview |>
  summarise(n = sum(count), .by = c(date, question)) |>
  distinct(date, n)

feedback |>
  summarise(n = sum(n), .by = c(date, statement)) |>
  distinct(date, n)

ggsave(
  filename = "overview.svg",
  plot = plot_overview_community(overview)
)

feedback |>
  group_split(date) |>
  walk(save_plot_feedback)
