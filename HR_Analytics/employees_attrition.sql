--Attrition overview with CTEs — department-wise attrition rate and counts

WITH dept_stats AS (
  SELECT
    Department,
    COUNT(*) AS total_emp,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrited
  FROM employees
  GROUP BY Department
)
SELECT
  Department,
  total_emp,
  attrited,
  ROUND(attrited * 100.0 / NULLIF(total_emp,0), 2) AS attrition_pct
FROM dept_stats
ORDER BY attrition_pct DESC;


--Show JobRoles where average satisfaction is less than 3
select JobRole,
round(avg(JobSatisfaction),2) as js
from employees_attrition
group by JobRole
having avg(JobSatisfaction)<3



--Use CASE to compute promotion eligibility

SELECT EmployeeNumber, YearsInCurrentRole, PerformanceRating, JobSatisfaction,
  CASE
    WHEN YearsInCurrentRole >= 2 AND PerformanceRating >= 3 AND JobSatisfaction >= 3 THEN 'Eligible'
    WHEN YearsInCurrentRole >= 2 AND PerformanceRating >= 3 THEN 'Consider'
    ELSE 'Not Eligible'
  END AS promotion_status
FROM employees;

--Compare employees with same JobRole but different salaries

SELECT 
    e1.EmployeeNumber AS emp_low,
    e2.EmployeeNumber AS emp_high,
    e1.JobRole,
    e1.MonthlyIncome AS low_income,
    e2.MonthlyIncome AS high_income
FROM employees_attrition e1
JOIN employees_attrition e2 
    ON e1.JobRole = e2.JobRole
   AND e1.MonthlyIncome < e2.MonthlyIncome
ORDER BY JobRole, low_income;



--Find employees in the same Department

SELECT 
    e1.EmployeeNumber AS emp1,
    e2.EmployeeNumber AS emp2,
    e1.Department
FROM employees_attrition e1
JOIN employees_attrition e2 
    ON e1.Department = e2.Department
   AND e1.EmployeeNumber < e2.EmployeeNumber     -- avoid duplicates
ORDER BY e1.Department;


--Rank employees by MonthlyIncome by each department
SELECT 
    EmployeeNumber,
    JobRole,department,
    MonthlyIncome,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY MonthlyIncome DESC) AS income_rank
FROM employees_attrition
ORDER BY department;


--Rank based on Attrition risk indicators (TotalWorkingYears low + OverTime Yes)


SELECT
    EmployeeNumber,JobRole,
    OverTime,
    TotalWorkingYears,
    RANK() OVER (PARTITION BY JobRole ORDER BY TotalWorkingYears ASC, OverTime DESC) AS risk_rank
FROM employees_attrition
ORDER BY JobRole;

--Rank based on YearsAtCompany inside each JobRole

SELECT 
    EmployeeNumber,
    JobRole,
    YearsAtCompany,
    RANK() OVER (PARTITION BY JobRole ORDER BY YearsAtCompany DESC) AS role_tenure_rank
FROM employees
ORDER BY JobRole, role_tenure_rank;



--Quick data quality checks (NULLs and duplicates)

-- Nulls
SELECT 
  SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS null_age,
  SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS null_monthlyincome
FROM employees_attrition;

-- Duplicate EmployeeNumber
SELECT EmployeeNumber, COUNT(*) AS cnt FROM employees_attrition
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;


--Create a small summary table (materialized view-ish) — department KPIs

CREATE TABLE IF NOT EXISTS dept_kpis AS
SELECT
  Department,
  COUNT(*) AS total_employees,
  ROUND(AVG(MonthlyIncome),2) AS avg_income,
  SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) AS attrited,
  ROUND(SUM(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END)*100.0/(COUNT(*)),2) AS attrition_pct,
  ROUND(AVG(JobSatisfaction),2) AS avg_job_satisfaction
FROM employees_attrition
GROUP BY Department;
select * from dept_kpis


