-- MSSQL

CREATE DATABASE sql_challenge_c;
USE sql_challenge_c;

-------------------
-- Create tables --
-------------------
CREATE TABLE HardwareComponents (
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Name VARCHAR(100) NOT NULL,
	Price DECIMAL(7, 2) NOT NULL,
	IsSubassembly BIT NOT NULL
);

CREATE TABLE PcParts(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	ComponentId INT NOT NULL,
	Quantity INT NOT NULL DEFAULT 1,
	ParentId INT,

	FOREIGN KEY (ComponentId) REFERENCES HardwareComponents(Id),
	FOREIGN KEY (ParentId) REFERENCES PcParts(Id)
);

-----------------------------
-- Add hardware components --
-----------------------------
INSERT INTO HardwareComponents(Name, Price, IsSubassembly) VALUES
	('Personal Computer', 0,    1),
	('Power Supply',      1500, 0),
	('Case',              2400, 0),
	('Motherboard',       2800, 1),
	('CPU',               3500, 0),
	('RAM',               3500, 0),
	('GPU',               6000, 0),
	('Network Card',      2000, 0);


SELECT * FROM HardwareComponents;

-- Result Set Batch 1 - Query 1
-- ========================================

-- Id          Name               Price       IsSubassembly
-- ----------  -----------------  ----------  -------------
-- 1           Personal Computer  0.00        1            
-- 2           Power Supply       1500.00     0            
-- 3           Case               2400.00     0            
-- 4           Motherboard        2800.00     1            
-- 5           CPU                3500.00     0            
-- 6           RAM                3500.00     0            
-- 7           GPU                6000.00     0            
-- 8           Network Card       2000.00     0            
-- ((8 rows affected))



------------------------
-- Build computers :) --
------------------------
-- PC 1
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (1, 1, NULL); -- Personal Computer (ID 1)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (2, 1, 1); -- Power Supply (ID 2)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (3, 1, 1); -- Case (ID 3)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (4, 1, 1); -- Motherboard (ID 4)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (5, 1, 4); -- CPU (ID 5)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (6, 2, 4); -- RAM (ID 6)

SELECT
	HardwareComponents.Name AS Name,
	PcParts.Quantity AS Quantity,
	(
		SELECT
			HardwareComponents.Name AS Name
		FROM HardwareComponents
		WHERE HardwareComponents.Id = PcParts.ParentId
	) AS Parent
FROM PcParts
JOIN HardwareComponents ON PcParts.ComponentId = HardwareComponents.Id;

-- Result Set Batch 1 - Query 1
-- ========================================

-- Name               Quantity    Parent           
-- -----------------  ----------  -----------------
-- Personal Computer  1           NULL             
-- Power Supply       1           Personal Computer
-- Case               1           Personal Computer
-- Motherboard        1           Personal Computer
-- CPU                1           Motherboard      
-- RAM                2           Motherboard      
-- ((6 rows affected))

