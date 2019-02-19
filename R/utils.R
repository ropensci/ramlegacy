# private function to check version argument
check_version_arg <- function(version) {
  if (length(version) != 1) {
    stop("Please pass in only one version number.")
  }

  if (version < "4.4"){
    old_vers <- c("1.0", "2.0", "2.5", "3.0", "4.3")
    if(!version %in% old_vers) {
    stop(paste(
      "Invalid version number."), call. = FALSE)
    }
  } else {
    new_vers <- c("4.40", "4.41", "4.44")
    if (!version %in% new_vers) {
    stop(paste(
      "Invalid version number."), call. = FALSE)
    }
  }
  invisible(TRUE)
}

# private function to format version argument
fmt_version <- function(version) {
  if (typeof(version) == "character") {
    version <- as.numeric(version)
  }
  if (version < 4.4) {
    version <- sprintf("%.1f", version)
  } else {
    version <- sprintf("%.2f", version)
  }
  return(version)
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

#' @title Output OS-independent path to the rappdirs directory on user's computer where
#' the RAM Legacy database is downloaded by default
#' @name ram_dir
#' @description Provides the download location for \code{\link{download_ramlegacy}}
#'  in an  OS independent manner. This is also the location from where
#'  \code{\link{load_ramlegacy}} loads the database from.
#' @param version character, version number of the database. As of January 2019,
#' the available versions are "1.0", "2.0", "2.5", "3.0", "4.3", and "4.4" . If version
#' is not specified the \code{ram_dir()} returns the path to the rappdirs directory.
#' @export
#' @examples
#' # return the path to the rappdirs directory.
#' ram_dir()
#'
#' # Returns the path to version 4.3 subdirectory of the rappdirs directory.
#' # This is the path where version 4.3 of the database is downloaded to and
#' # read from.
#' ram_dir(version = "4.3")
ram_dir <- function(vers = NULL) {
  if (!is.null(vers)) {
    version <- fmt_version(vers)
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
net_check <- function(url, show_error = FALSE) {

  response <- tryCatch(httr::GET(url),
    error = function(e) {
      if (show_error) {
        stop(paste(
          "Could not connect to the internet.",
          "Please check your connection settings and try again."
        ),
        call. = FALSE
        )
      }
    }
  )

  if (typeof(response) == "list") invisible(TRUE) else invisible(FALSE)
}

find_latest_net_check <- function() {
  ram_url <- "https://doi.org/10.5281/zenodo.2542918"
  is_work <- TRUE
  res <- tryCatch({httr::GET(ram_url, httr::accept("application/vnd.schemaorg.ld+json"))},
                       error = function(e) {
                         is_work <<- FALSE
                       })
  return(is_work)
  }

# regex function to find the latest version from the ram website
#' @noRd
find_latest <- function(ram_url) {

  # if there is connection issue then default to 4.44
  if (!find_latest_net_check()) {
    return("4.44")
  }

  # set version to 4.44 if retrieving fails for some reason
  vers <- "4.44"

  # perform content negotiation to get it in json
  req <- httr::GET(ram_url, httr::accept("application/vnd.schemaorg.ld+json"))
  # try to get latest version
  if (req$status_code == 200) {
    # get the content as text
    contnt <- httr::content(req, as = "text")
    # parse the text as json
    json_text <- jsonlite::parse_json(contnt)
    # get the name from json_text
    json_name <- json_text$name
    # get newest version the json_name
    m_vers <- gregexpr("\\d\\.\\d+", text = json_name)
    vers <- unlist(regmatches(json_name, m_vers))
  }
  return(vers)
}


# Returns the versions present locally by checking local rappdirs directory
#' @noRd
find_local <- function(path) {

  # get the number of subdirectories in rappdirs directory
  num_dirs <- length(dir(path, pattern = "^[0-9]\\.[0-9]{1,2}$"))

  if (num_dirs == 0) {
    return(NULL)
  }

  # a vector containing all the subdirectories inside rappdirs directory
  # they are all potential local versions
  potential_vers_vec <- dir(path, pattern = "^[0-9]\\.[0-9]{1,}$")

  # check if these directories (potential local versions) contain rds file
  # and create rds_exists_vec, a boolean vector indicating whether the potential
  # local version actually contains a rds file of the database
  rds_exists_vec <- unlist(lapply(potential_vers_vec, function(vers) {
    vers <- fmt_version(vers)
    if (vers < "4.4") {
      rds_path <- file.path(path, file.path(vers, paste0("v", vers, ".rds")))
    } else {
      path1 <- file.path(path, file.path(vers))
      path2 <- file.path(path1, paste0("RLSADB v", vers))
      path3 <- file.path(path2, "DB Files With Assessment Data")
      rds_path <- file.path(path3, paste0("v", vers, ".rds"))
    }
    file.exists(rds_path)
  }))

  # these are the versions that actually exist since they contain rds files
  vers_that_exist <- potential_vers_vec[rds_exists_vec]
  return(vers_that_exist)
}
