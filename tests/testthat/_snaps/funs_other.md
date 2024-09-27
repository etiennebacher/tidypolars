# n_distinct() works

    Code
      summarize(test, foo = n_distinct())
    Condition
      Error in `summarize()`:
      ! Error while running function `n_distinct()` in Polars.
      x `...` is absent, but must be supplied.

# unique() works

    Code
      mutate(test, foo = unique(y))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c780a207c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c6ea66c59"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1a77bf0"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c4d2870f9", 
                    compress = FALSE)
                base::flush(base::stdout())
                base::flush(base::stderr())
                {
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout(as.environment("tools:callr")$`__callr_data__`$.__stdout__)
                    }
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr(as.environment("tools:callr")$`__callr_data__`$.__stderr__)
                    }
                }
                base::invisible()
            }, error = function(e) {
                {
                    callr_data <- base::as.environment("tools:callr")$`__callr_data__`
                    err <- callr_data$err
                    if (FALSE) {
                        base::assign(".Traceback", base::.traceback(4), envir = callr_data)
                        utils::dump.frames("__callr_dump__")
                        base::assign(".Last.dump", .GlobalEnv$`__callr_dump__`, 
                            envir = callr_data)
                        base::rm("__callr_dump__", envir = .GlobalEnv)
                    }
                    e <- err$process_call(e)
                    e2 <- err$new_error("error in callr subprocess")
                    class <- base::class
                    class(e2) <- base::c("callr_remote_error", class(e2))
                    e2 <- err$add_trace_back(e2)
                    cut <- base::which(e2$trace$scope == "global")[1]
                    if (!base::is.na(cut)) {
                        e2$trace <- e2$trace[-(1:cut), ]
                    }
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c4d2870f9", 
                        ".error"))
                }
            }, interrupt = function(e) {
                {
                    callr_data <- base::as.environment("tools:callr")$`__callr_data__`
                    err <- callr_data$err
                    if (FALSE) {
                        base::assign(".Traceback", base::.traceback(4), envir = callr_data)
                        utils::dump.frames("__callr_dump__")
                        base::assign(".Last.dump", .GlobalEnv$`__callr_dump__`, 
                            envir = callr_data)
                        base::rm("__callr_dump__", envir = .GlobalEnv)
                    }
                    e <- err$process_call(e)
                    e2 <- err$new_error("error in callr subprocess")
                    class <- base::class
                    class(e2) <- base::c("callr_remote_error", class(e2))
                    e2 <- err$add_trace_back(e2)
                    cut <- base::which(e2$trace$scope == "global")[1]
                    if (!base::is.na(cut)) {
                        e2$trace <- e2$trace[-(1:cut), ]
                    }
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c4d2870f9", 
                        ".error"))
                }
            }, callr_message = function(e) {
                base::try({
                    pxlib <- base::as.environment("tools:callr")$`__callr_data__`$pxlib
                    if (base::is.null(e$code)) 
                        e$code <- "301"
                    msg <- base::paste0("base64::", pxlib$base64_encode(base::serialize(e, 
                        NULL)))
                    data <- base::paste0(e$code, " ", base::nchar(msg), "\n", 
                        msg)
                    pxlib$write_fd(3L, data)
                    if (base::inherits(e, "cli_message") && !base::is.null(base::findRestart("cli_message_handled"))) {
                        base::invokeRestart("cli_message_handled")
                    }
                    else if (base::inherits(e, "message") && !base::is.null(base::findRestart("muffleMessage"))) {
                        base::invokeRestart("muffleMessage")
                    }
                })
            }), error = function(e) {
                {
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout(as.environment("tools:callr")$`__callr_data__`$.__stdout__)
                    }
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr(as.environment("tools:callr")$`__callr_data__`$.__stderr__)
                    }
                }
                if (FALSE) {
                    base::try(base::stop(e))
                }
                else {
                    base::invisible()
                }
            }, interrupt = function(e) {
                {
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout(as.environment("tools:callr")$`__callr_data__`$.__stdout__)
                    }
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr(as.environment("tools:callr")$`__callr_data__`$.__stderr__)
                    }
                }
                if (FALSE) {
                    e
                }
                else {
                    base::invisible()
                }
            })]
         1: Encountered the following error in Rust-Polars:
            	lengths don't match: unable to add a column of length 4 to a DataFrame of height 5

# nth() work

    Code
      summarize(test, foo = nth(x, 2:3))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must have size 1, not size 2.

---

    Code
      summarize(test, foo = nth(x, NA))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` can't be `NA`.

---

    Code
      summarize(test, foo = nth(x, 1.5))
    Condition
      Error in `summarize()`:
      ! Error while running function `nth()` in Polars.
      x `n` must be an integer.

# na_if() works

    Code
      mutate(test, foo = na_if(x, 1:2))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $with_columns()
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c780a207c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c6ea66c59"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1a77bf0"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c4d2870f9", 
                    compress = FALSE)
                base::flush(base::stdout())
                base::flush(base::stderr())
                {
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout(as.environment("tools:callr")$`__callr_data__`$.__stdout__)
                    }
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr(as.environment("tools:callr")$`__callr_data__`$.__stderr__)
                    }
                }
                base::invisible()
            }, error = function(e) {
                {
                    callr_data <- base::as.environment("tools:callr")$`__callr_data__`
                    err <- callr_data$err
                    if (FALSE) {
                        base::assign(".Traceback", base::.traceback(4), envir = callr_data)
                        utils::dump.frames("__callr_dump__")
                        base::assign(".Last.dump", .GlobalEnv$`__callr_dump__`, 
                            envir = callr_data)
                        base::rm("__callr_dump__", envir = .GlobalEnv)
                    }
                    e <- err$process_call(e)
                    e2 <- err$new_error("error in callr subprocess")
                    class <- base::class
                    class(e2) <- base::c("callr_remote_error", class(e2))
                    e2 <- err$add_trace_back(e2)
                    cut <- base::which(e2$trace$scope == "global")[1]
                    if (!base::is.na(cut)) {
                        e2$trace <- e2$trace[-(1:cut), ]
                    }
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c4d2870f9", 
                        ".error"))
                }
            }, interrupt = function(e) {
                {
                    callr_data <- base::as.environment("tools:callr")$`__callr_data__`
                    err <- callr_data$err
                    if (FALSE) {
                        base::assign(".Traceback", base::.traceback(4), envir = callr_data)
                        utils::dump.frames("__callr_dump__")
                        base::assign(".Last.dump", .GlobalEnv$`__callr_dump__`, 
                            envir = callr_data)
                        base::rm("__callr_dump__", envir = .GlobalEnv)
                    }
                    e <- err$process_call(e)
                    e2 <- err$new_error("error in callr subprocess")
                    class <- base::class
                    class(e2) <- base::c("callr_remote_error", class(e2))
                    e2 <- err$add_trace_back(e2)
                    cut <- base::which(e2$trace$scope == "global")[1]
                    if (!base::is.na(cut)) {
                        e2$trace <- e2$trace[-(1:cut), ]
                    }
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c4d2870f9", 
                        ".error"))
                }
            }, callr_message = function(e) {
                base::try({
                    pxlib <- base::as.environment("tools:callr")$`__callr_data__`$pxlib
                    if (base::is.null(e$code)) 
                        e$code <- "301"
                    msg <- base::paste0("base64::", pxlib$base64_encode(base::serialize(e, 
                        NULL)))
                    data <- base::paste0(e$code, " ", base::nchar(msg), "\n", 
                        msg)
                    pxlib$write_fd(3L, data)
                    if (base::inherits(e, "cli_message") && !base::is.null(base::findRestart("cli_message_handled"))) {
                        base::invokeRestart("cli_message_handled")
                    }
                    else if (base::inherits(e, "message") && !base::is.null(base::findRestart("muffleMessage"))) {
                        base::invokeRestart("muffleMessage")
                    }
                })
            }), error = function(e) {
                {
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout(as.environment("tools:callr")$`__callr_data__`$.__stdout__)
                    }
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr(as.environment("tools:callr")$`__callr_data__`$.__stderr__)
                    }
                }
                if (FALSE) {
                    base::try(base::stop(e))
                }
                else {
                    base::invisible()
                }
            }, interrupt = function(e) {
                {
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout(as.environment("tools:callr")$`__callr_data__`$.__stdout__)
                    }
                    {
                        as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr(as.environment("tools:callr")$`__callr_data__`$.__stderr__)
                    }
                }
                if (FALSE) {
                    e
                }
                else {
                    base::invisible()
                }
            })]
         1: Encountered the following error in Rust-Polars:
            	cannot evaluate two Series of different lengths (5 and 2)
      
            Error originated in expression: '[(col("x")) == (Series)]'

