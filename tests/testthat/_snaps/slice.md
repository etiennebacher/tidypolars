# basic slice_sample works

    Code
      slice_sample(pl_iris, n = 2, prop = 0.1)
    Condition
      Error in `slice_sample()`:
      ! You must provide either `n` or `prop`, not both.

---

    Code
      slice_sample(pl_iris, n = 200)
    Condition
      Error in `slice_sample()`:
      ! Cannot take more rows than the total number of rows when `replace = FALSE`.

---

    Code
      slice_sample(pl_iris, prop = 1.2)
    Condition
      Error in `slice_sample()`:
      ! Cannot take more rows than the total number of rows when `replace = FALSE`.

# slice_sample errors on unknown args

    Code
      slice_sample(pl_mtcars, weight_by = cyl > 5, n = 5)
    Condition
      Error in `slice_sample()`:
      ! Argument weight_by is not supported by tidypolars yet.

---

    Code
      slice_sample(pl_mtcars, foo = 1, n = 5)
    Condition
      Error in `slice_sample()`:
      ! `...` must be empty.
      x Problematic argument:
      * foo = 1

