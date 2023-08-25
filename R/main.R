main <- function() {

  # TODO
  # Define working directory
  root_directory <- "/mnt/data/cured/"
  
  # Iterate over data sets
  data_set_ids <- c("apc", "ae", "op")

  # Run each workflow
  for (data_set_id in data_set_ids) {
    run_workflow(
      data_set_id=data_set_id,
      root_directory=root_directory
    )
  }
  

  
}
