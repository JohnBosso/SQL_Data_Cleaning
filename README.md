
# Layoffs Data Cleaning (SQL Project)

This project focuses on cleaning and preparing a real-world layoffs dataset using structured SQL queries. The dataset contains information about tech company layoffs, including fields such as company name, location, industry, number of employees laid off, percentage laid off, and funding raised.

## Objectives

- Identify and remove duplicate records
- Normalize and correct data inconsistencies
- Handle missing and null values
- Convert text dates to proper SQL `DATE` format
- Standardize formatting across relevant columns

## Tools & Technologies

- **MySQL**: SQL syntax, window functions, CTEs, string functions
- **DBMS**: Any SQL-compliant database (e.g., MySQL Workbench, SQLite)

## Steps Performed

### 1. Duplicate Removal
- Used `ROW_NUMBER()` to detect exact duplicate records.
- Deleted redundant entries by preserving only the first occurrence of each unique row.

### 2. Data Normalization
- Trimmed whitespace from the `company` and `country` columns.
- Unified industry names (e.g., all variations of "Crypto" set to "Crypto").
- Refilled missing industry values using available company data.

### 3. Missing Value Handling
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were null (non-informative).

### 4. Date Transformation
- Converted the `date` column from `TEXT` to `DATE` format using `STR_TO_DATE()`.
- Ensured all date values were stored in SQL’s `DATE` data type.

### 5. Final Cleanup
- Removed trailing punctuation (e.g., '.' from `country` values).
- Ensured consistent formatting for key categorical values.

## Final Output

A clean and standardized dataset stored in `copy2_layoffs` table, ready for further analysis and visualization.

## Key Learnings

- Advanced SQL window functions and CTE usage
- Practical data cleaning techniques in SQL
- Transforming unstructured or messy data into analysis-ready format
