
#' @importFrom utils download.file
NULL

#' @title download_ramlegacy
#' @description Download the RAM Legacy Stock Assesment Database as R Binary object. This database contains a compilation of stock assessment results for commercially exploited marine populations from around the world
#' The function will check for a existing version of the database and won't download the file if the same version is already present.
#' @param ram_path Local directory to the RAM Legacy database. The path is chosen by the \code{rappdirs} package and is OS specific and can be view by \code{ram_dir}.
#' This path is also supplied automatically to any function that uses the RAM Legacy database. A user specified path can be set though this is not the advised approach.
#' @param version Version Number of the database. So far available versions : (1.0, 2.0, 2.5, 3.0, 4.3). If version is not specified then it defaults to most recent version 4.3.
#' @param format A character string specifying the format of zipped database : excel or access. Defaults to excel version of the database. The format argument is
#' case sensitive.
#' @export
download_ramlegacy <- function(version = NULL, ram_path = NULL, format = NULL) {
  if (!is.null(version)) {
    check_version_arg(version)
  } else {
    det_vers()
  }

  if(is.null(format)) {
    format <- "excel"
  } else {
    check_format(format)
  }
  if (is.null(ram_path)) {
    ram_path <- ram_dir(vers = version)
  } else {
    check_download_path(ram_path)
  }

  ## Close all connections if function fails halfway through
  on.exit(closeAllConnections())
  ## If there is an existing ramlegacy version ask the user
 if (version == check_local()) {
    if (interactive()) {
      ans <- ask("Version ", sprintf("%.1f", version), " has already been downloaded. Overwrite?")
      if (!ans) return(cat("Not overwriting. Exiting the function."))
    } else {
      return(cat(paste("Version ", sprintf("%.1f", version),
                       " has already been downloaded. Exiting the function.")))
    }
  }

  # Check for existing file at user specified path
  if (interactive() && file.exists(ram_path)) {
    ans <- ask("A file already exists in this location. Overwrite?")
    if (!ans) return(cat("Not overwriting. Exiting the function."))
  }

  base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"

  # check internet connection
  net_check(base_url)

  if (version == 1.0) {
    if (format == "excel") {
      data_url <- "RLSADB_v1.0_excel.zip"
    } else {
      data_url <- "RLSADB_v1.0_access.zip"
    }
  } else if (version == 2.5){
    data_url <- paste0("RLSADB_v", as.character(version),
                       "_(assessment_data_only)_", format, ".zip")
  } else if (version == 4.3){
    data_url <- paste0("RLSADB_v", as.character(version),
                       "_(assessment_data_only)_", format, ".zip")
  } else {
    data_url <- paste0("RLSADB_v",
                       paste(as.character(version),  "0", sep = "."),
                       "_(assessment_data_only)_", format, ".zip")
  }
  ram_url <- paste(base_url, data_url, sep = "/")
  request <- httr::GET(ram_url)
  status <- httr::http_status(request)
  tmp <- tempfile("ramlegacy_")
  if (status$category != "Success") {
    if (interactive()) {
      ans <- ask("www.ramlegacy.org seems to be down right now. Download from backup location?")
      if (!ans) return(cat("Not downloading. Exiting the function."))
    }
  off_url <- paste0("https://github.com/kshtzgupta1/ramlegacy-assets/blob/master/RLSADB%20v",
                    sprintf("%.1f", version), "%20(assessment%20data%20only).xlsx")
  download.file(off_url, temp)
  } else {
    ## Download the zip file
    ## temporary path to save

    ## Download the zip file
    res <- httr::GET(ram_url, httr::write_disk(tmp), httr::progress("down"),
                     httr::user_agent("https://github.com/kshtzgupta1/ramlegacy"))
    on.exit(file.remove(tmp))
  }

    if(file.exists(tmp)) {
      notify("\nExtracting RAM Legacy Stock Assessment Database...")
      utils::unzip(tmp, exdir = ram_path, overwrite = TRUE)
      notify("\nSaving the Database as R Binary File...")
      excel_file <- grep("RLSADB.*", list.files(ram_path), value = T)
      readin_path <- file.path(ram_path, excel_file)
      read_ramlegacy(readin_path, version)
    }

  if (file.exists(ram_path)) {
    completed(paste("Version", sprintf("%.1f", version), "successfully downloaded."))
  } else {
    not_completed(paste("Failed to download Version", sprintf("%.1f", version), sep = " "))
  }
}

