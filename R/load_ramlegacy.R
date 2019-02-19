
#' @name load_ramlegacy
#' @title Read-in downloaded RAM Legacy Database
#' @description Returns a specific dataframe or a list of all the dataframes present in the specified
#'  version of the database.
#' @param version A character vector of length 1 specifying the version number of the
#'  database. As of February 2019, the available versions are "1.0", "2.0", "2.5", "3.0", "4.3",
#'  "4.40", "4.41" and "4.44". If version argument is not specified then it defaults to latest version
#'  (currently "4.44"). If you want to load multiple versions please
#'  load them one at a time as passing them all at once will throw an error.
#' @param dfs A character vector specifying the names of the dataframes to load from a certain version
#' @param ram_path path to the local directory where the specified version of
#' the RAM Legacy Stock Excel Assessment Database was downloaded.
#' By default this path is set to within the rapddirs directory and can be viewed using calling the function
#' \code{\link{ram_dir}} and specifying the version number inside.
#' Although this is not the \strong{recommended} approach \code{load_ramlegacy} supports reading in the
#'  database's dataframes from a user-specified path provided that the database is present
#'  at the specified path as an rds object.
#' @export
#'
#' @examples
#' \dontrun{
#' # If version is not specified then current latest version
#' # (4.44) will be loaded
#' load_ramlegacy()
#'
#' # load version 3.0
#' load_ramlegacy(version = "3.0")
#'
#' # load version 2.5
#' load_ramlegacy(version = "2.5")
#' }
#'
load_ramlegacy <- function(version = NULL, dfs = NULL, ram_path = NULL) {
  ram_url <- "https://doi.org/10.5281/zenodo.2542918"

  if (!is.null(version)) {
    # ensure that the version is properly formatted
    version <- fmt_version(version)
    check_version_arg(version)
  } else {
    version <- find_latest(ram_url)
  }

  if (is.null(ram_path)) {

    if (version < "4.40") {
      rds_path <- file.path(ram_dir(vers = version), paste0("v", version, ".rds"))

      } else {

      rds_path <- file.path(ram_dir(vers = version), paste0("RLSADB v", version))
      rds_path <- file.path(rds_path, "DB Files With Assessment Data")
      rds_path <- file.path(rds_path, paste0("v", version, ".rds"))

      }

  } else {

    check_path(ram_path)
    rds_path <- ram_path

    }

  # make sure version is present
  if (!file.exists(rds_path)) {
    stop(paste0("Version ", version, " not found locally."))
  }

  list_dataframes <- readRDS(rds_path)
  if (!is.null(dfs)) {
    listToReturn <- vector("list", length(dfs))
    for (i in seq_along(1:length(dfs))) {
      # construct df name
      df_name <- dfs[i]
      if (grepl("\\.data", dfs[i])) {
        MostUsedTimeSeries <- list_dataframes[[26]]
        listToReturn[[i]]  <- MostUsedTimeSeries[[df_name]]
      } else {
        listToReturn[[i]] <- list_dataframes[[df_name]]
      }
    }
    names(listToReturn) <- dfs
    return(listToReturn)
  } else {
    return(list_dataframes)
  }
}
