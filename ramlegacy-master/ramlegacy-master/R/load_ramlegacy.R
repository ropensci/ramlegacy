load_ramlegacy <- function(version = NULL) {
  read_path <- file.path(ram_dir(vers = version),
                         paste0("v", sprintf("%.1f", version), ".RDS"))
  lst_dfs <- readRDS(read_path)

}
