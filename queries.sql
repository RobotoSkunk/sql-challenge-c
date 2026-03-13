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

-- Example PC from PDF
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (1, 1, NULL); -- Personal Computer (ID 1)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (2, 1, 1); -- Power Supply (ID 2)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (3, 1, 1); -- Case (ID 3)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (4, 1, 1); -- Motherboard (ID 4)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (5, 1, 4); -- CPU (ID 5)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (6, 2, 4); -- RAM (ID 6)

SELECT
	PcParts.Id AS Id,
	HardwareComponents.Name AS Name,
	CASE
		WHEN HardwareComponents.IsSubassembly = 1 THEN 'Y'
		ELSE 'N'
	END AS IsFinal,
	PcParts.ParentId AS ParentId
FROM PcParts
JOIN HardwareComponents ON PcParts.ComponentId = HardwareComponents.Id
ORDER BY Id;

-- Result Set Batch 1 - Query 1
-- ========================================

-- Id          Name               IsFinal     ParentId  
-- ----------  -----------------  ----------  ----------
-- 1           Personal Computer  Y           NULL      
-- 2           Power Supply       N           1         
-- 3           Case               N           1         
-- 4           Motherboard        Y           1         
-- 5           CPU                N           4         
-- 6           RAM                N           4              
-- ((6 rows affected))




-- Components to build 5 PCs
-- I'll assume all PC will also have 1 GPU, 1 Network Card and just 2 RAM sticks
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (1, 5,  NULL); -- Personal Computer (ID 7)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (2, 5,  7); -- Power Supply (ID 8)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (3, 5,  7); -- Case (ID 9)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (4, 5,  7); -- Motherboard (ID 10)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (5, 5,  10); -- CPU (ID 11)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (6, 10, 10); -- RAM (ID 12)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (7, 5,  10); -- GPU (ID 13)
INSERT INTO PcParts(ComponentId, Quantity, ParentId) VALUES (8, 5,  10); -- Network Card (ID 14)

SELECT
	PcParts.Id AS Id,
	HardwareComponents.Name AS Name,
	CASE
		WHEN HardwareComponents.IsSubassembly = 1 THEN 'Y'
		ELSE 'N'
	END AS IsFinal,
	PcParts.ParentId AS ParentId
FROM PcParts
JOIN HardwareComponents ON PcParts.ComponentId = HardwareComponents.Id
ORDER BY Id;

-- Result Set Batch 1 - Query 1
-- ========================================

-- Id          Name               IsFinal     ParentId  
-- ----------  -----------------  ----------  ----------
-- 1           Personal Computer  Y           NULL      
-- 2           Power Supply       N           1         
-- 3           Case               N           1         
-- 4           Motherboard        Y           1         
-- 5           CPU                N           4         
-- 6           RAM                N           4         
-- 7           Personal Computer  Y           NULL      
-- 8           Power Supply       N           7         
-- 9           Case               N           7         
-- 10          Motherboard        Y           7         
-- 11          CPU                N           10        
-- 12          RAM                N           10        
-- 13          GPU                N           10        
-- 14          Network Card       N           10        
-- ((14 rows affected))
