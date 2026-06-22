-- ============================================
-- UK JOB MARKET ANALYSIS - SQL QUERIES
-- ============================================
-- These queries analyze job listings data
-- Database: job_listings table

-- ============================================
-- 1. SALARY ANALYSIS BY ROLE
-- ============================================

-- Average salary by role type
SELECT 
    role,
    COUNT(*) as total_listings,
    ROUND(AVG(salary_min), 0) as avg_min_salary,
    ROUND(AVG(salary_max), 0) as avg_max_salary,
    ROUND((AVG(salary_max) + AVG(salary_min)) / 2, 0) as avg_mid_salary,
    MIN(salary_min) as min_listed,
    MAX(salary_max) as max_listed
FROM job_listings
GROUP BY role
ORDER BY avg_max_salary DESC;


-- Salary distribution by role and experience level
SELECT 
    role,
    experience_level,
    COUNT(*) as count,
    ROUND(AVG(salary_min), 0) as avg_min,
    ROUND(AVG(salary_max), 0) as avg_max,
    ROUND((AVG(salary_max) + AVG(salary_min)) / 2, 0) as avg_salary
FROM job_listings
GROUP BY role, experience_level
ORDER BY role, experience_level;


-- ============================================
-- 2. GEOGRAPHIC ANALYSIS
-- ============================================

-- Jobs and salary by location
SELECT 
    location,
    COUNT(*) as total_jobs,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM job_listings), 2) as pct_of_market,
    ROUND(AVG(salary_min), 0) as avg_min_salary,
    ROUND(AVG(salary_max), 0) as avg_max_salary,
    ROUND((AVG(salary_max) + AVG(salary_min)) / 2, 0) as avg_salary
FROM job_listings
WHERE location IS NOT NULL
GROUP BY location
ORDER BY total_jobs DESC
LIMIT 20;


-- Remote vs On-site vs Hybrid
SELECT 
    job_type,
    COUNT(*) as count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM job_listings), 2) as percentage,
    ROUND(AVG(salary_min), 0) as avg_min,
    ROUND(AVG(salary_max), 0) as avg_max
FROM job_listings
GROUP BY job_type
ORDER BY count DESC;


-- ============================================
-- 3. SKILLS ANALYSIS
-- ============================================

-- Top 20 most demanded skills
SELECT 
    skill,
    COUNT(*) as frequency,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM job_skills), 2) as percentage,
    ROUND(AVG(salary_max), 0) as avg_salary_for_skill
FROM job_skills
GROUP BY skill
ORDER BY frequency DESC
LIMIT 20;


-- Skills by role type (top 10 per role)
SELECT 
    role,
    skill,
    COUNT(*) as frequency,
    ROUND(100.0 * COUNT(*) / (
        SELECT COUNT(*) FROM job_skills WHERE role = outer_js.role
    ), 2) as percentage_in_role
FROM job_skills outer_js
GROUP BY role, skill
ORDER BY role, frequency DESC;


-- Skill combinations that correlate with higher salary
SELECT 
    jl.role,
    GROUP_CONCAT(DISTINCT js.skill ORDER BY js.skill) as skill_combo,
    COUNT(*) as count,
    ROUND(AVG(jl.salary_max), 0) as avg_salary
FROM job_listings jl
LEFT JOIN job_skills js ON jl.id = js.job_id
GROUP BY jl.role
HAVING COUNT(DISTINCT js.skill) >= 3
ORDER BY avg_salary DESC
LIMIT 15;


-- ============================================
-- 4. EXPERIENCE REQUIREMENTS
-- ============================================

-- Average experience required by role
SELECT 
    role,
    COUNT(*) as total_roles,
    ROUND(AVG(CAST(experience_years_min AS DECIMAL)), 1) as min_exp_avg,
    ROUND(AVG(CAST(experience_years_max AS DECIMAL)), 1) as max_exp_avg,
    MIN(experience_years_min) as min_min_exp,
    MAX(experience_years_max) as max_max_exp
FROM job_listings
WHERE experience_years_min IS NOT NULL
GROUP BY role
ORDER BY min_exp_avg DESC;


-- ============================================
-- 5. COMPANY SIZE ANALYSIS
-- ============================================

-- Salary trends by company size
SELECT 
    company_size,
    COUNT(*) as count,
    ROUND(AVG(salary_min), 0) as avg_min_salary,
    ROUND(AVG(salary_max), 0) as avg_max_salary,
    ROUND((AVG(salary_max) + AVG(salary_min)) / 2, 0) as avg_salary
FROM job_listings
WHERE company_size IS NOT NULL
GROUP BY company_size
ORDER BY avg_salary DESC;


-- Companies with most job openings
SELECT 
    company_name,
    COUNT(*) as open_positions,
    COUNT(DISTINCT role) as role_types,
    ROUND(AVG(salary_min), 0) as avg_min_salary,
    ROUND(AVG(salary_max), 0) as avg_max_salary
FROM job_listings
GROUP BY company_name
ORDER BY open_positions DESC
LIMIT 20;


-- ============================================
-- 6. ROLE DISTRIBUTION
-- ============================================

-- Market share by role
SELECT 
    role,
    COUNT(*) as count,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM job_listings), 2) as market_percentage
FROM job_listings
GROUP BY role
ORDER BY count DESC;


-- ============================================
-- 7. JOB POSTING TRENDS
-- ============================================

-- New jobs posted by date (monthly)
SELECT 
    DATE_TRUNC('month', date_posted) as month,
    COUNT(*) as new_jobs,
    COUNT(DISTINCT role) as unique_roles,
    ROUND(AVG(salary_max), 0) as avg_salary
FROM job_listings
GROUP BY DATE_TRUNC('month', date_posted)
ORDER BY month DESC;


-- ============================================
-- 8. INSIGHTS FOR JOB SEEKERS
-- ============================================

-- Best paying location-role combinations
SELECT 
    location,
    role,
    COUNT(*) as count,
    ROUND(AVG(salary_min), 0) as avg_min,
    ROUND(AVG(salary_max), 0) as avg_max,
    ROUND((AVG(salary_max) + AVG(salary_min)) / 2, 0) as avg_salary
FROM job_listings
WHERE location IS NOT NULL
GROUP BY location, role
HAVING COUNT(*) >= 3
ORDER BY avg_salary DESC
LIMIT 20;


-- Most competitive roles (by number of listings)
SELECT 
    role,
    COUNT(*) as total_listings,
    COUNT(DISTINCT company_name) as unique_companies,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM job_listings), 2) as market_pct
FROM job_listings
GROUP BY role
ORDER BY total_listings DESC;


-- Skills that increase salary the most
SELECT 
    js.skill,
    COUNT(*) as occurrences,
    ROUND(AVG(jl.salary_min), 0) as with_skill_min,
    ROUND(AVG(jl.salary_max), 0) as with_skill_max,
    (
        SELECT ROUND(AVG(salary_max), 0) FROM job_listings 
        WHERE id NOT IN (SELECT job_id FROM job_skills WHERE skill = js.skill)
    ) as without_skill_max,
    ROUND(
        AVG(jl.salary_max) - 
        (SELECT AVG(salary_max) FROM job_listings 
         WHERE id NOT IN (SELECT job_id FROM job_skills WHERE skill = js.skill)),
        0
    ) as salary_premium
FROM job_skills js
JOIN job_listings jl ON js.job_id = jl.id
GROUP BY js.skill
HAVING COUNT(*) >= 10
ORDER BY salary_premium DESC
LIMIT 15;


-- ============================================
-- 9. DATA QUALITY CHECKS
-- ============================================

-- Check for nulls
SELECT 
    'salary_min' as field,
    COUNT(CASE WHEN salary_min IS NULL THEN 1 END) as null_count,
    ROUND(100.0 * COUNT(CASE WHEN salary_min IS NULL THEN 1 END) / COUNT(*), 2) as null_pct
FROM job_listings
UNION ALL
SELECT 'salary_max', COUNT(CASE WHEN salary_max IS NULL THEN 1 END), 
    ROUND(100.0 * COUNT(CASE WHEN salary_max IS NULL THEN 1 END) / COUNT(*), 2)
FROM job_listings
UNION ALL
SELECT 'location', COUNT(CASE WHEN location IS NULL THEN 1 END),
    ROUND(100.0 * COUNT(CASE WHEN location IS NULL THEN 1 END) / COUNT(*), 2)
FROM job_listings;


-- Total records and date range
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT company_name) as unique_companies,
    COUNT(DISTINCT role) as unique_roles,
    MIN(date_posted) as earliest_date,
    MAX(date_posted) as latest_date
FROM job_listings;
