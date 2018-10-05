
<!-- README.md is generated from README.Rmd. Please edit that file -->
ramlegacy
=========

[![Build Status](https://travis-ci.com/kshtzgupta1/ramlegacy.svg?branch=master)](https://travis-ci.com/kshtzgupta1/ramlegacy)

[![Coverage status](https://codecov.io/gh/kshtzgupta1/ramlegacy/branch/master/graph/badge.svg)](https://codecov.io/github/kshtzgupta1/ramlegacy?branch=master)

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/kshtzgupta1/ramlegacy?branch=master&svg=true)](https://ci.appveyor.com/project/kshtzgupta1/ramlegacy)

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/ramlegacy)](https://cran.r-project.org/package=ramlegacy)

an R package that downloads the zipped version of the RAM Legacy Stock Assessment Data Base, an online compilation of stock assessment results for commercially exploited marine populations from around the world. More information about the database can be found [here.](www.ramlegacy.org)

The goal of ramlegacy is to ...

Installation
------------

You can install the development version from GitHub\[<https://github.com/>\] with:

``` r
install.packages("devtools")
#> Installing package into '/home/kshitiz/R/x86_64-pc-linux-gnu-library/3.4'
#> (as 'lib' is unspecified)
library(devtools)
install_github("kshtzgupta1/ramlegacy")
#> Skipping install of 'ramlegacy' from a github remote, the SHA1 (2d629786) has not changed since last install.
#>   Use `force = TRUE` to force installation
```

Usage
-----

See the ramlegacy\[\] vignette for details about additional package functionality.

Start by loading the library.

``` r
library(ramlegacy)
```

The RAM Legacy Stock Assessment Database is available in compressed(zipped) form on the website\[www.ramlegacy.org\] in two formats: **access**(Microsoft Office Access 2007 file format) and **excel**(Microsoft Excel Open XML Format Spreadsheet).

### download\_ramlegacy

The `download_ramlegacy` function is a thin wrapper around `download.file`. To download the most recent zipped version (3.0) of the database in excel format use `download` like so

``` r
download_ramlegacy(path = tempdir(), version = 3.0, format = "excel")
```

Alternatively, we can use `download_ramlegacy` to download the access format of the zippped database

``` r
download_ramlegacy(path = tempfile(tmpdir = tempdir()), version = 3.0, format = "access")
```

If version is not specified, `download_ramlegacy` defaults to version 3.0 of the zipped excel database

`{r default_download} # # downloads the zipped excel format of the most recent version (3.0) # download_ramlegacy(path = tempfile(tmpdir = tempdir()) ) #`
==========================================================================================================================================================

### read\_ramlegacy

`ramlegacy` also contains `read_ramlegacy` to unzip and read in the excel format of the downloaded zipped database as a \[tibble\]\[tibble::tibble-package\]. Reading in and unzipping the access format of the zipped database is currently not supported.

To read in a particular sheet of the downloaded excel database `read_ramlegacy` can be used like so

``` r
# unzips the zipped excel database and reads in the area sheet as a tibble
file_path <- tempfile(tmpdir = tempdir())
read_ramlegacy(path = file_path, sheet = "area")
```

`read_ramlegacy` also supports reading in all the sheets of the excel database through its `read_all` argument to return a list of tibbles. This list can then be used to access individual tibbles.

``` r
# unzips and reads in all the sheets to return a list of tibbles
list_tibbles = read_ramlegacy(file_path, read_all = TRUE)
```
