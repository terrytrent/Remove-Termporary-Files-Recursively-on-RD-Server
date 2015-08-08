cls

write-host "Gathering the list of user folders under C:\Users, please wait...." -foregroundcolor "Green"

$userFolders=(get-childitem C:\Users -exclude "Public" | where {$_.Length -eq $NULL} | select name)

write-host "`nRemoving Temporary Internet Files from the gathered folders..." -foregroundcolor "Green"

foreach($folder in $userFolders){$a=$folder.name;$userFolderTemp="C:\Users\" + $a + "\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*";get-childitem "$userFolderTemp" -Recurse | remove-item -Confirm:$false -force -recurse -EA SilentlyContinue}

write-host "`nTemporary Internet Files have been cleaned.  Checking for files and folders not deleted." -foregroundcolor "Green"

$missedFiles=$(foreach($folder in $userFolders){$a=$folder.name;$userFolderTemp="C:\Users\" + $a + "\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*";get-childitem "$userFolderTemp" -Recurse})

if($missedFiles -ne $NULL){

	write-host "`nThe following files and/or folderse could not be removed.`nThe most likelycause is that they are in use." -foregroundcolor "yellow"

	$missedFiles

}
else {

write-host "`nAll Temporary Internet Files removed." -forgroundcolor "yellow"

}

Write-Host "`n`n`nPress any key to close this window..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')