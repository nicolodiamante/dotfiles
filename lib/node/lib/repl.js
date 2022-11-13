#!/usr/bin/env node

/**
 * REPL
 */

// Module dependencies
const Repl = require('repl')
const util = require('util')

// Color functions
const colors = { GREEN: '32' }
const colorize = (color, s) => `\x1b[${color}m${s}\x1b[0m`

// Function that takes an object o1 and returns another function
// that takes an object o2 to extend it with the o1 properties as
// read-only
const extendWith = (properties) => (context) => {
  Object.entries(properties).forEach(([k, v]) => {
    Object.defineProperty(context, k, {
      configurable: false,
      enumerable: true,
      value: v
    })
  })
}

// Function that takes an object o1 with shape { key: command } and returns
// another function that takes the repl and defines the commands in it
const defineCommands = (commands) => (repl) => {
  Object.entries(commands).forEach(([k, v]) => {
    repl.defineCommand(k, v)
  })
}

// Context initializer
const initializeContext = extendWith({
  noop: () => {},
  identity: (x) => x,
  isString: (x) => typeof x === 'string' || x instanceof String,
  timeout: util.promisify(setTimeout)
})

// Set colors
const nodeVersion = colorize(
  colors.GREEN,
  `${process.title} ${process.version}`
)
const prompt = colorize(colors.GREEN, '› ')

// Prompt
const say = (message) => () => console.log(message)
const sayWelcome = say(`Now using ${nodeVersion}\n`) // Log Message
const sayBye = say(`\nClosed ${process.title}.`) // Exit Message

// Print the welcome message
sayWelcome()

// Start the REPL
const repl = Repl.start({
  prompt,
  terminal: true,
  useColors: true,
  useGlobal: true
})

// Initialize our context
initializeContext(repl.context)

// Listen for the server events
repl.on('reset', initializeContext)
repl.on('exit', sayBye)

// History
require('../lib/history.js')(
  repl,
  process.env.HOME + '/.local/state/node/node_history'
)
