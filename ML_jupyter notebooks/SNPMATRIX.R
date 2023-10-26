df <- read.csv("/Users/kakembo/Downloads/snp_matrix.csv", )
View(df)

df_filtered <- df %>%
  select(-ends_with(".REF"))

View(df_filtered)
df_filtered$X1552.ALT[1]

df_filtered %>%
  mutate_all(~na_if(., ""))

row.names(df_filtered) <- df_filtered$X.Sample
df_filtered$X <- NULL
df_filtered$X.Sample <- NULL
df_filtered_copy <- df_filtered
View(df_filtered_copy)

for (c in 1:ncol(df_filtered)) {
  for (r in 1:nrow(df_filtered)) {
    #print(df_filtered[r,c])
    if (is.na(df_filtered[r,c]) || df_filtered[r,c] == "") {
      #print(df_filtered[r,c])
      df_filtered[r,c] <- 0
    } else {
      df_filtered[r,c] <- 1
    }
  }
}

n <- names(df_filtered) %>% gsub("X(\\d+)\\.ALT", "POS_\\1", .)
n[1:20]
names(df_filtered) <- n


write.csv(df_filtered, "/Users/kakembo/Desktop/Projects/Sandra_Chana/Snp_Matrix_file.csv")
