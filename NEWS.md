# tidypolars (development version)

## New features

* Support `as.numeric()`, `as.character()` and `as.logical()` in expressions
  in `pl_filter()`, `pl_mutate()` and `pl_summarize()`.

## Bug fixes

* Fix `pl_mutate()` and `pl_summarize()` when expressions use some variables 
  previously created or modified (#10, #37).
  
* Fix bug in `pl_filter()` when passing a vector in the RHS of `%in%`.
  
## Misc

* Improve the backend to translate R expressions into Polars expressions. This
  also led to a complete rewriting of the vignette "R and Polars expressions" 
  (#27).
  
* Error messages should now report the correct function call.

* Improve CI coverage (#35).



# tidypolars 0.0.1

* First Github release.
