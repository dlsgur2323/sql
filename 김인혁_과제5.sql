실습 join8
SELECT countries.region_id, region_name, country_name
FROM countries, regions
WHERE countries.region_id = regions.region_id AND regions.region_name = 'Europe';

SELECT countries.region_id, region_name, country_name
FROM countries JOIN regions ON(countries.region_id = regions.region_id )
WHERE regions.region_name = 'Europe';

실습 JOIN 9
SELECT countries.region_id, region_name, country_name, locations.city
FROM countries, regions, locations
WHERE countries.region_id = regions.region_id AND countries.country_id = locations.country_id AND regions.region_name = 'Europe';

SELECT countries.region_id, region_name, country_name, locations.city
FROM countries JOIN regions ON(countries.region_id = regions.region_id ) JOIN locations ON(countries.country_id = locations.country_id)
WHERE regions.region_name = 'Europe';

실습 join10
SELECT countries.region_id, region_name, country_name, locations.city, department_name
FROM countries, regions, locations, departments
WHERE countries.region_id = regions.region_id AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND regions.region_name = 'Europe';

SELECT countries.region_id, region_name, country_name, locations.city, department_name
FROM countries JOIN regions ON(countries.region_id = regions.region_id )
        JOIN locations ON(countries.country_id = locations.country_id)
        JOIN departments ON (locations.location_id = departments.location_id)
WHERE regions.region_name = 'Europe';

실습 join11
SELECT countries.region_id, region_name, country_name, locations.city, department_name, CONCAT(first_name,last_name) name
FROM countries, regions, locations, departments, employees
WHERE countries.region_id = regions.region_id AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND employees.department_id = departments.department_id
    AND regions.region_name = 'Europe';

SELECT countries.region_id, region_name, country_name, locations.city, department_name, CONCAT(first_name,last_name) name
FROM countries JOIN regions ON(countries.region_id = regions.region_id )
        JOIN locations ON(countries.country_id = locations.country_id)
        JOIN departments ON (locations.location_id = departments.location_id)
        JOIN employees ON (employees.department_id = departments.department_id)
WHERE regions.region_name = 'Europe';

실습 join 12
SELECT employee_id, CONCAT(first_name,last_name) name, employees.job_id, job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

SELECT employee_id, CONCAT(first_name,last_name) name, employees.job_id, job_title
FROM employees JOIN jobs ON (employees.job_id = jobs.job_id);

실습 join13
SELECT m.employee_id mgr_id, CONCAT(m.first_name,m.last_name) mgr_name, e.employee_id, CONCAT(e.first_name,e.last_name) name,
        e.job_id, jobs.job_title
FROM employees e, jobs, employees m
WHERE e.job_id = jobs.job_id AND e.manager_id = m.employee_id;

SELECT m.employee_id mgr_id, CONCAT(m.first_name,m.last_name) mgr_name, e.employee_id, CONCAT(e.first_name,e.last_name) name,
        e.job_id, jobs.job_title
FROM employees e JOIN jobs ON(e.job_id = jobs.job_id) JOIN employees m ON(e.manager_id = m.employee_id);






