function Is_WingetInstalled {
    try {
        Get-Command winget -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}


Is_WingetInstalled
