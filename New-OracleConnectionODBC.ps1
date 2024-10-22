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


<#

$releaseKey = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction Stop).Release
switch ($releaseKey) {
    { $_ -ge 533325 } { ".NET Framework 4.8.1 or later"; break }
    { $_ -ge 528040 } { ".NET Framework 4.8"; break }
    { $_ -ge 461814 } { ".NET Framework 4.7.2"; break }
    { $_ -ge 461808 } { ".NET Framework 4.7.2 (Windows 10 April 2018 Update)"; break }
    { $_ -ge 461308 } { ".NET Framework 4.7.1"; break }
    { $_ -ge 460798 } { ".NET Framework 4.7"; break }
    { $_ -ge 394802 } { ".NET Framework 4.6.2"; break }
    { $_ -ge 394254 } { ".NET Framework 4.6.1"; break }
    { $_ -ge 393295 } { ".NET Framework 4.6"; break }
    { $_ -ge 379893 } { ".NET Framework 4.5.2"; break }
    { $_ -ge 378675 } { ".NET Framework 4.5.1"; break }
    { $_ -ge 378389 } { ".NET Framework 4.5"; break }
    default { "Version 4.5 or earlier"; break }
}




#>