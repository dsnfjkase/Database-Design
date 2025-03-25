-- Test 3: Can you tell what doctor give what diagnosis(s) for a visit and the prescribed treatments for that visit (if any)?


-- Insert Data Used For Test3 (No new data required)

-- --------------------------------------------------------------------------------------------------------------------


-- Test Query 

SELECT e.E_name as Doctor_Name, p.P_name as Patient_Name, CONCAT(v.V_date, ' ', v.V_time) as Visit_DateTime, 
d.D_name as Diagnosis, t.T_name as Treatment
FROM Employee e
JOIN Visit v ON e.E_id = v.Service_provider_eid
JOIN Patient p ON v.P_id = p.P_id
LEFT JOIN Diagnosis d ON (v.V_date = d.V_date AND v.V_time = d.V_time AND v.P_id = d.P_id)
LEFT JOIN Treatment t ON (v.V_date = t.V_date AND v.V_time = t.V_time AND v.P_id = t.P_id)
WHERE e.Type = 'Doctor'
ORDER BY v.V_date, v.V_time;
