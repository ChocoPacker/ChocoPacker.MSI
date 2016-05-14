param($buildNumber = 1,
    [switch]
    $localDotNet)
    
# If specified we will prepend PATH with local dotnet CLI SDK
if ($localDotNet){
    . .\downloadDotNet.ps1
    Download-DotNet
}

& dotnet restore ChocoPacker.MSI.Windows
if ($LASTEXITCODE -ne 0){
    Write-Output 'Failed to restore dotnet dependencies'
    exit 1
}

& dotnet pack ChocoPacker.MSI.Windows -c Release --version-suffix=$buildNumber
if ($LASTEXITCODE -ne 0){
    Write-Output 'Failed to create Burn nuget'
    exit 1
}

& dotnet restore ChocoPacker.MSI.Windows.Tests
if ($LASTEXITCODE -ne 0){
    Write-Output 'Failed to restore dotnet test dependencies'
    exit 1
}

& dotnet build ChocoPacker.MSI.Windows.Tests -c Release
if ($LASTEXITCODE -ne 0){
    Write-Output 'Failed to build unit tests'
    exit 1
}

& dotnet test ChocoPacker.MSI.Windows.Tests
if ($LASTEXITCODE -ne 0){
    Write-Output 'Failed to run unit tests'
    exit 1
}

exit 0