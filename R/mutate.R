#' Mutate
#'
#' @description
#' Add new columns or modify existing ones
#'
#' @param .df A data.frame or data.table
#' @param ... Columns to add/modify
#' @param by Columns to group by
#'
#' @md
#' @export
#'
#' @examples
#' test_df <- data.table(
#'   a = c(1,2,3),
#'   b = c(4,5,6),
#'   c = c("a","a","b"))
#'
#' test_df %>%
#'   mutate.(double_a = a * 2,
#'           a_plus_b = a + b)
#'
#' test_df %>%
#'   mutate.(double_a = a * 2,
#'           avg_a = mean(a),
#'           by = c)
mutate. <- function(.df, ..., by = NULL) {
  UseMethod("mutate.")
}

#' @export
mutate..data.frame <- function(.df, ..., by = NULL) {

  .df <- as_tidytable(.df)
  .df <- shallow(.df)

  dots <- enquos(...)
  by <- enquo(by)

  if (quo_is_null(by)) {
    # Faster version if there is no "by" provided
    all_names <- names(dots)
    data_size <- nrow(.df)

    for (i in seq_along(dots)) {

      .col_name <- all_names[[i]]
      val <- dots[i][[1]]

      # Prevent modify-by-reference if the column already exists in the data.table
      # Fixes cases when user supplies a single value ex. 1, -1, "a"
      # !is.null(val) allows for columns to be deleted using mutate.(.df, col = NULL)
      if (.col_name %in% names(.df) && !quo_is_null(val)) {

        eval_quo(
          .df[, !!.col_name := eval_quo(
            {.N = .env$.N; .SD = .env$.SD; .I = .env$.I; .GRP = .env$.GRP;
            vec_recycle(!!val, data_size)}, .SD)]
        )

      } else {

        eval_quo(
          .df[, !!.col_name := eval_quo(
            {.SD = .env$.SD; .N = .env$.N; .I = .env$.I; .GRP = .env$.GRP; !!val},
            .SD)]
        , .df)
      }
    }
  } else {
    # Faster with "by", since the "by" call isn't looped multiple times for each column added
    by <- select_vec_by(.df, !!by)

    dot_names <- names(dots)
    dots <- unname(dots)

    eval_quo(
      .df[ , !!dot_names := eval_quo(
        {.N = .env$.N; .SD = .env$.SD; .I = .env$.I; .GRP = .env$.GRP; list(!!!dots)},
        .SD),
        by = !!by],
      .df)

  }
  .df[]
}

#' @export
#' @rdname mutate.
dt_mutate <- mutate.
