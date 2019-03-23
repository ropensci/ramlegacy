context("Testing that download_ramlegacy works")

test_that("defaults to curr. latest version 4.44 if version not specified", {
  #skip_on_cran()
  temp_path <- tempfile("ramlegacy", tempdir())
  download_ramlegacy(NULL, temp_path)
  vers_path <- file.path(temp_path, "4.44")
  rds_path <- file.path(vers_path, "v4.44.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = TRUE)
})

test_that("download_ramlegacy errors when there is no internet", {
  temp_path <- tempfile("ramlegacy", tempdir())
  httptest::without_internet(
    expect_error(
      download_ramlegacy("3.0", temp_path),
      paste(
        "Could not connect to the internet.",
        "Please check your connection settings and try again."
      )
    )
  )
  unlink(temp_path, recursive = TRUE)
})

test_that("download_ramlegacy errors out behind a proxy server", {
  skip_on_cran()
  temp_path <- tempfile("ramlegacy", tempdir())
  httr::with_config(
    httr::use_proxy(url = "http://google.com", port = 1234),
    expect_error(
      download_ramlegacy("3.0", temp_path),
      paste(
        "Could not connect to the internet.",
        "Please check your connection settings and try again."
      )
    )
  )
  unlink(temp_path, recursive = TRUE)
})


test_that("Doesn't download when requested version is already present", {
  skip_on_cran()
  temp_path <- tempfile("ramlegacy", tempdir())
  # download version 3.0 for the first time
  download_ramlegacy("3.0", temp_path)
  # call download_ramlegacy again to test behavior
  expect_is(download_ramlegacy("3.0", temp_path), "character")
  unlink(temp_path, recursive = TRUE)
})

# testing download_ramlegacy downloads older version 1.0
test_that("download_ramlegacy downloads v1.0", {
  skip_on_cran()
  temp_path <- tempfile("ramlegacy", tempdir())
  download_ramlegacy("1.0", temp_path)
  vers_path <- file.path(temp_path, "1.0")
  rds_path <- file.path(vers_path, "v1.0.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = TRUE)
})
