# paste with groups and collapse

    Code
      mutate(test_pl, foo = paste(x, collapse = 1:2))
    Condition
      Error in `mutate()`:
      ! Error while running function `paste()` in Polars.
      x `collapse` must be a single string or `NULL`, not an integer vector.

# length functions work

    Code
      mutate(test_pl, foo = nchar(x4, "foo"))
    Condition
      Error in `mutate()`:
      ! Error while running function `nchar()` in Polars.
      x `type` must be one of "chars" or "bytes", not "foo".

# pad functions work

    Code
      mutate(test_pl, foo = str_pad(x6, width = 10, side = "both"))
    Condition
      Error in `mutate()`:
      ! `str_pad()` doesn't work with a Polars object when `side = "both"`

---

    Code
      mutate(test_pl, foo = str_pad(x6, width = 10, use_width = FALSE))
    Condition
      Error in `mutate()`:
      ! `str_pad()` doesn't work with a Polars object when `use_width = FALSE`

---

    Code
      mutate(test_pl, foo = str_pad(x6, width = 10, pad = c("*", "-")))
    Condition
      Error in `mutate()`:
      ! `str_pad()` doesn't work with a Polars object when `pad` has a length greater than 1.

# word functions work

    Code
      mutate(test_pl, foo = word(x7, c(1L, 2L)))
    Condition
      Error in `mutate()`:
      ! `word()` doesn't work with a Polars object when `start` or `end` has a length greater than 1.

# split functions work

    Code
      mutate(test_pl, foo = str_split_i(x8, "-", i = 0))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_split_i()` in Polars.
      x `i` must not be 0.

# trunc functions work

    Code
      mutate(test_pl, foo = str_trunc(x1, 1))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_trunc()` in Polars.
      x `width` (1) is shorter than `ellipsis` (3).

---

    Code
      mutate(test_pl, foo = str_trunc(x1, 5, side = "center"))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_trunc()` in Polars.
      x `side = "center"` is not supported.

---

    Code
      mutate(test_pl, foo = str_trunc(x1, 5, side = "foobar"))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_trunc()` in Polars.
      x `side` must be either "left" or "right".

# stringr::str_replace_na works

    Code
      mutate(test_pl, rep = str_replace_na(generic, replacement = NA))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not `NA`.

---

    Code
      mutate(test_pl, rep = str_replace_na(generic, replacement = 1))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not the number 1.

---

    Code
      mutate(test_pl, rep = str_replace_na(generic, replacement = c("a", "b")))
    Condition
      Error in `mutate()`:
      ! Error while running function `str_replace_na()` in Polars.
      x `replacement` must be a single string, not a character vector.

