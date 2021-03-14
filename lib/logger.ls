require! <[colors]>

logger = {}
[<[info green]> <[warn yellow]> <[error red]>].map (n) ->
  logger[n.0] = (...args) ->
    args = ( ["#{n.0.toUpperCase![n.1]}\t: [server]"] ++ args)
    console[n.0].apply console, args

module.exports = logger
