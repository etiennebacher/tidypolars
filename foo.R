library(rlang)


expr_env = new.env(parent = emptyenv())

# Define a custom environment where I store a function.
# This is done in another package.
some_env <- new.env(parent = emptyenv())
class(some_env) <- "custom_class"
some_env$some_function <- function(x) {
  print(x)
}

# Make a user-facing function that calls the function stored in the custom
# environment under the hood
user_facing_fn <- function(val = 1) {
  some_env$some_function(val)
}

user_facing_fn()

expr_env[["1"]]


some_env <- eapply(some_env, function(env) {
  function(x) {
    foo = env
    expr = call2(quote(foo), x)
    fc = as.list(frame_call())
    fc1 = fc[[1]]
    fc[[1]] <- NULL
    fc <- lapply(fc, eval_bare, env = caller_env())
    full_call <- call2(fc1, !!!fc)
    assign(
      as.character(length(expr_env) + 1),
      full_call,
      envir = expr_env
    )
    call2(foo, !!!fc) |> eval_bare()
  }
})

user_facing_fn()

expr_env[["1"]]







# Define a custom `$` to access the call before evaluating it
# `$.custom_class` <- function(x, name) {
#   fc <- rlang::frame_call()
#
#   ### For debugging
#   cat("----------------\n")
#   print(fc)
#   cat("----------------\n")
#   print(str(fc))
#   cat("----------------\n")
#   print(deparse(fc))
#   ###
#
#   NextMethod("$")  # <<<<<<<<<<<<< Not interested in this part
# }
#
# user_facing_fn()

