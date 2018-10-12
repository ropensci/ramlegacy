
#' @importFrom utils download.file
NULL

#' @title download_ramlegacy
#' @description Download the RAM Legacy Stock Assesment Database. This database contains a compilation of stock assessment results for commercially exploited marine populations from around the world
#' The function will check for a existing sqlite file and won't download the file if the same version is already present.
#' @param ram_path Directory to the RAM Legacy database. The path is chosen by the \code{rappdirs} package and is OS specific and can be view by \code{ram_dir}.
#' This path is also supplied automatically to any function that uses the RAM Legacy database. A user specified path can be set though this is not the advised approach.
#' @param version Version Number of the database. So far available versions : (1.0, 2.0, 2.5, 3.0, 4.3). If version is not specified then it defaults to most recent version 4.3.
#' @param format A character string specifying the format of zipped database : excel or access. Defaults to excel version of the database. The format argument is
#' case sensitive.
#' @export
download_ramlegacy <- function(ram_path = NULL, version = NULL, format = NULL) {
  if(is.null(version)) {
    version = 4.3
  } else {
    check_version(version)
  }
  if (version < 4.3) {
    ans <- ask("Newest version (4.3) of the database is available. Would you like to download that instead?")
    if (ans) version = 4.3 else notify(paste0("Okay downloading version ", as.character(version)))
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

  ## If there is an existing ramlegacy database ask the user
  if (interactive() && file.exists(ram_path)) {
    ans <- ask("A version already exists in this location. Overwrite?")
    if (!ans) return(cat("Not overwriting and exiting the function."))
  }

  base_url<-"https://depts.washington.edu/ramlegac/wordpress/databaseVersions"

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
  status <- http_status(request)
  if (status$category != "Success") {
    if (interactive()) {
      ans <- ask("www.ramlegacy.org seems to be down right now. Download backup data?")
      if (!ans) return(cat("Not downloading backup data and exiting the function."))
    }
  off_url <- paste0("https://github.com/kshtzgupta1/ramlegacy-assets/blob/master/RLSADB%20v", version, "%20(assessment%20data%20only).xlsx")
  download.file(off_url, ram_path)
  } else {
    ## Download the zip file
    ## temporary path to save
    tmp <- tempfile("ramlegacy_")
    ## Create the directory if it doesn't exist already.
    #if(!dir.exists(dirname(tmp))) dir.create(dirname(tmp))

    ## Download the zip file
    res <- httr::GET(ram_url, httr::write_disk(tmp), httr::progress("down"),
                     httr::user_agent("https://github.com/kshtzgupta1/ramlegacy"))
    on.exit(file.remove(tmp))
    httr::stop_for_status(res)

    if(file.exists(tmp)) notify("\nExtracting RAM Legacy Stock Assessment Database...")

    utils::unzip(tmp, exdir = ram_path, overwrite = TRUE)
  }
  if (file.exists(ram_path)) {
    print(ram_path)
    completed(paste("Version", as.character(version), "successfully downloaded"))
  } else {
    not_completed(paste("Failed to download Version", as.character(version), sep = " "))
  }
}


