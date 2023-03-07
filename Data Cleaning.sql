
--Standardizing the SaleDate as Date format 

select SaleDate, convert(date, SaleDate)
from PortfolioProject..HousingData

--Update the SaleDate column with standard format

update HousingData
set SaleDate = convert(date, SaleDate)

--Adding a column saledate in a standard date format without removing the original sale date column
ALTER TABLE PortfolioProject..HousingData
ADD SaleDateConverted Date;

update HousingData
set SaleDateConverted = convert(date, SaleDate)

--Property address checking for duplicates and null values

select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..HousingData a
join PortfolioProject..HousingData b
on a.ParcelID = b.ParcelID 
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

UPDATE a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..HousingData a
join PortfolioProject..HousingData b
on a.ParcelID = b.ParcelID 
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--Separating address from citynameusing substring
--CHARINDEX(',',PropertyAddress) is taking on a number which isnot a value soif we subtract 1 from it we can omit the comma in the result 

select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
from PortfolioProject..HousingData
--CHARINDEX(',',PropertyAddress) is taking on a number which isnot a value soif we add 1 to it we can omit the comma in the result 

select  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City
from PortfolioProject..HousingData

ALTER TABLE PortfolioProject..HousingData
ADD PropertySplitAddress nvarchar(255);

Update HousingData
set PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
  

ALTER TABLE PortfolioProject..HousingData
ADD PropertysplitCity nvarchar(255);

update HousingData
set PropertysplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select PropertysplitCity,PropertySplitAddress
from PortfolioProject..HousingData

--Owner address correction

select OwnerAddress
from PortfolioProject..HousingData

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject..HousingData

ALTER TABLE PortfolioProject..HousingData
ADD OwnersplitAddress nvarchar(255);

Update HousingData
set OwnersplitAddress = parsename(replace(OwnerAddress, ',','.'),3)
  

ALTER TABLE PortfolioProject..HousingData
ADD OwnersplitCity nvarchar(255);

Update HousingData
set OwnersplitCity = parsename(replace(OwnerAddress, ',','.'),2)

ALTER TABLE PortfolioProject..HousingData
ADD OwnersplitState nvarchar(255);

Update HousingData
set OwnersplitState = parsename(replace(OwnerAddress, ',','.'),1)

select OwnersplitCity, OwnersplitAddress, OwnersplitState from PortfolioProject..HousingData


--Correcting the SoldAsVacant column

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject..HousingData
group by SoldAsVacant
order by 2

select SoldAsVacant,
  case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  END
  from PortfolioProject..HousingData


  update HousingData
  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
  else SoldAsVacant
  END
  from PortfolioProject..HousingData

  --double check

  select DISTINCT(SoldAsVacant),count(SoldAsVacant)
  from PortfolioProject..HousingData
  group by SoldAsVacant
  order by 2 


  --Remove Duplicates

  --Using CTE And some windows functions

  with ROWNUMCTE AS(
  select *,
  ROW_NUMBER() OVER(
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   order by 
			   UniqueID) row_num
from PortfolioProject..HousingData
--order by ParcelID
)

DELETE
FROM ROWNUMCTE
WHERE row_num > 1


--Deleting unnecessary columns (unnecessary data)

select * from PortfolioProject..HousingData

alter table PortfolioProject..HousingData
drop column OwnerAddress, PropertyAddress, TaxDistrict,SaleDate

alter table PortfolioProject..HousingData
drop column SaleDate