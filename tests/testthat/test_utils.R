context("Testing function in utils.R")

test_that("net_check doesn't error out behind a proxy server when msg is FALSE",{
  skip_on_cran()
  httr::with_config(httr::use_proxy(url = "http://google.com", port = 1234),
                    {base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
                    expect_silent(net_check(base_url, msg = FALSE))
                    expect_true(net_check(base_url, msg = FALSE))
                    })
})

test_that("net_check errors out behind a proxy server when msg is TRUE",{
  skip_on_cran()
  httr::with_config(httr::use_proxy(url = "http://google.com", port = 1234),
                    {base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
                    expect_error(net_check(base_url, msg = TRUE), "Could not connect to the internet. Please check your connection settings and try again.")
                    })
})

test_that("net_check behaves as expected when no connection issues", {
  base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  expect_silent(net_check(base_url, msg = TRUE))
  expect_false(net_check(base_url, msg = TRUE))
})

test_that("net_check behaves as expected when no connection issues", {
  base_url <- "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  expect_silent(net_check(base_url, msg = FALSE))
  expect_false(net_check(base_url, msg = TRUE))

})

test_that("find_latest behaves correctly", {
  base_url <-  "https://depts.washington.edu/ramlegac/wordpress/databaseVersions"
  test_url1 <- "http://httpbin.org/status/300"
  test_url2 <- "http://httpbin.org/status/301"
  test_url3 <- "http://httpbin.org/status/404"
  expect_equal(find_latest(base_url), "4.3")
  httr::with_config(httr::use_proxy(url = "http://google.com", port = 1234), {
                    expect_silent(find_latest(base_url))
                    expect_output(find_latest(base_url), "4.3")
                    })
  expect_equal(find_latest(test_url1), "4.3")
  expect_equal(find_latest(test_url2), "4.3")
  expect_equal(find_latest(test_url3), "4.3")
})

test_that("write_version works as expected", {
  # create temp directory as a proxy for rappdirs directory
  # first we simulate loading the package for the first time
  # that is write_version would need to create ramlegacy directory if it
  # doesn't exit and then write the version no. we will also check if the
  # contents were right
  test_path <- file.path(tempdir(), "ramlegacy")
  # check test_path doesn't exist before calling write_version
  expect_false(dir.exists(test_path))
  write_version(test_path, "4.3")
  # check test_path has been created after calling write_version
  expect_true(dir.exists(test_path))
  txt_path <- file.path(test_path, "VERSION.txt")
  expect_true(file.exists(txt_path))
  expect_equal(readLines(txt_path), "4.3")

  # remove the contents of the temp paths
  unlink(test_path, recursive = T)

  # check that write_version ovewrites the latest version correctly
  dir.create(test_path)
  file.create(txt_path)
  writeLines(txt_path, "4.3")
  write_version(test_path, "5.0")
  expect_equal(readLines(txt_path), "5.0")

  # remove the contents of the temp paths
  unlink(test_path, recursive = T)

  # check the behavior of write_version when ramlegacy path is present
  dir.create(test_path)

  # check directory is present and created and that write_version
  # shouldn't create it
  expect_true(dir.exists(test_path))
  write_version(test_path, "2.0")
  expect_true(file.exists(txt_path))
  expect_equal(readLines(txt_path), "2.0")

  # remove the contents of the temp paths
  unlink(test_path, recursive = T)

})

test_that("find_local behaves as expected", {
  # use tempdir to mock rappdirs directory
  test_path <- file.path(tempdir(), "ramlegacy")
  expect_false(find_local(test_path, "4.3"))
  # put a single version in this directory
  version_path2.5 <- file.path(test_path, "2.5")
  dir.create(version_path2.5)
  expect_equal(find_local(test_path, "4.3"), "2.5")

  # put multiple versions (not including latest) in the directory
  #to check if it returns a vector of the versions
  version_path1.0 <- file.path(test_path, "1.0")
  version_path2.0 <- file.path(test_path, "2.0")
  version_path3.0 <- file.path(test_path, "3.0")
  dir.create(version_path1.0)
  dir.create(version_path2.0)
  dir.create(version_path3.0)
  set1 <- unlist(strsplit(find_local(test_path, "4.3"), split = " "))
  set2 <- c("2.5", "1.0", "2.0", "3.0")
  expect_true(setequal(set1, set2))

  # check if returns latest_vers when it is present in dir
  version_path4.3 <- file.path(test_path, "4.3")
  dir.create(version_path4.3)
  expect_equal(find_local(test_path, "4.3"), "4.3")
})



test_that("ram_dir returns a path",{
  expect_is(ram_dir(), "character")
  expect_is(ram_dir(vers = 2.0), "character")
})

test_that("check_version_arg works with valid versions", {
  expect_true(check_version_arg(3.0))
  expect_true(check_version_arg(2.5))
  expect_true(check_version_arg(2.0))
  expect_true(check_version_arg(1.0))
  expect_true(check_version_arg(4.3))
})


test_that("check_version_arg fails with invalid versions", {

  expect_error(check_version_arg(1.1),
               "Invalid version number. Available versions are")
  expect_error(check_version_arg(1.5),
               "Invalid version number. Available versions are")
  expect_error(check_version_arg(2.4),
               "Invalid version number. Available versions are")
  expect_error(check_version_arg(3.5),
               "Invalid version number. Available versions are")
  expect_error(check_version_arg(4.0),
               "Invalid version number. Available versions are")
})


test_that()
