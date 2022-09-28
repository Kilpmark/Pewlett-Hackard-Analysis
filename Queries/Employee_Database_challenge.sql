-- Create 'retirement_titles' table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	te.title,
	te.from_date,
	te.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as te
ON (e.emp_no = te.emp_no )
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- Eliminate Duplicates and display only the latest title held
SELECT DISTINCT ON (rt.emp_no) rt.emp_no, rt.first_name, rt.last_name, rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

-- Count number of 'titles' retiring
SELECT COUNT(u.title), u.title
INTO retiring_titles
FROM unique_titles AS u
GROUP BY u.title
ORDER BY COUNT(u.title) DESC;

-- Generate List of Employees eligible for mentorship program
SELECT DISTINCT ON (e.emp_no) e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
te.title
INTO mentorship_eligibility
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as te
ON (e.emp_no = te.emp_no)
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Count num of retiring by dept

SELECT DISTINCT ON(u.emp_no) d.dept_name,
u.emp_no,
u.first_name,
u.last_name,
u.title
INTO retiring_titles_departments
FROM unique_titles as u
INNER JOIN dept_emp as de
ON (u.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);

SELECT dept_name, COUNT(*) AS "Retiring"
FROM retiring_titles_departments
GROUP BY dept_name
ORDER BY dept_name ASC;

-- Count num of mentorship eligible by dept

SELECT DISTINCT ON(me.emp_no) d.dept_name,
me.title,
me.emp_no,
me.first_name,
me.last_name
INTO ment_elig_dept
FROM mentorship_eligibility as me
INNER JOIN dept_emp as de
ON (me.emp_no = de.emp_no)
INNER JOIN departments as d
ON (de.dept_no = d.dept_no);

SELECT dept_name, COUNT(*) AS "Mentorship Eligible"
FROM ment_elig_dept
GROUP BY dept_name
ORDER BY dept_name ASC;