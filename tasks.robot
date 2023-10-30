*** Settings ***
Library         RPA.HTTP
Library         RPA.Excel.Files
Library         RPA.Robocorp.Vault
Library         process_json_data.py

Suite Setup     Initial Setup


*** Variables ***
${SECRET_NAME}      CR_Process_Runs
${WORKBOOK_NAME}    output${/}runs.xlsx


*** Tasks ***
Collect Workspace Process Runs
    ${URL}=    Set Variable
    ...    https://cloud.robocorp.com/api/v1/workspaces/${secrets}[workspace_id]/process-runs?limit=500
    WHILE    $URL != $None
        ${URL}=    Get process runs    ${URL}
    END
    Save Workbook


*** Keywords ***
Get process runs
    [Arguments]    ${URL}
    &{headers}=    Create Dictionary    Authorization    RC-WSKEY ${secrets}[api_key]
    ${result}=    RPA.HTTP.GET
    ...    url=${URL}
    ...    headers=${headers}
    ${result_json}=    Evaluate    $result.json()
    ${table}=    Process Json Data    ${result_json}
    Append Rows To Worksheet    ${table}    header=True
    RETURN    ${result_json}[next]

Initial Setup
    ${secrets}=    Get Secret    ${SECRET_NAME}
    Set Suite Variable    ${secrets}
    Create Workbook    ${WORKBOOK_NAME}
