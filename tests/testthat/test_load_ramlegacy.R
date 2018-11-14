context("test load_ramlegacy works as expected")

test_that("load_ramlegacy actually loads version 1.0", {
  #skip_on_cran()
  temp_path <- tempfile(pattern = "ramlegacy", tmpdir = tempdir())
  download_ramlegacy(version = 1.0, ram_path = temp_path)
  # pass in the path to rds to load_ramlegacy
  rds_path <- file.path(temp_path, "1.0/v1.0.rds")
  load_ramlegacy(version = 1.0, rds_path)
  expect_true(exists("area_v1.0", envir = .GlobalEnv) |
                exists("Area_v1.0", envir = .GlobalEnv))
})

test_that("load_ramlegacy actually loads version 2.0", {
  #skip_on_cran()
  temp_path <- tempfile(pattern = "ramlegacy", tmpdir = tempdir())
  download_ramlegacy(version = 2.0, ram_path =temp_path)
  # pass in the path to rds to load_ramlegacy
  rds_path <- file.path(temp_path, "2.0/v2.0.rds")
  load_ramlegacy(version = 2.0, rds_path)
  expect_true(exists("area_v2.0", envir = .GlobalEnv) |
                exists("Area_v2.0", envir = .GlobalEnv))
})

test_that("load_ramlegacy actually loads version 2.5", {
  #skip_on_cran()
  temp_path <- tempfile(pattern = "ramlegacy", tmpdir = tempdir())
  download_ramlegacy(version = 2.5, ram_path = temp_path)
  # pass in the path to rds to load_ramlegacy
  rds_path <- file.path(temp_path, "2.5/v2.5.rds")
  load_ramlegacy(version = 2.5, rds_path)
  expect_true(exists("area_v2.5", envir = .GlobalEnv) |
                exists("Area_v2.5", envir = .GlobalEnv))
})

test_that("load_ramlegacy actually loads version 3.0", {
  #skip_on_cran()
  temp_path <- tempfile(pattern = "ramlegacy", tmpdir = tempdir())
  download_ramlegacy(version = 3.0, ram_path = temp_path)
  # pass in the path to rds to load_ramlegacy
  rds_path <- file.path(temp_path, "3.0/v3.0.rds")
  load_ramlegacy(version = 3.0, rds_path)
  expect_true(exists("area_v3.0", envir = .GlobalEnv) |
                exists("Area_v3.0", envir = .GlobalEnv))
})

test_that("load_ramlegacy actually loads version 4.3", {
  #skip_on_cran()
  temp_path <- tempfile(pattern = "ramlegacy", tmpdir = tempdir())
  download_ramlegacy(version = 4.3, ram_path = temp_path)
  # pass in the path to rds to load_ramlegacy
  rds_path <- file.path(temp_path, "4.3/v4.3.rds")
  load_ramlegacy(version = 4.3, rds_path)
  expect_true(exists("area_v4.3", envir = .GlobalEnv) |
                exists("Area_v4.3", envir = .GlobalEnv))
})

test_that("load_ramlegacy errors out when version is not present locally", {
  temp_path <- tempfile(pattern = "ramlegacy", tmpdir = tempdir())
  # pass in the path to rds to load_ramlegacy
  rds_path <- file.path(temp_path, "1.0/v1.0.rds")
  expect_error(load_ramlegacy(version = 1.0, rds_path),
               "Version 1.0 not found locally.")

})
