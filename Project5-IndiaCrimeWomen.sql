USE [PortfolioProject]
select * from IndiaCrimeWoman 


-- Checking each column name
select DISTINCT(Area) from IndiaCrimeWoman
select DISTINCT(year) from IndiaCrimeWoman
select DISTINCT(Group) from IndiaCrimeWoman


-- Drop the unnecessary column
ALTER TABLE IndiaCrimeWoman
DROP COLUMN Sub_Group_Name 

ALTER TABLE IndiaCrimeWoman
DROP COLUMN F23 


-- Deleting unnecessary rows
DELETE FROM IndiaCrimeWoman
WHERE [Group] = 'Importation of Girls' and Discharged = '1961';


-- Adding a necessary column
ALTER TABLE IndiaCrimeWoman
ADD TotalCaseWithdrawn float NULL 

ALTER TABLE IndiaCrimeWoman
ADD TotalFrSubmitted int NULL

ALTER TABLE IndiaCrimeWoman
ADD InActiveCases int NULL

ALTER TABLE IndiaCrimeWoman
ADD ActiveCases int NULL

ALTER TABLE IndiaCrimeWoman
ALTER COLUMN FRSubmitted1 int null;

ALTER TABLE IndiaCrimeWoman
ALTER COLUMN FRSubmitted2 int null;



-- Inserting value in column

UPDATE IndiaCrimeWoman
SET TotalCaseWithdrawn = (Withdrawn1 + Withdrawn2 + Withdrawn3)

UPDATE IndiaCrimeWoman
SET TotalFrSubmitted = (FRSubmitted1 + FRSubmitted2)

UPDATE IndiaCrimeWoman
SET InActiveCases = (Discharged + TotalCaseWithdrawn + Convicted + DeclaredFalse + InvstgRefused)

UPDATE IndiaCrimeWoman
SET ActiveCases = (TotalFrSubmitted + Chargesheeted + TotalInvstgPendingTillDate + TotalTrialPendingTillDate)

select * from IndiaCrimeWoman 
go;

-- Task 1 = Finding out a total investigation pending till date(for example pendinginvestigation till 2003 menas, addition of pending investigations from 2001 to 2003)

ALTER TABLE IndiaCrimeWoman
ALTER COLUMN InvstgPendingYearEnd int null;

ALTER TABLE IndiaCrimeWoman
ALTER COLUMN InvstgPendingPreviousYear int  null;

ALTER TABLE IndiaCrimeWoman
ALTER COLUMN TotalInvstgPendingTillDate int null;

-- adding a column 
ALTER TABLE IndiaCrimeWoman
ADD TotalInvstgPendingTillDateLag int null

UPDATE IndiaCrimeWoman
SET TotalInvstgPendingTillDateLag = 0;

UPDATE IndiaCrimeWoman
SET TotalInvstgPendingTillDate = 0;

UPDATE IndiaCrimeWoman
SET TotalInvstgPendingTillDateLag = 0;

-- Updating a coumn where the rownumber is 1
UPDATE IndiaCrimeWoman
SET TotalInvstgPendingTillDate = IndiaCrimeWoman.InvstgPendingYearEnd + IndiaCrimeWoman.InvstgPendingPreviousYear 
FROM (
    SELECT [Year], Area, [Group],
           ISNULL(InvstgPendingYearEnd, 0) AS InvstgPendingYearEnd,
           ISNULL(InvstgPendingPreviousYear, 0) AS InvstgPendingPreviousYear, 
           LAG(TotalInvstgPendingTillDate) OVER (ORDER BY [Group], Area,[Year]) AS TotalInvstgPendingTillDateLag,
           ROW_NUMBER() OVER (PARTITION BY [Group], Area ORDER BY Area, [Group],[Year]) AS RowNumber, 
           ISNULL(TotalInvstgPendingTillDate, 0) AS TotalInvstgPendingTillDate
    FROM IndiaCrimeWoman 
) AS InvstgPendingTable
WHERE IndiaCrimeWoman.[Year] = InvstgPendingTable.[Year]
AND IndiaCrimeWoman.Area = InvstgPendingTable.Area
AND IndiaCrimeWoman.[Group] = InvstgPendingTable.[Group]
AND InvstgPendingTable.RowNumber = 1;

-- Run the below command for rownumber 2 to 10 seprately , found error in using (between 2 to 10) thats why need to run command sperately for 2,3,4,5,6,7,8,9,10
UPDATE IndiaCrimeWoman
SET TotalInvstgPendingTillDate = IndiaCrimeWoman.InvstgPendingYearEnd + InvstgPendingTable.TotalInvstgPendingTillDateLag
FROM (
    SELECT [Year], Area, [Group],
           ISNULL(InvstgPendingYearEnd, 0) AS InvstgPendingYearEnd,
           ISNULL(InvstgPendingPreviousYear, 0) AS InvstgPendingPreviousYear, 
           LAG(TotalInvstgPendingTillDate) OVER (ORDER BY [Group], Area,[Year]) AS TotalInvstgPendingTillDateLag,
           ROW_NUMBER() OVER (PARTITION BY [Group], Area ORDER BY Area, [Group],[Year]) AS RowNumber, 
           ISNULL(TotalInvstgPendingTillDate, 0) AS TotalInvstgPendingTillDate
    FROM IndiaCrimeWoman 
) AS InvstgPendingTable
WHERE IndiaCrimeWoman.[Year] = InvstgPendingTable.[Year]
AND IndiaCrimeWoman.Area = InvstgPendingTable.Area
AND IndiaCrimeWoman.[Group] = InvstgPendingTable.[Group]
AND InvstgPendingTable.RowNumber = 10;
 
-- Testing for all the data from table
select [Year],[Area],[Group],InvstgPendingYearEnd,InvstgPendingPreviousYear,TotalInvstgPendingTillDate from IndiaCrimeWoman 
order by [Group],[Area],[Year]
-- Task1 Completed


-- Task 2 = Finding out a total trails pending till date(for example pendingtrial till 2003 menas, addition of pending trial from 2001 to 2003)


select [Year],[Area],[Group],TrialPendingYearEnd,TrialPendingPreviousYear,TotalTrialPendingTillDate, TotalTrialPendingTillDate from IndiaCrimeWoman 
order by [Group],[Area],[Year]

ALTER TABLE IndiaCrimeWoman
ALTER COLUMN TrialPendingYearEnd int null;

ALTER TABLE IndiaCrimeWoman
ALTER COLUMN TrialPendingPreviousYear int  null;


ALTER TABLE IndiaCrimeWoman
ADD TotalTrialPendingTillDate int null

UPDATE IndiaCrimeWoman
SET TotalTrialPendingTillDate = 0;

ALTER TABLE IndiaCrimeWoman
ADD TotalTrialPendingTillDateLag int null

UPDATE IndiaCrimeWoman
SET TotalTrialPendingTillDateLag = 0;

-- Updating a coumn where the rownumber is 1
UPDATE IndiaCrimeWoman
SET TotalTrialPendingTillDate = IndiaCrimeWoman.TrialPendingYearEnd + IndiaCrimeWoman.TrialPendingPreviousYear 
FROM (
    SELECT [Year], Area, [Group],
           ISNULL(TrialPendingYearEnd, 0) AS TrialPendingYearEnd,
           ISNULL(TrialPendingPreviousYear, 0) AS TrialPendingPreviousYear, 
           LAG(TotalTrialPendingTillDate) OVER (ORDER BY [Group], Area,[Year]) AS TotalTrialPendingTillDateLag,
           ROW_NUMBER() OVER (PARTITION BY [Group], Area ORDER BY Area, [Group],[Year]) AS RowNumber, 
           ISNULL(TotalTrialPendingTillDate, 0) AS TotalTrialPendingTillDate
    FROM IndiaCrimeWoman 
) AS TrialPendingTable
WHERE IndiaCrimeWoman.[Year] = TrialPendingTable.[Year]
AND IndiaCrimeWoman.Area = TrialPendingTable.Area
AND IndiaCrimeWoman.[Group] = TrialPendingTable.[Group]
AND TrialPendingTable.RowNumber = 1;

-- run the below command for rownumber 2 to 10 seprately , found error in using (between 2 to 10) thats why need to run command sperately for rownumber 2,3,4,5,6,7,8,9,10

UPDATE IndiaCrimeWoman
SET TotalTrialPendingTillDate = IndiaCrimeWoman.TrialPendingYearEnd + TrialPendingTable.TotalTrialPendingTillDateLag
FROM (
    SELECT [Year], Area, [Group],
           ISNULL(TrialPendingYearEnd, 0) AS TrialPendingYearEnd,
           ISNULL(TrialPendingPreviousYear, 0) AS TrialPendingPreviousYear, 
           LAG(TotalTrialPendingTillDate) OVER (ORDER BY [Group], Area,[Year]) AS TotalTrialPendingTillDateLag,
           ROW_NUMBER() OVER (PARTITION BY [Group], Area ORDER BY Area, [Group],[Year]) AS RowNumber, 
           ISNULL(TotalTrialPendingTillDate, 0) AS TotalTrialPendingTillDate
    FROM IndiaCrimeWoman 
) AS TrialPendingTable
WHERE IndiaCrimeWoman.[Year] = TrialPendingTable.[Year]
AND IndiaCrimeWoman.Area = TrialPendingTable.Area
AND IndiaCrimeWoman.[Group] = TrialPendingTable.[Group]
AND TrialPendingTable.RowNumber = 10;

-- Testing for all the data from table
select [Year],[Area],[Group],TrialPendingYearEnd,TrialPendingPreviousYear,TotalTrialPendingTillDate from IndiaCrimeWoman 
order by [Group],[Area],[Year]
-- Task2 Completed


select * from IndiaCrimeWoman

-- Overall Data 

select [Area],[Year],[Group],Reported,Discharged,Chargesheeted,Convicted,DeclaredFalse,InvstgRefused,SentForTrial,TrialCompleted,ActiveCases,InactiveCases,TotalFrSubmitted,TotalCaseWithdrawn,TotalInvstgPendingTillDate,TotalTrialPendingTillDate
from IndiaCrimeWoman

select * from IndiaCrimeWoman

-- Abstracting Data for further Data Visulizations Use
WITH myData as
( 
select [Area],[Group],SUM(Reported) AS Reported,SUM(ActiveCases) AS ActiveCasesTillDate,SUM(InActiveCases) AS InActiveCasesTillDate,SUM(TotalCaseWithdrawn) AS TotalCasesWithdrawn,SUM(TotalInvstgPendingTillDate) AS TotalInvstgPendingTillDate,SUM(TotalTrialPendingTillDate) as TotalTrialPendingTillDate
from IndiaCrimeWoman 
group by [Area],[Group] 
)
select * from myData 

-- Highest Case Reported 
select [Area],SUM(Reported) AS TotalCaseReported,SUM(ActiveCases) AS ActiveCasesTillDate,SUM(InActiveCases) AS InActiveCasesTillDate
from IndiaCrimeWoman
where [Group] != 'Total Crime Against Women'
group by [Area]
order by SUM(Reported) DESC

-- Total Case in each group by states
select  [Area],[Group],SUM(Reported) AS TotalCaseReported
from IndiaCrimeWoman
where [Group] != 'Total Crime Against Women'
group by [Area], [Group]
order by  [Group],SUM(Reported) Desc

-- Total Cases by each group by Year
select [Year],[Group],SUM(Reported) AS TotalCaseReported
from IndiaCrimeWoman
where [Group] != 'Total Crime Against Women'
group by [Year],[Group]
order by [Year],[Group]

-- Total Cases Reported by Group
select [Group],SUM(Reported) AS TotalCasesReported
from IndiaCrimeWoman
where [Group] != 'Total Crime Against Women'
group by [Group]
ORDER BY SUM(Reported) DESC

-- Total ACtive cases in india
select [YEAR],[Group],[Area],SUM(ActiveCases) AS ActiveCases,SUM(InActiveCases) as InActiveCases
from IndiaCrimeWoman
where [Group] != 'Total Crime Against Women'
group by [Group],[Area],[Year]

-- Total Cases for Rape
select [Year],[Area],[Group],Reported,ActiveCases,TotalInvstgPendingTillDate,TotalTrialPendingTillDate,Convicted
from IndiaCrimeWoman
where [Group] = 'Rape'

-- Overall Case Data
select [Area],SUM(Reported) AS Reported,SUM(Chargesheeted) AS ChargeSheeted,SUM(TotalFrSubmitted) AS FinalReportedSubmitted,SUM(TotalCaseWithdrawn) AS CasesWithdrawn,SUM(InvstgPendingYearEnd) AS InvestigationPending,SUM(TrialCompleted) AS TrialCompleted
from IndiaCrimeWoman
where [Group] != 'Total Crime Against Women'
Group BY [Area]


