# Prompt for the password securely
$securePassword = Read-Host "Enter your Oracle database password" -AsSecureString

# Convert the secure password to plain text (required for the connection string)
$passwordPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPtr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPtr)  # Clean up

# Define the connection string
$connectionString = @"
Data Source=(DESCRIPTION=
    (ADDRESS=(PROTOCOL=TCP)(HOST=danuxz9200si.wellsfargo.com)(PORT=3203))
    (CONNECT_DATA=(SERVICE_NAME=ullmsgzl_uat))
);
User ID=your-username;
Password=$plainPassword;
"@

# Load the Oracle Managed Data Access DLL using Reflection
try {
    [Reflection.Assembly]::LoadFrom("C:\Path\To\Oracle.ManagedDataAccess.dll") | Out-Null
} catch {
    $e = $_.Exception
    Write-Error "Failed to load assembly: $($e.Message)"
    if ($e.InnerException) {
        Write-Error "Inner Exception: $($e.InnerException.Message)"
    }
    if ($e.LoaderExceptions) {
        foreach ($le in $e.LoaderExceptions) {
            Write-Error "LoaderException: $($le.Message)"
        }
    }
    exit
}

# Proceed with creating the connection
try {
    $connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)
} catch {
    Write-Error "Failed to create OracleConnection: $($_.Exception.Message)"
    exit
}


try {
    # Open the connection
    $connection.Open()
    Write-Host "Connection successful!"

    # Define your query
    $query = "SELECT * FROM your_table WHERE ROWNUM <= 10"  # Replace 'your_table' with your actual table

    # Create a command
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    # Execute the command and fill the DataTable
    $reader = $command.ExecuteReader()
    $dataTable = New-Object System.Data.DataTable
    $dataTable.Load($reader)

    # Display the results
    $dataTable | Format-Table -AutoSize
}
catch {
    Write-Error "An error occurred during database operations: $($_.Exception.Message)"
}
finally {
    # Close the connection
    $connection.Close()
    Write-Host "Connection closed."

    # Clear the plain-text password from memory
    $plainPassword = $null
}


<#
Update the DLL Path:

Replace "C:\Oracle\lib\Oracle.ManagedDataAccess.dll" with the actual path where the DLL is located.

Enter Your Oracle Credentials:

User ID: Replace your-username in the connection string with your Oracle database username.
Password: The script securely prompts for your password.
Adjust the Query:

Replace your_table in the $query variable with the actual table name you want to query.

#>

<#Test Loading the Assembly Alone
try {
    [Reflection.Assembly]::LoadFrom("C:\Path\To\Oracle.ManagedDataAccess.dll") | Out-Null
    Write-Host "Assembly loaded successfully."
} catch {
    $e = $_.Exception
    Write-Error "Failed to load assembly: $($e.Message)"
    if ($e.InnerException) {
        Write-Error "Inner Exception: $($e.InnerException.Message)"
    }
    if ($e.LoaderExceptions) {
        foreach ($le in $e.LoaderExceptions) {
            Write-Error "LoaderException: $($le.Message)"
        }
    }
}

#>

<# Confirm the Assembly Is Properly Loaded

$assemblyPath = "C:\Path\To\Oracle.ManagedDataAccess.dll"
$assembly = [Reflection.Assembly]::LoadFrom($assemblyPath)

# List all types in the assembly
$assembly.GetTypes() | Where-Object { $_.FullName -like "*OracleConnection*" } | Select FullName

Expected Output:
Oracle.ManagedDataAccess.Client.OracleConnection


#>

<#
Use fully qualified assembly name
Note: Replace the Version and PublicKeyToken with the values from your DLL.

$assemblyName = "Oracle.ManagedDataAccess, Version=4.122.19.1, Culture=neutral, PublicKeyToken=89b483f429c47342"
Add-Type -AssemblyName $assemblyName


#>

<#

Use [Activator]::CreateInstance Instead of New-Object
If New-Object isn't working, you can try using the .NET Activator class to create an instance of OracleConnection.

$connectionType = [Oracle.ManagedDataAccess.Client.OracleConnection]
$connection = [Activator]::CreateInstance($connectionType, $connectionString)

Replace your New-Object line with the above code.

#>

<#
Minimal Test Script:

$assemblyPath = "C:\Path\To\Oracle.ManagedDataAccess.dll"
[Reflection.Assembly]::LoadFrom($assemblyPath) | Out-Null

$connectionString = "User Id=your_username;Password=your_password;Data Source=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=danuxz9200si.wellsfargo.com)(PORT=3203))(CONNECT_DATA=(SERVICE_NAME=ullmsgzl_uat)));"

try {
    $connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)
    Write-Host "OracleConnection object created successfully."
} catch {
    Write-Error "Failed to create OracleConnection: $($_.Exception.Message)"
}



#>