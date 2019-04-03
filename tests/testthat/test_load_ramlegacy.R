context("test load_ramlegacy works as expected")

test_that("load_ramlegacy works as expected when particular dataframes are requested for older version", {
  temp_path <- tempfile("ramlegacy", tempdir())
  download_ramlegacy("1.0", temp_path)
  vers_path <- file.path(temp_path, "1.0")
  rds_path <- file.path(vers_path, "v1.0.rds")
  lst_dfs <- load_ramlegacy("1.0", c("area", "bioparams"))
  expect_equal(length(lst_dfs), 2)
  expect_true(typeof(lst_dfs[[1]] == "list"))
})

test_that("load_ramlegacy works as expected when particular dataframes are requested for newer version", {
  temp_path <- tempfile("ramlegacy", tempdir())
  download_ramlegacy("4.44", temp_path)
  vers_path <- file.path(temp_path, "4.44")
  rds_path <- file.path(vers_path, "v4.44.rds")
  lst_dfs <- load_ramlegacy("4.44", c("area", "bioparams"))
  expect_equal(length(lst_dfs), 2)
  expect_true(typeof(lst_dfs[[1]] == "list"))
})

test_that("load_ramlegacy works as expected when all dataframes are requested for newer version", {
  temp_path <- tempfile("ramlegacy", tempdir())
  download_ramlegacy("4.44", temp_path)
  vers_path <- file.path(temp_path, "4.44")
  rds_path <- file.path(vers_path, "v4.44.rds")
  lst_dfs <- load_ramlegacy("4.44", c("area", "bioparams"))
  expect_equal(length(lst_dfs), 26)
  expect_true(typeof(lst_dfs[[1]] == "list"))
})

test_that("load_ramlegacy works as expected when all dataframes are requested for older version", {
  temp_path <- tempfile("ramlegacy", tempdir())
  download_ramlegacy("4.3", temp_path)
  vers_path <- file.path(temp_path, "4.3")
  rds_path <- file.path(vers_path, "v4.3.rds")
  lst_dfs <- load_ramlegacy("4.3", c("area", "bioparams"))
  expect_equal(length(lst_dfs), 24)
  expect_true(typeof(lst_dfs[[1]] == "list"))
})


test_that("load_ramlegacy errors out when version is not present locally", {
  temp_path <- tempfile("ramlegacy", tempdir())
  # pass in the path to rds to load_ramlegacy
  rds_path <- file.path(temp_path, "1.0/v1.0.rds")
  expect_error(
    load_ramlegacy(version = "1.0", ram_path = rds_path),
    "Version 1.0 not found locally."
  )
})
