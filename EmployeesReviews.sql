/*
Employees' Reviews of different companies 
*/



------ Task 1 : Seprate Out Country from the column 'Location'
------ Seprating the column 'location' from the last comma(,) 
Select 
PARSENAME(REPLACE(location, ',', '.') , 1)
FROM PortfolioProject.dbo.EmployeeReview

ALTER TABLE EmployeeReview
Add Country Nvarchar(255);
Update EmployeeReview
SET Country = PARSENAME(REPLACE(location, ',', '.') , 1)

SELECT Distinct(Country)
FROM PortfolioProject.dbo.EmployeeReview

----- Making a new column which us seprated by '(' 
Select 
PARSENAME(REPLACE(Country, '(', '.') , 1)
FROM PortfolioProject.dbo.EmployeeReview

ALTER TABLE EmployeeReview
Add Country1 Nvarchar(255);
Update EmployeeReview
SET Country1 = PARSENAME(REPLACE(Country, '(', '.') , 1)
SELECT Country1 FROM 
PortfolioProject.dbo.EmployeeReview

----- Removing ')' from the column Country 1
SELECT Distinct(Country1) FROM 
PortfolioProject.dbo.EmployeeReview

SELECT REPLACE(Country1, ')', ' ') 
FROM PortfolioProject.dbo.EmployeeReview
GO;


ALTER TABLE EmployeeReview
Add Country2 Nvarchar(255);
Update PortfolioProject.dbo.EmployeeReview
SET Country2 = REPLACE(Country1, ')', ' ')

Select Country2 FROM 
PortfolioProject.dbo.EmployeeReview
Select Distinct(Country2) FROM 
PortfolioProject.dbo.EmployeeReview

----- Filtering out USA from the column 'Country2'
SELECT * FROM
PortfolioProject.DBO.EmployeeReview

ALTER TABLE EmployeeReview
Add Country3 Nvarchar(255);
Update PortfolioProject.dbo.EmployeeReview
SET Country3 = TRIM(Country2)

SELECT Country2, 
CASE 
	WHEN TRIM(Country2) IN ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY','DC','AS','GU','MP','PR','VI') THEN  'USA'
	ELSE Country2
END
From PortfolioProject.dbo.EmployeeReview


ALTER TABLE EmployeeReview
Add CountrYSplit Nvarchar(255);
Update PortfolioProject.dbo.EmployeeReview
SET CountrySplit = CASE 
	WHEN TRIM(Country2) IN ('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY','DC','AS','GU','MP','PR','VI') THEN  'USA'
	ELSE Country2
END

SELECT * FROM 
PortfolioProject.dbo.EmployeeReview

------ CounyrySplit is a column which contain country
SELECT Distinct(CountrySplit) FROM
PortfolioProject.dbo.EmployeeReview

-----Deleting Unnecessary Column
ALTER TABLE PortfolioProject.dbo.EmployeeReview
DROP Column Country
ALTER TABLE PortfolioProject.dbo.EmployeeReview
DROP Column Country1,Country2,Country3

----- Rename the column CountrySplit to Country From The Object Explorer
------Task1 has been completed

----- Task 2: Converting DataType of dates to Date

-----Converting dates column to date from nvarchar
SELECT TRY_CAST(dates AS date) FROM PortfolioProject.dbo.EmployeeReview;
Update PortfolioProject.dbo.EmployeeReview
SET dates = TRY_CAST(dates AS date)



----- Task 3: Filtering out Employee Status 

SELECT * 
FROM PortfolioProject.dbo.EmployeeReview 


SELECT Substring([job-title],1,CHARINDEX(' ',[job-title])-1)
FROM PortfolioProject.dbo.EmployeeReview


ALTER TABLE EmployeeReview
Add EmployeeStatus Nvarchar(255);
Update PortfolioProject.dbo.EmployeeReview
SET EmployeeStatus = Substring([job-title],1,CHARINDEX(' ',[job-title])-1)

SELECT Distinct(EmployeeStatus)
FROM PortfolioProject.dbo.EmployeeReview



----- Task 4: Abstracting data from the sheet for the Tableaue Dashboard

----- Work Balance Star
SELECT [work-balance-stars],company,COUNT([work-balance-stars]) AS TotalCountWorkBalance
FROM PortfolioProject.dbo.EmployeeReview
where company = 'amazon' and [work-balance-stars] is not NULL
group by [work-balance-stars],company
order by [work-balance-stars]

-----Culture Values star  
SELECT [culture-values-stars],company,COUNT([culture-values-stars]) AS TotalCultureValues
FROM PortfolioProject.dbo.EmployeeReview
where [culture-values-stars] is not NULL
group by [culture-values-stars],company
order by [culture-values-stars]

----- Carer-opportubities-star 
SELECT [carrer-opportunities-stars],company,COUNT([carrer-opportunities-stars]) AS TotalCareerOpportunities
FROM PortfolioProject.dbo.EmployeeReview
where [carrer-opportunities-stars] is not NULL
group by [carrer-opportunities-stars],company
order by [carrer-opportunities-stars]

----- Comp-benefit-stars
SELECT [comp-benefit-stars],company,COUNT([comp-benefit-stars]) AS TotalCompanyBenefits
FROM PortfolioProject.dbo.EmployeeReview
where [comp-benefit-stars] is not NULL
group by [comp-benefit-stars],company
order by [comp-benefit-stars]

----- Senior-management-stars
SELECT [senior-mangemnet-stars],company,COUNT([senior-mangemnet-stars]) AS ToatalSeniorManagementStars
FROM PortfolioProject.dbo.EmployeeReview
where [senior-mangemnet-stars] is not NULL
group by [senior-mangemnet-stars],company
order by [senior-mangemnet-stars]

----- Overall Ratings
SELECT [overall-ratings],company,COUNT([overall-ratings]) AS ToatalOverallRating
FROM PortfolioProject.dbo.EmployeeReview
where [overall-ratings] is not NULL
group by [overall-ratings],company
order by [overall-ratings]

----- Collecting Total Reviews
SELECT company,
COUNT([overall-ratings]) AS TotalReviewsForOverallRatings,
COUNT([senior-mangemnet-stars]) AS TotalReviewsForSeniorManagaement,
COUNT([comp-benefit-stars]) AS TotalReviewsForCompanyBenefits,
COUNT([carrer-opportunities-stars]) AS TotalReviewsForCareerOpportunity, 
COUNT([work-balance-stars]) AS TotalReviewsForWorkBalance,
COUNT([culture-values-stars]) AS TotalReviewsForCultureValues
FROM PortfolioProject.dbo.EmployeeReview 
group by company







SELECT * FROM PortfolioProject.dbo.EmployeeReview



