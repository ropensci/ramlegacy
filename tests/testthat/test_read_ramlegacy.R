# context("Checking read_ramlegacy works as expected")
#
# ram_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
#
# test_that("read_ramlegacy writes the database as RDS for v1.0", {
#   skip_on_cran()
#   vers_url <- "RLSADB_v1.0_excel.zip"
#   url1 <- paste(ram_url, vers_url, sep = "/")
#   # test v1.0
#   temp_db_path <- file.path(tempfile("ramlegacy", tempdir()), "1.0")
#   dir.create(temp_db_path, showWarnings = FALSE, recursive = TRUE)
#   # download and unzip the database
#   download_db_path <- file.path(temp_db_path, "v1.0.zip")
#   download.file(url1, download_db_path)
#   utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
#   suppressWarnings(read_ramlegacy(temp_db_path, "1.0"))
#   # check RDS exists
#   rds_file <- file.path(temp_db_path, "v1.0.rds")
#   expect_true(file.exists(rds_file))
#   expect_is(readRDS(rds_file), "list")
#   unlink(rds_file, recursive = TRUE)
# })
#
# test_that("read_ramlegacy writes the database as RDS for v2.0", {
#   skip_on_cran()
#   vers_url <- paste0(
#     "RLSADB_v", "2.0",
#     "_(assessment_data_only)_excel.zip"
#   )
#   url2 <- paste(ram_url, vers_url, sep = "/")
#   # test v1.0
#   temp_db_path <- file.path(tempfile("ramlegacy", tempdir()), "2.0")
#   dir.create(temp_db_path, showWarnings = FALSE, recursive = TRUE)
#   # download and unzip the database
#   download_db_path <- file.path(temp_db_path, "v2.0.zip")
#   download.file(url2, download_db_path)
#   utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
#   suppressWarnings(read_ramlegacy(temp_db_path, "2.0"))
#   # check RDS exists
#   rds_file <- file.path(temp_db_path, "v2.0.rds")
#   expect_true(file.exists(rds_file))
#   expect_is(readRDS(rds_file), "list")
#   unlink(rds_file, recursive = TRUE)
# })
#
# test_that("read_ramlegacy writes the database as RDS for v2.5", {
#   skip_on_cran()
#   vers_url <- paste0(
#     "RLSADB_v", "2.5",
#     "_(assessment_data_only)_excel.zip"
#   )
#   url2.5 <- paste(ram_url, vers_url, sep = "/")
#   temp_db_path <- file.path(tempfile("ramlegacy", tempdir()), "2.5")
#   dir.create(temp_db_path, showWarnings = FALSE, recursive = TRUE)
#   # download and unzip the database
#   download_db_path <- file.path(temp_db_path, "v2.5.zip")
#   download.file(url2.5, download_db_path)
#   utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
#   suppressWarnings(read_ramlegacy(temp_db_path, "2.5"))
#   # check RDS exists
#   rds_file <- file.path(temp_db_path, "v2.5.rds")
#   expect_true(file.exists(rds_file))
#   expect_is(readRDS(rds_file), "list")
#   unlink(rds_file, recursive = TRUE)
# })
#
# test_that("read_ramlegacy writes the database as RDS for v3.0", {
#   skip_on_cran()
#   vers_url <- paste0(
#     "RLSADB_v", "3.0",
#     "_(assessment_data_only)_excel.zip"
#   )
#   url3 <- paste(ram_url, vers_url, sep = "/")
#   temp_db_path <- file.path(tempfile("ramlegacy", tempdir()), "3.0")
#   dir.create(temp_db_path, showWarnings = FALSE, recursive = TRUE)
#   # download and unzip the database
#   download_db_path <- file.path(temp_db_path, "v3.0.zip")
#   download.file(url3, download_db_path)
#   utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
#   suppressWarnings(read_ramlegacy(temp_db_path, "3.0"))
#   # check RDS exists
#   rds_file <- file.path(temp_db_path, "v3.0.rds")
#   expect_true(file.exists(rds_file))
#   expect_is(readRDS(rds_file), "list")
#   unlink(rds_file, recursive = TRUE)
# })
#
# test_that("read_ramlegacy writes the database as RDS for v4.3", {
#   skip_on_cran()
#   vers_url <- paste0(
#     "RLSADB_v", "4.3",
#     "_(assessment_data_only)_excel.zip"
#   )
#   url4.3 <- paste(ram_url, vers_url, sep = "/")
#   # test v1.0
#   temp_db_path <- file.path(tempfile("ramlegacy", tempdir()), "4.3")
#   dir.create(temp_db_path, showWarnings = FALSE, recursive = TRUE)
#   # download and unzip the database
#   download_db_path <- file.path(temp_db_path, "v4.3.zip")
#   download.file(url4.3, download_db_path)
#   utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
#   suppressWarnings(read_ramlegacy(temp_db_path, "4.3"))
#   # check RDS exists
#   rds_file <- file.path(temp_db_path, "v4.3.rds")
#   expect_true(file.exists(rds_file))
#   expect_is(readRDS(rds_file), "list")
#   unlink(rds_file, recursive = TRUE)
# })
