context("Testing that download_ramlegacy works")

test_that("download_ramlegacy defaults to 4.3 if version not specified", {
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/4.3")
  download_ramlegacy(version = NULL, temp_path)
  rds_file <- file.path(temp_path, "v4.3.rds")
  expect_true(file.exists(rds_file))
  unlink(rds_file, recursive = TRUE)
})

test_that("download_ramlegacy errors when there is no internet", {
  temp_path <- file.path(tempdir(), "ramlegacy/3.0")
  httptest::without_internet(
    expect_error(download_ramlegacy("3.0", temp_path), "Could not connect to the internet. Please check your connection settings and try again.")
    )
  unlink(temp_path, recursive = T)
    })

test_that("download_ramlegacy errors out behind a proxy server",{
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/3.0")
  httr::with_config(httr::use_proxy(url = "http://google.com", port = 1234),
   expect_error(download_ramlegacy("3.0", temp_path),
    "Could not connect to the internet. Please check your connection settings and try again.")
  )
  unlink(temp_path, recursive = T)
})

test_that("download_ramlegacy downloads data from backup location when primary location is unavailable",{
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/3.0")
  test_url1 <- "http://httpbin.org/status/300"
  test_url2 <- "http://httpbin.org/status/301"
  test_url3 <- "http://httpbin.org/status/404"
  test_url4 <- "http://httpbin.org/status/500"
  expect_message(download_ramlegacy("3.0", temp_path, test_url1), "Downloading from backup location...")
  expect_message(download_ramlegacy("3.0", temp_path, test_url2), "Downloading from backup location...")
  expect_message(download_ramlegacy("3.0", temp_path, test_url3), "Downloading from backup location...")
  expect_message(download_ramlegacy("3.0", temp_path, test_url4), "Downloading from backup location...")
  expect_message(download_ramlegacy("3.0", temp_path, test_url5), "Downloading from backup location...")
  unlink(temp_path, recursive = T)
   })

test_that("download_ramlegacy doesn't download when requested version is already present", {
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy")
  # put in version 3.0
  download_ramlegacy("3.0", temp_path)
  # call download_ramlegacy again to test behavior
  expect_equal(download_ramlegacy("3.0", temp_path), "Version 3.0 has already been downloaded. Exiting the function.")
  unlink(temp_path, recursive = T)
})

# testing download_ramlegacy downloads data from primary location
test_that("download_ramlegacy downloads v1.0", {
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/1.0")
  download_ramlegacy("1.0", temp_path)
  rds_path <- file.path(temp_path, "v1.0.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v2.0", {
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/2.0")
  download_ramlegacy("2.0", temp_path)
  rds_path <- file.path(temp_path, "v2.0.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v2.5", {
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/2.5")
  download_ramlegacy("2.5", temp_path)
  rds_path <- file.path(temp_path, "v2.5.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v3.0", {
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/3.0")
  download_ramlegacy("3.0", temp_path)
  rds_path <- file.path(temp_path, "v3.0.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v4.3", {
  skip_on_cran()
  temp_path <- file.path(tempdir(), "ramlegacy/4.3")
  download_ramlegacy("4.3", temp_path)
  rds_path <- file.path(temp_path, "v4.3.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

# testing that download_ramlegacy downloads data from backup location when
# original location is unavailable
test_that("download_ramlegacy downloads v1.0 from backup", {
  skip_on_cran()
  test_url <- "http://httpbin.org/status/404"
  temp_path <- file.path(tempdir(), "ramlegacy")
  download_ramlegacy("1.0", temp_path, test_url)
  rds_path <- file.path(temp_path, "1.0/v1.0.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v2.0 from backup", {
  skip_on_cran()
  test_url <- "http://httpbin.org/status/404"
  temp_path <- file.path(tempdir(), "ramlegacy")
  download_ramlegacy("2.0", temp_path, test_url)
  rds_path <- file.path(temp_path, "2.0/v2.0.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v2.5 from backup", {
  skip_on_cran()
  test_url <- "http://httpbin.org/status/404"
  temp_path <- file.path(tempdir(), "ramlegacy")
  download_ramlegacy("2.5", temp_path, test_url)
  rds_path <- file.path(temp_path, "2.5/v2.5.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v3.0 from backup", {
  skip_on_cran()
  test_url <- "http://httpbin.org/status/404"
  temp_path <- file.path(tempdir(), "ramlegacy")
  download_ramlegacy("3.0", temp_path, test_url)
  rds_path <- file.path(temp_path, "3.0/v3.0.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

test_that("download_ramlegacy downloads v4.3 from backup", {
  skip_on_cran()
  test_url <- "http://httpbin.org/status/404"
  temp_path <- file.path(tempdir(), "ramlegacy")
  download_ramlegacy("4.3", temp_path, test_url)
  rds_path <- file.path(temp_path, "4.3/v4.3.rds")
  expect_true(file.exists(rds_path))
  unlink(rds_path, recursive = T)
})

