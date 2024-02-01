/*
Cleaning in SQL
*/

Select *
from COVID..[NashvilleHousing]

/*
 Standardize Date Format
*/

Select SaleDate, CONVERT(date, saledate)
-- we add convert.... to remove the 00:00:00 at the the coulmn
from COVID..[NashvilleHousing]

update [Nashville Housing]
set SaleDate =  CONVERT(date, saledate)
-- emm still not updated
select SaleDate
from COVID..[NashvilleHousing]

-- let's try Alter table
Alter table NashvilleHousing
add Saledateconvert date;

update NashvilleHousing
set Saledateconvert = CONVERT(date, saledate)
--now works
select Saledateconvert
from COVID..[NashvilleHousing]

/*
	Populate Property Address data
*/

select PropertyAddress
from COVID..[NashvilleHousing]
where PropertyAddress is null

--let's try to see everthing and see where PropertyAddress is null
select *
from COVID..NashvilleHousing
--where PropertyAddress is null
order by ParcelID 


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from COVID..NashvilleHousing a
join COVID..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from COVID..NashvilleHousing a
join COVID..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


/*
	Breaking out Adress into Individual colums (Adress, City, State)
*/

select PropertyAddress
from COVID..[NashvilleHousing]

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Adress
from COVID..NashvilleHousing
--CharINDEX(',')   it's a method u can use to serach for anything 
-- for example CharINDEX('tom')

-- okay so here we were trying to get rid of the comma(,)
-- we used this form select 
--			SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Adress
		--  from COVID..NashvilleHousing	
-- without -1 we were still getting the comma at the end soo we tried to add -1 and it worked
-- select 
--BSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Adress
--from COVID..NashvilleHousing


--	Another Example

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Adress
, SUBSTRING(PropertyAddress,charindex(',', PropertyAddress) + 1, LEN(PropertyAddress)) as adress

from COVID..NashvilleHousing

Alter table COVID..NashvilleHousing
add PropertySplitAdress Nvarchar(255);

update COVID..NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter table COVID..NashvilleHousing
add PropertySplitCity Nvarchar(255);

update COVID..NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,charindex(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- check result
select *
from COVID..NashvilleHousing
-- if u go to the end end u will find the columns