
Param(
    [Parameter(Mandatory = $true )][string] $SiteUrl
)

$env:ENTRAID_APP_ID = '39a54693-963c-4ebb-aad0-3e2bc2c9a6b4'
Import-Module Microsoft.PowerShell.Utility;
Import-Module PnP.PowerShell

	
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
#Import-Module BHF.PnP.Addons


If ($null -eq ${Function New-Guid}) {
    Function New-Guid {
        return [guid]::NewGuid()
    }
}
#



Function New-WorkdayDataList($ListName, $ListUrl, $Connection) {
 
	If($null -ne (Get-PnPList -Identity $ListName -ErrorAction SilentlyContinue)){
       Remove-PnPList -Force -Identity $ListName -Connection $connection 
	}
	New-PnPList -Title $ListName -Url $ListUrl -Template DocumentLibrary
	Add-PnPFolder -Name 'Input' -Folder $ListName
	Add-PnPFolder -Name 'Output' -Folder $ListName
	Set-PnPList -Identity $ListName -BreakRoleInheritance #not sure if I need this -CopyRoleAssignments

	   
    #Grant permission on list to Group
    #Set-PnPListPermission -Identity $ListName -AddRole 'Contribute' -Group 'HROwnersTest'
	Set-PnPListPermission -Identity $ListName -AddRole 'Full Control' -Group 'TESTEFStuff Owners'

	}

#Read more: https://www.sharepointdiary.com/2017/03/add-yes-no-check-box-field-to-sharepoint-list-using-powershell.html#ixzz7PfnvrnL0

Try {

    Connect-PnPOnline -Url $SiteUrl -Interactive 
    $Connection= Get-PnpConnection
	New-WorkdayDataList -ListName 'Rejections' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'ListerPlanning' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'ListerKPIs' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'Refunds' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'G4SCashandCheques' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'MyVolunteer' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'FlashStockCounts' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'AdobeCommerce' -ListUrl $listUrlWorkdayData -Connection $connection
	New-WorkdayDataList -ListName 'Budgetsandtargets' -ListUrl $listUrlWorkdayData -Connection $connection
}
catch {
    $e =    $_.Exception
    $line = $_.InvocationInfo.ScriptLineNumber
    $msg =  $e.Message 
    Write-Host -ForegroundColor Red "caught exception: $msg at $line"
    write-host "Error adding field: $($_.Exception.Message)" -foregroundcolor Red
    Write-Host "Stack Trace: $($_.ScriptStackTrace)"  -ForegroundColor Red
    Exit
}