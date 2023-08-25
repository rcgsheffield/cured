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
#' @param metadata List. Dictionary containing the column definitions.
csv_to_binary <- function(raw_data_dir, metadata) {
  csv_to_parquet(raw_data_dir, metadata)
}

csv_to_parquet <- function(raw_data_dir, output_data_dir, metadata) {
  
  # Define paths
  raw_data_glob <- file.path(raw_data_dir, "*.csv")
  output_path <- file.path(output_data_dir, "data.parquet")
  
  # Create an in-memory database connection
  con <- dbConnect(duckdb::duckdb(), dbdir = ":memory:")
  
  # Convert file format
  # Load the CSV file and save to Apache Parquet format.
  # DuckDB documentation "CSV Loading"
  # https://duckdb.org/docs/data/csv/overview.html
  # TODO interpret data types
  query <- stringr::str_interp("
    COPY (
      SELECT *
      FROM  read_csv_auto('{input_glob}',
              all_varchar=TRUE)
    ) TO '{output_path}' (FORMAT 'PARQUET', CODEC 'ZSTD', OVERWRITE_OR_IGNORE);",
      list(input_glob=raw_data_glob, output_path=output_path))
  
  cli::cli_alert_info(query)
  
  # Run the query
  affected_rows_count <- DBI::dbExecute(con, query)
  
  cli::cli_alert_info(sprintf("%s rows affected", affected_rows_count))

}
