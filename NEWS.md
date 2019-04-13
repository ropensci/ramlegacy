NEWS 
====

For more fine-grained list of changes or to report a bug, consult 

* [The issues log](https://github.com/ropensci/ramlegacy/issues)
* [The commit log](https://github.com/ropensci/ramlegacy/commits/master)

Versioning
----------

Releases will be numbered with the following semantic versioning format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor 
  and patch)
* New additions without breaking backward compatibility bumps the minor 
  (and resets the patch)
* Bug fixes and misc changes bumps the patch
* Following the RStudio convention, a .99 is appended after the patch
  number to indicate the development version on Github.  Any version
  Coming from Github will now use the .99 extension, which will never
  appear in a version number for the package on CRAN. 


v0.1.0
------

* Initial Release

v0.2.0
-----
* Removed the loading behavior of library(ramlegacy) leaving the loading solely to load_ramlegacy which instead of assigning all the tables to global environment now just returns a list of the tables.
* Additionally, if the user wants specific tables from a version of the database load_ramlegacy now supports that behavior.
* We have also modified download_ramlegacy and load_ramlegacy so that while the default is still to download and read in the dataframes from the rappdirs directory the functions now also support downloading to a location chosen by the user and reading from that location.
