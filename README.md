# template 

## Features

 * simple web server
 * easy to extend with API
 * auto watch / build, recursive tree parsing
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
   ```
   {
     "port": 3012
   }
   ```


## Start Kit

'''sample''' folder serves as a starting point to bootstrap a project. It contains following files:
 * package.json - a simple package.json with necessary dependencies. You need to update repo info in this.
 * LICENSE - default MIT.
 * config.json - config file used by template.
 * deploy - if you use gh-pages of github, this automatically push your static/ directory to gh-pages branch.
   you need to have a gh-pages branch at first.
 * README.md - a dummy readme. edit it as necessary.
 * src/ - template style source code folder.
   * src/ls/ - livescript code, built to static/js/
   * src/pug/ - pug code, built to static/
   * src/styl/ - stylus code, built to static/css/
 * static/ - generated files or other assets.


## TODO

 * support both indir building or src / static building.
 * api style invocation


## License

MIT
