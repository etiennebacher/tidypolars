_default:
    just --list

document:
  Rscript -e 'devtools::document()'

test:
  Rscript -e 'devtools::test()'

lint:
  jarl check .

format:
  air format .

lint-format:
  jarl check .
  air format .



