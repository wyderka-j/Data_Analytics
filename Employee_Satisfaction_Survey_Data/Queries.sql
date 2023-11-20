-- MySQL 

CREATE DATABASE HR_Analytics;

USE HR_Analytics;

-- 1. number of employees and number of employees in each department

SELECT COUNT(*)
FROM employee_attrition;

	-- each department
SELECT dept, COUNT(*)
FROM employee_attrition
GROUP BY dept;

-- 2. number of employees by accicent at work

SELECT 
	CASE 
		WHEN work_accident = 0 THEN 'no accident'
        WHEN work_accident = 1 THEN 'accident'
	END AS work_accidents,
	COUNT(work_accident) AS 'No of employees'
FROM employee_attrition
GROUP BY work_accidents, work_accident;

-- 3. number of employees by promotion

SELECT 
	CASE 
		WHEN promotion_last_5years = 0 THEN 'no promotion'
        WHEN promotion_last_5years = 1 THEN 'promotion'
	END AS promotion,
	COUNT(promotion_last_5years) AS 'No of employees'
FROM employee_attrition
GROUP BY promotion, promotion_last_5years;

-- 4. number of employees in each project
SELECT 
	number_project,
    COUNT('Emp ID') AS 'No of employees'
FROM employee_attrition
GROUP BY  number_project
ORDER BY 2 DESC;

-- 5. Which three departments had the highest satisfaction scores, and which three had the lowest satisfaction scores?

SELECT
	dept,
	ROUND(AVG(satisfaction_level),4) AS avg_satisfaction
FROM employee_attrition
GROUP BY 1
ORDER BY 2 DESC;

-- 6. What is the relationship between salary and satisfaction score?

SELECT
	DISTINCT salary
FROM employee_attrition;

-- 'low',  'medium',  'high'

SELECT
	salary,
    ROUND(AVG(satisfaction_level),2) AS avg_satisfaction
FROM employee_attrition
GROUP BY 1
ORDER BY 2;

-- 7. How did the top two and bottom two depts perform in the following arears
-- 	 last_evaluation, number_project, average_montly_hours, time_spend_company, time_spend_company, Work_accident, promotion_last_5years

SELECT
    CASE
		WHEN dept IN (SELECT * FROM 
			(SELECT dept FROM employee_attrition
			GROUP BY 1
			ORDER BY AVG(satisfaction_level) DESC
			LIMIT 2) 
            AS t1) THEN 'top_dept'
		WHEN dept IN (SELECT * FROM 
			(SELECT dept FROM employee_attrition
			GROUP BY 1
			ORDER BY AVG(satisfaction_level)
			LIMIT 2) 
            AS t2) THEN 'lower_dept'
	END AS top_bot,
    COUNT('Emp ID') AS number_of_emp,
    ROUND(AVG(last_evaluation),2) AS avg_last_evaluation,
    ROUND(AVG(number_project),1) AS avg_projects,
    ROUND(AVG(average_montly_hours),2) AS hours_worked,
    ROUND(AVG(time_spend_company),2) AS time_at_company,
    ROUND(AVG(work_accident),2) AS avg_num_accidents,
    ROUND(AVG(promotion_last_5years),2) AS avg_num_prom
FROM employee_attrition
GROUP BY 1
ORDER BY 1 DESC
LIMIT 2;