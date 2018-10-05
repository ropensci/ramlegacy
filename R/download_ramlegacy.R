# private function to check version number
check_version <- function(version) {
  if (!version %in% c(3, 3.0, 2.5, 2.0, 1.0)) {
    stop("Invalid version number")
  }
  TRUE
}

# private function to check string
is_string <- function(x) {
  length(x) == 1 && is.character(x)
}

# private function to check format
check_format <- function(format) {
  if (!format %in% c("excel", "access")) {
    stop("Invalid format. Format can only be 'excel' or 'access'.")
  }
  TRUE
}

# private function to check path is valid or not
check_path <- function(path) {
    if (!is_string(path)) {
      stop("`path` must be a string", call. = FALSE)
    }
    TRUE
}

#' @importFrom utils download.file
#' @title download_ramlegacy
#' @description Downloads the zipped RAM Legacy Stock Assessment Data Base to a specified location
#' @param path A character string specifying path of the location where the downloaded database should be saved
#' @param version Version Number of the database. So far available versions : (1.0, 2.0, 2.5, 3.0). If version is not specified then it defaults to most recent version 3.0.
#' @param format A character string specifying the format of zipped database : excel or access. Defaults to excel version of the database. The format argument is
#' Case Sensitive.
#' @param quiet If TRUE, suppress status messages (if any), and the progress bar. Defaults to FALSE
#' @param offline If website is offline then downloads the database from github
#' @return None
#' @examples
#' download_ramlegacy(path = tempdir(), version = 2.5, format = 'excel')
#'
#' download_ramlegacy(path = tempdir(), version = 3.0)
#'
#' # if version is not provided then it defaults to most recent (3.0) version
#' download_ramlegacy(path = tempdir())

#' @export
download_ramlegacy <- function(path, version = 3.0, format = "excel", quiet = FALSE, offline = FALSE) {
    check_path(path)
    if (!is.null(version) & !is.null(format)) {
      check_version(version)
      check_format(format)
    }
    if (offline) {
      url <- "https://github.com/kshtzgupta1/ramlegacy/blob/master/assets/RLSADB%20v%.1f%20(assessment%20data%20only).xlsx"
      url <- sprintf(url, version)
      download.file(url, path, quiet = quiet)
    } else {
      ram_url<-"https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
      if (interactive() && file.exists(path)) {
          ans <- readline("A version already exists in this location. Overwrite? Y/N: ")
          if (ans %in% c("N", "n", "NO", "no", "No")) {
              stop("Not Overwriting.")
          }
      }
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
                             paste(as.character(version),  "0", sep = "."),
                                  "_(assessment_data_only)_", format, ".zip")
      }
      url <- paste(ram_url, data_url, sep = "/")
      download.file(url, path, quiet = quiet)
    }
}

