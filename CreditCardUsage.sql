/*
Credit Card Usage Data Exploration 
*/

SELECT *
FROM PortfolioProject.dbo.CreditCardUsage



----- Split the city from column 
SELECT City,SUBSTRING(City,1,CHARINDEX(',',City)-1)
FROM PortfolioProject.dbo.CreditCardUsage

ALTER TABLE PortfolioProject.dbo.CreditCardUsage
ADD CitySplit NVARCHAR(30) ;
UPDATE PortfolioProject.dbo.CreditCardUsage
SET CitySplit = SUBSTRING(City,1,CHARINDEX(',',City)-1)



----- Converting F into Female and M into Male
SELECT Gender, 
CASE 
	WHEN Gender='F' THEN 'Female'
	WHEN Gender='M' THEN 'Male'
	ELSE Gender
END
From PortfolioProject.dbo.CreditCardUsage

ALTER TABLE PortfolioProject.dbo.CreditCardUsage
ADD GenderEdited NVARCHAR(30) ;
UPDATE PortfolioProject.dbo.CreditCardUsage
SET GenderEdited =
CASE 
	WHEN Gender='F' THEN 'Female'
	WHEN Gender='M' THEN 'Male'
	ELSE Gender
END

SELECT * FROM 
PortfolioProject.dbo.CreditCardUsage
---- Renamed the column GenderEdited to Gender, CitySplit to City from the object explorer



----- changing data type of column "date" to datatype date 
ALTER TABLE PortfolioProject.dbo.CreditCardUsage
ALTER COLUMN Date Date



-----Deleting Unused column
ALTER TABLE PortfolioProject.dbo.CreditCardUsage
DROP COLUMN City,Gender;
GO
Select * FROM 
PortfolioProject.dbo.CreditCardUsage



-----Grouping by City,Date,CardType,Exp Type
SELECT Date,City,Gender,[Card Type],[Exp Type],SUM(Amount) As Amount
FROM PortfolioProject.dbo.CreditCardUsage
Group By City,Date,Gender,[Card Type],[Exp Type]
order by Date



-----Credit card usage by Genders Per Day
SELECT Date,City,Gender,SUM(Amount) As Amount
FROM PortfolioProject.dbo.CreditCardUsage
Group By City,Date,Gender
order by Date



----- CreditCard Usage By Expanse Type Per Day
SELECT Date,City,[Exp Type],SUM(Amount) As Amount
FROM PortfolioProject.dbo.CreditCardUsage
Group By City,Date,[Exp Type]
order by Date



----- Credit Card Usage by Card Type Per Day
SELECT Date,City,[Card Type],SUM(Amount) As Amount
FROM PortfolioProject.dbo.CreditCardUsage
Group By City,Date,[Card Type]
order by Date



Select * FROM 
PortfolioProject.dbo.CreditCardUsage
order by Date,City



Select SUM(Amount) FROM 
PortfolioProject.dbo.CreditCardUsage
where City = 'Ahmedabad' and Date >='2014-01-01'and Date <= '2014-12-31'


