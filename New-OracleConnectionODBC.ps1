# Prompt for the password securely
#$securePassword = Read-Host "Enter your password" -AsSecureString

# Convert the secure password to plain text for the connection string
#$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

# Define connection string using the plain text password
$connectionString = "Driver={Microsoft ODBC for Oracle};Dbq=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=danuxz9200si.wellsfargo.com)(PORT=3203))(CONNECT_DATA=(SERVICE_NAME=ullmsgzl_uat)));Uid=your-username;Pwd=$plainPassword;"

# Create ODBC connection object
$connection = New-Object System.Data.Odbc.OdbcConnection
$connection.ConnectionString = $connectionString

try {
    # Attempt to open the connection
    $connection.Open()
    Write-Host "Connection successful!"

    # Define a test query
    $query = "SELECT * FROM some_table WHERE ROWNUM <= 10"  # Modify as needed

    # Create command object
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    # Execute query and store results
    $adapter = New-Object System.Data.Odbc.OdbcDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataset)

    # Display the first 10 rows from the result
    $dataset.Tables[0] | Format-Table

} catch {
    # Catch and display any errors
    Write-Host "Error occurred: $_"
} finally {
    # Ensure the connection is closed
    $connection.Close()
    Write-Host "Connection closed."
}

# Clear the plain-text password from memory
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))
