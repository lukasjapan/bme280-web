# BME280 - Web

[![Build Status](https://travis-ci.org/lukasjapan/bme280-web.svg?branch=master)](https://travis-ci.org/lukasjapan/bme280-web)
[![Coverage Status](https://coveralls.io/repos/github/lukasjapan/bme280-web/badge.svg?branch=master)](https://coveralls.io/github/lukasjapan/bme280-web?branch=master)

Temperature, Humidity and Air pressure logging/visualization with the Bosch BME280 sensor.

The following libraries are used:

- [Sinatra](http://www.sinatrarb.com/) (Minimalistic Ruby Framework)
- [Vue.js](https://vuejs.org/index.html) (Frontend reactive framework)
- [Element](http://element.eleme.io/#/en-US) (GUI element library for Vue.js)
- [Chart.js](http://www.chartjs.org/) (Graphs in an HTML5 canvas)

# Installation

The BME280 must be connected via the I2C interface.
On default, the device it is expected to be available at `/dev/i2c-1`.

Details of the used BME280 ruby driver: https://github.com/lukasjapan/i2c-bme280

```bash
git clone git@github.com:lukasjapan/bme280-web.git
cd bme280-web/
bundle install
yarn install
```

## Raspberry Pi

Make sure you have a relatively new version of Ruby available.
Install [rbenv](https://gist.github.com/blacktm/8302741) or similar if needed.

I2C Pin layout: https://pinout.xyz/pinout/i2c

(BCM mode works well for me)

## Development

I recommend to develop on a desktop machine.
The BME280 does not need to be available in development mode.

```bash
# Initialize DB schema
bundle exec rake db:migrate

# Webpack development server for on-the-fly js updates
./bin/webpack-dev-server

# Start the logger - in development mode random data is inserted in the database
./bin/bme280-logger

# Start the web frontend
./bin/bme280-web
```

Default URL: http://localhost:4567

## Production

```bash
# Initialize DB schema
RACK_ENV=production bundle exec rake db:migrate

# Compile minified js pack
yarn run build

# Start the logger - will be daemonized
RACK_ENV=production ./bin/bme280-logger

# Start the web frontend
RACK_ENV=production ./bin/bme280-web
```

Default URL: http://localhost:4567 (server listens on 0.0.0.0)

# TODO

Aggregation of data.
Currently, raw data will be pulled from the database in 1s steps, even for large ranges.
Averaged results should be used.
