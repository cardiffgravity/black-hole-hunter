require('../lost.html')

#
# Get a cookie's value
#
# [W3Schools](http://www.w3schools.com/js/js_cookies.asp)
#
# @param  {string} cname Cookie name/key
# @return {string} Value of cookie with key cname
#
getCookie = (cname) ->
  name = cname + '='
  ca = document.cookie.split ';'
  for c in ca
      c = c.substring(1) while c.charAt(0) is ' '
      return c.substring(name.length,c.length) if c.indexOf(name) is 0
  return ''

#
# Set a cookie's value
#
# [W3Schools](http://www.w3schools.com/js/js_cookies.asp)
#
# @param  {string} cname Cookie name/key
# @param  {string} cvalue Cookie value
#
setCookie = (cname, cvalue) ->
  # Compile cookie string
  cookie = "#{cname}=#{cvalue};"

  # Compile expiration string for 30 days
  date = new Date()
  date.setTime date.getTime()+(30*24*60*60*1000)
  expires = "expires="+date.toGMTString()+";"

  # Set cookie
  document.cookie = cookie+expires+"path=/game.html;"

splash = new Vue
  el: '.container'

  data:
    locs: require('../locs.json')
    loc: getCookie('loc') or 'en'

  created: () ->
    setCookie('level', 1)
    setCookie('lives', 3)

  computed:
    playAgain: () -> @locs[@loc].endgame['main']['play-again']
    home: () -> @locs[@loc].endgame['main']['home']
    lostTitle: () -> @locs[@loc].endgame['lost']['title']
    lostText: () -> @locs[@loc].endgame['lost']['text']
    learnTitle: () -> @locs[@loc].endgame['learn']['title']
    learnText: () -> @locs[@loc].endgame['learn']['text']
    doTitle: () -> @locs[@loc].endgame['do']['title']
    doText: () -> @locs[@loc].endgame['do']['text']
