const { join, resolve } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')
module.exports = safeLoad(readFileSync(resolve('config', 'settings.yml')), 'utf8')['webpacker_dev_server']