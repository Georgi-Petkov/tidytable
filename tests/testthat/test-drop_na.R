test_that("dt_drop_na() works with no dots", {
  test_df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))
  drop_df <- test_df %>%
    dt_drop_na()

  expect_named(drop_df, c("x", "y"))
  expect_equal(drop_df$x, 1)
  expect_equal(drop_df$y, "a")
})

test_that("dt_drop_na() works with one dot", {
  test_df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))
  drop_df <- test_df %>%
    dt_drop_na(x)

  expect_named(drop_df, c("x", "y"))
  expect_equal(drop_df$x, c(1, 2))
  expect_equal(drop_df$y, c("a", NA))
})

test_that("dt_drop_na() works with multiple dots", {
  test_df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))
  drop_df <- test_df %>%
    dt_drop_na(x, y)

  expect_named(drop_df, c("x", "y"))
  expect_equal(drop_df$x, 1)
  expect_equal(drop_df$y, "a")
})

test_that("dt_drop_na() works with select helpers", {
  test_df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))
  drop_df <- test_df %>%
    dt_drop_na(dt_starts_with("x"))

  expect_named(drop_df, c("x", "y"))
  expect_equal(drop_df$x, c(1, 2))
  expect_equal(drop_df$y, c("a", NA))
})

test_that("dt_drop_na() works with enhanced selection", {
  test_df <- data.table(x = c(1, 2, NA), y = c("a", NA, "b"))
  drop_df <- test_df %>%
    dt_drop_na(is.numeric)

  expect_named(drop_df, c("x", "y"))
  expect_equal(drop_df$x, c(1, 2))
  expect_equal(drop_df$y, c("a", NA))
})