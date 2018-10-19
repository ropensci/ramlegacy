.onAttach <- function(libname, pkgname) {
  det_version()
  vers_to_load = check_local()
  if (is.null(vers_to_load)) {
    not_completed("No version of RAM Legacy Stock Assessment Database has yet been downloaded. Use function download_ramlegacy to download a version now.")
  } else {
    load_ramlegacy(version = vers_to_load)
  }
}
