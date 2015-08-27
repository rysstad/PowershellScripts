################################################################################
#                    PowershellGenerateRandomPassword
#
# Description:  Generate random password consisting of only upper and lower case letters and numbers.
#               Adding non-letter characters would increase the password complexity, but would add 
#               potential problems related to SQL server, ODBC etc. 
#
#     Author name:  Tor Arne Rysstad
#     Created date: 2013.10.29
#     Version:      0.02
#     
#     Based on code snipped from:
# http://blogs.technet.com/b/heyscriptingguy/archive/2013/06/03/generating-a-new-password-with-windows-powershell.aspx
#            ----  All hail to the Scripting Guy!!!!!! ---
#
################################################################################

Function Generate-Password {
 <#
  .SYNOPSIS
  Generate random password.
  .DESCRIPTION
  Generate random password consisting of only upper and lower case letters and numbers. 
  Number of characters is set using the length parameter.
  .EXAMPLE
  Generate-Password
  .EXAMPLE
  Generate-Password -length 10
  .PARAMETER length
  The length of the password. The default 19 characters should work well with most MS systems.
  #>
  [CmdletBinding()]
  Param(
    [int]$Length=19 
  )
  Write-Verbose "Running function Generate-Password"  
  $alphabet=$NULL;
  # Upper case letters A-Z
  For ($a=65;$a –le 90;$a++) {
    $alphabet+=,[char][byte]$a 
  }
  # Lower case letters a-z
  For ($a=97;$a –le 122;$a++) {
    $alphabet+=,[char][byte]$a 
  }
  # Numbers 0-9
  For ($a=48;$a –le 57;$a++) {
    $alphabet+=,[char][byte]$a 
  }
 
  For ($loop=1; $loop –le $length; $loop++) {
    $TempPassword+=($alphabet | Get-Random)
  }
  Write-Verbose "Function Generate-Password completed"
  return $TempPassword
} # end of Function Generate-Password