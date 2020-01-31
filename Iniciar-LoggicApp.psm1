# Enviar informacoes para o Logic App
# Ivo Dias

# Referencia:
# https://4bes.nl/2020/01/05/send-email-from-powershell-with-a-logic-app/
# https://docs.microsoft.com/pt-br/azure/logic-apps/logic-apps-http-endpoint
function New-LogicAppInfo {
    param (
        [parameter(position=0, Mandatory=$True)]
        $urlLogicApp,
        [parameter(position=1, Mandatory=$True)]
        $NomePool
    )

    # Configura a informacao
    $infoPool = [PSCustomObject]@{
        NomePool      = "$NomePool"
    }

    # Create a line that creates a JSON from this object
    $JSONInfo = $infoPool | ConvertTo-Json 

    # this line sends the email through the logic app
    Invoke-RestMethod -Method POST -Uri $urlLogicApp -Body $JSONInfo -ContentType 'application/json'
}