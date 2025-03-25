-- Test 2: Can a patient have different visits with the same treatment?


-- Insert Data Used For Test2

-- Guardian Data
INSERT INTO Guardian (G_id, Name, Email, Addr, Phone_number) VALUES
(1, 'Sarah Brown', 'sarah.brown@email.com', '910 Lake Street, Minneapolis', '555-0104');

-- Signature Data
INSERT INTO Signature (Signature_id, P_id, G_id) VALUES
(1, NULL, 1),  -- Tom Brown's guardian signature
(2, 2, NULL),  -- Mary Johnson's first visit signature
(3, 2, NULL);  -- Mary Johnson's second visit signature

-- Treatment Data
INSERT INTO Treatment (T_code, V_time, V_date, P_id, T_name, Cost, Signature_id) VALUES
('2W4GX5Z', '10:00:00', '2024-02-05', 2, 'X-ray', 150.00, 2),
('2W4GX5Z', '11:00:00', '2024-02-20', 2, 'X-ray', 150.00, 3),
('2W4GX5Z', '13:00:00', '2024-02-10', 3, 'X-ray', 200.00, 1);

-- --------------------------------------------------------------------------------------------------------------------


-- Test Query 

SELECT p.P_name, t.T_code, t.T_name, CONCAT(t.V_date, ' ', t.V_time) as Visit_DateTime, t.Cost
FROM Patient p
JOIN Treatment t ON p.P_id = t.P_id 
WHERE p.P_name = 'Mary Johnson' 
ORDER BY t.V_date, t.V_time;
