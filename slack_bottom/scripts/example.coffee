# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  POST_MESSAGE_URL = 'https://slack.com/api/chat.postMessage?token=<YOUR_SLACK_TOKEN>&channel=<YOUR_DEBUG_CHANNEL>&username=<YOUR_SLACK_USERNAME>&as_user=true&pretty=1&&text='
  SERVER_ADDRESS = "[COMPUTATIONAL_SERVER_ADDRESS]:5000"

  robot.respond /set production/i, (res) ->
    robot.brain.set 'production', 1
    res.reply 'Set production = ' + robot.brain.get('production')
    return

  robot.respond /set no production/i, (res) ->
    robot.brain.set 'production', 0
    res.reply 'Set production = ' + robot.brain.get('production')
    return

  robot.respond /get production/i, (res) ->
    res.reply 'Production = ' + robot.brain.get('production')
    return

  robot.respond /help/i, (res) ->
    help_res = ['Sorry I can\'t help you. I am just a bot', 'Sorry I can\'t. Call 911 if you need emergency help.']
    res.send res.random help_res
    return

  robot.respond /you talked, finally/i, (res) ->
    res.send 'Yea right, I am quite a slow learner, but better late than never!'
    return

  robot.respond /what can you do/i, (res) ->
    res.send 'I do nothing.'
    res.send 'I just listen to you guys and speak a sentence or two when I feel like to.'
    res.send 'Keep talking, the more you talk, the more intelligent I will be.'
    return

  filter_chat = (s) -> return s.match(/set production/i) or 
            s.match(/set no production/i) or 
            s.match(/get production/i) or
            s.match(/help/i) or 
            s.match(/you talked, finally/i) or 
            s.match(/what can you do/i)
            

  robot.hear /(.*)/i, (res) ->
    s = res.match[0]
    if (filter_chat(s))
      return

    if (robot.brain.get('production') > 0)
      SERVER_URL = SERVER_ADDRESS + "/chat?input="
      robot.http(SERVER_URL + res.match[0]).get() (err, res1, body1) ->
        if (body1 isnt "") and (body1 isnt "UNK")
          res.send body1
    else
      SERVER_URL = SERVER_ADDRESS + "/chat?debug=yes&input="
      robot.http(SERVER_URL + res.match[0]).get() (err2, res2, body2) ->
        if (body2 isnt "")
          robot.http(POST_MESSAGE_URL + "Answer for: " + s + "\n" + body2).get() (err3, res3, body3) ->
            return
  
  