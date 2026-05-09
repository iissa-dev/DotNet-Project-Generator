function New-CleanProject {
    <#
    .SYNOPSIS
        Creates a Clean Architecture Solution with EF Core, JWT, and Swagger.
    
    .DESCRIPTION
        This function automates the setup of a .NET Web API following Clean Architecture principles.
        It creates a Solution file, four projects (Api, Application, Domain, Infrastructure),
        organizes internal folders, installs essential NuGet packages, and sets up project references.
    
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
        New-Item -Path $basePath -ItemType Directory
    }

    Set-Location $projectName

    dotnet new sln

    Write-Host "Creating Projects..." -ForegroundColor Cyan
    dotnet new webapi -o "$projectName.Api"
    dotnet new classlib -o "$projectName.Application"
    dotnet new classlib -o "$ProjectName.Infrastructure"
    dotnet new classlib -o "$projectName.Domain"

    # Add projects to solution file
    dotnet sln add (Get-ChildItem -Filter *.csproj -Recurse)
    # Api Folders
    $apiPaths = @("Controllers", "wwwroot")
    foreach($path in $apiPaths) {New-Item -ItemType Directory -Path "$projectName.Api/$path" | Out-Null}
    Write-Host "Installing Packages for WebApi..." -ForegroundColor Blue
    dotnet add "$projectName.Api/$projectName.Api.csproj" package Microsoft.EntityFrameworkCore.Design
    dotnet add "$projectName.Api/$projectName.Api.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer
    dotnet add "$projectName.Api/$projectName.Api.csproj" package Swashbuckle.AspNetCore

    # Domain Folders
    $domainPaths = @("Entities", "Enums", "Exceptions")
    foreach ($path in $domainPaths) { New-Item -ItemType Directory -Path "$projectName.Domain/$path" | Out-Null }

    # Application Folders
    $appPaths = @("Interfaces", "Features", "DTOs", "Mapper", "DependencyInjection", "Extensions", "Result")
    foreach ($path in $appPaths) { New-Item -ItemType Directory -Path "$projectName.Application/$path" | Out-Null }
    Write-Host "Installing Packages for Application..." -ForegroundColor Blue
    dotnet add "$projectName.Application/$projectName.Application.csproj" package Microsoft.AspNetCore.Authentication.JwtBearer

    # Infrestructer Folders
    $infraPaths = @("DependencyInjection", "Identity", "Repositories", "Configuration", "Data")
    foreach ($path in $infraPaths) { New-Item -ItemType Directory -Path "$projectName.Infrastructure/$path" | Out-Null }
    Write-Host "Installing Packages for Infrastructure..." -ForegroundColor Blue
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.AspNetCore.Identity.EntityFrameworkCore
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Design
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Relational
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.SqlServer
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Tools

    Write-Host "Setting up References..." -ForegroundColor Yellow

    dotnet add "$projectName.Application/$projectName.Application.csproj" reference "$projectName.Domain/$projectName.Domain.csproj"

    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" reference "$projectName.Application/$projectName.Application.csproj"
    dotnet add "$projectName.Infrastructure/$projectName.Infrastructure.csproj" reference "$projectName.Domain/$projectName.Domain.csproj"

    dotnet add "$projectName.Api/$projectName.Api.csproj" reference "$projectName.Application/$projectName.Application.csproj"
    dotnet add "$projectName.Api/$projectName.Api.csproj" reference "$projectName.Infrastructure/$projectName.Infrastructure.csproj"

    Write-Host "Clean Architecture Solution '$projectName' is ready!" -ForegroundColor Green

    tree

    Write-Host "Path: $(Get-Location)" -ForegroundColor Gray
    
}