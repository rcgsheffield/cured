library(data.table)
library(lubridate)

#' Format date to ISO8601
#'
#' @param in_date Input date
#' @param format_type Input format, should be one of "yyyy-mm-dd", "yyyymmdd" or
#' "dd/mm/yyyy"
#' @returns String vector of dates formatted as yyyy-mm-dd
#' @export
#' @examples
#' dates <- c("01/02/1999", "03/04/2001")
#' date_to_isodate(dates, "dd/mm/yyyy")
#' dates <- c("19990201", "20010403")
#' date_to_isodate(dates, "yyyymmdd")
#' dates <- c("1999-02-01 16:01", "2001-04-03 09:00")
#' date_to_isodate(dates, "yyyy-mm-dd etc")
date_to_isodate <- function(in_date, format_type) {
  # Converts to YYYY-MM-DD
  if (format_type == "dd/mm/yyyy") {
    out_date <- ifelse((is.na(in_date) | nchar(in_date) < 10),
      as.character(NA),
      paste(substr(in_date, 7, 10),
        substr(in_date, 4, 5),
        substr(in_date, 1, 2),
        sep = "-"
      )
    )
  } else if (format_type == "yyyymmdd") {
    out_date <- ifelse((is.na(in_date) | nchar(in_date) < 8),
      as.character(NA),
      paste(substr(in_date, 1, 4),
        substr(in_date, 5, 6),
        substr(in_date, 7, 8),
        sep = "-"
      )
    )
  } else if (format_type == "yyyy-mm-dd etc") {
    out_date <- ifelse((is.na(in_date) | nchar(in_date) < 10),
      as.character(NA),
      substr(in_date, 1, 10)
    )
  }
  return(out_date)
}
#' Convert times to standardised strings.
#'
#' @param x Vector of times to convert.
#' @param format_type Format times take
#' @returns Vector of standardised times as string formatted as HH:MM:SS
#' @export
time_to_isotime <- function(x, format_type) {
  # Converts to HH:MM:SS
  if (format_type == "HHMMSS") {
    out_times <- stringr::str_pad(x, 6, side = "left", pad = "0")
    out_times <- ifelse(is.na(out_times),
      as.character(NA),
      paste(substr(out_times, 1, 2),
        substr(out_times, 3, 4),
        substr(out_times, 5, 6),
        sep = ":"
      )
    )
  } else if (format_type == "yyyy-mm-dd HH:MM:SS") {
    out_times <- ifelse((is.na(x) | nchar(x) != 19),
      as.character(NA),
      substr(x, 12, 19)
    )
  }
  return(out_times)
}
#' Converts datetime to iso datetime.
#'
#' @param x String vector of date-times to be converted.
#' @param format_type Format of date-times.
#' @returns Vector of dates in ISO-8601 format.
#' @export
datetime_to_isodatetime <- function(x, format_type) {
  # Converts to YYYY-MM-DD HH:MM:SS
  if (format_type == "YYYY-MM-DD HH:MM:SS") {
    out_times <- ifelse(is.na(x) | nchar(x) != 19,
      as.character(NA),
      paste(
        paste(substr(x, 1, 4),
          substr(x, 5, 6),
          substr(x, 7, 8),
          sep = "-"
        ),
        substr(x, 10, 17),
        sep = " "
      )
    )
  } else if (format_type == "yyyy-mm-dd HH:MM:SS") {

  }
  return(out_times)
}

#' Convert times of arrival at A&E
#'
#' @param x String vector of date-time or time to be converted.
#' @param format_type Format of date-time/time.
#' @returns String vector of just times
#' @export
time_to_ae_time <- function(x, format_type) {
  # Converts to HHMM
  if (format_type == "HM") {
    out_times <- stringr::str_pad(x, 4, side = "left", pad = "0")
  } else if (format_type == "yyyy-mm-dd HH:MM:SS") {
    out_times <- ifelse((is.na(x) | nchar(x) != 19),
      as.character(NA),
      paste0(substr(x, 12, 13), substr(x, 15, 16))
    )
  } else if (format_type == "HH:MMetc") {
    out_times <- ifelse((is.na(x) | nchar(x) < 5),
      as.character(NA),
      paste0(substr(x, 1, 2), substr(x, 4, 5))
    )
  } else if (format_type == "HHMMetc") {
    out_times <- ifelse((is.na(x) | nchar(x) < 4),
      as.character(NA),
      substr(x, 1, 4)
    )
  }
  return(out_times)
}

#' Trim white-space from variable.
#'
#' @param x String vector to have white space trimmed.
#' @returns String vector with white spaces trimmed and blanks converted to NA
#' @export
remove_blanks <- function(x) {
  x <- trimws(x)
  return(replace(x, x == "", NA))
}

#' Removes some values
#'
#'
#' @param field Variable to be cleaned.
#' @param values_to_remove values to remove, can be a single value or a list of values.
#' @param case_sensitive Boolean whether to make search case-sensitive or not.
#' @returns Vector with values_to_remove converted to NA.
#' @export
remove_values <- function(field, values_to_remove, case_sensitive = FALSE) {
  stopifnot(length(values_to_remove) > 0)

  if (case_sensitive) {
    field <- replace(field, field %in% values_to_remove, NA)
  } else {
    field <- replace(field, toupper(field) %in% toupper(values_to_remove), NA)
  }
  return(field)
}

#' Split Forenames and Surnames
#'
#' Splits are made based on the last whitespace and so if there are middle names they are included in the Forename
#'
#' @param names String vector of names to be split.
#' @returns Data Table of forename and surname.
#' @export
split_forenames_surnames <- function(names) {
  max_name_len <- max(nchar(names), na.rm = TRUE)

  out_names <- data.table(names)
  out_names[, name_last_blank := regexpr("\\s[^\\s]+\\s*$", names, perl = TRUE)]
  out_names[name_last_blank == -1, name_last_blank := 1]
  out_names[, ":="(surname = trimws(substr(
    names,
    name_last_blank,
    max_name_len
  )),
  forenames = trimws(substr(names, 1, name_last_blank - 1)))]
  out_names[name_last_blank == 1, forenames := NA]

  out_names[, c("names", "name_last_blank") := NULL]

  return(out_names)
}

#' Tidies Names
#'
#' Replaces multiple white-spaces with single white space and converts characters to upper case.
#'
#' @param name String vector of names to be cleaned.
#' @returns String vector of names in upper case with white space trimmed.
#' @export
clean_names <- function(name) {
  text_temp <- trimws(gsub("\\s+", " ", gsub("[^A-Z\\s\\-\\']+", "", toupper(name), perl = TRUE), perl = TRUE))

  # Set blanks to NA
  return(replace(text_temp, text_temp == "" | text_temp == "UNKNOWN", as.character(NA)))
}

#' Tidies NHS Numbers
#'
#' @param nhs_number String vector of nhs numbers.
#' @returns String vector of ten digits. Values that do not conform are converted to NA.
#' @export
# TODO - See if we can use https://github.com/sellorm/nhsnumber it includes checksum functionality
validate_nhs_number <- function(nhs_number) {
  expand_nhsno <- data.table(nhsno = nhs_number)

  # remove non-numeric characters
  expand_nhsno[, nhsno := gsub("[^0-9]+", "", nhs_number)]

  # Set NHS number of invalid length or dummy value to NA
  expand_nhsno[nchar(nhsno) != 10L | nhsno == "2333455667", nhsno := NA]

  # Split NHS number into characters
  expand_nhsno[, paste0("dig", 1:10) := tstrsplit(nhsno, "", fixed = TRUE)]

  # convert digits to to integers
  col_names <- paste0("dig", 1:10)
  expand_nhsno[, (col_names) := lapply(.SD, as.integer), .SDcols = col_names]

  # calculate checksum
  expand_nhsno[, checksum := 11L - (10L * dig1 +
    9L * dig2 +
    8L * dig3 +
    7L * dig4 +
    6L * dig5 +
    5L * dig6 +
    4L * dig7 +
    3L * dig8 +
    2L * dig9) %% 11L]
  expand_nhsno[checksum == 11L, checksum := 0L]

  # compare checksum (this accounts for case when checksum 10 [as a single digit cannot be 10!])
  expand_nhsno[dig10 != checksum, nhsno := NA]

  # Check for other invalid formats: 1st and last equal all else 0 OR all equal
  expand_nhsno[(dig1 == dig10 &
    dig2 == 0 &
    dig3 == 0 &
    dig4 == 0 &
    dig5 == 0 &
    dig6 == 0 &
    dig7 == 0 &
    dig8 == 0 &
    dig9 == 0) |
    (dig1 == dig2 &
      dig1 == dig3 &
      dig1 == dig4 &
      dig1 == dig5 &
      dig1 == dig6 &
      dig1 == dig7 &
      dig1 == dig8 &
      dig1 == dig9 &
      dig1 == dig10), nhsno := NA]

  return(expand_nhsno[, nhsno])
}

#' Tidies Postcode
#'
#' Formats postcode correctly ensuring all characters are uppercase and incorrect values as NA
#'
#' @param postcode String vector of postcodes.
#' @returns String vector of tidied postcodes.
#' @export
validate_postcode <- function(postcode) {
  postcode_temp <- gsub("[^A-Z0-9]+", "", toupper(postcode))
  postcode_temp[!grepl("[A-Z][A-Z0-9]{1,3}[0-9][A-Z]{2}", postcode_temp)] <- NA
  postcode_tidy <- paste0(
    substring(postcode_temp, 1, nchar(postcode_temp) - 3),
    " ",
    substring(postcode_temp, nchar(postcode_temp) - 2)
  )

  postcode_tidy <- replace(postcode_tidy, is.na(postcode_temp), NA)
  postcode_tidy <- replace(postcode_tidy, is.na(postcode), NA)
  return(postcode_tidy)
}

#' Tidies Codes
#'
#' Replaces missing and codes that are not valid with the invalid code value.
#'
#' @param field_in Variable to be validated.
#' @param valid_codes List of valid codes.
#' @param invalid_code Invalid code to replace values not observed in valid_codes with.
#' @returns Vector of codes wher values not in valid_codes are replaced with invalid_code.
#' @export
validate_codes <- function(field_in, valid_codes, invalid_code) {
  return(replace(field_in, (!is.na(field_in) & !(field_in %in% valid_codes)), invalid_code))
}

#' Tidies dates
#'
#' Replaces "1900-01-01" with NA and anything < "188-01-01" or > "2017-03-31" as NA.
#'
#' @param field_in Date variable to tidy.
#' @param start_date The first date from which values are valid, anything before this is converted to NA.
#' @param finish_date The last date from which values are valid, anything after this is converted to NA.
#' @returns Vector of dates tidied.
#' @export
validate <- dates <- function(field_in, start_date, finish_date) {
  date_out <- replace(field_in, field_in %in% "1900-01-01", NA)
  date_converted <- lubridate::fast_strptime(date_out, format = "%Y-%m-%d", tz = "Europe/London", lt = FALSE)
  return(replace(date_out, !is.na(field_in) &
    (is.na(date_converted) |
      date_converted < as.POSIXct(start_date, tz = "Europe/London") |
      date_converted > as.POSIXct(finis_date, tz = "Europe/London")), NA))
}

#' Tidies Datetimes to POSIX values
#'
#' Converts date-times as strings to elapsed POSIX values. This is required so that elapsed periods can be calculated.
#'
#' @param x Vector of date-time as strings to convert.
#' @param start_date_time The first date from which values are valid, anything before this is converted to NA.
#' @param finish_date_time The last date from which values are valid, anything after this is converted to NA.
#' @param missing_date_time String representation of date/time that should be considered missing, such values are
#' converted to NA.
#' @param invalid_code Value to replace invalid codes with.
#' @returns Vector of dates converted to YYYY-MM-DD HH:MM:SS.
#' @export
validate_date_times <- function(x, invalid_code, start_date_time, finish_date_time, missing_date_time) {
  datetime_out <- replace(x, x %in% "1900-01-01 00:00:00", NA)
  datetime_converted <- lubridate::fast_strptime(datetime_out,
    format = "%Y-%m-%d %H:%M:%S",
    tz = "Europe/London", lt = FALSE
  )
  return(replace(
    datetime_out, !is.na(x) &
      (is.na(datetime_converted) |
        datetime_converted < as.POSIXct(start_date_time, tz = "Europe/London") |
        datetime_converted > as.POSIXct(finish_date_time, tz = "Europe/London")
      ),
    invalid_code
  ))
}

#' Tidies A&E Times
#'
#' Tidies A&E times, converting 2400 to 0000 and replacing invalid values with the specified code.
#'
#' @param x String vector of times.
#' @param invalid_code Code to use for invalid values.
#' @returns Vector of times correctly formatted.
#' @export
validate_ae_times <- function(x, invalid_code) {
  time_out <- replace(x, x == "2400", "0000")
  return(replace(
    time_out,
    (!is.na(time_out) & !grepl("^(?:[01][0-9]|2[0-3])(?:[0-5][0-9])$", time_out)),
    invalid_code
  ))
}

#' Tidies numerical values to be strings padded with 0
#'
#' Pads numerical values with zeros, values NOT in valid_codes are replaced with invalid_code.
#'
#' @param x Vector of numerical values.
#' @param len Integer indicating the width (number of digits) and number is meant to had any value with a shorter length
#' is left-padded with '0'.
#' @param valid_codes Vector of codes that are valid, observed values that do not match are replaced with invalid_code.
#' @param invalid_code Value to use for invalid codes.
#' @returns Vector of tidied numerical values as strings left-padded with zeros.
#' @export
validate_digits <- function(x, len, valid_codes, invalid_code) {
  x <- stringr::str_pad(x, width = len, side = "left", "0")
  return(replace(
    x,
    (!is.na(x) & !(x %in% valid_codes)),
    invalid_code
  ))
}

#' Validates numerical values
#'
#' @param x Vector of numerical values.
#' @param len Length entries are meant to be.
#' @returns String vector of numbers left-padded with zero. Missing values are '9' repeated the value of 'len'.
#' @export
validate_numeric <- function(x, len) {
  x <- stringr::str_pad(trimws(x), width = len, side = "left", "0")
  return(replace(
    x,
    (!is.na(x) & !grepl(paste0("^[$[0-9]{", len, "}$"), x)),
    paste0(rep(9, len), collapse = "")
  ))
}

#' Tidies Procodet
#'
#' @param procodet_in Prodocdet input
#' @param procodet_sender Value to replace missing observations or when the length of the code is neither 3 nor 5.
#' @returns Tidied prodocdet of length 3 characters with no missing values.
#' @export
validate_procodet <- function(procodet_in, procodet_sender) {
  stopifnot(length(unique(procodet_sender)) == 1)
  procodet_out <- toupper(procodet_in)
  procodet_out <- replace(
    procodet_out,
    is.na(procodet_out) | (nchar(procodet_out) != 3 & nchar(procodet_out) != 5),
    procodet_sender[1]
  )
  return(substr(procodet_out, 1, 3))
}
#' Tidies Site Treatment codes to upper-case
#'
#' Converts Site Treatment codes to upper case and replaces those that do not conform or are missing with an invalid
#' code.
#'
#' @param site_treatment_code Vector of site treatment codes.
#' @param procodet The procodet to check against.
#' @returns String vector of upper case Site Treatment codes. Missing values
#' @export
validate_sitetret <- function(site_treatment_code, procodet) {
  sitetret_out <- toupper(site_treatment_code)
  sitetret_out <- replace(
    sitetret_out,
    !is.na(sitetret_out) &
      (substr(sitetret_out, 1, 3) != procodet |
        (nchar(sitetret_out) != 3 & nchar(sitetret_out) != 5)),
    procodet[!is.na(sitetret_out) &
      (substr(sitetret_out, 1, 3) != procodet |
        (nchar(sitetret_out) != 3 &
          nchar(sitetret_out) != 5))]
  )
  return(replace(
    sitetret_out,
    !is.na(sitetret_out) & nchar(sitetret_out) == 3,
    paste0(sitetret_out[!is.na(sitetret_out) & nchar(sitetret_out) == 3], "00")
  ))
}
#' Tidies GP Practice code to upper-case.
#'
#' Converts GP Practice codes to upper case and replaces those that do not conform or are missing with an invalid code.
#'
#' @param x Vector of GP practice codes.
#' @param invalid_code String code to indicate invalid or NA value.
#' @returns Vector of GP practice codes converted to upper case, missing values are invalid_code.
#' @export
validate_gp_prac <- function(x, invalid_code) {
  field_out <- toupper(x)
  return(replace(
    field_out,
    (!is.na(x) & !grepl("^[A-HJ-NP-WY][0-9]{5}$", field_out)),
    invalid_code
  ))
}

#' Tidies Referrer organisation code to upper-case.
#'
#' Converts Referrer organisation codes to upper case and replaces those that do not conform or are missing with
#' an invalid code.
#'
#' @param x Vector of Referrer organisation codes.
#' @param invalid_code String code to indicate invalid or NA value.
#' @returns Vector of Referrer organisation as upper case strings, missing and invalid values replaced with
#' invalid_code.
#' @export
validate_refer_org <- function(x, invalid_code) {
  field_out <- toupper(x)
  return(replace(
    field_out,
    (!is.na(x) & !grepl("^[A-Z0-9]{2,6}$", field_out)),
    invalid_code
  ))
}

#' Tidies ICD10 codes
#'
#' @param diags_wide Vector of ICD10 codes, can contain multiple codes per cell, as these will be split.
#' @param apc_data APC data
#' @returns Data table of multiple ICD10 diagnoses.
#' @export
validate_icd10 <- function(diags_wide, apc_data = TRUE) {
  # TODO - Make reference data and variable arguments
  icd10_x_codes <- readRDS("data/reference/apc_reference_data.rds")[["diag_icd10_x"]][, code]

  # TODO - Make id/variable/value arguments
  diags <- melt(diags_wide,
    id.vars = "urid",
    variable.name = "ordinal",
    value.name = "val_diag",
    variable.factor = FALSE
  )

  diags[, ":="(ordinal = as.numeric(substr(ordinal, 6, 7)),
    val_diag = toupper(val_diag))]

  # Remove morphology data
  diags[grepl("^M?[0-9]{4}\\/[0-9]{0,1}$", val_diag), ":="(val_diag = NA,
    ordinal = NA)]

  ## Reorder
  setorder(diags, ordinal, na.last = TRUE)
  diags[, ordinal := seq_len(.N), by = urid]

  ## Strip dashes from codes
  diags[, val_diag := sub("-", " ", val_diag, fixed = TRUE)]

  ## General ICD10 form
  ##  (approximates HES ACv3 Rule0510)
  if (apc_data) {
    diags[!is.na(val_diag) &
      !grepl(
        "^[A-Z][0-9]{2}\\.?(?:[ X0-9][ A-Z0-9]{0,3})?$",
        val_diag
      ), val_diag := "R69X8"]
  } else {
    diags[!is.na(val_diag) &
      !grepl(
        "^[A-Z][0-9]{2}\\.?(?:[ X0-9][ A-Z0-9]{0,3})?$",
        val_diag
      ), val_diag := NA]
  }

  ## Strip dot from codes
  ##  (approximates HES ACv3 Rule0460)
  diags[, val_diag := sub(".", "", val_diag, fixed = TRUE)]

  ## Replace space (if present)- or if only 3 char diag right pad- with X for valid X codes
  ##   (HES ACv3 Rule0470)
  diags[
    (substr(val_diag, 4, 4) == " " | nchar(val_diag) == 3) & substr(val_diag, 1, 3) %in% icd10_x_codes,
    val_diag := paste0(substr(val_diag, 1, 3), "X", substring(val_diag, 5))
  ]

  ## Replace space (if present)- or if only 3 char diag right pad- with 9 for non X codes
  ##   (HES ACv3 Rule0470)
  diags[
    (substr(val_diag, 4, 4) == " " |
      nchar(val_diag) == 3) &
      !(substr(val_diag, 1, 3) %in% icd10_x_codes),
    val_diag := paste0(substr(val_diag, 1, 3), "9", substring(val_diag, 5))
  ]

  if (apc_data) {
    ## Null primary diagnosis
    ##   (HES ACv3 Rule0500a,b)
    diags[ordinal == 1 & is.na(val_diag), val_diag := "R69X6"]

    ## Cause codes
    ##   (HES ACv3 Rule0580 [Part 1])
    if (diags[grepl("^[VWXY][0-9]{2}", val_diag), .N] > 0) {
      cause_diags <- merge(diags[grepl("^[VWXY][0-9]{2}", val_diag), .(ordinal = min(ordinal)), by = urid],
        diags,
        by = c("urid", "ordinal")
      )


      diags <- rbind(diags, cause_diags[, .(urid, ordinal = 21, val_diag)])


      if (cause_diags[ordinal == 1, .N] > 0) {
        cause_primary_diags <- merge(cause_diags[ordinal == 1, .(urid, cause = val_diag)],
          diags[is.na(val_diag), .(ordinal = min(ordinal)), by = urid],
          by = "urid"
        )

        ## cause code in primary diag
        ##   (HES ACv3 Rule0530)
        diags[ordinal == 1 & grepl("^[VWXY][0-9]{2}", val_diag), val_diag := "R69X3"]

        diags <- merge(diags, cause_primary_diags, by = c("urid", "ordinal"), all.x = TRUE)
        diags[!is.na(cause), val_diag := cause]
        diags[, cause := NULL]
      }
    }
  }

  # Reshape wide
  diags[, ordinal := paste0("val_diag_", stringr::str_pad(ordinal, 2, side = "left", pad = "0"))]
  diags_wide <- dcast(diags, urid ~ ordinal, fill = NA, drop = FALSE, value.var = "val_diag")
  ##   (HES ACv3 Rule0580 [Part 2])
  if ("val_diag_21" %in% colnames(diags_wide)) {
    setnames(diags_wide, "val_diag_21", "cause")
  } else if (apc_data) {
    diags_wide[, cause := as.character(NA)]
  }

  # Return diagnoses
  return(diags_wide)
}
#' Tidies OPCSOps codes
#'
#' @param ops_wide OPCS Data in wide format.
#' @param invalid_date_code Code to use for invalid dates.
#' @returns Data table of tidied formats in upper case with missing dates replaced.
#' @export
validate_opcs_ops <- function(ops_wide, invalid_date_code) {
  ## reshape long
  ops_data <- melt(ops_wide,
    id.vars = "urid", measure = patterns("opertn_", "opdate_"),
    variable.name = "ordinal", value.name = c("val_opertn", "val_opdate"),
    variable.factor = FALSE
  )

  ops_data[, ":="(ordinal = as.numeric(ordinal),
    val_opertn = toupper(val_opertn))]

  ## General OPCS form
  ##   (approximates HES ACv3 Rule0550 [Part1] & Rule0560)
  ops_data[!is.na(val_opertn) & !grepl("^[A-HJ-Z][0-9]{2}\\.?[0-9\\-]?$", val_opertn), val_opertn := "&"]

  ## Strip dot from codes
  ops_data[, val_opertn := sub(".", "", val_opertn, fixed = TRUE)]

  ## Replace dash (if present)- or if only 3 char right pad- with 9
  ##   (approximates HES ACv3 Rule0450)
  ops_data[
    (substr(val_opertn, 4, 4) == "-" | nchar(val_opertn) == 3),
    val_opertn := paste0(substr(val_opertn, 1, 3), 9)
  ]

  ## Invalid primary operation
  ##   (approximates HES ACv3 Rule0550 [Part2])
  ops_data[
    ordinal == 1 &
      (substring(val_opertn, 1, 1) %in% c("Y", "Z") | substring(val_opertn, 1, 3) %in% c("O11", "O13", "O14")),
    val_opertn := "&"
  ]

  ## Invalid primary operation
  ##   (HES ACv3 Rule0540)
  ops_data[
    ordinal == 1 & substring(val_opertn, 1, 3) == "X99",
    val_opertn := NA
  ]

  ## Validate operation dates
  ##   (approximates HES ACv3 Rule0480 & Rule0485)
  ops_data[is.na(val_opertn) & !is.na(val_opdate), val_opdate := invalid_date_code]
  ops_data[, val_opdate := validate_dates(val_opdate, invalid_date_code)]
  ops_data[val_opdate < "1930-01-01", val_opdate := invalid_date_code]

  ## Reshape wide
  ops_data[, ordinal := stringr::str_pad(ordinal, 2, side = "left", pad = "0")]
  ops_wide <- dcast(ops_data,
    urid ~ ordinal,
    fill = NA, drop = FALSE, value.var = c("val_opertn", "val_opdate")
  )

  return(ops_wide)
}

#' Tidies A&E Diagnoses
#'
#' @param diags Vector of diagnoses.
#' @returns Vector of diagnoses with values converted to upper case, missing and invalud values as NA.
#' @export
validate_ae_diagnoses <- function(diags) {
  diags_out <- toupper(diags)
  return(replace(diags_out, !is.na(diags_out) & !grepl("^[0-9 ]{1,5}[ LRB8]$", diags_out), NA))
}

#' Tidies A&E Investigation codes
#'
#' Ensures A&E Investigation codes are strings of two characters left-padded with two leading zeros.
#' @param invests Vector of investigation codes.
#' @returns Vector of investigation codes padded with zeros and missing/invalid codes converted to NA.
#' @export
validate_ae_investigations <- function(invests) {
  invests_out <- stringr::str_pad(substr(invests, 1, 2), 2, side = "left", pad = "0")
  return(replace(invests_out, !is.na(invests_out) & !grepl("^[0-9]{2}$", invests_out), NA))
}

#' Validate A&E Treatments
#'
#' Tidies treatment codes to be strings, left padded with zeros, if not possible returns NA
#'
#' @param treats Treatment code to tidy and validate
#' @returns Vector of treatment codes padded with zeros and missing/invalid codes converted to NA.
#' @export
validate_ae_treatments <- function(treats) {
  treats_out <- stringr::str_pad(substr(treats, 1, 3), 2, side = "left", pad = "0")
  return(replace(treats_out, !is.na(treats_out) & !grepl("^[0-9]{2,3}$", treats_out), NA))
}

# QUESTION : Why is age returned as a padded string, its a natural numerical unit
#' Calculate age in years
#'
#' @param point_time Date on which age is to be calculated
#' @param ref_time Reference time point, typically date of birth
#' @returns String vector of ages, rounded down
#' @export
calc <- age <- function(point_time, ref_time) {
  age <- floor(lubridate::time_length(
    difftime(
      as.Date(point_time,
        format = "%Y-%m-%d"
      ),
      as.Date(ref_time, format = "%Y-%m-%d")
    ),
    "years"
  ))
  age <- replace(age, age > 120, 120)
  age <- replace(age, age < 0, NA)
  return(stringr::str_pad(as.character(age), width = 3, side = "left", pad = "0"))
}

#' Remove white spaces from strings
#'
#' @param x String vector to tidy
#' @returns String vector with carriage returns removed, white space trimmed and missing ("") values as NA.
#' @export
remove_whitespace <- function(x) {
  x <- gsub("\\n", " ", x, fixed = TRUE)
  x <- trimws(gsub("[\\s]{1,}", " ", x, perl = TRUE))
  x <- replace(x, x == "", NA)
  return(x)
}

#' Convert date from string to date
#'
#' @param date Vector of dates as strings to be converted.
#' @param dt_format Format of date strings.
#' @returns Vector of dates as elapsed dates.
#' @export
convert_str_to_date <- function(date, dt_format = "%Y-%m-%d") {
  date_out <- as.Date(lubridate::fast_strptime(paste(date, "12:00:00"),
    format = paste(dt_format, "%H:%M:%S"),
    tz = "Europe/London", lt = FALSE
  ))
  date_out <- replace(date_out, date_out %in% as.Date("1900-01-01"), NA)
  return(date_out)
}
