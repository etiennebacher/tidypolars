# Get tidypolars function translation without loading their original package

Use `.tp$function_name()` to get access to the functions that are
translated by `tidypolars` without loading the package these functions
originally come from.

This may be useful in cases where you want to benefit from the interface
of these functions but don't want to add some `tidyverse` dependencies
to your project (e.g. `stringr` because it might be slow to build the
package in some cases).

Note that the name of the package that originally provided the function
must be appended to the function name. For instance, if you want to use
[`stringr::str_extract()`](https://stringr.tidyverse.org/reference/str_extract.html)
without loading `stringr`, you can do so with
`.tp$str_extract_stringr()`. This is because multiple packages may have
a function named
[`str_extract()`](https://stringr.tidyverse.org/reference/str_extract.html),
so we need to inform `tidypolars` of which translation we want exactly.

**Note:** using `.tp` will make it harder to convert `tidypolars` code
to run with other `tidyverse`-based backends because `.tp` will be
unknown to those backends. If you expect to switch between `tidypolars`,
the original `tidyverse`, and `tidyverse`-based backends, you should
avoid using `.tp`and load the original packages in the session instead.

This is similar to the `dd` object in `duckplyr` and to the `.sql`
object in `dbplyr`.

## Usage

``` r
.tp
```

## Examples

``` r
# List of all functions stored in this object
sort(names(.tp))
#>   [1] "ISOdatetime"             "abs"                    
#>   [3] "acos"                    "acosh"                  
#>   [5] "all"                     "am_lubridate"           
#>   [7] "any"                     "anyNA"                  
#>   [9] "as.Date"                 "as.character"           
#>  [11] "as.logical"              "as.numeric"             
#>  [13] "asin"                    "asinh"                  
#>  [15] "atan"                    "atanh"                  
#>  [17] "between_dplyr"           "case_match_dplyr"       
#>  [19] "case_when_dplyr"         "ceiling"                
#>  [21] "coalesce_dplyr"          "consecutive_id_dplyr"   
#>  [23] "cos"                     "cosh"                   
#>  [25] "cummax"                  "cummin"                 
#>  [27] "cumprod"                 "cumsum"                 
#>  [29] "date_lubridate"          "day_lubridate"          
#>  [31] "days_in_month_lubridate" "days_lubridate"         
#>  [33] "ddays_lubridate"         "dense_rank_dplyr"       
#>  [35] "desc_dplyr"              "dhours_lubridate"       
#>  [37] "diff"                    "dmicroseconds_lubridate"
#>  [39] "dmilliseconds_lubridate" "dminutes_lubridate"     
#>  [41] "dmy_lubridate"           "dnanoseconds_lubridate" 
#>  [43] "dseconds_lubridate"      "duplicated"             
#>  [45] "dweeks_lubridate"        "dym_lubridate"          
#>  [47] "exp"                     "first_dplyr"            
#>  [49] "floor"                   "force_tz_lubridate"     
#>  [51] "grepl"                   "gsub"                   
#>  [53] "hour_lubridate"          "hours_lubridate"        
#>  [55] "ifelse"                  "infinite"               
#>  [57] "interpolate"             "is.finite"              
#>  [59] "is.infinite"             "is.nan"                 
#>  [61] "is.null"                 "is_first"               
#>  [63] "isoyear_lubridate"       "kurtosis"               
#>  [65] "lag_dplyr"               "last_dplyr"             
#>  [67] "lead_dplyr"              "leap_year_lubridate"    
#>  [69] "length"                  "log"                    
#>  [71] "log10"                   "make_date_lubridate"    
#>  [73] "make_datetime_lubridate" "max"                    
#>  [75] "mday_lubridate"          "mdy_lubridate"          
#>  [77] "mean"                    "median"                 
#>  [79] "microseconds_lubridate"  "milliseconds_lubridate" 
#>  [81] "min"                     "min_rank_dplyr"         
#>  [83] "minute_lubridate"        "minutes_lubridate"      
#>  [85] "mode"                    "month_lubridate"        
#>  [87] "my_lubridate"            "myd_lubridate"          
#>  [89] "n_distinct_dplyr"        "n_dplyr"                
#>  [91] "na_if_dplyr"             "nanoseconds_lubridate"  
#>  [93] "nchar"                   "near_dplyr"             
#>  [95] "now_lubridate"           "nth_dplyr"              
#>  [97] "paste"                   "paste0"                 
#>  [99] "pm_lubridate"            "quarter_lubridate"      
#> [101] "rank"                    "recode_values_dplyr"    
#> [103] "replace_na_tidyr"        "replace_values_dplyr"   
#> [105] "replace_when_dplyr"      "rev"                    
#> [107] "rollback_lubridate"      "rollbackward_lubridate" 
#> [109] "rollforward_lubridate"   "round"                  
#> [111] "row_number_dplyr"        "sample"                 
#> [113] "sd"                      "second_lubridate"       
#> [115] "seconds_lubridate"       "seq"                    
#> [117] "seq_len"                 "sign"                   
#> [119] "sin"                     "sinh"                   
#> [121] "skew"                    "sort"                   
#> [123] "sqrt"                    "str_count_stringr"      
#> [125] "str_detect_stringr"      "str_dup_stringr"        
#> [127] "str_ends_stringr"        "str_equal_stringr"      
#> [129] "str_extract_all_stringr" "str_extract_stringr"    
#> [131] "str_length_stringr"      "str_pad_stringr"        
#> [133] "str_remove_all_stringr"  "str_remove_stringr"     
#> [135] "str_replace_all_stringr" "str_replace_na_stringr" 
#> [137] "str_replace_stringr"     "str_split_i_stringr"    
#> [139] "str_split_stringr"       "str_squish_stringr"     
#> [141] "str_starts_stringr"      "str_sub_stringr"        
#> [143] "str_to_lower_stringr"    "str_to_title_stringr"   
#> [145] "str_to_upper_stringr"    "str_trim_stringr"       
#> [147] "str_trunc_stringr"       "strptime"               
#> [149] "substr"                  "sum"                    
#> [151] "tan"                     "tanh"                   
#> [153] "toTitleCase"             "tolower"                
#> [155] "toupper"                 "trimws"                 
#> [157] "unique"                  "unique_counts"          
#> [159] "var"                     "wday_lubridate"         
#> [161] "week_lubridate"          "weeks_lubridate"        
#> [163] "when_all_dplyr"          "when_any_dplyr"         
#> [165] "which.max"               "which.min"              
#> [167] "with_tz_lubridate"       "word_stringr"           
#> [169] "yday_lubridate"          "ydm_lubridate"          
#> [171] "year_lubridate"          "ym_lubridate"           
#> [173] "ymd_hms_lubridate"       "ymd_lubridate"          

dat <- polars::pl$DataFrame(x = c("abc12", "def3"))
dat |>
  mutate(y = .tp$str_extract_stringr(x, "\\d+"))
#> shape: (2, 2)
#> ┌───────┬─────┐
#> │ x     ┆ y   │
#> │ ---   ┆ --- │
#> │ str   ┆ str │
#> ╞═══════╪═════╡
#> │ abc12 ┆ 12  │
#> │ def3  ┆ 3   │
#> └───────┴─────┘
```
