Function BuildArray(){

    ##Parameter Values to allow new arguments on the function
    Param(
	[Parameter(Mandatory,Position=0)]
	[String[]]
    $String,

    [Parameter(Mandatory=$False,Position=1)]
    [String[]]
    $Quotes,

    [Parameter(Mandatory=$False,Position=2)]
    [switch]
    $NoContainer,

    [Parameter(Mandatory=$False,Position=3)]
    [switch]
    $Clip
    )

    ##Reads the arguments and changes output of script
    if($Quotes -eq "Double"){$Quotes = '"'}
    else{$Quotes = "'"}

    if($NoContainer -eq $true){$ContainerString1 = $null; $ContainerString2 = $null}
    elseif($NoContainer -eq $false){$ContainerString1 = "@("; $ContainerString2 = ")"}
    
    ##Turns the string into an array
    $string = $string.split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)

    ##Format a new string and add each entry into it one by one
    $newstring = $ContainerString1
    Foreach($entry in $string){
        $newstring = $newstring + "$Quotes$entry$Quotes,"
    }

    ##Remove a few extra characters and we have the desired string
    $newstring = $newstring.remove($newstring.length - 1)
    $newstring = $newstring + $ContainerString2

    ##Logic to print array to screen, if string is too long it will concatenate some of it.
    if($newstring.length -gt 80){
        $reportout = $newstring.substring(0,80) + "...... and more."
    }
    else{
        $reportout = $newstring
    }

    ##Set clipboard to array if -clip flag is called.
    if($clip){
        set-clipboard $reportout
    }

    ##Output
    write-host "`nArray built!`n$reportout"
    return $reportout | out-null
}

export-modulemember BuildArray