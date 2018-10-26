
#' @importFrom utils download.file
NULL

#' @title download_ramlegacy
#' @description Downloads the excel version of RAM Legacy Stock Assesment Database as R Binary object to a local directory whose path
#' is OS specific and chosen by \code{rappdirs} package. This path can be viewed by calling the function \code{ram_dir}.
#' @param version Version Number of the database. If version argument is not specified then it defaults to latest version.
#' @export
download_ramlegacy <- function(version = NULL) {
  if (!is.null(version)) {
    version <- sprintf("%.1f", as.numeric(version))
    check_version_arg(version)
  } else {
    version <- find_version()
  }
  ram_path <- ram_dir(vers = version)

  ## If there is an existing ramlegacy version ask the user
  if (version %in% find_local()) {
    if (interactive()) {
      ans <- ask_yn("Version ", version, " has already been downloaded. Overwrite?")
      if (!ans) return(cat("Not overwriting. Exiting the function."))
    } else {
      return(cat(paste("Version ", version,
                       " has already been downloaded. Exiting the function.")))
    }
  }

 base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  # check internet connection
  net_check(base_url, TRUE)

  if (version == '1.0') {
      data_url <- "RLSADB_v1.0_excel.zip"
  } else {
    data_url <- paste0("RLSADB_v",version,
                       "_(assessment_data_only)_excel.zip")
  }
  ram_url <- paste(base_url, data_url, sep = "/")
  request <- httr::GET(ram_url)
  status <- httr::http_status(request)
  tmp <- tempfile("ramlegacy_")
  if (status$category != "Success") {
    if (interactive()) {
      ans <- ask_yn("www.ramlegacy.org seems to be down right now. Download from backup location?")
      if (!ans) return(cat("Not downloading. Exiting the function."))
    }
    ram_url <- paste0("https://github.com/kshtzgupta1/ramlegacy-assets/raw/master/RLSADB%20v3.0%20(assessment%20data%20only).xlsx",
                    version, "%20(assessment%20data%20only).xlsx")
  }
    ## Download the zip file
    res <- httr::GET(ram_url, httr::write_disk(tmp), httr::progress("down"),
                     httr::user_agent("https://github.com/kshtzgupta1/ramlegacy"))
    on.exit(file.remove(tmp), add = TRUE)

  if(file.exists(tmp)) {
    notify("Downloaded the RAM Legacy Stock Assessment Database database. Now unzipping it...")
    utils::unzip(tmp, exdir = ram_path, overwrite = TRUE)
    notify("Saving the unzipped database as R Binary File...")
    excel_file_name <- grep("RLSADB.*", list.files(ram_path), value = T)
    readin_path <- file.path(ram_path, excel_file_name)
    suppressWarnings(read_ramlegacy(readin_path, version))
    on.exit(file.remove(readin_path), add = T)
  }

  # check if file downloaded or not
  rds_path <- file.path(ram_path, paste0("v", version, ".RDS"))
  if (file.exists(rds_path)) {
    completed(paste("Version", version, "successfully downloaded."))
  } else {
    not_completed(paste("Failed to download Version", version, sep = " "))
  }
  invisible(TRUE)
}

