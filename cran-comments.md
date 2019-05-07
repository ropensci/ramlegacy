## Resubmission
This is a resubmission. In this version I have:

* Corrected the database reference in DESCRIPTION to be in the form: authors (year) <doi:....>
* Put Excel within quotes in DESCRIPTION
* Explained the acronym RAM in DESCRIPTION
* Ensured that functions do not write by default in the user's home filespace.
* Ensured that functions in examples/vignettes/tests write to tempdir(). Please note that the code
  where we explicitly set the destination file path to `tempdir()` is within `\dontshow{}` for the 
  sake of having clear unambiguous examples.

## Test environments
* Local - ubuntu 18.04 (R 3.6.0)
* Travis CI - ubuntu 14.04 (R 3.6.0)
* Appveyor - Windows Server 2012 R2 x64 (R 3.6.0 (patched))
* win-builder (oldrelease, release, and devel)

## Note about examples in download_ramlegacy and load_ramlegacy
Because of the large size of the RAM Legacy database the examples in `download_ramlegacy` and `load_ramlegacy` take longer than 5 seconds to run and that's why there were placed within `donttest{}`. The runtime for examples in `download_ramlegacy` is 286.102 seconds and the runtime for examples in `load_ramlegacy` is 94.094 seconds.

## R CMD check results

There were no ERRORs, no WARNINGs, no NOTEs.

## Downstream dependencies

There are no downstream dependencies for this package.
