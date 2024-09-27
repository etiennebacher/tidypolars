# error if no common variables and and `by` no provided

    Code
      left_join(test, polars::pl$DataFrame(iris))
    Condition
      Error in `left_join()`:
      ! `by` must be supplied when `x` and `y` have no common variables.
      i Use `cross_join()` to perform a cross-join.

# argument suffix works

    Code
      left_join(test, test2, by = c("x", "y"), suffix = c(".hi"))
    Condition
      Error in `left_join()`:
      ! `suffix` must be of length 2.

# suffix + join_by works

    Code
      left_join(test, test2, by = join_by(x, y), suffix = c(".hi"))
    Condition
      Error in `left_join()`:
      ! `suffix` must be of length 2.

# argument relationship works

    Code
      left_join(test, test2, by = join_by(x, y), relationship = "foo")
    Condition
      Error in `left_join()`:
      ! `relationship` must be one of "one-to-one", "one-to-many", "many-to-one", or "many-to-many", not "foo".

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "one-to-one"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill 1:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "many-to-one"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill m:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "one-to-one"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill 1:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "many-to-one"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill m:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "one-to-one"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill 1:1 validation

---

    Code
      do.call(i, list(country, country_year, join_by(iso), relationship = "many-to-one"))
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill m:1 validation

---

    Code
      right_join(country, country_year, join_by(iso), relationship = "one-to-one")
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill 1:1 validation

---

    Code
      right_join(country, country_year, join_by(iso), relationship = "one-to-many")
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $collect():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stdout-6c5c5dfb740c"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-stderr-6c5c544f48d0"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-fun-6c5c1622497"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpoTqvlx\\callr-rs-result-6c5c24291f8f", 
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
            	join keys did not fulfill 1:m validation

# argument na_matches works

    Code
      left_join(pdf1, pdf2, na_matches = "foo")
    Condition
      Error in `left_join()`:
      ! `relationship` must be one of "na" or "never", not "foo".

# error if two inputs don't have the same class

    Code
      left_join(test, iris)
    Condition
      Error in `left_join()`:
      ! `x` and `y` must be either two DataFrames or two LazyFrames.

