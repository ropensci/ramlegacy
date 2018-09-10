# private function to check version number
check_version <- function(version) {
  if (!version %in% c(3, 3.0, 2.5, 2.0, 1.0)) {
    stop("Invalid version number")
  }
  TRUE
}

# private function to check format
check_format <- function(format) {
  if (!format %in% c("excel", "access")) {
    stop("Invalid format. Format can only be excel or access.")
  }
  TRUE
}

# private function to check location
check_location <- function(format) {
  if (typeof(getwd()) != "character") {
    stop("Invalid location argument. Location has to be of type character.")
  }
  TRUE
}

#' @title download
#' @description Downloads the zipped RAM Legacy Stock Assessment Data Base to a specified location
#' @param location A character string specifying path of the location where the downloaded database should be saved
#' @param version Version Number of the database. Defaults to most recent version 3.0
#' @param format A character string specifying the format of zipped database : excel or access. Defaults to excel version of the database. The format argument is
#' Case Sensitive.
#' @param quiet If TRUE, suppress status messages (if any), and the progress bar. Defaults to FALSE
#' @return None
#' @examples
#' download(location = '../data/version2.5', version = 2.5)
#'
#' download(location = '../data/version3.0', version = 3.0)
#'
#' # if version is not provided then it defaults to most recen(3.0) version
#' download(location = '../data/version3.0')

#' @export
download <- function(location, version = 3.0, format = "excel", quiet = FALSE) {
    check_location(location)
    check_version(version)
    check_format(format)
    ram_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
    if (version == 1.0) {
        if (format == "excel") {
          data_url <- "RLSADB_v1.0_excel.zip"
        } else {
          data_url <- "RLSADB_v1.0_access.zip"
        }
    } else if (version == 2.5){
        data_url <- paste0("RLSADB_v", as.character(version),
                          "_(assessment_data_only)_", format, ".zip")
    } else {
        data_url <- paste0("RLSADB_v",
                           paste(as.character(version),'0', sep = '.'),
                                "_(assessment_data_only)_", format, ".zip")
    }
    url <- paste(ram_url, data_url, sep = "/")
    download.file(url, location, quiet = quiet)
}

