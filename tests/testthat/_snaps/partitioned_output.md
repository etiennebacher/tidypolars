# partition_by() + key works

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 00000000.csv
      |   +-- cyl=6.0
      |   |   \-- 00000000.csv
      |   \-- cyl=8.0
      |       \-- 00000000.csv
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 00000000.csv
          +-- cyl=6.0
          |   \-- 00000000.csv
          \-- cyl=8.0
              \-- 00000000.csv

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 00000000.ipc
      |   +-- cyl=6.0
      |   |   \-- 00000000.ipc
      |   \-- cyl=8.0
      |       \-- 00000000.ipc
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 00000000.ipc
          +-- cyl=6.0
          |   \-- 00000000.ipc
          \-- cyl=8.0
              \-- 00000000.ipc

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 00000000.jsonl
      |   +-- cyl=6.0
      |   |   \-- 00000000.jsonl
      |   \-- cyl=8.0
      |       \-- 00000000.jsonl
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 00000000.jsonl
          +-- cyl=6.0
          |   \-- 00000000.jsonl
          \-- cyl=8.0
              \-- 00000000.jsonl

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 00000000.parquet
      |   +-- cyl=6.0
      |   |   \-- 00000000.parquet
      |   \-- cyl=8.0
      |       \-- 00000000.parquet
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 00000000.parquet
          +-- cyl=6.0
          |   \-- 00000000.parquet
          \-- cyl=8.0
              \-- 00000000.parquet

# partition_by() + key + include_key works

    Code
      sink_csv(my_lf, partition_by(out_path, max_rows_per_file = 1, include_key = FALSE),
      mkdir = TRUE)
    Condition
      Error in `sink_csv()`:
      ! `include_key` cannot be used without specifying `key`.

# partition_by() + max_rows_per_file works

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- 00000000.csv
      +-- 00000001.csv
      +-- 00000002.csv
      +-- 00000003.csv
      +-- 00000004.csv
      +-- 00000005.csv
      \-- 00000006.csv

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- 00000000.ipc
      +-- 00000001.ipc
      +-- 00000002.ipc
      +-- 00000003.ipc
      +-- 00000004.ipc
      +-- 00000005.ipc
      \-- 00000006.ipc

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- 00000000.jsonl
      +-- 00000001.jsonl
      +-- 00000002.jsonl
      +-- 00000003.jsonl
      +-- 00000004.jsonl
      +-- 00000005.jsonl
      \-- 00000006.jsonl

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- 00000000.parquet
      +-- 00000001.parquet
      +-- 00000002.parquet
      +-- 00000003.parquet
      +-- 00000004.parquet
      +-- 00000005.parquet
      \-- 00000006.parquet

# partition_by_key() is defunct

    Code
      sink_csv(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
    Condition
      Error in `sink_csv()`:
      ! `partition_by_key()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `key` argument of `partition_by()` instead.

---

    Code
      sink_ipc(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
    Condition
      Error in `sink_ipc()`:
      ! `partition_by_key()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `key` argument of `partition_by()` instead.

---

    Code
      sink_ndjson(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
    Condition
      Error in `sink_ndjson()`:
      ! `partition_by_key()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `key` argument of `partition_by()` instead.

---

    Code
      sink_parquet(my_lf, partition_by_key(out_path, by = c("am", "cyl")), mkdir = TRUE)
    Condition
      Error in `sink_parquet()`:
      ! `partition_by_key()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `key` argument of `partition_by()` instead.

# partition_by_max_size() is defunct

    Code
      sink_csv(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
    Condition
      Error in `sink_csv()`:
      ! `partition_by_max_size()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `max_rows_per_file` argument of `partition_by()` instead.

---

    Code
      sink_ipc(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
    Condition
      Error in `sink_ipc()`:
      ! `partition_by_max_size()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `max_rows_per_file` argument of `partition_by()` instead.

---

    Code
      sink_ndjson(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
    Condition
      Error in `sink_ndjson()`:
      ! `partition_by_max_size()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `max_rows_per_file` argument of `partition_by()` instead.

---

    Code
      sink_parquet(my_lf, partition_by_max_size(out_path, max_size = 5), mkdir = TRUE)
    Condition
      Error in `sink_parquet()`:
      ! `partition_by_max_size()` was deprecated in tidypolars 0.16.0 and is now defunct.
      i Please use the `max_rows_per_file` argument of `partition_by()` instead.

