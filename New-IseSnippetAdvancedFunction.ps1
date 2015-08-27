New-IseSnippet -Force -CaretOffset 9 -Author "Tor Arne Rysstad" -Title "Function-Advanced" -Description "A template for advanced functions" -Text 'Function Verb-Noun {
<#
.SYNOPSIS
A brief description of the function or script.
.DESCRIPTION
A detailed description of the function or script.
.PARAMETER
Add an explanation for each parameter. Add a .PARAMETER keyword for
each parameter in the function or script syntax
.EXAMPLE
Add one or more examples
.NOTES
Add notes, if needed
.LINK
https://gist.github.com/rysstad
#>
  [Cmdletbinding()]
  param (
  )
 
  Begin {
    Write-Verbose "Started function "
  }
 
  Process {
  
  }
  
  End {
    Write-Verbose "End of function "
  } 
} # End of function
'