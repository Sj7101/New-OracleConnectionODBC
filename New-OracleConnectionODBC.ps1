$connectionString = "Driver={Microsoft ODBC for Oracle};Server=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=danuxz9200si.wellsfargo.com)(PORT=3203))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=ullmsgzl_uat)));Uid=your-username;Pwd=your-password;"

$connection = New-Object System.Data.Odbc.OdbcConnection
$connection.ConnectionString = $connectionString
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "SELECT * FROM your_table"

$adapter = New-Object System.Data.Odbc.OdbcDataAdapter $command
$dataset = New-Object System.Data.DataSet
$adapter.Fill($dataset)

$dataset.Tables[0] | Format-Table

$connection.Close()
