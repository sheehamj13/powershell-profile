#
# Azure
#


# Install Azure PowerShell Module
function InstallAzureModule {
    if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
        Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
          'Az modules installed at the same time is not supported.')
    } else {
        Install-Module -Name Az -AllowClobber -Scope CurrentUser
    }
}

function UpdateAzureModule {
    if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
        Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
          'Az modules installed at the same time is not supported.')
    } else {
        Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force
    }
}

function LoadAzureModule {
    Import-Module -Name Az
}



# # Stolen from
# # https://blogs.msdn.microsoft.com/appserviceteam/2017/02/24/creating-a-local-pfx-copy-of-app-service-certificate/
# #
# # Make sure you follow the steps to make the certificate exportable, by getting the root and intermediate certs,
# # https://ssl-ccp.godaddy.com/repository?origin=CALLISTO
# #
# # Download these tools,
# # https://www.powershellgallery.com/packages/AzureRM/6.13.1
# #
# Function Export-AppServiceCertificate {
#     ###########################################################

#     Param(
#         [Parameter(Mandatory = $true, Position = 1, HelpMessage = "ARM Login Url")]
#         [string]$loginId,

#         [Parameter(Mandatory = $true, HelpMessage = "Subscription Id")]
#         [string]$subscriptionId,

#         [Parameter(Mandatory = $true, HelpMessage = "Resource Group Name")]
#         [string]$resourceGroupName,

#         [Parameter(Mandatory = $true, HelpMessage = "Name of the App Service Certificate Resource")]
#         [string]$name
#     )

#     ###########################################################
#     Write-Output $loginId
#     Write-Output $resourceGroupName
#     Write-Output $keyvaultName

#     Login-AzureRmAccount
#     Set-AzureRmContext -SubscriptionId $subscriptionId

#     ## Get the KeyVault Resource Url and KeyVault Secret Name were the certificate is stored
#     $ascResource = Get-AzureRmResource -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.CertificateRegistration/certificateOrders/$name"
#     $certProps = Get-Member -InputObject $ascResource.Properties.certificates[0] -MemberType NoteProperty
#     $certificateName = $certProps[0].Name
#     $keyVaultId = $ascResource.Properties.certificates[0].$certificateName.KeyVaultId
#     $keyVaultSecretName = $ascResource.Properties.certificates[0].$certificateName.KeyVaultSecretName

#     ## Split the resource URL of KeyVault and get KeyVaultName and KeyVaultResourceGroupName
#     $keyVaultIdParts = $keyVaultId.Split("/")
#     $keyVaultName = $keyVaultIdParts[$keyVaultIdParts.Length - 1]
#     $keyVaultResourceGroupName = $keyVaultIdParts[$keyVaultIdParts.Length - 5]

#     ## --- !! NOTE !! ----
#     ## Only users who can set the access policy and has the the right RBAC permissions can set the access policy on KeyVault, if the command fails contact the owner of the KeyVault
#     Set-AzureRmKeyVaultAccessPolicy -ResourceGroupName $keyVaultResourceGroupName -VaultName $keyVaultName -UserPrincipalName $loginId -PermissionsToSecrets get
#     Write-Host "Get Secret Access to account $loginId has been granted from the KeyVault, please check and remove the policy after exporting the certificate"

#     ## Getting the secret from the KeyVault
#     $secret = Get-AzureKeyVaultSecret -VaultName $keyVaultName -Name $keyVaultSecretName
#     $pfxCertObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @([Convert]::FromBase64String($secret.SecretValueText), "", [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
#     $pfxPassword = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 50 | % {[char]$_})
#     $currentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
#     [Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath
#     [io.file]::WriteAllBytes(".\$name.pfx", $pfxCertObject.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $pfxPassword))

#     ## --- !! NOTE !! ----
#     ## Remove the Access Policy required for exporting the certificate once you have exported the certificate to prevent giving the account prolonged access to the KeyVault
#     ## The account will be completely removed from KeyVault access policy and will prevent to account from accessing any keys/secrets/certificates on the KeyVault, 
#     ## Run the following command if you are sure that the account is not used for any other access on the KeyVault or login to the portal and change the access policy accordingly.
#     # Remove-AzureRmKeyVaultAccessPolicy -ResourceGroupName $keyVaultResourceGroupName -VaultName $keyVaultName -UserPrincipalName $loginId
#     # Write-Host "Access to account $loginId has been removed from the KeyVault"

#     # Print the password for the exported certificate
#     Write-Host "Created an App Service Certificate copy at: $currentDirectory\appservicecertificate.pfx"
#     Write-Warning "For security reasons, do not store the PFX password. Use it directly from the console as required."
#     Write-Host "PFX password: $pfxPassword"
# }



# function Set-KeyVaultGetPolicy {
#     Param(
#         [Parameter(Mandatory = $true, Position = 1, HelpMessage = "ARM Login Url")]
#         [string]$loginId,

#         [Parameter(Mandatory = $true, HelpMessage = "Key Vault Name")]
#         [string]$keyvaultName
#     )

#     Set-AzureRmKeyVaultAccessPolicy -ResourceGroupName "Infrastructure" -VaultName "$keyvaultName" -UserPrincipalName "$loginId" -PermissionsToSecrets get
# }



# # function Export-AppServiceCertificate2 {
# #     $azureLoginEmailId = "mattsheehan@apteryxinc.onmicrosoft.com"
# #     $subscriptionName = "XVWeb2"
# #     $subscriptionId = "9964afa7-28f8-413f-a9db-2a1ea2b23955"
# #     $resourceGroupName = "Infrastructure"
# #     # $certificateName = "xvwebnet2019"
# #     $pfxPassword = "xvwebnet2019"

# #     Login-AzureRmAccount
# #     Select-AzureRmSubscription -SubscriptionName $subscriptionName
# #     # $certificateResource = Get-AzureRmResource -ResourceName $certificateName -ResourceGroupName $resourceGroupName -ResourceType "Microsoft.Web/certificates" -ApiVersion "2015-08-01"
# #     $certificateResource = Get-AzureRmResource -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.CertificateRegistration/certificateOrders/$name"

# #     # $keyVaultId = $certificateResource.Properties.keyVaultId
# #     $certProps = Get-Member -InputObject $certificateResource.Properties.certificates[0] -MemberType NoteProperty
# #     $certificateName = $certProps[0].Name
# #     $keyVaultId = $certificateResource.Properties.certificates[0].$certificateName.KeyVaultId

# #     $keyVaultData = $keyVaultId.Split("/")
# #     $keyVaultDataLength = $keyVaultData.Length
# #     $keyVaultName = $keyVaultData[$keyVaultDataLength - 1]
# #     $keyVaultResourceGroupName = $keyVaultData[$keyVaultDataLength - 5]
# #     $keyVaultSecretName = $certificateResource.Properties.KeyVaultSecretName

# #     Set-AzureRmKeyVaultAccessPolicy -ResourceGroupName $keyVaultResourceGroupName -VaultName $keyVaultName -UserPrincipalName $azureLoginEmailId -PermissionsToSecrets get
# #     $pfxCertObject=New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @([Convert]::FromBase64String($keyVaultSecret.SecretValueText),"", [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)

# #     [io.file]::WriteAllBytes(".\appservicecertificate.pfx", $pfxCertObject.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $pfxPassword))
# # }

