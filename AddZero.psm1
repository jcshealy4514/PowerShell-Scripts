Function AddZero ($String){

    $String = $String.split("`r`n",[System.StringSplitOptions]::RemoveEmptyEntries)
    $Index = 0
    foreach($Item in $String){
        $i = 6 - $Item.length
        while($i -gt 0){
            $String[$Index] = "0" + $String[$Index]
            $i--
        }
        $Index++
    }
    set-clipboard $String
}

Export-ModuleMember AddZero