Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes256 -TPMProtector -SkipHardwareTest
Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryKeyPath "D:\" -RecoveryKeyProtector
(Get-BitLockerVolume -MountPoint C).KeyProtector.recoverypassword > D:\bitlockerkey.txt