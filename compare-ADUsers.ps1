If ( ! (Get-module ActiveDirectory )) {
    Import-Module ActiveDirectory
}

# accunts to compare
$UserName1 = "Username1"
$UserName2 = "Username2"

# Getting the AD User objects, inkluding the MemberOf property
$userAccount1 = Get-ADUser -Identity $UserName1 -Properties MemberOf
$userAccount2 = Get-ADUser -Identity $UserName2 -Properties MemberOf

# Compare group memberships
$comparison = Compare-Object -ReferenceObject ($userAccount1).MemberOf -DifferenceObject ($userAccount2).MemberOf

# Replace the arrows produced by Compare-Object with text
# (sorry for the crappy code... )
$comparison | ForEach-Object  {
      if ($_.sideindicator -eq '<=') {
       $_.sideindicator = "Only $UserName1 is member of"
      }

      if ($_.sideindicator -eq '=>'){
       $_.sideindicator = "Only $UserName2 is member of"
      }
     }

# Output a table that shows the diffenence in group membership.
$comparison | Select-Object @{l='User';e={$_.SideIndicator}},@{l='Group';e={$_.InputObject}} | Format-Table -AutoSize