# Change Log

## 2.2.2

 - fix bug: pug malformat crashes the whole server


## 2.2.1

 - fix bug: update of dependencies doesn't trigger pug file's rebuilding.
 - calculate pug dependencies based on pug native function


## 2.2.0

 - add module / static path for including pug files


## 2.1.10

 - trim i18n key when use to prevent confusion


## 2.1.9

 - add `intlbase` pug function for wrapping url with i18n base.


## 2.1.8

 - tweak build script.
 - add `-p` / `--port` option for assigning port to listen.


## 2.1.7

 - support auto-open functionality with option `-o` or config `open`. default false ( suppressed )


## 2.1.6

 - fix bug: we should require scoped packages with their full name.


## 2.1.5

 - use dependency debounce.js from npm instead of github.


## 2.1.4

 - remove LiveScript header comment.
 - add lson format support.
 - upgrade from `LiveScript 1.3` to `livescript 1.6` for json support.
 - update build script to adopt livescript 1.3 -> 1.6 change.

## 2.1.3

 - make web root customizable and formalize server arguments.
