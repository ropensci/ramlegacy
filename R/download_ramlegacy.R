
#' @importFrom utils download.file
NULL

#' @title download_ramlegacy
#' @description Downloads the excel version of RAM Legacy Stock Assesment Database as R Binary object to a local directory whose path
#' is OS specific and chosen by \code{rappdirs} package. This path can be viewed by calling the function \code{ram_dir}.
#' @param version Version Number of the database. So far available versions are 1.0, 2.0, 2.5, 3.0 and 4.3. If version argument is not specified then it defaults to latest version.
#' @export
download_ramlegacy <- function(version = NULL, ram_path = NULL, ram_url = "https://depts.washington.edu/ramlegac/wordpress/databaseVersions") {
  latest_vers <- find_latest(ram_url)
  if (!is.null(version)) {
    version <- sprintf("%.1f", as.numeric(version))
    check_version_arg(version)
  } else {
    version <- latest_vers
  }
  if (is.null(ram_path)) {
    vers_path <- ram_dir(vers = version)
    ram_path <- ram_dir()
  } else {
    check_download_path(ram_path)
    vers_path <- ram_path
  }

  notify("Please wait. This may take a while..")

  ## If there is an existing ramlegacy version ask the user
  if (version %in% find_local(ram_path, latest_vers)) {
    if (interactive()) {
      ans <- ask_yn("Version ", version, " has already been downloaded. Overwrite?")
      if (!ans) return(cat("Not overwriting. Exiting the function."))
    } else {
      return(cat(paste(paste("Version", version,
                       "has already been downloaded."), "Exiting the function.", sep = "\n")))
    }
  }

  if(!dir.exists(vers_path)) {
    dir.create(vers_path, recursive = T)
  }


  # check internet connection
  net_check(ram_url, show_error = TRUE)
  if (version == '1.0') {
    data_url <- "RLSADB_v1.0_excel.zip"
  } else {
    data_url <- paste0("RLSADB_v",version,
                       "_(assessment_data_only)_excel.zip")
  }
  ram_url <- paste(ram_url, data_url, sep = "/")
  # check if website is down
  req <- httr::GET(ram_url)
  if (req$status_code != 200) {
    if (interactive()) {
      ans <- ask_yn(paste("www.ramlegacy.org seems to be down right now.", "Download from backup location?",
                          sep = "\n"))
      if (!ans) return(cat("Not downloading. Exiting the function."))
    }
    message("Downloading from backup location...")
    ram_url <- paste0("https://github.com/kshtzgupta1/ramlegacy-assets/raw/master/RLSADB%20v",
                    version, "%20(assessment%20data%20only).xlsx")
    ## create path for excel file
    excel_path <- file.path(vers_path, paste("RLSADB v", version, " (assessment data only).xlsx"))
    download.file(ram_url, excel_path, quiet = TRUE)
    if(file.exists(excel_path)) {
      suppressWarnings(read_ramlegacy(vers_path = vers_path, version = version))
    }
  } else {
    ## Download the zip file to temp
    tmp <- tempfile("ramlegacy_")
    notify("Downloading...")
    download.file(ram_url, tmp, quiet = TRUE)
    if(file.exists(tmp)) {
      notify("Downloaded the RAM Legacy Stock Assessment Database database. Now unzipping it...")
      utils::unzip(tmp, exdir = vers_path, overwrite = TRUE)
      notify("Saving the unzipped database as R Binary object...")
      suppressWarnings(read_ramlegacy(vers_path = vers_path, version = version))
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

