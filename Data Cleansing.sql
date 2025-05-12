SELECT *
FROM layoffs;

-- creating a copy of the dataset where tranformation will happen
CREATE TABLE copy_layoffs
LIKE layoffs;

INSERT copy_layoffs
SELECT *
FROM layoffs;

SELECT *
FROM copy_layoffs;

-- finding duplicates in the dataset
WITH iden_duplicates AS
( 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS row_num
FROM copy_layoffs
)
SELECT * 
FROM iden_duplicates 
WHERE row_num > 1;

-- Create a table with column row_num added since deletion from cte is not possible
CREATE TABLE copy2_layoffs (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting data into the new table
INSERT copy2_layoffs
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS row_num
FROM copy_layoffs;

-- deleting duplicate fron new table
DELETE
FROM copy2_layoffs
WHERE row_num > 1;

SELECT *
FROM copy2_layoffs
;

-- checking for errors in each column
SELECT DISTINCT(country) 
FROM copy2_layoffs
ORDER BY 1;

-- triming compony column to remove white spaces
UPDATE copy2_layoffs
SET company = TRIM(company);

-- updating all intances of crypto
UPDATE copy2_layoffs
SET industry = 'Crypto'
WHERE industry LIKE '%Crypto%';

-- finding other company listing where industry is listed
UPDATE copy2_layoffs
SET industry = NULL
WHERE industry = '';

SELECT t1.industry, t2.industry
FROM copy2_layoffs t1 
JOIN copy2_layoffs t2 
ON t1.company = t2.company
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

UPDATE copy2_layoffs t1
JOIN copy2_layoffs t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND
t2.industry IS NOT NULL;

-- checking of Company bally has anyother occurence with industry mentioned
SELECT * FROM copy2_layoffs
WHERE industry LIKE '%bally%';

-- deleting all rows where total layoff and percentage is null
SELECT *
FROM copy2_layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM copy2_layoffs
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- update date from a text to datetime
SELECT `date`
FROM copy2_layoffs;

UPDATE copy2_layoffs
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE copy2_layoffs
MODIFY COLUMN `date` DATE;

-- triming '.' from United States
SELECT DISTINCT(country)
FROM copy2_layoffs
ORDER BY 1;

UPDATE copy2_layoffs
SET country = TRIM(TRAILING '.' FROM country);
