-- Query 1: Top 10 Highest Paying Data Analyst Jobs

SELECT 
    title,
    company_name,
    location,
    salary,
    salary_avg::NUMERIC AS avg_salary
FROM jobs
WHERE 
    title ILIKE '%Data Analyst%'
    AND salary_avg IS NOT NULL
ORDER BY avg_salary DESC
LIMIT 10;


-- Query 2: Most In-Demand Skills

SELECT 
    skill,
    COUNT(*) AS demand_count
FROM jobs,
UNNEST(string_to_array(
REPLACE(REPLACE(description_tokens, '[', ''), ']', ''),
', ')) AS skill
WHERE title ILIKE '%Data Analyst%'
GROUP BY skill
ORDER BY demand_count DESC
LIMIT 10;


-- Query 3: Top Paying Skills

SELECT 
    skill,
    ROUND(AVG(salary_avg::NUMERIC),0) AS avg_salary
FROM jobs,
UNNEST(string_to_array(
REPLACE(REPLACE(description_tokens, '[', ''), ']', ''),
', ')) AS skill
WHERE salary_avg IS NOT NULL
GROUP BY skill
ORDER BY avg_salary DESC
LIMIT 10;


-- Query 4: Remote vs Onsite Jobs

SELECT 
    location,
    COUNT(*) AS job_count
FROM jobs
WHERE title ILIKE '%Data Analyst%'
GROUP BY location
ORDER BY job_count DESC
LIMIT 10;


-- Query 5: Top Hiring Companies

SELECT 
    company_name,
    COUNT(*) AS total_jobs
FROM jobs
WHERE title ILIKE '%Data Analyst%'
GROUP BY company_name
ORDER BY total_jobs DESC
LIMIT 10;


-- Query 6: Average Salary by Company

SELECT 
    company_name,
    ROUND(AVG(salary_avg::NUMERIC),0) AS avg_salary
FROM jobs
WHERE salary_avg IS NOT NULL
GROUP BY company_name
ORDER BY avg_salary DESC
LIMIT 10;


-- Query 7: CTE Query - Top Companies Hiring

WITH company_jobs AS (
    SELECT 
        company_name,
        COUNT(*) AS job_count
    FROM jobs
    WHERE title ILIKE '%Data Analyst%'
    GROUP BY company_name
)

SELECT *
FROM company_jobs
ORDER BY job_count DESC
LIMIT 10;


-- Query 8: Window Function - Salary Ranking

SELECT 
    title,
    company_name,
    salary_avg::NUMERIC AS salary,
    RANK() OVER (ORDER BY salary_avg::NUMERIC DESC) AS salary_rank
FROM jobs
WHERE salary_avg IS NOT NULL
LIMIT 15;