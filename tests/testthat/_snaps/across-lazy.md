# anonymous functions has to return a Polars expression

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! Could not evaluate an anonymous function in `across()`.
      i Are you sure the anonymous function returns a Polars expression?

# need to specify .cols (either named or unnamed)

    Code
      current$collect()
    Condition
      Error in `mutate()`:
      ! You must supply the argument `.cols` in `across()`.

# cannot use external list of functions in across()

    Code
      current$collect()
    Condition
      Error:
      ! When using `across()` in tidypolars, `.fns` doesn't accept an external list of functions or formulas.
      i Instead of `across(.fns = <external_list>)`, do `across(.fns = list(fun1 = ..., fun2 = ...))`
