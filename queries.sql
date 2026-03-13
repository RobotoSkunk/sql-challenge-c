-- MSSQL

CREATE DATABASE sql_challenge_c;
USE sql_challenge_c;


-- Create tables
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
