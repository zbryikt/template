template - for adobe extension
-----------------------

base template for developing html5 adobe extension

Development Note
======================

Enable dev mode for testing extension without signing it : [(ref)](http://www.adobe.com/devnet/creativesuite/articles/a-short-guide-to-HTML5-extensions.html)

* On Mac, open the file ~/Library/Preferences/com.adobe.CSXS.4.plist and add a row with key PlayerDebugMode, of type String, and value 1.
* On Windows, open the registry key HKEY_CURRENT_USER/Software/Adobe/CSXS.4 and add a key named PlayerDebugMode, of type String, and value 1.

Location for unsigned extension :
* On Mac, copy the extension into ~/Library/Application Support/Adobe/CEPServiceManager4/extensions
* On Windows, copy the extension into %APPDATA%\Adobe\CEPServiceManager4\extensions

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
