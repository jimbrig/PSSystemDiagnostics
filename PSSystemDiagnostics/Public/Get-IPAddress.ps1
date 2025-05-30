Function Get-IpAddress {
  [alias('Get-IP')]
  [CmdletBinding()]
  param()
  $DNSParam = @{
    Name    = 'myip.opendns.com'
    Server  = 'resolver1.opendns.com'
    DnsOnly = $true
  }
  return Resolve-DnsName @DNSParam | ForEach-Object IPAddress
}
