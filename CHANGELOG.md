# Change Log

## v2.4.0

 - support `-m` option to mix up pug and asset folder ( copy asset directly from pug )


## v2.3.46

 - upgrade `@plotdb/srcbuild` to v0.0.68
 - upgrade `chokidar` to v3.6.0


## v2.3.45

 - upgrade `@plotdb/srcbuild` from v0.0.60 to v0.0.61


## v2.3.44

 - upgrade `@plotdb/srcbuild` from v0.0.59 to v0.0.60


## v2.3.43

 - upgrade `@plotdb/srcbuild` from v0.0.56 to v0.0.59
 - audit fix vulnerabilities of dependencies


## v2.3.42

 - upgrade `@plotdb/srcbuild` from v0.0.54 to v0.0.56
 - audit fix for minimatch


## v2.3.41

 - upgrade `@plotdb/srcbuild` from v0.0.53 to v0.0.54


## v2.3.40

 - upgrade `@plotdb/srcbuild` from v0.0.52 to v0.0.53


## v2.3.39

 - upgrade `@plotdb/srcbuild` from v0.0.47 to v0.0.52
 - upgrade `@plotdb/colors` from v0.0.1 to v0.0.2
 - upgrade other dev modules


## v2.3.38

 - upgrade `@plotdb/srcbuild` from v0.0.46 to v0.0.47 for disabling debugCompile option


## v2.3.37

 - upgrade `@plotdb/srcbuild` from v0.0.45 to v0.0.46 for intlbase and watcher behavior change


## v2.3.36

 - upgrade `@plotdb/srcbuild` from v0.0.43 to v0.0.45 with customizable watcher root 
 - support customizable `feroot` in server init option.


## v2.3.35

 - upgrade minimist for vulnerability fixing
 - upgrade `@plotdb/srcbuild` from v0.0.38 to v0.0.43


## v2.3.34

 - upgrade `@plotdb/srcbuild` for fixing dependency issue
 - audit fix


## v2.3.33

 - remove useless `bin/lib/view.js`
 - use `@plotdb/colors` to replace `colors`
 - remove useless dependencies


## v2.3.32

 - bump @plotdb/srcbuild version for libLoader bug fixing


## v2.3.31

 - bump @plotdb/srcbuild version for bundler relative path feature


## v2.3.30

 - bump @plotdb/srcbuild version for stylus dependency and script option bug fixing


## v2.3.29

 - bump @plotdb/srcbuild version for script and css loading bug fixing


## v2.3.28

 - bump @plotdb/srcbuild version for natively supporting script and css loading


## v2.3.27

 - bump @plotdb/srcbuild version for bundler bug fixing


## v2.3.26

 - bump @plotdb/srcbuild version for disabling js compression in minification


## v2.3.25

 - bump @plotdb/srcbuild version for js minifying compression issue


## v2.3.24

 - bump @plotdb/srcbuild version for log removal


## v2.3.23

 - bump @plotdb/srcbuild version for builder update


## v2.3.22

 - bump @plotdb/srcbuild version for tweaking pug generation
 - add legacy / deprecated notes for cfgfile
 - add `lsp` option in config


## v2.3.21

 - bump @plotdb/srcbuild version for bug fixing


## v2.3.20

 - bump @plotdb/srcbuild version for bug fixing


## v2.3.19

 - bump @plotdb/srcbuild version for resolving module from basedir in ext/pug


## v2.3.18

 - bump stylus and @plotdb/srcbuild version for removing deprecated dependencies


## v2.3.17

 - bump `@plotdb/srcubild` version to 0.0.18 for livescript building failed issue


## v2.3.16

 - upgrade `@plotdb/srcbuild` for `json` reading feature


## v2.3.15

 - upgrade `@plotdb/srcbuild` for bug fixing


## v2.3.14

 - upgrade `path-parse` for resolving ReDoS vulnerability
 - upgrade `@plotdb/srcbuild` for supporting glslify transformation of lsc files


## v2.3.13

 - upgrade `@plotdb/srcbuild` for new pug api


## v2.3.12

 - fix module interface issue by removing non-existed dependency


## v2.3.11

 - upgrade `@plotdb/srcbuild` to `0.0.13` for fixing view/pug -> ext/pug parameter passing issue


## v2.3.10

 - upgrade `@plotdb/srcbuild` to `0.0.12` for fixing base, desdir and bundling path log bug


## v2.3.9

 - add `debug` level in default logger.
 - update `@plotdb/srcbuild` for view engine bug fixing
 - remove builtin pug view engine
 - remove useless `watch.ls`


## v2.3.8

 - skipped version due to typo


## v2.3.7

 - update `@plotdb/srcbuild`


## v2.3.6

 - update `@plotdb/srcbuild` for dependencies tracking bug fix


## v2.3.5

 - update `@plotdb/srcbuild` for bundling support


## v2.3.4

 - update `@plotdb/srcbuild` for bug fixing


## v2.3.3

 - enable i18n only if i18n in option is defined.


## v2.3.2

 - upgrade `@plotdb/srcbuild` for bug fixing
 - add test case for special pug include path rule


## v2.3.1

 - update `@plotdb/srcbuild` for pug path bug fix
 - add test case for pug inclusion and extend
 - fix bug: lsp should use '.' instead of


## v2.3.0

 - use `@plotdb/srcbuild` for source code building
 - remove local source code building codes


## v2.2.4

 - fix bug: incorrect path resolving in customized resolve plugin 
 - use local js instead of npx for running local script
 - add test case for relative / absolute path inclusion


## v2.2.3

 - fix bug: pug dependency path resolving incorrect


## v2.2.2

 - fix bug: pug malformat crashes the whole server


## v2.2.1

 - fix bug: update of dependencies doesn't trigger pug file's rebuilding.
 - calculate pug dependencies based on pug native function


## v2.2.0

 - add module / static path for including pug files


## v2.1.10

 - trim i18n key when use to prevent confusion


## v2.1.9

 - add `intlbase` pug function for wrapping url with i18n base.


## v2.1.8

 - tweak build script.
 - add `-p` / `--port` option for assigning port to listen.


## v2.1.7

 - support auto-open functionality with option `-o` or config `open`. default false ( suppressed )


## v2.1.6

 - fix bug: we should require scoped packages with their full name.


## v2.1.5

 - use dependency debounce.js from npm instead of github.


## v2.1.4

 - remove LiveScript header comment.
 - add lson format support.
 - upgrade from `LiveScript 1.3` to `livescript 1.6` for json support.
 - update build script to adopt livescript 1.3 -> 1.6 change.

## v2.1.3

 - make web root customizable and formalize server arguments.
