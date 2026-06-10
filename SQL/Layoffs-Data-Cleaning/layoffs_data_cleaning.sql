-- Data cleaning  
select * 
from layoffs;
-- 1. Remove Duplicates 
-- 2. standardize the data
-- 3- null values or blank values
-- 4- Remove Any Columns

create table layoffs_staging 
like layoffs;
 
 
select * 
from layoffs_staging;

insert layoffs_staging 
select * 
from layoffs;
with doublons as (
select *, 
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised ) AS row_num
from layoffs_staging 
)

select * 
from doublons 
where row_num > 1;

select * 
from layoffs_staging 
where company = 'casper';

 with doublons as (
select *, 
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised ) AS row_num
from layoffs_staging 
)

delete
from doublons 
where row_num > 1; 





CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` int DEFAULT NULL,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2;


INSERT INTO layoffs_staging2(
select *, 
ROW_NUMBER() OVER (
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised ) AS row_num
from layoffs_staging 
);

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;

SELECT *
from layoffs_staging2
WHERE row_num > 1;

select * 
from layoffs_staging2;

-- standardizing  data

select company, TRIM(company)
from layoffs_staging2;

select distinct country, trim(trailing '.' from country) 
from layoffs_staging 
order by 1;


SET SQL_SAFE_UPDATES = 0;
update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';
SET SQL_SAFE_UPDATES = 1;

SELECT `date`
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

SELECT
    `date`,
    STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2
LIMIT 10;

SELECT `date`
FROM layoffs_staging2
LIMIT 10;

SELECT COUNT(*)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` IS NOT NULL;

SELECT `date`
FROM layoffs_staging2
LIMIT 10;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
   OR percentage_laid_off IS NULL;


SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1 
join layoffs_staging2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry is null  or t1.industry = '') and t2.industry is not null;    
 
 DELETE 
 FROM layoffs_staging2 
 WHERE total_laid_off IS NULL 
 AND percentage_laid_off is null;

ALTER TABLE layoffs_staging2 
DROP column row_num;










