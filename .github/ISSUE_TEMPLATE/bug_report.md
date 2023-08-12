---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: ''

---

<!-- 

Please fill the template at the bottom and ensure that you have the latest versions
 ========================================================

`polars` and `tidypolars` are frequently updated. Please reinstall both and check whether the bug still exists:
```r
### Windows and macOS
install.packages("polars", repos = "https://rpolars.r-universe.dev")
install.packages('tidypolars', repos = c('https://etiennebacher.r-universe.dev', 'https://cloud.r-project.org'))

### Linux
install.packages("polars", repos = "https://rpolars.r-universe.dev/bin/linux/jammy/4.3")
remotes::install_github(
  "etiennebacher/tidypolars", 
  repos = c("https://rpolars.r-universe.dev/bin/linux/jammy/4.3", getOption("repos"))
)
```
 -->



**Describe the bug**
Write here a clear and concise description of what the bug is.

**To Reproduce**
Please use the R package [`reprex`](https://reprex.tidyverse.org/) to create a minimal and reproducible example. Paste the output here.

**Expected behavior**
Write here a clear and concise description of what you expected to happen.
