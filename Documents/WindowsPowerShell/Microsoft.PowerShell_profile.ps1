Invoke-Expression (&starship init powershell)

# This removes .exe for executables that are on the path, making the prompt
# command feel more unixy.
Function TabExpansion2 {
    [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
    Param(
        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
        [string] $inputScript,

        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 1)]
        [int] $cursorColumn,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
        [System.Management.Automation.Language.Ast] $ast,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
        [System.Management.Automation.Language.Token[]] $tokens,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
        [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

        [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
        [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
        [Hashtable] $options = $null
    )

    End
    {
        $source = $null
        if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet')
        {
            $source = [System.Management.Automation.CommandCompletion]::CompleteInput(
                <#inputScript#>  $inputScript,
                <#cursorColumn#> $cursorColumn,
                <#options#>      $options)
        }
        else
        {
            $source = [System.Management.Automation.CommandCompletion]::CompleteInput(
                <#ast#>              $ast,
                <#tokens#>           $tokens,
                <#positionOfCursor#> $positionOfCursor,
                <#options#>          $options)
        }
        $field = [System.Management.Automation.CompletionResult].GetField('completionText', 'Instance, NonPublic')
        $source.CompletionMatches | % {
            If ($_.ResultType -eq 'Command' -and [io.file]::Exists($_.ToolTip)) {
                $field.SetValue($_, [io.path]::GetFileNameWithoutExtension($_.CompletionText))
            }
        }
        Return $source
    }    
}

# This gives a bash/zsh-like tab autocomplete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# gdot
function gdot {
    & git --git-dir=$HOME/.gdot/ --work-tree=$HOME @args
}


$env:PATH += ";C:\Program Files\Git\usr\bin"
