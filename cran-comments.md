I have read and agree to the the CRAN policies at http://cran.r-project.org/web/packages/policies.html

## Test environments
* Local - ubuntu 18.04 (R 3.5.3)
* Travis CI - ubuntu 14.04 (R 3.5.3)
* Appveyor - Windows Server 2012 R2 x64 (R 3.5.3 (patched))
* win-builder (oldrelease, release, and devel)

## Note about examples in download_ramlegacy and load_ramlegacy
Because of the large size of the RAM Legacy database the examples in `download_ramlegacy` and `load_ramlegacy` take longer than 5 seconds to run and that's why there were placed within `donttest{}`. The runtime for examples in `download_ramlegacy` is 286.102 seconds and the runtime for examples in `load_ramlegacy` is 94.094 seconds.

## R CMD check results

There were no ERRORs, no WARNINGs no NOTEs

## Downstream dependencies

There are no downstream dependencies for this package.
