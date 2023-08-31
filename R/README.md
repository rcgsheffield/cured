# Code structure

The entry-point to the workflow is the `main()` function in [main.R](./main.R). This iterates over the data sets, running `run_workflow()` for each one.

```mermaid
flowchart TD
  main["main.R::main()"] -->|"data_set_id"| run_workflow("run_workflow.R::run_workflow(data_set_id)")
  run_workflow --> parse_tos("metadata.R::parse_tos()")
  parse_tos --> csv_to_binary_format("csv_to_binary.R::csv_to_binary_format()")
  csv_to_binary_format --> validate("validate.R::validate()")
  validate --> etc["Etc."]
```
