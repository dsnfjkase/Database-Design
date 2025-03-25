-- Test 5: Can you see who authorized permission for treatment for a minor?


-- Insert Data Used For Test5 (No new data required)

-- --------------------------------------------------------------------------------------------------------------------


-- Test Query 

SELECT p.P_name as Patient_Name, t.T_name as Treatment, CONCAT(t.V_date, ' ', t.V_time) as Treatment_DateTime, 
g.Name as Guardian_Name, g.Phone_number as Guardian_Contact
FROM Treatment t
JOIN Patient p ON t.P_id = p.P_id
JOIN Signature s ON t.Signature_id = s.Signature_id 
JOIN Guardian g ON s.G_id = g.G_id
WHERE p.P_name = 'Tom Brown';
