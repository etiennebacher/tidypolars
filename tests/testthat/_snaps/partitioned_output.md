# partition_by_key() works

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 0.csv
      |   +-- cyl=6.0
      |   |   \-- 0.csv
      |   \-- cyl=8.0
      |       \-- 0.csv
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 0.csv
          +-- cyl=6.0
          |   \-- 0.csv
          \-- cyl=8.0
              \-- 0.csv

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 0.ipc
      |   +-- cyl=6.0
      |   |   \-- 0.ipc
      |   \-- cyl=8.0
      |       \-- 0.ipc
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 0.ipc
          +-- cyl=6.0
          |   \-- 0.ipc
          \-- cyl=8.0
              \-- 0.ipc

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 0.jsonl
      |   +-- cyl=6.0
      |   |   \-- 0.jsonl
      |   \-- cyl=8.0
      |       \-- 0.jsonl
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 0.jsonl
          +-- cyl=6.0
          |   \-- 0.jsonl
          \-- cyl=8.0
              \-- 0.jsonl

---

    Code
      fs::dir_tree(out_path)
    Output
      <scrubbed>
      +-- am=0.0
      |   +-- cyl=4.0
      |   |   \-- 0.parquet
      |   +-- cyl=6.0
      |   |   \-- 0.parquet
      |   \-- cyl=8.0
      |       \-- 0.parquet
      \-- am=1.0
          +-- cyl=4.0
          |   \-- 0.parquet
          +-- cyl=6.0
          |   \-- 0.parquet
          \-- cyl=8.0
              \-- 0.parquet

# partition_by_max_size() works

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

