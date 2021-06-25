
#' Read CSVs of a certain species and treatment.
#'
#' @param path The path to the data.
#' @param sp_name The species name to search by.
#' @param treatment The treatment name.
#' @param index The replicate (id or file) to read.
#'
#' @return A dataframe with one individual and species.
#' @export
#'
#' @examples
read_tracking_data <- function(path = "data/processed/data_id/",
                               sp_name, treatment, index) {
  files <- list.files(path, full.names = TRUE)
  file <- stringi::stri_subset_regex(files, pattern = sp_name)
  file <- stringi::stri_subset_regex(file, pattern = treatment)[index]
  df <- data.table::fread(file)

  # check there is only one individual
  assertthat::assert_that(
    length(unique(df$TAG_ID)) == 1L,
    msg = "read_species: more than one individual in file"
  )

  # check the correct species is in
  assertthat::assert_that(
    unique(df$sp) == sp_name,
    msg = "read_species: more than one individual in file"
  )

  # check the correct treatment
  # check the correct species is in
  assertthat::assert_that(
    unique(df$treat) == treatment,
    msg = "read_species: more than one individual in file"
  )

  df
}
