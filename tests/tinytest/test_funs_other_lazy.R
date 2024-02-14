### [GENERATED AUTOMATICALLY] Update test_funs_other.R instead.

Sys.setenv('TIDYPOLARS_TEST' = TRUE)

source("helpers.R")
using("tidypolars")

test_df <- data.frame(
  x = c(1:4, 0:5, 11, 10),
  x_na = c(1:4, NA, 1:5, 11, 10),
  x_inf = c(1, Inf, 3:4, -Inf, 1:5, 11, 10)
)
test <- polars::pl$LazyFrame(test_df)

# which.min and which.max

expect_equal_lazy(
  test |>
    mutate(
      argmin = which.min(x),
      argmax = which.max(x),

      argmin_na = which.min(x_na),
      argmax_na = which.max(x_na),

      argmin_inf = which.min(x_inf),
      argmax_inf = which.max(x_inf)
    ),
  test_df |>
    mutate(
      argmin = which.min(x),
      argmax = which.max(x),

      argmin_na = which.min(x_na),
      argmax_na = which.max(x_na),

      argmin_inf = which.min(x_inf),
      argmax_inf = which.max(x_inf)
    )
)


Sys.setenv('TIDYPOLARS_TEST' = FALSE)