_default:
    just --list

document:
    Rscript -e 'devtools::document()'

test filter="":
    Rscript -e 'devtools::test(filter = commandArgs(TRUE)[[1]])' {{ quote(filter) }}

lint:
    jarl check .

format:
    air format .

lint-format:
    jarl check .
    air format .
