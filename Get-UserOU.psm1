Function Get-UserOU{
     Param(
	[Parameter(Mandatory,Position=0)]
	[String]
    $SamAccountName,

    [Parameter(Mandatory=$False,Position=1)]
    [String]
    $Server,

    [Parameter(Mandatory=$False,Position=2)]
    [Switch]
    $Hierarchy
    )

    if(!$Server){
        $Server = $env:LOGONSERVER.Remove(0,2)
    }

    Try{
        $UserData = Get-aduser $SamAccountName -server $Server
    }
    Catch{
        Return write-host "`nUnable to find username: $samaccountname`nPlease try another username..." -ForegroundColor Red
    }

    $IndexOfString = $UserData.distinguishedname.indexof(",OU") + 1
    $DNLength = $UserData.Distinguishedname.length - $IndexOfString
    $UserOU = $UserData.DistinguishedName.Substring($IndexOfString,$DNLength)
    if($Hierarchy){
        $HierarchyOUs = @()
        $HierarchyOUs += $UserOU
        $CurrentDepth = $UserOU
        for($i = 0;$i -lt 50; $i++){
            $IndexOfString = $CurrentDepth.indexof(",OU") + 1
            $DNLength = $CurrentDepth.length - $IndexOfString
            $ParentOU = $CurrentDepth.Substring($IndexOfString,$DNLength)
            $CurrentDepth = $ParentOU
            $HierarchyOUs += $ParentOU
            if($HierarchyOUs[-1] -eq $HierarchyOUs[-2]){
                $HierarchyOUs[-1] = $null
                return $HierarchyOUs = $HierarchyOUs | out-gridview -PassThru -Title "Select the OU('s) you wish to target."
            }
        }
    }
    else{
        return $UserOU
    }
}
