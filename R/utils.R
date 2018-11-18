# private function to check version argument
check_version_arg <- function(version) {
  if (length(version) != 1) {
    stop("Please pass in only one version number.")
  }
  latest_vers <- find_latest()
  list_vers <- c("1.0", "2.0", "2.5", "3.0", "4.3")
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


# private function to check path is valid or not
check_path <- function(path) {
  if (!is_string(path)) {
    stop("`path` must be a string", call. = FALSE)
  }
  TRUE
}

#' @title Output OS-independent path to the downloaded RAM Legacy database
#' @name ram_dir
#' @description Provides the download location for \code{\link{download_ramlegacy}} in an
#'  an OS independent manner. This is also the location from where \code{\link{load_ramlegacy}}
#'  loads the database from.
#' @param vers character, version number of the database. If NULL, then \code{ram_dir()}
#' returns the path to the rappdirs directory.
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
  cat(crayon::green(paste0(...,"\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::menu(choices) == which(choices == "Yes")
}


## Ask for multiple choices
#' @noRd
ask_multiple <- function(msg, choices) {
  cat(crayon::green(paste0(msg,"\n", collapse = "")))
  cli::cat_rule(col = "green")
  utils::select.list(choices)
}


# Catch 'network timeout error' or 'could not resolve host error' generated
# when dealing with proxy-related or connection related
# issues and fail with an informative error
# message
#' @noRd
net_check <- function(url, show_error = FALSE){
 response <- tryCatch(httr::GET(url),
  error = function(e) {
      if(show_error) {
        stop("Could not connect to the internet. Please check your connection settings and try again.",
        call. = FALSE)
      }
    })
  if(typeof(response) == "list") invisible(TRUE) else invisible(FALSE)
}


# regex function to find the latest version from the web, return it as a string
#' @noRd
find_latest <- function(ram_url) {
  if (!net_check(ram_url)) {
    return("4.3")
  }
  req <- httr::GET(ram_url)
  if (req$status_code != 200) {
    return("4.3")
  } else {
    # get the content
    contnt <- httr::content(req, "text")
    # get all the links
    m <- gregexpr("RLSADB_v[0-9]\\.[0-9]+_[()_a-zA-Z0-9]+_excel.zip",
                  text = contnt )
    links <- unlist(regmatches(contnt, m))
    # get the latest href
    latest_link <- links[length(links)]
    # get newest version from latest_link
    m_vers <- gregexpr("\\d\\.\\d+", text = latest_link)
    version <- unlist(regmatches(latest_link, m_vers))
    return(version)
  }
}

# write latest version as metadata to rappdirs directory
#' @noRd
write_version <- function(path, version) {
  version <- sprintf("%.1f", as.numeric(version))
  if(!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  writePath <- file.path(path, "VERSION.txt")
  writeLines(version, writePath)
}


# Returns the version (as a string) to load
# find_local should return a vector of string versions instead
# of a single string
#' @noRd
find_local <- function(path, latest_vers) {
  # httr::GET the number of versions in rappdirs
  num_vers <- length(dir(path, pattern = "^[0-9]\\.[0-9]{1,2}$"))

  if (num_vers == 0) {
    return(NULL)
  }

  potential_local_vers <- dir(path, pattern = "^[0-9]\\.[0-9]{1,2}$")
  # get the local version
  rds_exists_vec <- unlist(lapply(potential_local_vers, function(vers) {
    vers <- sprintf("%.1f", as.numeric(vers))
    rds_path <- file.path(path, file.path(vers, paste0("v", vers,".rds")))
    file.exists(rds_path)
  }))

  vers_that_exist <- potential_local_vers[rds_exists_vec]
  if (latest_vers %in% vers_that_exist) {
    return(latest_vers)
  } else {
    return(vers_that_exist)
  }
}










