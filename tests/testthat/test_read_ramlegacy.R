context("Checking read_ramlegacy works as expected")

test_that("read_ramlegacy writes the database as RDS for v1.0", {
  ##skip_on_cran()
  url1 <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions/RLSADB_v1.0_excel.zip"
  # test v1.0
  temp_db_path <- file.path(tempdir(), "ramlegacy/1.0")
  dir.create(temp_db_path, showWarnings = F)
  # download and unzip the database
  download_db_path <- file.path(temp_db_path, "v1.0.zip")
  download.file(url1, download_db_path)
  utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
  suppressWarnings(read_ramlegacy(temp_db_path, "1.0"))
  # check RDS exists
  rds_file <- file.path(temp_db_path, "v1.0.rds")
  expect_true(file.exists(rds_file))
  expect_is(readRDS(rds_file), "list")
  unlink(rds_file, recursive = T)
})

test_that("read_ramlegacy writes the database as RDS for v2.0", {
  #skip_on_cran()
  url2 <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions/RLSADB_v2.0_(assessment_data_only)_excel.zip"
  # test v1.0
  temp_db_path <- file.path(tempdir(), "ramlegacy/2.0")
  dir.create(temp_db_path, showWarnings = F)
  # download and unzip the database
  download_db_path <- file.path(temp_db_path, "v2.0.zip")
  download.file(url2, download_db_path)
  utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
  suppressWarnings(read_ramlegacy(temp_db_path, "2.0"))
  # check RDS exists
  rds_file <- file.path(temp_db_path, "v2.0.rds")
  expect_true(file.exists(rds_file))
  expect_is(readRDS(rds_file), "list")
  unlink(rds_file, recursive = T)
})

test_that("read_ramlegacy writes the database as RDS for v2.5", {
  #skip_on_cran()
  url2.5 <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions/RLSADB_v2.5_(assessment_data_only)_excel.zip"
  temp_db_path <- file.path(tempdir(), "ramlegacy/2.5")
  dir.create(temp_db_path, showWarnings = F)
  # download and unzip the database
  download_db_path <- file.path(temp_db_path, "v2.5.zip")
  download.file(url2.5, download_db_path)
  utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
  suppressWarnings(read_ramlegacy(temp_db_path, "2.5"))
  # check RDS exists
  rds_file <- file.path(temp_db_path, "v2.5.rds")
  expect_true(file.exists(rds_file))
  expect_is(readRDS(rds_file), "list")
  unlink(rds_file, recursive = T)
})

test_that("read_ramlegacy writes the database as RDS for v3.0", {
  ##skip_on_cran()
  url3 <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions/RLSADB_v3.0_(assessment_data_only)_excel.zip"
  temp_db_path <- file.path(tempdir(), "ramlegacy/3.0")
  dir.create(temp_db_path, showWarnings = F)
  # download and unzip the database
  download_db_path <- file.path(temp_db_path, "v3.0.zip")
  download.file(url3, download_db_path)
  utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
  suppressWarnings(read_ramlegacy(temp_db_path, "3.0"))
  # check RDS exists
  rds_file <- file.path(temp_db_path, "v3.0.rds")
  expect_true(file.exists(rds_file))
  expect_is(readRDS(rds_file), "list")
  unlink(rds_file, recursive = T)
})

test_that("read_ramlegacy writes the database as RDS for v4.3", {
  ##skip_on_cran()
  url4.3 <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions/RLSADB_v4.3_(assessment_data_only)_excel.zip"
  # test v1.0
  temp_db_path <- file.path(tempdir(), "ramlegacy/4.3")
  dir.create(temp_db_path, showWarnings = F)
  # download and unzip the database
  download_db_path <- file.path(temp_db_path, "v4.3.zip")
  download.file(url4.3, download_db_path)
  utils::unzip(download_db_path, exdir = temp_db_path, overwrite = TRUE)
  suppressWarnings(read_ramlegacy(temp_db_path, "4.3"))
  # check RDS exists
  rds_file <- file.path(temp_db_path, "v4.3.rds")
  expect_true(file.exists(rds_file))
  expect_is(readRDS(rds_file), "list")
  unlink(rds_file, recursive = T)
})

