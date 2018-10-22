.onAttach <- function(libname, pkgname) {
  latest_vers <- det_version()
  vers_to_load = check_local()
  num_vers <- length(dir(ram_dir(), pattern = "\\d[.0-9]{,3}"))
  if (vers_to_load == 0) {
    not_completed("No version of RAM Legacy Stock Assessment Database has yet been downloaded. Use function download_ramlegacy to download a version now.")
    return(invisible(TRUE))
  } else if (num_vers > 1) {
    not_completed(paste("Multiple versions found. Downloading and loading latest version v",
                        det_version()))
    download_ramlegacy()
    load_ramlegacy(version = det_version())
  } else if (vers_to_load < latest_vers) {
    notify(paste0("Loading version v", vers_to_load,
                  ". Be informed that a newer version v",
                  latest_vers,
                  " of the database is available."))
    load_ramlegacy(version = vers_to_load)
  }
  invisible(TRUE)
}
