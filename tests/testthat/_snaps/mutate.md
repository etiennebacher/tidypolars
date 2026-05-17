# scalar value works

    Code
      mutate(test_pl, Sepal.Width = 1:2)
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

---

    Code
      mutate(test_pl, Sepal.Width = letters[1:2])
    Condition
      Error in `.data$with_columns()`:
      ! Evaluation failed in `$with_columns()`.
      Caused by error:
      ! Evaluation failed in `$collect()`.
      Caused by error:
      ! lengths don't match: unable to add a column of length 2 to a DataFrame of height 150

# custom function that doesn't return Polars expression

    Code
      mutate(test_pl, x = foo(Sepal.Length, Petal.Length))
    Condition
      Error in `mutate()`:
      ! Error while running function `foo()` in Polars.
      x non-numeric argument to mathematical function

# argument .keep works

    Code
      mutate(test_pl, x = 1, .keep = "foo")
    Condition
      Error in `mutate()`:
      ! `.keep` must be one of "all", "used", "unused", or "none", not "foo".

# arguments .before and .after error consistently

    Code
      mutate(test_pl, x = Sepal.Length, .before = missing_col)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

    Code
      mutate(test_pl, x = Sepal.Length, .after = missing_col)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

---

    Code
      mutate(test_pl, x = Sepal.Length, .before = Sepal.Width, .after = Species)
    Condition
      Error in `relocate()`:
      ! You can specify either `.before` or `.after` but not both.

---

    Code
      mutate(test_pl, Sepal.Width = Sepal.Width * 2, .before = missing_col)
    Condition
      Error in `relocate()`:
      ! Can't select columns that don't exist.
      x Column `missing_col` doesn't exist.

