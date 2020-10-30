# template 

## Features

 * simple web server
 * easy to extend with API
 * auto watch / build, recursive tree parsing
 * as a module, but extensible.


## Usage

install required modules

    npm install --save github:zbryikt/template#v2.0.0


start server:

    cd <your-web-root>; ./node_modules/.bin/server


you can also add following in your own package.json:

    "scripts": {
        "start": "node_modules/.bin/lsc node_modules/template/server.ls"
    },


optional `config.json` in `<your-web-root>` dir for altering default port and other config:

    {
        "port": 3012
    }

Port will be randomized unused port if not specified.


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


## Custom API

run `template` with customized web api by manually initing server:

    require("template")
    template.server.init({
        api: function(server) {
            server.app.get("/custom-api", function(req, res) {
                return res.send("custom api response");
            });
        }
    });

in this case you will have to watch source files manually:

    template.watch.init({ ... });


## Options

server.init accepts config with following options:

 - `port` - port to listen. when omitted, random unused port is used.
 - `startTime` - optional time for providing initialization elapsed time information.
 - `api` - functions for customizing server. executed before server started


watch.init accepts config with following options:

 - `watcher`
   - `ignores`: files to ignored ( not watched ). array of regular expression against file names.
 - `assets`: array of node module names to be copied to `static/assets` folder. **not stable feature.**


## TODO

 * support both indir building or src / static building.
 * api style invocation


## Note

 * To optimize pug building, keep an eye on the pug inclusion tree, and prevent unnecessary include if possible.

## License

MIT
