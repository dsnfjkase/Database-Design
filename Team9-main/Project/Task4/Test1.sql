-- Test 1: Can a patient have different visits with the same diagnosis?


-- Insert Data Used For Test1

-- Department Data
INSERT INTO Department (D_id, D_name) VALUES
(1, 'Patient Care'),
(2, 'Intake'),
(3, 'Assessment');

-- Employee Data
INSERT INTO Employee (E_id, Type, SSN, E_name, D_id) VALUES
(1, 'Doctor', '123456789', 'Dr. Smith', 1),
(2, 'Doctor', '234567890', 'Dr. Johnson', 1),
(3, 'Nurse', '345678901', 'Nurse Williams', 3),
(4, 'Intake Clerk', '456789012', 'Clerk Davis', 2);

-- Service Provider Data
INSERT INTO Service_provider (S_id, College, Location, Degree, Degree_date, E_id) VALUES
(1, 'University of Minnesota', 'Minneapolis, MN', 'MD', '2010-05-15', 1),
(2, 'University of Wisconsin', 'Madison, WI', 'MD', '2012-06-20', 2);

-- Patient Data
INSERT INTO Patient (P_id, P_name, Birthday, Addr, E_name, E_addr, E_phone_number) VALUES
(1, 'John Smith', '1980-03-15', '1234 Hennepin Ave, Minneapolis', 'Jane Smith', '1234 Hennepin Ave, Minneapolis', '555-0101'),
(2, 'Mary Johnson', '1990-07-22', '5678 Nicollet Ave, Minneapolis', 'Mike Johnson', '5678 Nicollet Ave, Minneapolis', '555-0102'),
(3, 'Tom Brown', '2010-11-30', '910 Lake Street, Minneapolis', 'Sarah Brown', '910 Lake Street, Minneapolis', '555-0103');

-- Insurance Data
INSERT INTO Insurance (Number_id, Start_date, End_date, Company, Copay, Group_number, State, P_id) VALUES
(1, '2024-01-01', NULL, 'Blue Cross', 25.00, 'BC12345', 'MN', 1),
(2, '2024-01-01', NULL, 'Aetna', 30.00, 'AE67890', 'MN', 2),
(3, '2024-01-01', NULL, 'United', 20.00, 'UN13579', 'MN', 3);

-- Intake clerk Data
INSERT INTO Intake_clerk (E_id) VALUES
(4);

-- Visit Data
INSERT INTO Visit (V_time, V_date, P_id, Medical_info, Payment_method, Payment_amount, Insurance_id, Service_provider_eid, Service_provider_id, Clerk_id) VALUES
('09:00:00', '2024-02-01', 1, 'Head pain', 'Credit Card', 25.00, 1, 1, 1, 4),
('14:00:00', '2024-02-15', 1, 'Head pain again', 'Cash', 25.00, 1, 1, 1, 4),
('10:00:00', '2024-02-05', 2, 'Knee pain', 'Credit Card', 30.00, 2, 2, 2, 4),
('11:00:00', '2024-02-20', 2, 'Knee check', 'Cash', 30.00, 2, 2, 2, 4),
('13:00:00', '2024-02-10', 3, 'Hand pain', 'Credit Card', 20.00, 3, 1, 1, 4);

-- Diagnosis Data
INSERT INTO Diagnosis (D_code, D_name, V_time, V_date, P_id, Service_provider_eid, Service_provider_id) VALUES
('G44.1', 'Headache', '09:00:00', '2024-02-01', 1, 1, 1),
('G44.1', 'Headache', '14:00:00', '2024-02-15', 1, 1, 1),
('S93.401', 'Knee sprain', '10:00:00', '2024-02-05', 2, 2, 2),
('S52.501', 'Hand injury', '13:00:00', '2024-02-10', 3, 1, 1);

-- --------------------------------------------------------------------------------------------------------------------


-- Test Query 

SELECT p.P_name, d.D_code, d.D_name, CONCAT(d.V_date, ' ', d.V_time) as Visit_DateTime
FROM Patient p
JOIN Diagnosis d ON p.P_id = d.P_id
WHERE p.P_name = 'John Smith' 
ORDER BY d.V_date, d.V_time;
