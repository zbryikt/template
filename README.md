template - for adobe extension
-----------------------

base template for developing html5 adobe extension

Development Note
======================

Download Extension signing toolkit ( ZXPSignCmd  ) : 
* http://labs.adobe.com/downloads/extensionbuilder3.html

create self-signed cert
```
ZXPSignCmd -selfSignedCert TW Taiwan <YourExtensionName> <YourExtensionName> <password> adobe.p12 -validityDays 3650
```

sign extension and create zxp file
```
ZXPSignCmd -sign dist/ dist.zxp adobe.p12 <password> -tsa https://timestamp.geotrust.com/tsa
```

check certificate timestamp
```
  openssl x509 -enddate -noout -in file.pem
```

Debug
=======================

Use localhost:8088 for Photoshop, and localhost:8089 for Illustrator. Check .debug for more configuration.
