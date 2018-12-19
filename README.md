
<!-- README.md is generated from README.Rmd. Please edit that file -->
ramlegacy
=========

[![Travis Build Status](https://travis-ci.com/kshtzgupta1/ramlegacy.svg?branch=master)](https://travis-ci.com/kshtzgupta1/ramlegacy) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/kshtzgupta1/ramlegacy?branch=master&svg=true)](https://ci.appveyor.com/project/kshtzgupta1/ramlegacy) [![Coverage status](https://codecov.io/gh/kshtzgupta1/ramlegacy/branch/master/graph/badge.svg)](https://codecov.io/github/kshtzgupta1/ramlegacy?branch=master) [![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

-   **Authors**: Kshitiz Gupta, [Carl Boettiger](http://www.carlboettiger.info/)
-   **License**: [MIT](http://opensource.org/licenses/MIT)
-   [Package source code on Github](https://github.com/kshtzgupta1/ramlegacy)
-   [**Submit Bugs and feature requests**](https://github.com/kshtzgupta1/ramlegacy/issues)

`ramlegacy` is an R package that supports caching and reading in different versions of the RAM Legacy Stock Assessment Data Base, an online compilation of stock assessment results for commercially exploited marine populations from around the world. More information about the database can be found [here.](www.ramlegacy.org)

What does `ramlegacy` do?
-------------------------

-   Provides a function `download_ramlegacy()`, to download all the available
    versions of the RAM Legacy Stock Assessment Excel Database as RDS objects. This way once a version has been downloaded it doesn't need to be re-downloaded for subsequent analysis.
-   Supports reading in the cached versions of the database through loading the package i.e. calling `library(ramlegacy)` and also by providing a function `load_ramlegacy()` to load any specified version.
-   Provides a function `ram_dir()` to view the path where the downloaded database was saved.

Installation
------------

You can install the development version from [GitHub](https://github.com/kshtzgupta1/ramlegacy) with:

``` r
install.packages("devtools")
library(devtools)
install_github("kshtzgupta1/ramlegacy")
```

Usage
-----

Please see the ramlegacy vignette for more detailed examples and additional package functionality. The vignette can be viewed by calling `vignette(package = "ramlegacy")`

Start by loading the package using `library`.

``` r
library(ramlegacy)
```

When `ramlegacy` is loaded for the first time after installation of the package calling `library(ramlegacy)` will prompt the user to download a version of the database using `download_ramlegacy()`. After downloading a version or multiple versions of the database the subsequent behavior of `library(ramlegacy)` will depend on which version/versions were downloaded and are present on disk as well as whether `library(ramlegacy)` is called in an interactive vs non-interactive session. For more details about this behavior please see the ramlegacy vignette.

### download\_ramlegacy

`download_ramlegacy()` downloads the specified version of **RAM Legacy Stock Assessment Excel Database** and then saves it as an RDS object in user’s application data directory as detected by the [rappdirs](https://cran.r-project.org/web/packages/rappdirs/index.html) package. This location is also where `load_ramlegacy()` will look for the downloaded database.

``` r
# downloads version 3.0
download_ramlegacy(version = "3.0")
```

If version is not specified then `download_ramlegacy` defaults to downloading current latest version (4.3) :

``` r
# downloads current latest version 4.3
download_ramlegacy()
```

To ensure that the user is able to download the data in case www.ramlegacy.org is down, the function also supports downloading all the different versions of the database from a [backup](www.github.com/kshtzgupta1/ramlegacy-assets/) location:

``` r
# downloads version 1.0 from backup location if www.ramlegacy.org is down
download_ramlegacy(version = "4.3")
```

### load\_ramlegacy

After the specified version of the database has been downloaded through `download_ramlegacy`, in addition to calling `library(ramlegacy)` to read in the database we can call `load_ramlegacy()` to do the same thing. That is, calling `load_ramlegacy` makes all the dataframes present in the database become available in the user's global environment. Note that `load_ramlegacy()` does not support vectorization and can only load and read in one version at a time. If version is not specified then `load_ramlegacy` defaults to loading the latest version (currently 4.3) :

``` r
# load version 3.0
load_ramlegacy(version = "3.0")

# loads current latest version 4.3
load_ramlegacy()
```

### ram\_dir

To view the exact path where a certain version of the database was downloaded and cached by `download_ramlegacy` you can run `ram_dir(vers = 'version')`, specifying the version number inside the function call:

``` r
# downloads version 2.5
download_ramlegacy(version = '2.5')

# view the location where version 2.5 of the database was downloaded
ram_dir(vers = '2.5')
```

Similar Projects
----------------

1.  [`ramlegacy`](https://github.com/seananderson/ramlegacy) Sean Anderson has a namesake package that appears to be a stalled project on GitHub (last updated 9 months ago). However, unlike this package which supports downloading and reading in the Excel version of the database, Sean Anderson's project downloads the Microsoft Access version and converts it to a local sqlite3 database.

2.  [`RAMlegacyr`](https://github.com/ashander/RAMlegacyr) `RAMlegacyr` is an older package last updated in 2015. Similar to Sean Anderson's project, the package seems to be an R interface for the Microsoft Access version of the RAM Legacy Stock Assessment Database and provides a set of functions using RPostgreSQL to connect to the database.

Citation
--------

Use of the RAM Legacy Stock Assessment Database is subject to a [Fair Use Policy.](http://ramlegacy.marinebiodiversity.ca/ram-legacy-stock-assessment-database/ram-legacy-stock-assessment-database-fair-use-policy)

Please cite the RAM Legacy Stock Assessment Database as follows:

Ricard, D., Minto, C., Jensen, O.P. and Baum, J.K. (2013) Evaluating the knowledge base and status of commercially exploited marine species with the RAM Legacy Stock Assessment Database. Fish and Fisheries 13 (4) 380-398. DOI: 10.1111/j.1467-2979.2011.00435.x
