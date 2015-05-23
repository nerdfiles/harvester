###
# fileOverview

  ____  ____ ___  ____
 / ___)/ ___) _ \|  _ \
( (___| |  | |_| | | | |
 \____)_|   \___/|_| |_|

## description

Automated workflows for scraping meetup.com by group name.

###

cronJob = require('cron').CronJob
scrape_find = require('scrape-find')
scrape_messages = require('scrape-messages')
_ = require('lodash')


harvestJob = new cronJob( '0 18 * * *', () ->

  scrape_find().then (compiled_list) ->
    _list = _.map compiled_list, (groupFound) ->
      groupFound.href

    #scrape_messages()

)
