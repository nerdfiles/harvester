###
# fileOverview

  ___  ____  ____ _____ ____  _____
 /___)/ ___)/ ___|____ |  _ \| ___ |
|___ ( (___| |   / ___ | |_| | ____|
(___/ \____)_|   \_____|  __/|_____)
                       |_|

 ____  _____  ___  ___ _____  ____ _____  ___
|    \| ___ |/___)/___|____ |/ _  | ___ |/___)
| | | | ____|___ |___ / ___ ( (_| | ____|___ |
|_|_|_|_____|___/(___/\_____|\___ |_____|___/
                            (_____|

## description

Basic HTTP GETs for archive data grokable from meetup.com.

###

request = require('request')
cheerio = require('cheerio')
elastical = require('elastical')

client = new (elastical.Client)

group = process.argv[2]


# @frex http://www.meetup.com/{{group||"houstonbitcoin"}}/
page = if process.argv[3] then process.argv[3] else 1


# @frex ???
url = 'http://www.meetup.com/' + group + '/messages/archive/?offset=' + (page - 1) * 100


count = 0
start = process.hrtime()


# var filter_html = function (string) {
#     var newstr = string.replace("\r", " ", "gi");
#     newstr = newstr.replace("\n", " ", "gi");
#     newstr = newstr.replace("\t", "", "gi");
#     newstr = newstr.replace(/( )+/, " ", "gi");
#     newstr = newstr.replace(/<( )*td([^>])*>/, "\t", "gi");
#     newstr = newstr.replace(/<( )*br( )*>/, "\n", "gi");
#     newstr = newstr.replace(/<( )*li( )*>/, "\n", "gi");
#     newstr = newstr.replace(/<( )*div([^>])*>/, "\n", "gi");
#     newstr = newstr.replace(/<( )*tr([^>])*>/, "\n", "gi");
#     newstr = newstr.replace(/<( )*p([^>])*>/, "\n", "gi");
#     newstr = newstr.replace("&bull;"," * ", "gi");
#     newstr = newstr.replace("&lsaquo;","<", "gi");
#     newstr = newstr.replace("&rsaquo;",">", "gi");
#     newstr = newstr.replace("&trade;","(tm)", "gi");
#     newstr = newstr.replace("&frasl;","/", "gi");
#     newstr = newstr.replace("&lt;","<", "gi");
#     newstr = newstr.replace("&gt;",">", "gi");
#     newstr = newstr.replace("&copy;","(c)", "gi");
#     newstr = newstr.replace("&reg;","(r)", "gi");
#     newstr = newstr.replace(/&(.{2,6});/,"", "gi");
#     newstr = newstr.replace("\r","\n", "gi");
#     newstr = newstr.replace(/(\n)( )+(\n)/, "\n\n", "gi");
#     newstr = newstr.replace(/(\t)( )+(\t)/, "\t\t", "gi");
#     newstr = newstr.replace(/(\t)( )+(\n)/, "\t\n", "gi");
#     newstr = newstr.replace(/(\n)( )+(\t)/, "\n\t", "gi");
#     newstr = newstr.replace(/(\n)(\t)+(\n)/, "\n\n", "gi");
#     newstr = newstr.replace(/(\n)(\t)+/, "\n\t", "gi");
#     var breaks = "\n\n\n";
#     var tabs = "\t\t\t\t\t";
#     for(var i = 0; i < newstr.length; i++) {
#         newstr = newstr.replace(breaks, "\n\n", "gi");
#         newstr = newstr.replace(tabs, "\t\t\t\t", "gi");
#         breaks = breaks + "\n";
#         tabs = tabs + "\t";
#     }
#     return newstr;
# }


save_to_es = (record) ->
  ###
  Save to ES.

  @param {object} record
  ###

  client.index 'meetup_message_archive', 'message', record, (err, res) ->
    if !err
      console.log 'The message "{record.topic}" was successfully saved.'
    # `err` is an Error, or `null` on success.
    # `res` is the parsed ElasticSearch response data.
    return
  return


get_partial_message = (url, topic) ->
  ###
  Get Partial Message.

  @param {string} url
  @param {string} topic
  ###

  request url, (error, response, body) ->
    if !error and response.statusCode == 200
      $ = cheerio.load(body, ignoreWhitespace: true)
      # console.log("Parsing " + url);
      from = undefined
      from_url = undefined
      date_sent = undefined
      message_body = undefined
      $('div.D_mailHead table tr:nth-child(1) td:nth-child(2)').each ->
        from = $(this).text().trim()
        from_url = $(this).find('a').attr('href')
        return
      $('div.D_mailHead table tr:nth-child(2) td:nth-child(2)').each ->
        date_sent = $(this).text().trim()
        return
      message_body = $('div.D_mailBody').html()
      console.log count
      result = 
        'group': group
        'topic': topic
        'from': from
        'from_url': from_url
        'date_sent': date_sent
        'message_body': message_body
      console.log result
      console.log JSON.stringify(result)
      # save_to_es(result);
      console.log '--------'
      count++
    return
  return


get_full_message = (url) ->
  ###
  Get Full Message.

  @param {string} url
  ###

  request url, (error, response, body) ->
    if !error and response.statusCode == 200
      $ = cheerio.load(body, ignoreWhitespace: true)
      topic = $('div.D_boxhead h1').first().text()
      from = undefined
      from_url = undefined
      date_sent = undefined
      message_body = undefined
      if $('iframe#mailBody').length == 0
        $('div.D_mailHead table tr:nth-child(1) td:nth-child(2)').each ->
          from = $(this).text().trim()
          from_url = $(this).find('a').attr('href')
          return
        $('div.D_mailHead table tr:nth-child(2) td:nth-child(2)').each ->
          date_sent = $(this).text().trim()
          return
        message_body = $('div.D_mailBody').html()
        console.log count
        result = 
          'group': group
          'topic': topic
          'from': from
          'from_url': from_url
          'date_sent': date_sent
          'message_body': message_body
        console.log JSON.stringify(result)
        # save_to_es(result);
        console.log '--------'
        count++
      else
        get_partial_message $('iframe#mailBody').attr('src'), topic
    return
  return


request url, (error, response, body) ->
  if !error and response.statusCode == 200
    $ = cheerio.load(body, ignoreWhitespace: true)
    $('td.wrapNice > a').each ->
      get_full_message $(this).attr('href')
      return
  else
    console.log error
  return
