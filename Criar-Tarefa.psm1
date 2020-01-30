# Criar tarefa no Azure Devops
# Ivo Dias

function New-AzureDevOpsWI {
    param (
        [parameter(position=0, Mandatory=$True)]
        $nomeTarefa,
        [parameter(position=1, Mandatory=$True)]
        $descricaoTarefa,
        [parameter(position=2)]
        $tipoTarefa,
        [parameter(position=3)]
        $AzureDevOpsPAT,
        [parameter(position=4)]
        $OrganizationName,
        [parameter(position=5)]
        $ProjectID
    )

    # Configura o acesso
    $AzureDevOpsAuthenicationHeader = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }
    $UriOrga = "https://dev.azure.com/$($OrganizationName)/" 
    #$uriProject = $UriOrga + "_apis/projects/$($ProjectID)/properties?api-version=5.1-preview.1"

    # https://dev.azure.com/{organization}/{project}/_apis/wit/workitems/${type}?api-version=5.1
    $uriProject = $UriOrga + "$ProjectID/_apis/wit/workitems/`$" + $tipoTarefa + "?api-version=5.1"    

    # Escreve a tarefa
    $workItem = @{
        "name" = "$nomeTarefa"
        "description" = "$descricaoTarefa"
        "ProjectVisibility" = "private"
        "capabilities" = @{
            "versioncontrol" = @{
                "sourceControlType" = "Git"
            }
            "processTemplate" = @{
                "templateTypeId" = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2"
            }
        }
    }  | ConvertTo-Json -Depth 5

    # Envia a tarefa
    try {
        Invoke-RestMethod -Uri $uriProject -Method Post -Headers $AzureDevOpsAuthenicationHeader -Body $workItem -ContentType "application/json"
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Ocorreu um erro ao criar a tarefa $nomeTarefa"
        Write-Host "Error: $ErrorMessage"
    }

    return $uriProject
}