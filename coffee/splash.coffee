require('../index.html')

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
# Get a cookie's value
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
  document.cookie = cookie+expires

splash = new Vue
  el: '#splash'

  data:
    locs: require('../locs.json')

  created: () ->
    setCookie('level', 1)
    setCookie('lives', 3)

  mounted: () ->
      locCookie = getCookie('loc') or 'en'
      $('[data-loc-sel="'+locCookie+'"]').addClass('active')
      $('[data-loc="'+locCookie+'"]').addClass('active')

  methods:
    about: () ->
      $('#welcome').removeClass().addClass('op-out')
      $('#about').removeClass().addClass('op-in')

    home: () ->
      $('#about').removeClass().addClass('op-out')
      $('#welcome').removeClass().addClass('op-in')

    selectLoc: (e) ->
      target = $(e.currentTarget)

      # Get localization value
      locVal = target.data 'loc-sel'
      loc = "loc="+locVal+";"

      # Compile expiration string for 30 days
      date = new Date()
      date.setTime date.getTime()+(30*24*60*60*1000)
      expires = "expires="+date.toGMTString()+";"

      # Set cookie
      document.cookie = loc+expires+"path=/;"

      # Set selector styles
      $('[data-loc-sel]').removeClass()
      $('[data-loc-sel="'+locVal+'"]').addClass('active')

      # Set display styles
      $('[data-loc]').removeClass()
      $('[data-loc='+locVal+']').addClass('active')

