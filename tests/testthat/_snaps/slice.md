# basic slice_sample works

    Code
      slice_sample(test_pl, n = 2, prop = 0.1)
    Condition
      Error in `slice_sample()`:
      ! You must provide either `n` or `prop`, not both.

# dots must be empty

    Code
      slice_sample(test_pl, foo = 1, n = 5)
    Condition
      Error in `slice_sample()`:
      ! `...` must be empty.

