
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

You can install the development version from [GitHub](https://github.com/) with:

``` r
install.packages("devtools")
#> Installing package into '/home/kshitiz/R/x86_64-pc-linux-gnu-library/3.4'
#> (as 'lib' is unspecified)
library(devtools)
install_github("kshtzgupta1/ramlegacy")
#> Skipping install of 'ramlegacy' from a github remote, the SHA1 (750c6604) has not changed since last install.
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
