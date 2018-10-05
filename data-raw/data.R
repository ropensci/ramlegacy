#
#
if(!file.exists(system.file("data", "v3.0.rda", package = "ramlegacy"))) {
  # create a temporary directory
  td = tempdir()
  # create the placeholder file
  tf = tempfile(tmpdir = td, fileext = ".zip")
  # download into the placeholder file
  download_ramlegacy(tf)
  # read in all dataframes of v3.0 database
  lst_df <- read_ramlegacy(path = tf, read_all = TRUE)
  # write all dataframes as rdata objects
  mapply(function(obj, name) {
      assign(name, obj)
      do.call("use_data", list(as.name(name), overwrite = TRUE))
    }, lst_df, names(lst_df))
}
#
#
#
