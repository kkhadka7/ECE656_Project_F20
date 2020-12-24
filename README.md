# ECE656_Project_F20
This repository contains movie dataset and all the files associated with this project. This project creates database and CLI-based client which allows
the user to search movies based on various criteria like genres, any keywords, cast & crew information, production houses, revenue, budget,etc.
It has recommendation feature as well.

Files and Folders:
1. Folder MovieDataset: 
    It contains 
      i. movies_df.csv
      ii. ratings_df.csv
      iii. production_companies_df.csv
      iv. cast_credits_df.csv
      v. crew_credits_df.csv
      vi. genres_df.csv
      vii. keywords_df.csv
2. data_preparation_break_csv.ipynb:
    This python scripts converts original Kaggle Movie Dataset from JSON (from inside csv) to all csv format.
3. load_database.sql
    This file contains all necessary queries to initialize the main database. It creates eight different tables and loads data from MovieDataset to the            database.
4. client.py
    This is the main cli-based client program. Main functions are:
        i. For initialization, user can choose to create new datbase. It uses queries in load_database.sql file to load data from 7 csv files in MovieDataset
            Folder, which should be inside same folder, to the database.
