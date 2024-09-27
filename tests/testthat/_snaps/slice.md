# slice_sample works

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

