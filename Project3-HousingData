SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing 



-----Standardize Date Format
SELECT SaleDate
FROM PortfolioProject.dbo.NashvilleHousing 
UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)




-----If the above query does not work properly
ALTER Table NashvilleHousing
Add SaleDateConverted Date;
UPDATE NashvilleHousing
SET SaleDateConverted = Convert(Date,SaleDate)




-----Populate Property Address Data
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID




-----Definition and Usage. 
-----The ISNULL() function returns a specified value if the expression is NULL. If the expression is NOT NULL, this function returns the expression.
SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID and 
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID and 
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

SELECT * 
FROM PortfolioProject.dbo.NashvilleHousing




-----Breaking out address in individualcolumn(address,city,state)
SELECT PropertyAddress
FROM
PortfolioProject.dbo.NashvilleHousing
---SUBSTRING(Expression, Starting Position, Total Length)
---The CHARINDEX() function searches for a substring in a string, and returns the position. 
SELECT
SUBSTRING(PropertyAddress,0,1)
FROM PortfolioProject.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)
FROM PortfolioProject.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM PortfolioProject.dbo.NashvilleHousing

ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(50);
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER Table NashvilleHousing
Add PropertySplitCity Nvarchar(50);
UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM
PortfolioProject.dbo.NashvilleHousing




--- This is a another way we can breaking out address in city,state, etc.
--- we will use function "PARSENAME"
--- PARSENAME Returns the specified part of an object name through the period (".") and its a backword
--- in our data we have comma"," in order to use PARSENAME we have to convert "," to "."
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(50);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER Table NashvilleHousing
Add OwnerSplitCity Nvarchar(50);
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER Table NashvilleHousing
Add OwnerSplitState Nvarchar(50);
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT *
FROM
PortfolioProject.dbo.NashvilleHousing



-----change y and n to yes and no in soldasvacant column
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM
PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant

SELECT SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' THEN  'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' THEN  'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
From PortfolioProject.dbo.NashvilleHousing




----- RemoveDuplicates
----- to remove duplicate we are using ROW_NUMBER
-----ROW_NUMBER function is a SQL ranking function that assigns a sequential rank number to each new record in a partition.
-----When the SQL Server ROW NUMBER function detects two identical values in the same partition, it assigns different rank numbers to both.



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select * 
From RowNumCTE
where row_num >1

Delete 
From RowNumCTE
Where row_num > 1




----- Delete Unused Column
Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
