$file1 = $args[0]
$file2 = $args[1]
print $file1
print $file2
$hash1 = Get-FileHash -Path $file1 -Algorithm MD5
$hash2 = Get-FileHash -Path $file2 -Algorithm MD5

if ($hash1.Hash -eq $hash2.Hash) {
    Write-Host "The files are identical."
} else {
    Write-Host "The files are different."
}

$file1 = "C:\Users\Josh-2019\source\repos\LiF\whitelist\Standard_010d104005030100000000000.dds"
$file2 = "D:\Life is Feudal MMO\default\game\game\eu\art\Textures\Heraldry\Cache\cbh.dds"