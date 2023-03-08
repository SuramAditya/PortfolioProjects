select * from NashvilleHousing

-- Standadize Date Format -- 

select SaleDate from NashvilleHousing

select SaleDateConverted , convert (Date, SaleDate)
from NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert (Date, saledate)

---------------------------------------------------
--Populate Property Address-----
select *
from NashvilleHousing
where PropertyAddress is Null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isNull(a.PropertyAddress, b.PropertyAddress) 
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID 
And a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = isNull(a.PropertyAddress, b.PropertyAddress) 
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID 
And a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

---Braeking out address into Individual Columns ---

select PropertyAddress
from NashvilleHousing
--where PropertyAddress is Null
--order by ParcelID

select substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Address
from NashvilleHousing

alter table NashvilleHousing
add PropertysplitAddress nvarchar(255);

update NashvilleHousing
set PropertysplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

alter table NashvilleHousing
add PropertysplitCity nvarchar(255);

update NashvilleHousing
set PropertysplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) 

select parsename (replace(OwnerAddress,',','.'),3),
parsename (replace(OwnerAddress,',','.'),2),
parsename (replace(OwnerAddress,',','.'),1)
from NashvilleHousing

alter table NashvilleHousing
add OwnersplitAddress nvarchar(255);

update NashvilleHousing
set OwnersplitAddress = parsename (replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnersplitCity nvarchar(255);

update NashvilleHousing
set OwnersplitCity = parsename (replace(OwnerAddress,',','.'),2)

alter table NashvilleHousing
add OwnersplitState nvarchar(255);

update NashvilleHousing
set OwnersplitState = parsename (replace(OwnerAddress,',','.'),1)

select distinct(SoldAsVacant), count(SoldAsVacant)from NashvilleHousing
group by SoldAsVacant order by 2

select SoldAsVacant,
 case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  Else  SoldAsVacant
	  end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  Else  SoldAsVacant
	  end


--Remove Duplicates--

With RoneNumCTE as(
Select *,
row_number() over( partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
order by UniqueID) row_num
from NashvilleHousing

--order by ParcelID
)
select* from RoneNumCTE
where row_num>1
--order by PropertyAddress


--delete unused Columns--
select * from NashvilleHousing

alter table NashvilleHousing 
drop column OwnerAddress,TaxDistrict, PropertyAddress

alter table NashvilleHousing 
drop column SaleDate