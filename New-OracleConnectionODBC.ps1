# Prompt for the password securely
#$securePassword = Read-Host "Enter your Oracle database password" -AsSecureString

# Convert the secure password to plain text (required by the Oracle client)
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

# Load the Oracle Managed Data Access DLL
Add-Type -Path "C:\Oracle\lib\Oracle.ManagedDataAccess.dll"

# Create a new Oracle connection
$connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)

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
    Write-Error "An error occurred: $_"
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