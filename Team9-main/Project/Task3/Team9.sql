USE C4707F24S002U9;

-- Create Table


-- CREATE PATIENT ENTITY TABLE
CREATE TABLE Patient (
    P_id INT PRIMARY KEY AUTO_INCREMENT,
    P_name VARCHAR(100),
    Birthday DATE,
    Addr TEXT,
    E_name VARCHAR(100),
    E_addr TEXT,
    E_phone_number VARCHAR(15)
);  

-- CREATE Guardian ENTITY TABLE
CREATE TABLE Guardian (
    G_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(255),
    Addr TEXT,
    Phone_number VARCHAR(15)
);  

-- CREATE Insurance TABLE
CREATE TABLE Insurance (
    Number_id INT PRIMARY KEY AUTO_INCREMENT,
    Start_date DATE,
	End_date DATE,
    Company VARCHAR(100),
    Copay DECIMAL(5,2),
    Group_number  VARCHAR(15),
    State VARCHAR(50),
    P_id INT NOT NULL,
    FOREIGN KEY (P_id) REFERENCES Patient(P_id),
    CONSTRAINT valid_dates CHECK (End_date IS NULL OR End_date > Start_date),
    CONSTRAINT valid_copay CHECK (Copay >= 0)
);

-- CREATE Signature TABLE
CREATE TABLE Signature (
    Signature_id INT PRIMARY KEY AUTO_INCREMENT,
    P_id INT,
	G_id INT,
    FOREIGN KEY (P_id) REFERENCES Patient(P_id),
	FOREIGN KEY (G_id) REFERENCES Guardian(G_id),
    CONSTRAINT check_pid_gid CHECK ( -- To ensure either patient himself of his guradian should sign the signature.
        (P_id IS NOT NULL AND G_id IS NULL) OR 
        (P_id IS NULL AND G_id IS NOT NULL)
    )
);

-- CREATE Department TABLE
CREATE TABLE Department (
    D_id INT PRIMARY KEY AUTO_INCREMENT,
    D_name VARCHAR(50)
);

-- CREATE Employee TABLE
CREATE TABLE Employee (
    E_id INT PRIMARY KEY AUTO_INCREMENT,
    `Type` VARCHAR(50),
	SSN VARCHAR(11) UNIQUE,
    E_name VARCHAR(100),
    D_id INT NOT NULL,
    FOREIGN KEY (D_id) REFERENCES Department(D_id),
    CONSTRAINT valid_ssn CHECK (SSN REGEXP '^[0-9]{9}$'),
    CONSTRAINT valid_type CHECK (Type IN ('Doctor', 'Nurse', 'Support', 'Intake Clerk', 'Physical Assistant', 'Nurse Practitioner'))
);

-- CREATE Nurse TABLE
CREATE TABLE Nurse (
	E_id INT NOT NULL UNIQUE,
    N_id INT NOT NULL AUTO_INCREMENT UNIQUE,
    Liscence_type VARCHAR(50),
    Exp_date DATE,
    Conferral_date DATE,
    PRIMARY KEY (E_id, N_id),
    FOREIGN KEY (E_id) REFERENCES Employee(E_id),
    CONSTRAINT valid_nurse_dates CHECK (Exp_date > Conferral_date)
);

-- CREATE Support TABLE
CREATE TABLE Support (
	E_id INT PRIMARY KEY,
	FOREIGN KEY (E_id) REFERENCES Employee(E_id)
);

-- CREATE Intake clerk TABLE
CREATE TABLE Intake_clerk (
	E_id INT PRIMARY KEY,
	FOREIGN KEY (E_id) REFERENCES Employee(E_id)
);

-- CREATE Service provider TABLE
CREATE TABLE Service_provider (
	S_id INT NOT NULL UNIQUE,
    College VARCHAR(200),
    Location VARCHAR(200),
    Degree VARCHAR(100),
    Degree_date DATE,
    E_id INT NOT NULL UNIQUE,
    PRIMARY KEY (S_id, E_id),
    FOREIGN KEY (E_id) REFERENCES Employee(E_id)
);

-- CREATE Doctor TABLE
CREATE TABLE Doctor (
	E_id INT NOT NULL,
    S_id INT NOT NULL,
    PRIMARY KEY (E_id, S_id),
	FOREIGN KEY (E_id) REFERENCES Service_provider(E_id),
	FOREIGN KEY (S_id) REFERENCES Service_provider(S_id)
);

-- CREATE Physical assistant TABLE
CREATE TABLE Physical_assistant (
	E_id INT NOT NULL,
    S_id INT NOT NULL,
    PRIMARY KEY (E_id, S_id),
	FOREIGN KEY (E_id) REFERENCES Service_provider(E_id),
	FOREIGN KEY (S_id) REFERENCES Service_provider(S_id)
);

-- CREATE Nurse practitioner TABLE
CREATE TABLE Nurse_practitioner (
	E_id INT NOT NULL,
    S_id INT NOT NULL,
    PRIMARY KEY (E_id, S_id),
	FOREIGN KEY (E_id) REFERENCES Service_provider(E_id),
	FOREIGN KEY (S_id) REFERENCES Service_provider(S_id)
);

-- CREATE VISIT TABLE
CREATE TABLE Visit (
    V_time TIME NOT NULL,
    V_date DATE NOT NULL,
	P_id INT NOT NULL,
    Billing_info TEXT,
    Notes TEXT,
    Medical_info TEXT,
    Payment_method VARCHAR(50),
    Payment_amount DECIMAL(10,2),
    Insurance_id INT NOT NULL,
    Service_provider_eid INT NOT NULL,
    Service_provider_id INT NOT NULL,
    Clerk_id INT NOT NULL,
    PRIMARY KEY (V_time, V_date, P_id),
    FOREIGN KEY (Insurance_id) REFERENCES Insurance(Number_id),
    FOREIGN KEY (Service_provider_eid) REFERENCES Service_provider(E_id),
    FOREIGN KEY (Service_provider_id) REFERENCES Service_provider(S_id),
    FOREIGN KEY (Clerk_id) REFERENCES Intake_clerk(E_id),
    CONSTRAINT valid_payment CHECK (Payment_amount > 0),
    CONSTRAINT valid_payment_method CHECK (Payment_method IN ('Cash', 'Credit Card'))
);

-- CREATE Treatment TABLE
CREATE TABLE Treatment (
	T_code VARCHAR(7) NOT NULL,
    V_time TIME NOT NULL,
    V_date DATE NOT NULL,
	P_id INT NOT NULL,
    T_name VARCHAR(50),
    Cost DECIMAL(10,2),
    Signature_id INT NOT NULL,
    PRIMARY KEY (T_code, V_time, V_date, P_id),
    FOREIGN KEY (V_time, V_date, P_id) REFERENCES Visit(V_time, V_date, P_id),
    FOREIGN KEY (Signature_id) REFERENCES Signature(Signature_id),
    CONSTRAINT valid_cost CHECK (Cost > 0),
    CONSTRAINT valid_icd_pcs CHECK (T_code REGEXP '^[0-9A-Z]{7}$')
);

-- CREATE Diagnosis TABLE
CREATE TABLE Diagnosis (
	D_code VARCHAR(7) NOT NULL,
    D_name VARCHAR(50),
    V_time TIME NOT NULL,
    V_date DATE NOT NULL,
	P_id INT NOT NULL,
	Service_provider_eid INT NOT NULL,
    Service_provider_id INT NOT NULL,
    PRIMARY KEY (D_code, V_time, V_date, P_id),
	FOREIGN KEY (V_time, V_date, P_id) REFERENCES Visit(V_time, V_date, P_id),
    FOREIGN KEY (Service_provider_eid) REFERENCES Service_provider(E_id),
    FOREIGN KEY (Service_provider_id) REFERENCES Service_provider(S_id)
);

-- CREATE Initial assessment TABLE
CREATE TABLE Initial_assessment (
	IA_id INT NOT NULL,
    V_time TIME NOT NULL,
    V_date DATE NOT NULL,
	P_id INT NOT NULL,
    Medical_condition TEXT,
    Temperature DECIMAL(3,1),
    Blood_pressure SMALLINT,
    Weight DECIMAL(5,2),
    Height DECIMAL(5,2),
    Nurse_eid INT NOT NULL,
    Nurse_id INT NOT NULL,
	PRIMARY KEY (IA_id, V_time, V_date, P_id),
	FOREIGN KEY (V_time, V_date, P_id) REFERENCES Visit(V_time, V_date, P_id),
	FOREIGN KEY (Nurse_eid) REFERENCES Nurse(E_id),
	FOREIGN KEY (Nurse_id) REFERENCES Nurse(N_id),
    CONSTRAINT valid_temp CHECK (Temperature BETWEEN 95 AND 108),
    CONSTRAINT valid_bp CHECK (Blood_pressure BETWEEN 60 AND 200),
    CONSTRAINT valid_weight CHECK (Weight > 0),
    CONSTRAINT valid_height CHECK (Height > 0)
);

-- CREATE Guard Table
CREATE TABLE Guard ( -- We are not able to ensure that every guardian has at least one patient, so we should insert a row into Guard immediately after inserting a row into Guardian in Application logic.
	G_id INT NOT NULL, 
    P_id INT NOT NULL,
    PRIMARY KEY (G_id, P_id),
	FOREIGN KEY (G_id) REFERENCES Guardian(G_id),
	FOREIGN KEY (P_id) REFERENCES Patient(P_id)
);
