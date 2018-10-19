# private function to check version number
check_version_arg <- function(version) {
  if (!version %in% c(3, 3.0, 2.5, 2.0, 1.0, 4.3)) {
    stop("Invalid version number", call. = FALSE)
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
    stop("Invalid format. Format can only be 'excel' or 'access'.", call. = FALSE)
  }
  TRUE
}

# private function to check path is valid or not
check_download_path <- function(path) {
  if (!is_string(path)) {
    stop("`ram_path` must be a string", call. = FALSE)
  }
  TRUE
}

#' @title Output OS-independent path to the zipped ramlegacy database
#'
#' @description Provides the download location for \link{download_ramlegacy} in an OS independent manner.
#'
#' @param ... arguments potentially passed to \code{rappdirs::user_data_dir}
#'
#' @examples \dontrun{
#' ram_dir()
#' }
#'
#' @export
#'
#'
ram_dir <- function(vers = NULL){
  rappdirs::user_data_dir("ramlegacy", version = vers)
}

## Ask for something
#' @noRd
ask <- function(...) {
  choices <- c("Yes", "No")
  cat(crayon::green(paste0(...,"\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::menu(choices) == which(choices == "Yes")
}


# Catch network timeout error or not resolve host error generated
# when dealing with proxy-related connection
# issues and fail with an informative error
# message
#' @noRd
net_check <- function(url){
  tryCatch(httr::GET(url),
           error = function(e) {
             if(grepl("Timeout was reached:", e$message) | grepl("Could not resolve host:", e$message)) {
               stop("Could not connect to the internet. Please check your connection settings and try again.", call. = FALSE)
             }
           }
  )}

# regex function to extract the latest version
#' @noRd
extract_vers <- function(request) {
  # Get the content
  contnt <- httr::content(request, "text")
  # Get all the a hrefs
  ahrefs <- unlist(stringr::str_extract_all(contnt, "<a href.*"))
  # Get the latest href
  latest_href <- tail(ahrefs, 1)
  ## Get newest version from latest_href
  version <- stringr::str_extract(latest_href, "\\d\\.\\d{1,}")
  return(version)
}


# determine latest version from the web
det_version <- function() {
  base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  tryCatch(req <- httr::GET(base_url),
           error = function(e) {
             if(grepl("Timeout was reached:", e$message) | grepl("Could not resolve host:", e$message)) {
               version <- 4.3
             }
           }
  )
  if (httr::http_status(req)$category == "Success") {
          version <- extract_vers(req)
             } else {
               version <- 4.3
             }

  # write latest version as metadata to rappdirs directory

  version <- as.numeric(version)
  writePath <- file.path(ram_dir(), "VERSION.txt")
  message <- sprintf("%.1f", version)
  writeLines(message, writePath)
}

# Returns the version to load
check_local <- function() {
  # read in latest version number
    message <- readLines(file.path(ram_dir(), "VERSION.txt"))
    lat_vers_no <- stringr::str_extract(message, "\\d\\.\\d{1,}")
    latest_vers <- sprintf("%.1f", as.numeric(lat_vers_no))

    # Get the number of versions in rappdirs
    num_vers <- length(list.dirs(ram_dir(), recursive = FALSE))

    if (num_vers > 1) {
        warning("Multiple versions found. Loading the latest version.")
      return(latest_vers)
    }

      if(num_vers == 0) {
        return(NULL)
      }
  # get the local version number
  local_vers <- as.numeric(dir(ram_dir(), pattern = "\\d[.0-9]{,3}"))
  local_vers <- sprintf("%.1f", local_vers)
  if (local_vers < latest_vers) {
    notify(paste0("Be informed that a newer version v",
                  latest_vers,
                  " of the database is available."))
    }
    return(local_vers)
}



