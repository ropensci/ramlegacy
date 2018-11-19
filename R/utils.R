# private function to check version argument
check_version_arg <- function(version) {
  if (length(version) != 1) {
    stop("Please pass in only one version number.")
  }
  latest_vers <- find_latest()
  list_vers <- c("1.0", "2.0", "2.5", "3.0", "4.3")

  # make sure version is formatted correctly
  version <- sprintf("%.1f", as.numeric(version))

  if (!latest_vers %in% list_vers) {
    list_vers <- c(list_vers, latest_vers)
  }
  if (!version %in% list_vers) {
    list_vers <- paste0(c("1.0", "2.0", "2.5", "3.0", "4.3"), ",")
    list_vers <- paste(list_vers, collapse = " ")
    stop(paste("Invalid version number. Available versions are",
               list_vers), call. = FALSE)
  }
  invisible(TRUE)
}

# private function to check string
is_string <- function(x) {
  length(x) == 1 && is.character(x)
}

# private function to check validity of path
check_path <- function(path) {
  if (!is_string(path)) {
    stop("`path` must be a string", call. = FALSE)
  }
  TRUE
}

#' @title Output OS-independent path to the downloaded RAM Legacy database
#' @name ram_dir
#' @description Provides the download location for \code{\link{download_ramlegacy}}
#'  in an  OS independent manner. This is also the location from where
#'  \code{\link{load_ramlegacy} loads the database from.
#' @param vers character, version number of the database. As of November 2018,
#' the availabl versions are "1.0", "2.0", "2.5", "3.0" and "4.3". If version
#' is not specified the \code{ram_dir()} returns the path to the rappdirs directory.
#' @export
#' @examples
#' # return the path to the rappdirs directory.
#' ram_dir()
#'
#' # Returns the path to version 4.3 subdirectory of the rappdirs directory.
#' # This is the path where version 4.3 of the database is downloaded to and
#' # read from.
#' ram_dir(vers = '4.3')
#'

ram_dir <- function(vers = NULL){
  if (!is.null(vers)) {
    vers <- sprintf("%.1f", as.numeric(vers))
    check_version_arg(vers)
  }
  rappdirs::user_data_dir("ramlegacy", version = vers)
}

## Ask for yes or no
#' @noRd
ask_yn <- function(...) {
  choices <- c("Yes", "No")
  cat(crayon::green(paste0(..., "\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::menu(choices) == which(choices == "Yes")
}


## Ask for multiple choices
#' @noRd
ask_multiple <- function(msg, choices) {
  cat(crayon::green(paste0(msg, "\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::select.list(choices)
}


# Catch 'network timeout error' or 'could not resolve host error' generated
# when dealing with proxy-related or connection related
# issues and fail with an informative error message
#' @noRd
net_check <- function(url, show_error = FALSE){

 response <- tryCatch(httr::GET(url),

  error = function(e) {

      if (show_error) {
        stop(paste("Could not connect to the internet.",
                   "Please check your connection settings and try again."),
        call. = FALSE)
      }
    })

  if (typeof(response) == "list") invisible(TRUE) else invisible(FALSE)

}



# regex function to find the latest version from the ram website
#' @noRd
find_latest <- function(ram_url) {

  # if there is connection issue then default to 4.3
  if (!net_check(ram_url)) {
    return("4.3")
  }

  req <- httr::GET(ram_url)

  # set version to return if fails
  version <- "4.3"

  # try to get latest version
  if (req$status_code == 200) {
    # get the content
    contnt <- httr::content(req, "text")
    # get all the links
    m <- gregexpr("RLSADB_v[0-9]\\.[0-9]+_[()_a-zA-Z0-9]+_excel.zip", contnt)
    links <- unlist(regmatches(contnt, m))
    # get the latest link
    latest_link <- links[length(links)]
    # get newest version from latest_link
    m_vers <- gregexpr("\\d\\.\\d+", text = latest_link)
    potential_latest_vers <- unlist(regmatches(latest_link, m_vers))
    # check the validity of potential_latest_vers
    if (nchar(potential_latest_vers) == 3) {
      # overwrite default version with the latest version
      version <- potential_latest_vers
    }
  }
    return(version)
}


# write latest version as metadata (text file) to rappdirs directory
#' @noRd
write_version <- function(path, version) {
  version <- sprintf("%.1f", as.numeric(version))
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  write_path <- file.path(path, "VERSION.txt")
  writeLines(version, write_path)
}


# Returns the version/versions to load by checking local rappdirs directory
#' @noRd
find_local <- function(path, latest_vers) {

  # get the number of subdirectories in rappdirs directory
  num_dirs <- length(dir(path, pattern = "^[0-9]\\.[0-9]{1,2}$"))

  if (num_dirs == 0) {
    return(NULL)
  }

  # a vector containing all the subdirectories inside rappdirs directory
  # they are all potential local versions
  potential_vers_vec <- dir(path, pattern = "^[0-9]\\.[0-9]{1,2}$")

  # check if these directories (potential local versions) contain rds file
  # and create rds_exists_vec, a boolean vector indicating whether the potential
  # local version actually contains a rds file of the database
  rds_exists_vec <- unlist(lapply(potential_vers_vec, function(vers) {
    vers <- sprintf("%.1f", as.numeric(vers))
    rds_path <- file.path(path, file.path(vers, paste0("v", vers, ".rds")))
    file.exists(rds_path)
  }))

  # these are the versions that actually exist since they contain rds files
  vers_that_exist <- potential_vers_vec[rds_exists_vec]

  # if latest version among the multiple version found locally then return the
  # latest version for loading
  if (latest_vers %in% vers_that_exist) {
    return(latest_vers)
  } else {
    return(vers_that_exist)
  }
}
