# Prompt for the password securely
$securePassword = Read-Host "Enter your Oracle database password" -AsSecureString

# Convert the secure password to plain text (required for the connection string)
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
)

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
$assemblyPath = "C:\Path\To\Oracle.ManagedDataAccess.dll"
$assembly = [Reflection.Assembly]::LoadFrom($assemblyPath)

# Use reflection to access the internal configuration
$providerConfigType = $assembly.GetType("OracleInternal.Common.ProviderConfig")
$configField = $providerConfigType.GetField("_config", [Reflection.BindingFlags] "NonPublic, Static")

# Create a custom configuration object
$config = New-Object OracleInternal.Common.ConfigBase
$configField.SetValue($null, $config)

# Proceed with creating the connection
try {
    $connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)
    Write-Host "OracleConnection object created successfully."

    # Open the connection
    $connection.Open()
    Write-Host "Connection successful!"

    # Define a simple test query
    $query = "SELECT 1 FROM DUAL"

    # Create a command
    $command = $connection.CreateCommand()
    $command.CommandText = $query

    # Execute the command and read the result
    $result = $command.ExecuteScalar()
    Write-Host "Query result: $result"

    # Close the connection
    $connection.Close()
    Write-Host "Connection closed."
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    $currentException = $_.Exception
    while ($currentException.InnerException) {
        $currentException = $currentException.InnerException
        Write-Error "Inner Exception: $($currentException.Message)"
    }
    # Display the stack trace
    Write-Host "Stack Trace:"
    Write-Host $currentException.StackTrace
}

finally {
    # Ensure the connection is closed
    if ($connection.State -eq 'Open') {
        $connection.Close()
        Write-Host "Connection closed in finally block."
    }

    # Clear the plain-text password from memory
    $plainPassword = $null
}
