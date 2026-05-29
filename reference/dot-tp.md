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
#>  [11] "as.integer"              "as.logical"             
#>  [13] "as.numeric"              "asin"                   
#>  [15] "asinh"                   "atan"                   
#>  [17] "atanh"                   "between_dplyr"          
#>  [19] "case_match_dplyr"        "case_when_dplyr"        
#>  [21] "ceiling"                 "coalesce_dplyr"         
#>  [23] "consecutive_id_dplyr"    "cos"                    
#>  [25] "cosh"                    "cummax"                 
#>  [27] "cummin"                  "cumprod"                
#>  [29] "cumsum"                  "date_lubridate"         
#>  [31] "day_lubridate"           "days_in_month_lubridate"
#>  [33] "days_lubridate"          "ddays_lubridate"        
#>  [35] "dense_rank_dplyr"        "desc_dplyr"             
#>  [37] "dhours_lubridate"        "diff"                   
#>  [39] "dmicroseconds_lubridate" "dmilliseconds_lubridate"
#>  [41] "dminutes_lubridate"      "dmy_lubridate"          
#>  [43] "dnanoseconds_lubridate"  "dseconds_lubridate"     
#>  [45] "duplicated"              "dweeks_lubridate"       
#>  [47] "dym_lubridate"           "exp"                    
#>  [49] "first_dplyr"             "floor"                  
#>  [51] "force_tz_lubridate"      "grepl"                  
#>  [53] "gsub"                    "hour_lubridate"         
#>  [55] "hours_lubridate"         "ifelse"                 
#>  [57] "is.finite"               "is.infinite"            
#>  [59] "is.na"                   "is.nan"                 
#>  [61] "isoyear_lubridate"       "lag_dplyr"              
#>  [63] "last_dplyr"              "lead_dplyr"             
#>  [65] "leap_year_lubridate"     "length"                 
#>  [67] "log"                     "log10"                  
#>  [69] "make_date_lubridate"     "make_datetime_lubridate"
#>  [71] "max"                     "mday_lubridate"         
#>  [73] "mdy_lubridate"           "mean"                   
#>  [75] "median"                  "microseconds_lubridate" 
#>  [77] "milliseconds_lubridate"  "min"                    
#>  [79] "min_rank_dplyr"          "minute_lubridate"       
#>  [81] "minutes_lubridate"       "month_lubridate"        
#>  [83] "my_lubridate"            "myd_lubridate"          
#>  [85] "n_distinct_dplyr"        "n_dplyr"                
#>  [87] "na_if_dplyr"             "nanoseconds_lubridate"  
#>  [89] "nchar"                   "near_dplyr"             
#>  [91] "now_lubridate"           "nth_dplyr"              
#>  [93] "paste"                   "paste0"                 
#>  [95] "pm_lubridate"            "quarter_lubridate"      
#>  [97] "rank"                    "recode_values_dplyr"    
#>  [99] "replace_na_tidyr"        "replace_values_dplyr"   
#> [101] "replace_when_dplyr"      "rev"                    
#> [103] "rollback_lubridate"      "rollbackward_lubridate" 
#> [105] "rollforward_lubridate"   "round"                  
#> [107] "row_number_dplyr"        "sample"                 
#> [109] "sd"                      "second_lubridate"       
#> [111] "seconds_lubridate"       "seq"                    
#> [113] "seq_len"                 "sign"                   
#> [115] "sin"                     "sinh"                   
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
#> [151] "trimws"                  "trunc"                  
#> [153] "unique"                  "var"                    
#> [155] "wday_lubridate"          "week_lubridate"         
#> [157] "weeks_lubridate"         "when_all_dplyr"         
#> [159] "when_any_dplyr"          "which.max"              
#> [161] "which.min"               "with_tz_lubridate"      
#> [163] "word_stringr"            "yday_lubridate"         
#> [165] "ydm_lubridate"           "year_lubridate"         
#> [167] "ym_lubridate"            "ymd_hms_lubridate"      
#> [169] "ymd_lubridate"          

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
