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

# dots must be empty

    Code
      slice_sample(pl_mtcars, foo = 1, n = 5)
    Condition
      Error in `slice_sample()`:
      ! `...` must be empty.

