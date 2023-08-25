#' Run a data processing workflow for a single data set.
#'
#' @description
#' `run_workflow` executes the data pipeline for a single data set.
#'
#' @details
#' TODO
#'
#' @param data_set_id String. Data set identifier e.g. "apc" or "op"
#' @param root_directry String. The root directory that contains all the data.
#' @examples
#' run_workflow("ae", "/mnt/data/cured")
run_workflow <- function(data_set_id, root_directry) {
  # TODO
  # Parse the TOS
  tos_path = "/path/to/TOS.xlsx"
  # Get data types for each column
  metadata <- parse_tos(tos_path)

  # Define raw data directory
  raw_data_dir = cat(root_directory, "/", data_set_id, "01-raw")

  # Convert to binary format
  staging_dir <- csv_to_binary_format(raw_data_dir, metadata)

  # Validate
  validate(staging_dir, metadata)

  # Generate summary report
  summarise(staging_dir, metadata)
  
  # Data linkage

  # Cleaning

  # Generate metadata (column names, data types, descriptions)

  # Data quality rules (Flag "bad" records)

  # Generate data quality report

  # Generate FHIR data model
  
}
