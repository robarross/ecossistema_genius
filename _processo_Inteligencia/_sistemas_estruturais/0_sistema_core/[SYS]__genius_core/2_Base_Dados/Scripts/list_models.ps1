# List Models
$key = "AIzaSyCYqId9KgFZIWa9Qhe2ps6jZW6AWFLyTpM"
$url = "https://generativelanguage.googleapis.com/v1beta/models?key=$key"
$res = Invoke-RestMethod -Uri $url -Method Get
$res.models | Where-Object { $_.supportedGenerationMethods -contains "embedContent" } | Select-Object name, displayName
