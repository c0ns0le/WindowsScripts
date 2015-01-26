:: Script to set the Execution Policy of Powershell
:: By Jason DiBabbo (jason.dibabbo@outlook.com)

:: Set the Execution Policy
@powershell -NoProfile -NoLogo -Command "Set-ExecutionPolicy RemoteSigned -Force"