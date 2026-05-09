# .NET Clean Architecture Project Generator

This is a PowerShell script that helps you start a new .NET project quickly. It creates a folder structure based on **Clean Architecture** principles.

## 🚀 Features
*   Creates a **Solution** and 4 **Projects** (Api, Application, Domain, Infrastructure).
*   Organizes internal folders (Entities, Interfaces, DTOs, etc.).
*   Automatically installs essential **NuGet Packages** (EF Core, JWT, Swagger).
*   Sets up all **Project References** (Dependencies) correctly.
*   Includes a `.gitignore` file to keep your repo clean.

## 🛠️ How to Use

1.  **Open PowerShell** as Administrator.
2.  **Copy the script** into your PowerShell Profile (type `notepad $PROFILE` to open it).
3.  **Run the command**:
    ```powershell
    New-CleanProject -ProjectName "YourProjectName"
    ```
4.  The script will build the entire structure for you in seconds.

## 🏗️ The Structure
*   **Domain**: Enterprise logic and Entities.
*   **Application**: Business logic, DTOs, and Interfaces.
*   **Infrastructure**: Database context, Identity, and Repositories.
*   **Api**: Controllers and Web configuration.

## 📝 Prerequisites
*   [.NET SDK](https://dotnet.microsoft.com/download) (Version 8.0 or newer recommended).
*   PowerShell 5.1 or 7+.

## 📄 License
This project is open-source. Feel free to use and modify it!