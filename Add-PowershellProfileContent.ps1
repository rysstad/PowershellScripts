Function Add-PowershellProfileContent {
     <#
    .SYNOPSIS
    Add Powershell Profile Content
    .NOTE
    Requires elevated privileges 
	.PARAMETER
    PowershellProfilePath
    .PARAMETER
    verificationText
    .PARAMETER
    contentToAdd
    .EXAMPLE
    $ScriptToAdd  = $(Invoke-WebRequest -Uri https://raw.githubusercontent.com/RamblingCookieMonster/PowerShell/master/Invoke-Sqlcmd2.ps1).Content
    Add-PowershellProfileContent -Verbose -PowershellProfilePath $($profile.AllUsersAllHosts) -verificationText "Invoke-Sqlcmd2" -contentToAdd $ScriptToAdd 
    #>

    [CmdletBinding()]

    Param (
        [parameter()] $PowershellProfilePath ,
		[parameter()] $verificationText ,
        [parameter()] $contentToAdd


    )

    Begin {
        Write-Verbose "Performing the Begin-block in Add-PowershellProfileContent"
        Write-Verbose "Verifying that script is run with elevated/administrative privileges"
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity
        $userIsAdmin = $principal.IsInRole( [Security.Principal.WindowsBuiltInRole]::Administrator )

        if ($userIsAdmin -eq $false) {
            Write-Error "ERROR: This script requires elevated/administrative privileges"
            return 1
        } else {
            Write-Verbose "Script run correctly, using elevated/administrative privileges" 
        }

    } # End of Begin

    Process {
        Write-Verbose "Performing the Process-block in Add-PowershellProfileContent"
        Write-Verbose "About to add content to file: $PowershellProfilePath"
        # Create the profile-file if not exist.
        if ($(Test-Path -Path $PowershellProfilePath) -eq $false) {
            Write-Verbose "File $PowershellProfilePath not found, attempting to create it now"
			New-Item -Type File -Path $PowershellProfilePath

# Wierd indentation here... It's because Powershell Here-strings requires it..
$powershellProfileHeader = @" 
#### Powershell Profile 
####

"@
			Set-Content -Path $PowershellProfilePath -Value $powershellProfileHeader -Force
        } else {
            Write-Verbose "File $PowershellProfilePath found, preparing to add content to it now"
        }

		
        Write-Verbose "Reading the Powershell Profile file $PowershellProfilePath"
		$PowershellProfileContent = Get-Content $PowershellProfilePath

		if ($PowershellProfileContent -match $verificationText) {
            Write-Verbose " - $verificationText - found in $PowershellProfilePath"
            Write-Verbose "Assuming content already added, exiting"
		} else {
            Add-Content -Path $PowershellProfilePath -Value $contentToAdd 
        }


    } # End of Process

	       
    #}
} # End of Function Add-PowershellProfileContent
