# Customize the PowerShell prompt
function prompt {
    $TitlePrefix = $env:MSYSTEM
    if (Test-Path -Path "/etc/profile.d/git-sdk.sh") {
        $TitlePrefix = "SDK-" + $env:MSYSTEM.Replace("MINGW", "")
    }
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $GitPromptPath = "~/.config/git/git-prompt.sh"
    if (Test-Path -Path $GitPromptPath) {
        . $GitPromptPath
    } else {
        $Host.UI.RawUI.WindowTitle = "${TitlePrefix}:$PWD"
        Write-Host ""
        Write-Host "╭─ " -NoNewline
        Write-Host -ForegroundColor Green -NoNewline $env:USERNAME
        Write-Host -NoNewline " at "
        Write-Host -ForegroundColor Cyan -NoNewline $env:COMPUTERNAME
        Write-Host -NoNewline " using "
        Write-Host -ForegroundColor Yellow -NoNewline "pws "
        Write-Host -ForegroundColor Magenta -NoNewline $CmdPromptCurrentFolder
        Write-Host ""

        if (-not $env:WINELOADERNOEXEC) {
            $GitExecPath = & git --exec-path 2>$null
            $CompletionPath = $GitExecPath -replace "\\libexec\\git-core$", ""
            $CompletionPath = $CompletionPath -replace "\\lib\\git-core$", ""
            $CompletionPath = Join-Path $CompletionPath "share\git\completion"
            if (Test-Path -Path (Join-Path $CompletionPath "git-prompt.sh")) {
                . (Join-Path $CompletionPath "git-completion.bash")
                . (Join-Path $CompletionPath "git-prompt.sh")
                Write-Host -ForegroundColor Cyan -NoNewline (Get-GitBranch)
            }
        }
    }

    Write-Host -NoNewline "╰─ λ"
    return " "
}

# MSYS2_PS1 environment variable
$env:MSYS2_PS1 = $function:prompt