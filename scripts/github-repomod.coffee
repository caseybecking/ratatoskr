# Description:
#   Control GitHub Repositories
#
# Dependencies:
#   "githubot": ">=0.2.0"
# 
# Configuration:
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_API
#   HUBOT_GITHUB_ORG
#
# Commands:
#   hubot repo add-hipchat <repo> <room||"Water Cooler"> - add the hipchat service hook to <repo>. <room> is optional.
#
# Notes:
#   HUBOT_GITHUB_API allows you to set a custom URL path (for Github enterprise users)


module.exports = (robot) ->
  github = require("githubot")(robot)
  
  robot.respond /repo add-hipchat ([A-Za-z0-9-_\/]+) ?([A-Za-z0-9-_ ]+)?/i, (msg) ->   
    room = msg.match[2] || 'Water Cooler'
    repo = msg.match[1]
    
    org = process.env.HUBOT_GITHUB_ORG
    
    # Prefix the organization [e.g.  BlueAcornInc/repository ]
    if ! /^{org}\//.test(repo)
      repo = "#{org}/#{repo}"
    
    base_url = process.env.HUBOT_GITHUB_API || 'https://api.github.com'
    url = "#{base_url}/repos/#{repo}/hooks"
    
    data = { active: 1, name: "hipchat", config: { "notify": 1, "auth_token": process.env.HUBOT_HIPCHAT_TOKEN, "room": room  } }
    
    github.post url, data, (response) ->
      msg.send "The \"#{room}\" room will be notified when the #{repo} repository is updated."
      
