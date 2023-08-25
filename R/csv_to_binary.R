library(DBI)
library(duckdb)
library(cli)

#' Use Duck DB to perform file format conversion.
#'
#' DuckDB R API
#' https://duckdb.org/docs/archive/0.8.1/api/r
#'
#' DBI documentation
#' https://dbi.r-dbi.org/
#'
#' Example: "Quickly Convert CSV to Parquet with DuckDB"
#' https://rmoff.net/2023/03/14/quickly-convert-csv-to-parquet-with-duckdb
#'
#' @param raw_data_dir String. Path. The directory that contains the raw data files.
#' @param output_data_dir String. Path. The directory the output data file(s) should be written to.
#' @param metadata List. Dictionary containing the column definitions.
#' 
#' @returns String. Path. The path of the output data file.
csv_to_binary <- function(...) {
  csv_to_parquet(...)
}

csv_to_parquet <- function(raw_data_dir, output_data_dir, metadata) {
  
  cli::cli_alert_info("Converting from CSV to parquet")
  cli::cli_alert_info("Reading path {raw_data_dir}")
  
  # Define paths
  input_glob <- file.path(raw_data_dir, "*.csv")
  output_path <- file.path(output_data_dir, "data.parquet")
  
  # Create an in-memory database connection
  con <- dbConnect(duckdb::duckdb(), dbdir = ":memory:")
  
  # Ensure output directory exists
  dir.create(output_data_dir, recursive = TRUE)
  
  # Convert file format
  # Load the CSV file and save to Apache Parquet format.
  # DuckDB documentation "CSV Loading":
  # https://duckdb.org/docs/data/csv/overview.html
  # TODO interpret data types
  # DuckDB COPY statement documentation:
  # https://duckdb.org/docs/sql/statements/copy
  query <- stringr::str_glue("
    COPY (
      SELECT *
      FROM  read_csv_auto('{input_glob}', all_varchar=TRUE)
    ) TO '{output_path}'
      WITH (FORMAT 'PARQUET');")
  cli::cli_alert_info(query)
  
  # Run the query
  affected_rows_count <- DBI::dbExecute(con, query)
  cli::cli_alert_info("{affected_rows_count} rows affected")
  
  return(output_path)
}
