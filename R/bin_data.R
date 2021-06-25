
#' Bin data.
#'
#' @param data The dataframe to bin.
#' @param id_cols The grouping columns.
#' @param axes The columns to bin.
#' @param binsize The binsize.
#'
#' @return A dataframe with the axes binned and counted.
#' @export
#'
bin_data <- function(data,
                     id_cols = "id",
                     axes = c("x", "y"),
                     binsize = 100) {
  # set data.table
  data.table::setDT(data)
  # round data
  data <- data[, lapply(.SD, plyr::round_any,
    accuracy = binsize, f = floor
  ),
  .SDcols = axes, by = id_cols
  ]
  # count data per id and axis
  data_summary <- data[, list(.N), by = c(id_cols, axes)]

  # return data
  data_summary
}
