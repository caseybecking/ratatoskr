# Description:
#   Control GitHub Repositories
#
# Dependencies:
#   "githubot": ">=0.2.0"
# 
# Required EnvVars: 
#
#   HUBOT_HIPCHAT_TOKEN  ( needs notification privileges )
#
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_TOKEN 
#   HUBOT_GITHUB_ORG
#
# Optional EnvVars:
#
#   HUBOT_GITHUB_API  (API endpoint [for GH enterprise users])
#
# Commands:
#   hubot !hipchat [org:BlueAcornInc]/<repo> [room:Water Cooler] [on|off:on] - enable/disable hipchat notifications on <repo>. E.g. "!hipchat drey devops" to enable drey notifications in devops room.  
#


module.exports = (robot) ->
  github = require("githubot")(robot)
  
  robot.respond /\!hipchat ([A-Za-z0-9-_\/]+) ?([A-Za-z0-9-_ ]+)? ?(on|off)?/i, (msg) ->
    toggle = if msg.match[3] and msg.match[3] is 'off' then false else true
    room = msg.match[2] || 'Water Cooler'
    repo = msg.match[1]
    
    org = process.env.HUBOT_GITHUB_ORG
    
    # Prefix the organization [e.g.  BlueAcornInc/repository ]
    if ! /^{org}\//.test(repo)
      repo = "#{org}/#{repo}"
    
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    url = "#{base_url}/repos/#{repo}/hooks"
    
    data = { active: 1, toggle: "hipchat", config: { "notify": 1, "auth_token": process.env.HUBOT_HIPCHAT_TOKEN, "room": room  } }
    
    github.post url, data, (response) ->
      msg.send "The \"#{room}\" room will be notified when the #{repo} repository is updated."
      
