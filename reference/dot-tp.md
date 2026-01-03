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
#>   [7] "any"                     "as.Date"                
#>   [9] "as.character"            "as.logical"             
#>  [11] "as.numeric"              "asin"                   
#>  [13] "asinh"                   "atan"                   
#>  [15] "atanh"                   "between_dplyr"          
#>  [17] "case_match"              "case_when"              
#>  [19] "ceiling"                 "coalesce_dplyr"         
#>  [21] "consecutive_id_dplyr"    "cos"                    
#>  [23] "cosh"                    "cumcount"               
#>  [25] "cummin"                  "cumprod"                
#>  [27] "cumsum"                  "date_lubridate"         
#>  [29] "day_lubridate"           "days_in_month_lubridate"
#>  [31] "days_lubridate"          "ddays_lubridate"        
#>  [33] "dense_rank_dplyr"        "desc_dplyr"             
#>  [35] "dhours_lubridate"        "diff"                   
#>  [37] "dmicroseconds_lubridate" "dmilliseconds_lubridate"
#>  [39] "dminutes_lubridate"      "dmy_lubridate"          
#>  [41] "dnanoseconds_lubridate"  "dseconds_lubridate"     
#>  [43] "duplicated"              "dweeks_lubridate"       
#>  [45] "dym_lubridate"           "exp"                    
#>  [47] "first_dplyr"             "floor"                  
#>  [49] "force_tz_lubridate"      "grepl"                  
#>  [51] "gsub"                    "hour_lubridate"         
#>  [53] "hours_lubridate"         "ifelse"                 
#>  [55] "infinite"                "interpolate"            
#>  [57] "is.finite"               "is.infinite"            
#>  [59] "is.nan"                  "is.null"                
#>  [61] "is_first"                "isoyear_lubridate"      
#>  [63] "kurtosis"                "lag_dplyr"              
#>  [65] "last_dplyr"              "lead_dplyr"             
#>  [67] "leap_year_lubridate"     "length"                 
#>  [69] "log"                     "log10"                  
#>  [71] "make_date_lubridate"     "make_datetime_lubridate"
#>  [73] "max"                     "mday_lubridate"         
#>  [75] "mdy_lubridate"           "mean"                   
#>  [77] "median"                  "microseconds_lubridate" 
#>  [79] "milliseconds_lubridate"  "min"                    
#>  [81] "min_rank_dplyr"          "minute_lubridate"       
#>  [83] "minutes_lubridate"       "mode"                   
#>  [85] "month_lubridate"         "my_lubridate"           
#>  [87] "myd_lubridate"           "n_distinct_dplyr"       
#>  [89] "n_dplyr"                 "na_if_dplyr"            
#>  [91] "nanoseconds_lubridate"   "nchar"                  
#>  [93] "now_lubridate"           "nth_dplyr"              
#>  [95] "paste"                   "paste0"                 
#>  [97] "pm_lubridate"            "quarter_lubridate"      
#>  [99] "rank"                    "replace_na_tidyr"       
#> [101] "rev"                     "rollback_lubridate"     
#> [103] "rollbackward_lubridate"  "rollforward_lubridate"  
#> [105] "round"                   "row_number_dplyr"       
#> [107] "sample"                  "sd"                     
#> [109] "second_lubridate"        "seconds_lubridate"      
#> [111] "seq"                     "seq_len"                
#> [113] "sign"                    "sin"                    
#> [115] "sinh"                    "skew"                   
#> [117] "sort"                    "sqrt"                   
#> [119] "str_count_stringr"       "str_detect_stringr"     
#> [121] "str_dup_stringr"         "str_ends_stringr"       
#> [123] "str_equal_stringr"       "str_extract_all_stringr"
#> [125] "str_extract_stringr"     "str_length_stringr"     
#> [127] "str_pad_stringr"         "str_remove_all_stringr" 
#> [129] "str_remove_stringr"      "str_replace_all_stringr"
#> [131] "str_replace_na_stringr"  "str_replace_stringr"    
#> [133] "str_split_i_stringr"     "str_split_stringr"      
#> [135] "str_squish_stringr"      "str_starts_stringr"     
#> [137] "str_sub_stringr"         "str_to_lower_stringr"   
#> [139] "str_to_title_stringr"    "str_to_upper_stringr"   
#> [141] "str_trim_stringr"        "str_trunc_stringr"      
#> [143] "strptime"                "substr"                 
#> [145] "sum"                     "tan"                    
#> [147] "tanh"                    "toTitleCase"            
#> [149] "tolower"                 "toupper"                
#> [151] "trimws"                  "unique"                 
#> [153] "unique_counts"           "var"                    
#> [155] "wday_lubridate"          "week_lubridate"         
#> [157] "weeks_lubridate"         "which.max"              
#> [159] "which.min"               "with_tz_lubridate"      
#> [161] "word_stringr"            "yday_lubridate"         
#> [163] "ydm_lubridate"           "year_lubridate"         
#> [165] "ym_lubridate"            "ymd_hms_lubridate"      
#> [167] "ymd_lubridate"          

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
