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
#>  [55] "ifelse"                  "is.finite"              
#>  [57] "is.infinite"             "is.na"                  
#>  [59] "is.nan"                  "isoyear_lubridate"      
#>  [61] "lag_dplyr"               "last_dplyr"             
#>  [63] "lead_dplyr"              "leap_year_lubridate"    
#>  [65] "length"                  "log"                    
#>  [67] "log10"                   "make_date_lubridate"    
#>  [69] "make_datetime_lubridate" "max"                    
#>  [71] "mday_lubridate"          "mdy_lubridate"          
#>  [73] "mean"                    "median"                 
#>  [75] "microseconds_lubridate"  "milliseconds_lubridate" 
#>  [77] "min"                     "min_rank_dplyr"         
#>  [79] "minute_lubridate"        "minutes_lubridate"      
#>  [81] "month_lubridate"         "my_lubridate"           
#>  [83] "myd_lubridate"           "n_distinct_dplyr"       
#>  [85] "n_dplyr"                 "na_if_dplyr"            
#>  [87] "nanoseconds_lubridate"   "nchar"                  
#>  [89] "near_dplyr"              "now_lubridate"          
#>  [91] "nth_dplyr"               "paste"                  
#>  [93] "paste0"                  "pm_lubridate"           
#>  [95] "quarter_lubridate"       "rank"                   
#>  [97] "recode_values_dplyr"     "replace_na_tidyr"       
#>  [99] "replace_values_dplyr"    "replace_when_dplyr"     
#> [101] "rev"                     "rollback_lubridate"     
#> [103] "rollbackward_lubridate"  "rollforward_lubridate"  
#> [105] "round"                   "row_number_dplyr"       
#> [107] "sample"                  "sd"                     
#> [109] "second_lubridate"        "seconds_lubridate"      
#> [111] "seq"                     "seq_len"                
#> [113] "sign"                    "sin"                    
#> [115] "sinh"                    "sort"                   
#> [117] "sqrt"                    "str_count_stringr"      
#> [119] "str_detect_stringr"      "str_dup_stringr"        
#> [121] "str_ends_stringr"        "str_equal_stringr"      
#> [123] "str_extract_all_stringr" "str_extract_stringr"    
#> [125] "str_length_stringr"      "str_pad_stringr"        
#> [127] "str_remove_all_stringr"  "str_remove_stringr"     
#> [129] "str_replace_all_stringr" "str_replace_na_stringr" 
#> [131] "str_replace_stringr"     "str_split_i_stringr"    
#> [133] "str_split_stringr"       "str_squish_stringr"     
#> [135] "str_starts_stringr"      "str_sub_stringr"        
#> [137] "str_to_lower_stringr"    "str_to_title_stringr"   
#> [139] "str_to_upper_stringr"    "str_trim_stringr"       
#> [141] "str_trunc_stringr"       "strptime"               
#> [143] "substr"                  "sum"                    
#> [145] "tan"                     "tanh"                   
#> [147] "toTitleCase"             "tolower"                
#> [149] "toupper"                 "trimws"                 
#> [151] "unique"                  "var"                    
#> [153] "wday_lubridate"          "week_lubridate"         
#> [155] "weeks_lubridate"         "when_all_dplyr"         
#> [157] "when_any_dplyr"          "which.max"              
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
