resource "aws_ssm_document" "ad_install_forest" {
  name            = "AX-AD-Install-Prep"
  document_type   = "Command"
  document_format = "YAML"

  content = <<DOC
---
schemaVersion: '2.2'
description  : aws:runPowerShellScript

parameters:
  commands:
    type       : String
    description: "Commands to run."
    default    : |
      Install-WindowsFeature AD-Domain-Services

      $adParams =
      @{
          ForestMode = "WinThreshold"
          DomainMode = "WinThreshold"
          DomainName = "${var.domain_name}"
          InstallDns = $true

          SafeModeAdministratorPassword = (ConvertTo-SecureString "${var.dsrm_password}" -AsPlainText -Force)
      }

      Install-ADDSForest @adParams -Confirm:$false

mainSteps:
- action: aws:runPowerShellScript
  name  : runPowerShellScript
  inputs:
    timeoutSeconds: '600'
    runCommand    :
    - "{{ commands }}"
DOC
}

resource "aws_ssm_association" "this" {
  name = aws_ssm_document.ad_install_forest.name

  targets {
    key    = "InstanceIds"
    values = var.instance_ids
  }
}
