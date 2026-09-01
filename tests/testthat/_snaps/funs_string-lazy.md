# paste with groups and collapse

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `paste()` in Polars.
      x `collapse` must be a single string or `NULL`, not an integer vector.

# length functions work

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `nchar()` in Polars.
      x `type` must be one of "chars" or "bytes", not "foo".

# pad functions work

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! `str_pad()` doesn't work with a Polars object when `side = "both"`.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! `str_pad()` doesn't work with a Polars object when `use_width = FALSE`.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! `str_pad()` doesn't work with a Polars object when `pad` has a length greater than 1.

# word functions work

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! `word()` doesn't work with a Polars object when `start` or `end` has a length greater than 1.

# split functions work

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `str_split_i()` in Polars.
      x `i` must not be 0.

# trunc functions work

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `str_trunc()` in Polars.
      x `width` (1) is shorter than `ellipsis` (3).

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `str_trunc()` in Polars.
      x `side = "center"` is not supported.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `str_trunc()` in Polars.
      x `side` must be either "left" or "right".

# stringr::str_replace_na works

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not `NA`.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not the number 1.

---

    Code
      collect(current)
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not a character vector.

