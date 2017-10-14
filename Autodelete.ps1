#Manual input section - Edit these to match recorder retention and NAS path

#Enter audio retention time in days
$AudioRetention = 365

#Enter screen retention time in days
$ScreenRetention = 21

#Enter Screen Recording Channel numbers
$ScreenChannels = 3, 4, 5

#Enter Archive root path in quotations
$ArchiveRoot = "C:\Archive test"




#----------Automated section **Do Not Touch**--------------

#Assign variables for date past audio retention
$AudioYear = (get-date).AddDays(-$AudioRetention).ToString("yyy")
$AudioMonth = (get-date).AddDays(-$AudioRetention).ToString("MM")
$AudioDay = (get-date).AddDays(-$AudioRetention).ToString("dd")

#Define function to check items in specified directory compared to retention date variables
function Retention{
foreach ($item in dir) <#For loop assigning a temporary variable to each item in the directory#>
{
If ($item.name -lt $args[0]) <#Check if the name integer (folder name) is less than the passed variable#>
{Remove-Item -path $item -recurse} <#Remove the folder where the above is true#>
}}

#Change directory to archive root
cd $ArchiveRoot

#Check items in Year directory compared to retention date variables
Retention $AudioYear

#Change directory to year folder
cd $AudioYear

#Check items in Month directory compared to retention date variables
Retention $AudioMonth

#Change directory to month folder
cd $AudioMonth

#Check items in Day directory compared to retention date variables
Retention $AudioDay

#-----------Screen recording section--------------------
#Format screen channels into 4-digit string to match file structure
$ScreenChannels = $ScreenChannels.ForEach{$_.ToString("0000")}

#Assign variables for date past screen retention
$ScreenYear = (get-date).AddDays(-$ScreenRetention).ToString("yyy")
$ScreenMonth = (get-date).AddDays(-$ScreenRetention).ToString("MM")
$ScreenDay = (get-date).AddDays(-$ScreenRetention).ToString("dd")

#Change directory to archive root
cd $ArchiveRoot

#Check items in directory compared to retention date variables
foreach ($item in dir) <#For loop assigning a temporary variable to each item in the directory#>
{
If ($item.name -lt $ScreenYear) <#Check if the name integer (folder name) is less than the ScreenYear variable#>
{$ScreenChannels.ForEach{Remove-Item -path $item\*\*\$_ -recurse} <#Remove the folder where the above is true#>
}}

#Change directory to the year folder
cd $ScreenYear

#Check items in directory compared to retention date variables
foreach ($item in dir) <#For loop assigning a temporary variable to each item in the directory#>
{
If ($item.name -lt $ScreenMonth) <#Check if the name integer (folder name) is less than the ScreenMonth variable#>
{$ScreenChannels.ForEach{Remove-Item -path $item\*\$_ -recurse} <#Remove the folder where the above is true#>
}}

#Change directory to the month folder
cd $ScreenMonth

#Check items in directory compared to retention date variables
foreach ($item in dir) <#For loop assigning a temporary variable to each item in the directory#>
{
If ($item.name -lt $ScreenDay) <#Check if the name integer (folder name) is less than the ScreenDay variable#>
{$ScreenChannels.ForEach{Remove-Item -path $item\$_ -recurse} <#Remove the folder where the above is true#>
}}
