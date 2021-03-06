test_that("dt_ can do group aggregation with by", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  tidytable_df <- df %>%
    dt_summarize(avg_x = mean(x), by = y)

  datatable_df <- df[, list(avg_x = mean(x)), by = y]

  expect_equal(tidytable_df, datatable_df)
})

test_that("can do group aggregation with by", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  tidytable_df <- df %>%
    summarize.(avg_x = mean(x), by = y)

  datatable_df <- df[, list(avg_x = mean(x)), by = y]

  expect_equal(tidytable_df, datatable_df)
})

test_that("n.() works", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  tidytable_df <- df %>%
    summarize.(count = n.(), by = y)

  datatable_df <- df[, list(count = .N), by = y]

  expect_equal(tidytable_df, datatable_df)
})

test_that(".GRP works", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  tidytable_df <- df %>%
    summarize.(count = .GRP, by = y)

  datatable_df <- df[, list(count = .GRP), by = y]

  expect_equal(tidytable_df, datatable_df)
})

test_that("can do group aggregation with no by", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  tidytable_df <- df %>%
    summarize.(avg_x = mean(x))

  datatable_df <- df[, list(avg_x = mean(x))]

  expect_equal(tidytable_df, datatable_df)
})

# test_that("can do group aggregation with by list()", {
#   df <- tidytable(x = 1:4, y = c("a","a","a","b"))
#
#   tidytable_df <- df %>%
#     summarize.(avg_x = mean(x), by = list(y))
#
#   datatable_df <- df[, list(avg_x = mean(x)), by = y]
#
#   expect_equal(tidytable_df, datatable_df)
# })

test_that("by = list() causes an error", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  expect_error(summarize.(df, avg_x = mean(x), by = list(y)))
})

test_that("by = list works for column named list", {
  df <- tidytable(x = 1:4, list = c("a","a","a","b"))

  tidytable_df <- df %>%
    summarize.(avg_x = mean(x), by = list)

  datatable_df <- df[, list(avg_x = mean(x)), by = list]

  expect_equal(tidytable_df, datatable_df)
})

test_that("can do group aggregation with by c()", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  tidytable_df <- df %>%
    summarize.(avg_x = mean(x), by = c(y))

  datatable_df <- df[, list(avg_x = mean(x)), by = y]

  expect_equal(tidytable_df, datatable_df)
})

test_that("can do group aggregation with by enhanced selection", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  tidytable_df <- df %>%
    summarize.(avg_x = mean(x), by = where(is.character))

  datatable_df <- df[, list(avg_x = mean(x)), by = y]

  expect_equal(tidytable_df, datatable_df)
})

test_that("can do group aggregation with by w/ data.frame", {
  df <- data.frame(x = 1:4, y = c("a","a","a","b"),
                   stringsAsFactors = FALSE)

  tidytable_df <- df %>%
    summarize.(avg_x = mean(x), by = y)

  datatable_df <- as_tidytable(df)[, list(avg_x = mean(x)), by = y]

  expect_equal(tidytable_df, datatable_df)
})

test_that("can do group aggregation without by with data.frame", {
  df <- data.frame(x = 1:4, y = c("a","a","a","b"),
                   stringsAsFactors = FALSE)

  tidytable_df <- df %>%
    summarize.(avg_x = mean(x))

  datatable_df <- as_tidytable(df)[, list(avg_x = mean(x))]

  expect_equal(tidytable_df, datatable_df)
})

test_that("can make a function with quosures", {
  df <- tidytable(x = 1:4, y = c("a","a","a","b"))

  summarize_fn <- function(.df, col) {
    .df %>%
      summarize.(avg_x = mean({{col}}), by = y)
  }

  tidytable_df <- df %>%
    summarize_fn(x)

  datatable_df <- df[, list(avg_x = mean(x)), by = y]

  expect_equal(tidytable_df, datatable_df)
})
