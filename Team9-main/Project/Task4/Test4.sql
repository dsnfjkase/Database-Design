-- Test 4: Can the same clerk do the intake for the same patient on different visits?


-- Insert Data Used For Test4 (No new data required)

-- --------------------------------------------------------------------------------------------------------------------


-- Test Query 

SELECT e.E_name as Clerk_Name, p.P_name as Patient_Name, COUNT(*) as Visit_Count,
GROUP_CONCAT(CONCAT(v.V_date, ' ', v.V_time)) as Visit_DateTimes
FROM Employee e
JOIN Visit v ON e.E_id = v.Clerk_id 
JOIN Patient p ON v.P_id = p.P_id 
WHERE e.Type = 'Intake Clerk' 
GROUP BY e.E_id, p.P_id HAVING COUNT(*) > 1;
