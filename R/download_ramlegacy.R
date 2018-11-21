
#' @name download_ramlegacy
#' @title Download RAM Legacy Excel Database
#' @description Downloads a specified version of RAM Legacy Stock Assessment
#'  Excel Database as an RDS object to a local directory specified by \code{\link{ram_dir}}.
#'  The function will check if the version requested already exists
#'  and if it is then it's up to the user to download it again. The function also
#'  supports downloading all the versions from [backup location](www.github.com/kshtzgupta1/ramlegacy-assets)
#'  in case the database [website](www.ramlegacy.org) is down.
#' @param version A character vector of length 1 specifying the version number
#'  of the database that should be downloaded. As of November 2018 the available versions are "1.0",
#'  "2.0", "2.5", "3.0" and "4.3". If the version argument is not specified then it defaults
#'  to latest version (currently latest version is "4.3"). Note that this function
#'  does not support vectorization so please \strong{don't pass in a vector of
#'  version numbers}
#' @param ram_path A string specifying the path of the local directory where
#'  database will be downloaded.
#'  This path is OS specific and is set to the location provided by \pkg{rappdirs}
#'  package. It can be viewed
#'  by calling \code{\link{ram_dir}}. This function \strong{does not} support
#'  setting a user-specified path so \strong{please
#'  do not pass} in a path to \code{ram_path}.
#' @param ram_url A string. By default it is set to the url of the ramlegacy
#' wordpress database website. Please \strong{do not pass} in any other url to
#'  \code{ram_url}.
#' @export
#' @examples
#' \dontrun{
#'
#' # If version is not specified then current latest version (4.3)
#' # will be downloaded
#' download_ramlegacy()
#'
#' # download version 1.0
#' download_ramlegacy(version = "1.0")
#'
#' # download version 4.3
#' download_ramlegacy(version = "4.3")
#' }
download_ramlegacy <- function(version = NULL, ram_path = NULL,
ram_url = "https://depts.washington.edu/ramlegac/wordpress/databaseVersions") {

  # Get the latest version from web
  latest_vers <- find_latest(ram_url)

  # version argument
  if (!is.null(version)) {

    # make sure the version argument is formatted correctly
    version <- sprintf("%.1f", as.numeric(version))
    check_version_arg(version)
  } else {
    version <- latest_vers
  }

  # ram_path argument
  if (is.null(ram_path)) {
    vers_path <- ram_dir(vers = version)
    ram_path <- ram_dir()
  } else {
    check_path(ram_path)
    vers_path <- file.path(ram_path, version)
  }

  ## If there is an existing ramlegacy version
  # ask the user what to do in interactive mode otherwise exit
  if (version %in% find_local(ram_path, latest_vers)) {
    if (interactive()) {
      ans <- ask_yn("Version ", version, " has already been downloaded.",
                    "Overwrite?")
      if (!ans) return("Not overwriting. Exiting the function.")
    } else {
      return(paste(paste("Version", version, "has already been downloaded."),
                   "Exiting the function."))
    }
  }

  # create vers_path if it doesn't exist
  if (!dir.exists(vers_path)) {
    dir.create(vers_path, recursive = TRUE)
  }

  # check internet connection and throw error if there is a connection issue
  net_check(ram_url, show_error = TRUE)

  # construct url to download from

  # version 1.0 has a diff url from the rest
  if (version == "1.0") {
    data_url <- "RLSADB_v1.0_excel.zip"
  } else {
    data_url <- paste0("RLSADB_v", version,
                       "_(assessment_data_only)_excel.zip")
  }
  ram_url <- paste(ram_url, data_url, sep = "/")

  # if database website is down then download from backup location
  req <- httr::GET(ram_url)
  if (req$status_code != 200) {
    if (interactive()) {
     ans <- ask_yn(paste("www.ramlegacy.org seems to be down right now.",
                      "Download from backup location?"))
     if (!ans) return("Not downloading. Exiting the function.")
    }
    message("Downloading from backup location...")
    bckup_url <- "https://github.com/kshtzgupta1/ramlegacy-assets/raw/master/RLSADB%20v"
    ram_url <- paste0(bckup_url, version, "%20(assessment%20data%20only).xlsx")
    # create path for excel file
    excel_path <- file.path(vers_path,
                  paste("RLSADB v", version, " (assessment data only).xlsx"))
    # download
    httr::GET(ram_url, httr::write_disk(excel_path))

    # read in the sheets using read_ramlegacy
    if (file.exists(excel_path)) {
      suppressWarnings(read_ramlegacy(vers_path, version))
    }

  } else {
    ## Download the zip file from database website to temp
    tmp <- tempfile("ramlegacy_")
    notify("Downloading...")
    httr::GET(ram_url, httr::write_disk(tmp))

    #unzip it and read it in
    if (file.exists(tmp)) {
      notify(paste("Downloaded the RAM Legacy Stock Assessment Database.",
                   "Now unzipping it..."))
      utils::unzip(tmp, exdir = vers_path, overwrite = TRUE)
      notify("Saving the unzipped database as R Binary object...")
      suppressWarnings(read_ramlegacy(vers_path, version))
    }

  }

  # check if file downloaded or not
  rds_path <- file.path(vers_path, paste0("v", version, ".rds"))
  if (file.exists(rds_path)) {
    completed(paste("Version", version, "successfully downloaded."))
  } else {
    not_completed(paste("Failed to download Version", version))
  }

  invisible(TRUE)

}
