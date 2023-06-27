# relig_income <- tidyr::relig_income |>
#   constructive::construct()

relig_income <- data.frame(
  religion = c(
    "Agnostic", "Atheist", "Buddhist", "Catholic", "Don't know/refused",
    "Evangelical Prot", "Hindu", "Historically Black Prot", "Jehovah's Witness",
    "Jewish", "Mainline Prot", "Mormon", "Muslim", "Orthodox", "Other Christian",
    "Other Faiths", "Other World Religions", "Unaffiliated"
  ),
  `<$10k` = c(27, 12, 27, 418, 15, 575, 1, 228, 20, 19, 289, 29, 6, 13, 9, 20, 5, 217),
  `$10-20k` = c(34, 27, 21, 617, 14, 869, 9, 244, 27, 19, 495, 40, 7, 17, 7, 33, 2, 299),
  `$20-30k` = c(60, 37, 30, 732, 15, 1064, 7, 236, 24, 25, 619, 48, 9, 23, 11, 40, 3, 374),
  `$30-40k` = c(81, 52, 34, 670, 11, 982, 9, 238, 24, 25, 655, 51, 10, 32, 13, 46, 4, 365),
  `$40-50k` = c(76, 35, 33, 638, 10, 881, 11, 197, 21, 30, 651, 56, 9, 32, 13, 49, 2, 341),
  `$50-75k` = c(137, 70, 58, 1116, 35, 1486, 34, 223, 30, 95, 1107, 112, 23, 47, 14, 63, 7, 528),
  `$75-100k` = c(122, 73, 62, 949, 21, 949, 47, 131, 15, 69, 939, 85, 16, 38, 18, 46, 3, 407),
  `$100-150k` = c(109, 59, 39, 792, 17, 723, 48, 81, 11, 87, 753, 49, 8, 42, 14, 40, 4, 321),
  `>150k` = c(84, 74, 53, 633, 18, 414, 54, 78, 6, 151, 634, 42, 6, 46, 12, 41, 4, 258),
  `Don't know/refused` = c(96, 76, 54, 1489, 116, 1529, 37, 339, 37, 162, 1328, 69, 22, 73, 18, 71, 8, 597),
  check.names = FALSE
)

usethis::use_data(relig_income, overwrite = TRUE)


# fish_encounters <- tidyr::fish_encounters |>
#   constructive::construct()

fish_encounters <- data.frame(
  fish = factor(rep(
    c(
      "4842", "4843", "4844", "4845", "4847", "4848", "4849", "4850", "4851",
      "4854", "4855", "4857", "4858", "4859", "4861", "4862", "4863", "4864",
      "4865"
    ),
    c(
      11L, 11L, 11L, 5L, 3L, 4L, 2L, 6L, 2L, 2L, 5L, 9L, 11L, 5L,
      11L, 9L, 2L, 2L, 3L
    )
  )),
  station = factor(
    c(
      "Release", "I80_1", "Lisbon", "Rstr", "Base_TD", "BCE", "BCW", "BCE2", "BCW2",
      "MAE", "MAW", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD", "BCE", "BCW",
      "BCE2", "BCW2", "MAE", "MAW", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD",
      "BCE", "BCW", "BCE2", "BCW2", "MAE", "MAW", "Release", "I80_1", "Lisbon",
      "Rstr", "Base_TD", "Release", "I80_1", "Lisbon", "Release", "I80_1", "Lisbon",
      "Rstr", "Release", "I80_1", "Release", "I80_1", "Rstr", "Base_TD", "BCE",
      "BCW", "Release", "I80_1", "Release", "I80_1", "Release", "I80_1", "Lisbon",
      "Rstr", "Base_TD", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD", "BCE",
      "BCW", "BCE2", "BCW2", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD", "BCE",
      "BCW", "BCE2", "BCW2", "MAE", "MAW", "Release", "I80_1", "Lisbon", "Rstr",
      "Base_TD", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD", "BCE", "BCW",
      "BCE2", "BCW2", "MAE", "MAW", "Release", "I80_1", "Lisbon", "Rstr", "Base_TD",
      "BCE", "BCW", "BCE2", "BCW2", "Release", "I80_1", "Release", "I80_1",
      "Release", "I80_1", "Lisbon"
    ),
    levels = c(
      "Release", "I80_1", "Lisbon", "Rstr", "Base_TD", "BCE", "BCW", "BCE2", "BCW2",
      "MAE", "MAW"
    )
  ),
  seen = rep(1L, 114L)
)

usethis::use_data(fish_encounters, overwrite = TRUE)



library(dplyr)

rd_files <- list.files(paste0("C:\\Users\\etienne\\Desktop\\Divers\\r-polars\\man")) |>
  tools::file_path_sans_ext()

rd_files <- rd_files[grepl("^Expr\\w+", rd_files, ignore.case = FALSE)]

expr_category <- gsub("Expr", "", rd_files)
expr_category <- gsub("_.*", "", expr_category)
expr_category[expr_category == ""] <- "default"

rd_files <- gsub("Expr(.*)_", "", rd_files)

r_polars_funs <- data.frame(
  category = expr_category,
  polars_funs = rd_files,
  r_funs = rd_files
) |>
  mutate(
    r_funs = case_match(
      r_funs,
      "std" ~ "sd",
      .default = r_funs
    )
  ) |>
  distinct() |>
  arrange(category, polars_funs, .locale = "en")

usethis::use_data(r_polars_funs, overwrite = TRUE, internal = TRUE)













