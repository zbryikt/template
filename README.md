# template 

## Features

 * simple web server
 * easy to extend with API
 * auto watch / build, recursive tree parsing
 * support indir building or src / static building.
 * as a module, but extensible.


## Usage

 * install required modules
   ```
   npm install --save github:zbryikt/template#v2 LiveScript
   ```
 * start server:
   ```
   ./node_modules/.bin/lsc ./node_modules/template/server.ls
   ```
   you can also add following in your own package.json:
   ```
   "scripts": {
     "start": "node_modules/.bin/lsc node_modules/template/server.ls"
   },
   ```
 * optional config.json in root dir for altering default port and other config:
   {
     "port": 3012
   }


## License

MIT
