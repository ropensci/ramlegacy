.onAttach <- function(libname, pkgname) {
  # get the latest version
  latest_version <- find_latest()

  # write latest version as metadata (text file) to rappdirs directory
  write_version(path = ram_dir(), version = latest_version)

  # find the local version/versions that should be loaded
  local_vers <- find_local(path = ram_dir(), latest_vers = latest_version)

  # if no version found locally then notify the user
  if (is.null(local_vers)) {
    not_completed(paste("No version of the database has yet been downloaded.",
              "Use function download_ramlegacy() to download a version now."))

  # if multiple versions found locally then prompt the user to select the one to
  # load if running in interactive mode
  } else if (length(local_vers) > 1) {
    ask_list <- paste0(local_vers, ",")
    display_list <- paste(ask_list, collapse = " ")
    if (interactive()) {
      completed(paste("Found these versions", display_list))
      ans <- ask_multiple("Select the version to load.", local_vers)
      ans <- sprintf("%.1f", as.numeric(ans))
      load_ramlegacy(version = ans)

    # otherwise inform the user that it was unable to determine which version
    # to load

    } else {
      not_completed(paste(paste("Found these versions", display_list),
                  ".Unable to determine which version to load.",
                  "Please use load_ramlegacy() to load the desired version.",
                   paste0("Also, be informed that a newer version ",
                            latest_version,
                           " of the database is available.")))
    }

  # if the single version found locally is the latest version then load that
  } else if (local_vers == latest_version) {
      notify(paste("Multiple versions found including the latest one:",
                   latest_version, ". Loading the latest version."))
      load_ramlegacy(version = latest_version)

  # otherwise load the older version while notifying the user of
  # availability of the latest version
  } else {
    notify(paste0("Loading the version specified. ",
                  "Be informed that a newer version ",
                  latest_version,
                  " of the database is available."))
    load_ramlegacy(version = local_vers)
  }
  invisible(TRUE)
}
