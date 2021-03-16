# Change Log

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
