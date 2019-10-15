# Digital Certificates

This program illustrates the use of digital certificates.

Refer to [`DigitalCertificate.java`](DigitalCertificate/src/com/kelvin/DigitalCertificate.java).

## Instructions

- Create a Key Pair for a Digital Certificate:

  ```powershell
  keytool.exe -genkeypair -alias kelvin_keypair -keyalg "RSA" -keysize 1024 -validity 180 -keystore "kelvin.keystore" -keypass abc123 -storepass 123abc
  ```

- Export the Digital Certificate:

  ```powershell
  keytool.exe -exportcert -alias kelvin_keypair -keystore "kelvin.keystore" -keypass abc123 -storepass 123abc -file "kelvin.cert"
  ```

- Print the Digital Certificatert information:

  ```powershell
  keytool.exe -printcert -file "kelvin.cert"
  ```
