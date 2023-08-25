#' Run workflow
#'
#' @description
#' `main` executes the entire data pipeline for all data sets.
#'
#' @details
#' TODO
#'
#' @param root_directory String. Path. The directory that contains all the working directories.
#' 
#' @examples
#' run_workflow("ae", "/mnt/data/cured")
#' 
main <- function(root_directory) {

  # A list of the unique identifier of each of the data sets to work with.
  data_set_ids <- c("apc", "ae", "op")

  # Iterate over data sets
  for (data_set_id in data_set_ids) {
    # Run each workflow
    run_workflow(
      data_set_id=data_set_id,
      root_directory=root_directory
    )
  }

}
