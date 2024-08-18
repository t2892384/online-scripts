
function Get-AdminRights {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($isAdmin) { return }
    Start-Process powershell -Verb runAs -ArgumentList '-noexit','-ExecutionPolicy','bypass','-File',$PSCommandPath
    Exit
}

function Choco-Install {
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    choco install nodejs git vscode firefox -y
    choco install postman tableplus mobaxterm 7zip obs-studio ffmpeg notepadplusplus.install github-desktop -y
    # choco install monday
}

function Update-Path {
    $userPath = (Get-ItemProperty -Path 'HKCU:\Environment').Path
    $systemPath = (Get-ItemProperty -Path 'HKLU:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment').Path
    $env:PATH = "$userPath;$systemPath"
}

function Python-Install {
    irm "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" | iex
    Update-Path
    pyenv install 3
    pyenv global 3
}

Set-ExecutionPolicy Bypass -Force
Get-AdminRights
Choco-Install
Python-Install