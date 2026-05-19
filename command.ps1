function New-CleanProject {
    <#
    .SYNOPSIS
        Creates a Clean Architecture Solution with EF Core, JWT, and Swagger.
    
    .DESCRIPTION
        This function automates the setup of a .NET Web API following Clean Architecture principles.
        It creates a Solution file, four projects (Api, Application, Domain, Infrastructure),
        organizes internal folders, installs essential NuGet packages, and sets up project references.
        It forces IDEs to display folders by creating a 'Placeholder.cs' file in each.
    
    .PARAMETER ProjectName
        The name of the solution and the prefix for all projects.
    
    .EXAMPLE
        New-CleanProject -ProjectName "OrderingSystem"
    #>
    param (
        [Parameter(Mandatory = $false)]
        [string]$projectName
    )

    if (-not $projectName) {
        $projectName = Read-Host "Project Name: "
    }

    $currentPath = Get-Location
    $basePath = Join-Path -Path $currentPath -ChildPath "$projectName"

    # Create Main Folder
    if (-not (Test-Path $basePath)) {
        New-Item -Path $basePath -ItemType Directory | Out-Null
    }

    Set-Location $basePath

    # Solution
    dotnet new sln -n $projectName

    Write-Host "Creating Projects..." -ForegroundColor Cyan
   
    dotnet new webapi -o "$projectName.Api" --use-controllers
    dotnet new classlib -o "$projectName.Application"
    dotnet new classlib -o "$projectName.Infrastructure"
    dotnet new classlib -o "$projectName.Domain"

    
    Write-Host "Adding projects to Solution..." -ForegroundColor Yellow
    dotnet sln add "$projectName.Api/$projectName.Api.csproj"
    dotnet sln add "$projectName.Application/$projectName.Application.csproj"
    dotnet sln add "$projectName.Infrastructure/$projectName.Infrastructure.csproj"
    dotnet sln add "$projectName.Domain/$projectName.Domain.csproj"

    function Create-FolderWithPlaceholder {
        param ([string]$projectPath, [string]$folderName)
        $fullPath = Join-Path -Path $projectPath -ChildPath $folderName
        if (-not (Test-Path $fullPath)) { New-Item -ItemType Directory -Path $fullPath -Force | Out-Null }
        
        $filePath = Join-Path -Path $fullPath -ChildPath "Placeholder.cs"
        "// Placeholder file to force IDE directory visibility" | Out-File -FilePath $filePath -Encoding utf8
    }

    # 1. Api Folders
    $apiPaths = @("Controllers")
    foreach($path in $apiPaths) {
        Create-FolderWithPlaceholder -projectPath "$projectName.Api" -folderName $path
    }
    
    Write-Host "Installing Packages for WebApi..." -ForegroundColor Blue
    dotnet add "$projectName.Api/$projectName.Api.csproj" package Microsoft.EntityFrameworkCore.Design
    dotnet add "$projectName.Api/$projectName.Api.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer
    dotnet add "$projectName.Api/$projectName.Api.csproj" package Swashbuckle.AspNetCore

    # 2. Domain Folders
    $domainPaths = @("Entities", "Enums", "Exceptions")
    foreach ($path in $domainPaths) { 
        Create-FolderWithPlaceholder -projectPath "$projectName.Domain" -folderName $path
    }

    # 3. Application Folders
    $appPaths = @("Interfaces", "Features", "DTOs", "Mapper", "DependencyInjection", "Extensions", "Result")
    foreach ($path in $appPaths) { 
        Create-FolderWithPlaceholder -projectPath "$projectName.Application" -folderName $path
    }
    
    Write-Host "Installing Packages for Application..." -ForegroundColor Blue
    dotnet add "$projectName.Application/$projectName.Application.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer

    # 4. Infrastructure Folders
    $infraPaths = @("DependencyInjection", "Identity", "Repositories", "Configuration", "Data")
    foreach ($path in $infraPaths) { 
        Create-FolderWithPlaceholder -projectPath "$projectName.Infrastructure" -folderName $path
    }
    
    Write-Host "Installing Packages for Infrastructure..." -ForegroundColor Blue
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.AspNetCore.Identity.EntityFrameworkCore
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Design
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Relational
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.SqlServer
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Tools

    # (References)
    Write-Host "Setting up References..." -ForegroundColor Yellow

    dotnet add "$projectName.Application/$projectName.Application.csproj" reference "$projectName.Domain/$projectName.Domain.csproj"

    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" reference "$projectName.Application/$projectName.Application.csproj"
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" reference "$projectName.Domain/$projectName.Domain.csproj"

    dotnet add "$projectName.Api/$projectName.Api.csproj" reference "$projectName.Application/$projectName.Application.csproj"
    dotnet add "$projectName.Api/$projectName.Api.csproj" reference "$projectName.Infrastructure/$projectName.Infrastructure.csproj"

    Write-Host "Clean Architecture Solution '$projectName' is ready!" -ForegroundColor Green
    Write-Host "Path: $(Get-Location)" -ForegroundColor Gray
}