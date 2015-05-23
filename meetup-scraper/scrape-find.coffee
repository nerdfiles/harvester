###
# fileOverview

                                          ___ _           _
                                         / __|_)         | |
  ___  ____  ____ _____ ____  _____    _| |__ _ ____   __| |
 /___)/ ___)/ ___|____ |  _ \| ___ |  (_   __) |  _ \ / _  |
|___ ( (___| |   / ___ | |_| | ____|    | |  | | | | ( (_| |
(___/ \____)_|   \_____|  __/|_____)    |_|  |_|_| |_|\____|
                       |_|

## description

Basic HTTP GETs for metadata grokable from meetup.com.

###

request = require('request')
cheerio = require('cheerio')
elastical = require('elastical')


client = new (elastical.Client)


group = process.argv[2]


# @frex http://www.meetup.com/{{group||"houstonbitcoin"}}/
page = if process.argv[3] then process.argv[3] else 1


###
@example http://www.meetup.com/find/?allMeetups=false&keywords=bitcoin&radius=Infinity&userFreeform=nerdfiles%40gmail.com&mcId=z77001&mcName=Houston%2C+TX&sort=default
###

# Finder configuration.

allMeetups = 'true'
allMeetups_prefix = 'allMeetups='
keywords = 'bitcoin'
keywords_prefix = 'keywords='
radius_prefix = 'radius='
radius = 'Infinity'
# @note Or units of N
userFreeform_prefix = 'userFreeform='
userFreeform = 'nerdfiles%40gmail.com'
mcId_prefix = 'mcId='
mcId = 'z77001'
mcName_prefix = 'mcName='
mcName = 'Houston%2C+TX'
sort_prefix = 'sort='
sort = 'default'

baseUrl = 'http://www.meetup.com/find/'


parameterConstruct = [
  allMeetups_prefix + allMeetups
  keywords_prefix + keywords
  radius_prefix + radius
  userFreeform_prefix + userFreeform
  mcId_prefix + mcId
  mcName_prefix + mcName
  sort_prefix + sort
].join('&')


baseUrlConstruct = [
  baseUrl
  parameterConstruct
].join('?')


url = baseUrlConstruct
count = 0
start = process.hrtime()


get_page_metadata = (url) ->
  ###
  Page metadata.
  ###

  request url, (error, response, body) ->
    if !error and response.statusCode == 200
      $ = cheerio.load(body, ignoreWhitespace: true)
      topic = $('ul.searchResults').text()
      #console.log topic
    return
  return

request url, (error, response, body) ->
  if !error and response.statusCode == 200
    $ = cheerio.load(body, ignoreWhitespace: true)
    a$ = $('a[href*="bitcoin"]')
    a$.each ->
      this$ = $(this)
      console.log this$.text()
      console.log this$.attr('href')
      #get_page_metadata this$.attr('href')
      return
  else
    console.log error
  return
