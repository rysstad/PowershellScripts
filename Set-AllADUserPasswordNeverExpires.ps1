# Set all AD user-account passwords to never expire.
# Use in test/dev-environments only! :-)
Get-ADUser -Filter * | Set-ADUser -PasswordNeverExpires:$true -Verbose