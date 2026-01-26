# can only use rowwise() on a subset of functions

    Code
      mutate(test_pl, m = range(c(x, y, !z)))
    Condition
      Error in `mutate()`:
      x Can't use function `pl_range()` in rowwise mode.
      i For now, `rowwise()` only works on the following functions:
      i `mean()`, `median()`, `min()`, `max()`, `sum()`, `all()`, `any()`

# can't apply rowwise on grouped data, and vice versa

    Code
      rowwise(group_by(test_pl, cyl))
    Condition
      Error in `rowwise()`:
      ! Cannot use `rowwise()` on grouped data.

---

    Code
      group_by(rowwise(test_pl), cyl)
    Condition
      Error in `group_by()`:
      ! Cannot use `group_by()` if `rowwise()` is also used.
      i Use `ungroup()` first, and then `group_by()`.

