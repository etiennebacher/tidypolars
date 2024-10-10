# simple filter query

    Code
      show_query(filter(as_polars_df(iris), Sepal.Length > 5))
    Output
      Pure polars expression:
      
      <data>

# simple selectquery

    Code
      show_query(select(as_polars_df(iris), starts_with("Sep"), matches("ies$")))
    Output
      Pure polars expression:
      
      <data>

# simple mutate query

    Code
      show_query(mutate(as_polars_df(iris), x = (Petal.Length / Petal.Width) > 3))
    Output
      Pure polars expression:
      
      <data>

# simple arrange query

    Code
      show_query(arrange(as_polars_df(iris), Sepal.Length, -Sepal.Width, desc(Species)))
    Output
      Pure polars expression:
      
      <data>

# complex_query

    Code
      show_query(arrange(drop_na(pivot_longer(as_polars_df(tidyr::relig_income),
      !religion, names_to = "income", values_to = "count")), religion, count))
    Output
      Pure polars expression:
      
      <data>$
        drop_nulls(NULL)$
        sort(list(<pointer: 0x769394383940>, <pointer: 0x769394383b20>), descending = c(FALSE, FALSE))

