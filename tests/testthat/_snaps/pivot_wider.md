# names_prefix works

    Code
      pivot_wider(pl_fish_encounters, names_from = station, values_from = seen,
        names_prefix = c("foo1", "foo2"))
    Condition
      Error in `pivot_wider()`:
      ! `names_prefix` must be of length 1.

# error when overwriting existing column

    Code
      pivot_wider(df, names_from = key, values_from = val)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $pivot():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-stdout-98b85b91377a"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-stderr-98b84c553531"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-fun-98b822007e55"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
            	duplicate: column with name 'a' has more than one occurrences

# `names_from` must be supplied if `name` isn't in data

    Code
      pivot_wider(df, values_from = val)
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `name` doesn't exist.

# `values_from` must be supplied if `value` isn't in data

    Code
      pivot_wider(df, names_from = key)
    Condition
      Error in `pivot_wider()`:
      ! Can't select columns that don't exist.
      x Column `value` doesn't exist.

# `names_from` must identify at least 1 column

    Code
      pivot_wider(df, names_from = starts_with("foo"), values_from = val)
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `names_from`.

# `values_from` must identify at least 1 column

    Code
      pivot_wider(df, names_from = key, values_from = starts_with("foo"))
    Condition
      Error in `pivot_wider()`:
      ! Must select at least one variable in `values_from`.

# `id_cols` can't select columns from `names_from` or `values_from`

    Code
      pivot_wider(df, id_cols = name, names_from = name, values_from = value)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $pivot():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-stdout-98b85b91377a"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-stderr-98b84c553531"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-fun-98b822007e55"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
            	index cannot be zero length

---

    Code
      pivot_wider(df, id_cols = value, names_from = name, values_from = value)
    Condition
      Error:
      ! Execution halted with the following contexts
         0: In R: in $pivot():
         0: During function call [base::tryCatch(base::withCallingHandlers({
                {
                    {
                        assign(".__stdout__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stdout_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-stdout-98b85b91377a"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                    {
                        assign(".__stderr__", as.environment("tools:callr")$`__callr_data__`$pxlib$set_stderr_file("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-stderr-98b84c553531"), 
                            envir = as.environment("tools:callr")$`__callr_data__`)
                    }
                }
                base::saveRDS(base::do.call(base::do.call, base::c(base::readRDS("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-fun-98b822007e55"), 
                    base::list(envir = .GlobalEnv, quote = TRUE)), envir = .GlobalEnv, 
                    quote = TRUE), file = "C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
                    base::saveRDS(base::list("error", e2, e), file = base::paste0("C:\\Users\\etienne\\AppData\\Local\\Temp\\RtmpaeY3d2\\callr-rs-result-98b8150d3ff1", 
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
            	index cannot be zero length

