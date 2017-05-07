require('../game.html')

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

#
# Generate level dial structure
#
# This block produces the level dial, level text and lives remaining that is
# rendered in the top left of the game page.
#

#
# Render the lives in the dial structure
#
# @param  {int} lives The number of remaining lives
# @return {undefined}
#
renderLives = (lives) ->
  maxLives = $('#dial-col').data('maxLives')
  $('#lives').html '&#9679;'.repeat(lives)+'&#9675;'.repeat(maxLives-lives)

setRenderLives = () ->

  # Set HTML metrics (over CSS) for level dial canvas
  dialCol = $('#dial-col')
  dialLen = Math.min dialCol.width(),dialCol.height()
  can = $('#dial')[0]
  can.width   = dialLen;
  can.height  = dialLen;

  # Set metrics for level dial highlighter to match dial
  high = $('#dial-highlight')
  high.width dialLen
  high.height dialLen

  # Render level dial
  level = dialCol.data 'level'
  maxLevel = dialCol.data 'maxLevel'

  data = [{
    value: level,
    color: 'rgba(220,20,60,1.0)'
  }, {
    value: maxLevel-level,
    color: 'rgba(220,20,60,0.3)'
  }]

  options =
    animation: false
    percentageInnerCutout : 80
    segmentShowStroke: false
    showTooltips: false

  ctx = can.getContext '2d'
  chart = new Chart(ctx).Doughnut(data, options)

  # Render level text
  $('#level').append(' '+level);

  # Render lives
  lives = dialCol.data 'lives'
  renderLives lives

#
# Define waveform rendering properties
#
# This global instances WaveSurfers for each full size (non-thumbnail) waveform
# and defines its associated rendering properties/colors. The keys for this
# object and the id's of the assoicated .wave-player.
#
GLOBAL_WAVES =
  'wave-signal':
    'wave': Object.create WaveSurfer
    'waveColor': 'rgba(255,255,255,0.5)'
    'progressColor': 'rgba(255,255,255,1.0)'
  'wave-ob1':
    'wave': Object.create WaveSurfer
    'waveColor': 'rgba(220,20,60,0.5)'
    'progressColor': 'rgba(220,20,60,1.0)'
  'wave-ob2':
    'wave': Object.create WaveSurfer
    'waveColor': 'rgba(173,255,47,0.5)'
    'progressColor': 'rgba(173,255,47,1.0)'
  'wave-ob3':
    'wave': Object.create WaveSurfer
    'waveColor': 'rgba(0,255,255,0.5)'
    'progressColor': 'rgba(0,255,255,1.0)'
  'wave-ob4':
    'wave': Object.create WaveSurfer
    'waveColor': 'rgba(255,165,0,0.5)'
    'progressColor': 'rgba(255,165,0,1.0)'

#
# Generate waveform thumbnails
#
# This block renders the thumbnails for the 5 waveforms populating the game
# page; 1 signal and 4 observations.
#

#
# Generate waveforms for selectable thumbnails
#
genThumbs = () ->
  # Get thumbnail dimension dependancies
  thumbs = $('.thumb')
  thumbWidth = thumbs.width()
  thumbHeight = thumbs.height()
  thumbTitleHeight = $('.thumb-title').outerHeight()

  # loop over waveform containers
  for i in [0...thumbs.length]
    thumb = thumbs.eq i
    wave = thumb.find '.thumb-wave'
    waveTarget = thumb.data 'target'
    waveColor = GLOBAL_WAVES[waveTarget].progressColor

    # Dynamically set HTML height dep on browser calculated .thumb-title height
    wave[0].height = thumbHeight - thumbTitleHeight

    # Instance wavesurfer and load data-src file
    wavesurfer = Object.create WaveSurfer
    wavesurfer.init
      container: '#'+wave.attr('id')
      waveColor: waveColor
      progressColor: waveColor
      height: wave[0].height.toString()
      cursorWidth: '0'
      hideScrollbar: true

    # Load data
    wavesurfer.load $('#'+waveTarget).data 'src'

#
# remove the .render classes on items in tutorial carousel
#
# Within Item 2 and Item 3 of the carousel there are a combined total of 5
# thumbnails that use the .render class hack on their parent .item's to be
# rendered by wavesurfer on window's load. These however need to be removed
# for the carousel to function properly.
#
# Unlike the .wave-player display: none post-initialization fix, I cannot
# remove the .render class after every 'load' event as there are multiple
# thumbnails nested in a single .render for Item 3 (not Item 2). The simplest
# way I see it right now is to remove all .render classes after all 5
# thumbnails in the tutorial have been rendered. A more effective solution
# can wait for a day of fun in the future.
#
removeRenderClosure = _.after 5, () ->
  $('.render').removeClass('render')

#
# Generate waveforms for un-selectable thumbnails (Tutorial::Item 2)
#
genTut2Thumbs = () ->
  # Get thumbnail dimension dependancies
  thumbs = $('.thumb-tut')
  thumbWidth = thumbs.width()
  thumbHeight = thumbs.height()
  thumbTitleHeight = thumbs.find('.thumb-title-tut').outerHeight()

  # Loop over waveform containers
  for i in [0...thumbs.length]
    thumb = thumbs.eq i
    wave = thumb.find '.thumb-wave-tut'
    waveTarget = thumb.data 'target'
    waveColor = GLOBAL_WAVES[waveTarget].progressColor

    # Dynamically set HTML height dep on browser calculated .thumb-title height
    wave[0].height = thumbHeight - thumbTitleHeight

    # Instance wavesurfer and load data-src file
    wavesurfer = Object.create WaveSurfer
    wavesurfer.init
      container: '#'+wave.attr('id')
      waveColor: waveColor
      progressColor: waveColor
      height: wave[0].height.toString()
      cursorWidth: '0'
      hideScrollbar: true

    # Remove the .render hack to allow thumbnails to be rendered
    wavesurfer.on 'ready', removeRenderClosure

    # Load data
    wavesurfer.load $('#'+waveTarget).data 'src'

#
# Generate waveforms for un-selectable thumbnails (Tutorial::Item 3)
#
genTut3Thumbs = () ->
  # Get thumbnail dimension dependancies
  thumbs = $('.thumb-tut-stack')
  thumbWidth = thumbs.width()
  thumbHeight = thumbs.height()
  thumbTitleHeight = thumbs.find('.thumb-title-tut-stack').outerHeight()

  # Loop over waveform containers
  for i in [0...thumbs.length]
    thumb = thumbs.eq i
    wave = thumb.find '.thumb-wave-tut-stack'
    waveTarget = thumb.data 'target'
    waveColor = GLOBAL_WAVES[waveTarget].progressColor

    # Dynamically set HTML height dep on browser calculated .thumb-title height
    wave[0].height = thumbHeight - thumbTitleHeight

    # Instance wavesurfer and load data-src file
    wavesurfer = Object.create WaveSurfer
    wavesurfer.init
      container: '#'+wave.attr('id')
      waveColor: waveColor
      progressColor: waveColor
      height: wave[0].height.toString()
      cursorWidth: '0'
      hideScrollbar: true

    # Remove the .render hack to allow thumbnails to be rendered
    wavesurfer.on 'ready', removeRenderClosure

    # Load data
    wavesurfer.load $('#'+waveTarget).data 'src'

#
# Trigger generation of thumbnails in Selector column and tutorial
#
# This is designed to be called only after all the .waveform-player wvaesurfer
# instances have loaded their data.
#
genThumbsOnAllLoad = _.after 5, () ->
  genThumbs()
  genTut2Thumbs()
  genTut3Thumbs()

#
# Generate waveforms
#
# This block renders the full size waveforms that appear in the waveform
# player region of the game page.
#
addWaveforms = () ->
  # Generate waveforms
  for waveID, waveProps of GLOBAL_WAVES
    waveElm = $('#'+waveID)
    waveHeight = waveElm.height()
    wave = waveProps['wave']

    # Instance wavesurfer and load data-src file
    wave.init
      container: '#'+waveID
      waveColor: waveProps['waveColor']
      progressColor: waveProps['progressColor']
      height: waveHeight.toString()
      cursorWidth: '1'
      cursorColor: 'rgba(255,255,255,0.5)'
      hideScrollbar: true

    # Initialize display properties display: none for all but the signal.
    # This is nessesary because the div cannot have an intial css of none.
    # http://stackoverflow.com/questions/30637577/how-to-obtain-clientwidth-clientheight-before-div-is-visible
    displayNoneClosure = (waveElm) ->
      () ->
        waveElm.css 'display', 'none'
        waveElm.css 'opacity', 100

    if waveID != 'wave-signal'
      wave.on 'ready', displayNoneClosure(waveElm)
    else
      waveElm.css 'opacity', 100

    # Load data
    wave.load waveElm.data('src')

#
# Generate waveform background ticks
#
# This block generates a thin set of ticks backing the .wave-player div's.
#
addBackgroundTicks = () ->
  can = $('#grid')
  gridWidth = can.width()
  gridHeight = can.height()

  # Set HTML metrics not CSS
  can = can[0]
  can.width = gridWidth
  can.height = gridHeight

  ctx = can.getContext "2d"

  # Center yaxis/vertical and get things crisp as shit :D
  # http://www.mobtowers.com/html5-canvas-crisp-lines-every-time/
  ctx.translate 0.5+Math.floor(gridWidth/2), 0.5

  ctx.lineWidth = 0.5
  ctx.strokeStyle = 'rgba(255,255,255,1)'

  # Major x/vertical lines
  halfCount = 10
  scale = 0.00006
  shift = 6
  for i in [1...halfCount]
    x = Math.floor i*(gridWidth-1)/(2*halfCount)

    ctx.beginPath()

    # First quadrant
    ctx.moveTo x, 0
    ctx.lineTo x, scale*x*x + shift

    # Second quadrant
    ctx.moveTo -x, 0
    ctx.lineTo -x, scale*x*x + shift

    # Third quadrant
    ctx.moveTo -x, gridHeight
    ctx.lineTo -x, gridHeight-(scale*x*x + shift) # 0.0001*x*x

    # Forth quadrant
    ctx.moveTo x, gridHeight
    ctx.lineTo x, gridHeight-(scale*x*x + shift)

    ctx.stroke()

  # Major x/vertical center lines
  ctx.beginPath()
  ctx.moveTo 0, 0
  ctx.lineTo 0, shift
  ctx.moveTo 0, gridHeight
  ctx.lineTo 0, gridHeight-shift
  ctx.stroke()

  # Minor x/vertical lines
  halfCount = 10
  for i in [1...halfCount*5]
    x = Math.floor i*(gridWidth-1)/(2*halfCount*5)
    size = 2

    ctx.beginPath()

    # First quadrant
    ctx.moveTo x, 0
    ctx.lineTo x, size

    # Second quadrant
    ctx.moveTo -x, 0
    ctx.lineTo -x, size

    # Third quadrant
    ctx.moveTo -x, gridHeight
    ctx.lineTo -x, gridHeight-size

    # Forth quadrant
    ctx.moveTo x, gridHeight
    ctx.lineTo x, gridHeight-size

    ctx.stroke()

#
# Bind actions to buttons
#
# Click actions for elments are declared on the element by naming the desired
# action in the data-action attribute. The named action may then be keyed in
# the GLOBAL_ACTIONS object and the associated function value defined.
#

#
# Get the visible .wave-player's ID
#
# It is assumed that there is only ever one visible .wave-player at any one
# time. This should be speced when possible.
#
# @return {string} The value of the id attribute for the visible .wave-player.
#
visibleWaveID = () ->
  $('.wave-player').filter(':visible').attr('id')

#
# Get the visible WaveSurfer
#
# It is assumed that there is only ever one visible .wave-player at any one
# time. This should be speced when possible.
#
# @return {WaveSurfer} Returns the WaveSurfer instance associated with the
#  visible .wave-player.
#
visibleWave = () ->
  waveID  = visibleWaveID()
  GLOBAL_WAVES[waveID]['wave']

#
# Carousel
#
# The default Boostrap carousel is great, but I do not want to give it a fixed
# height, as I want the enclosed text to be responsive to screen size. The
# issue then is that the carousel will expand and contract its height based
# on the current item.
#
# To fix this the below jQuery scans the heights of the elements, and sets all
# the items heights to the max height found. This also responds to window
# resizes. Its a hack, and I would have prefered a CSS solution, but this will
# do for now :D
#
# [source-1](https://coderwall.com/p/uf2pka/normalize-twitter-bootstrap-carousel-slide-heights)
# [source-2](http://ryanringler.com/blog/2014/08/24/fixed-height-carousel-for-twitter-bootstrap)
#
carouselNormalization = () ->
  items = $('#tut-carousel .item')   # Grab all slides
  heights = []                       # Empty array to store height values
  tallest = 0                        # To hold tallest slide height

  if items.length
    normalizeHeights = () ->
      items.each () -> # add heights to array
        heights.push $(@).height()
      tallest = Math.max.apply null, heights  # cache largest value
      items.each () ->
        $(@).css 'min-height', tallest + 'px'
    normalizeHeights()
    $('#game').hide().show(0) # Force a redraw as `flexbox` needs it, 0 is ness

    $(window).on 'resize orientationchange', () ->
      tallest = 0
      heights.length = 0 # reset vars
      items.each () ->
        $(@).css 'min-height','0'  # reset min-height
      normalizeHeights() # run it again

#
# Check Preloader
#
# This block generates the svg wave used as a preloader animation when the user
# has selected a data to check.
#
# [Varun Vachhar](http://codepen.io/winkerVSbecks/pen/EVJGVj)
#
addCheckPreloader = () ->
  m = 0.512286623256592433
  h = 60
  a = h / 4
  y = h / 2

  pathDataInit = [
    'M', 0, y+a/2,
    'c', a*m, 0, -(1-a)*m, -a, a, -a
  ].join(' ');

  pathDataBody = _.times 20, () -> [
    's', -(1-a)*m, a, a, a,
    's', -(1-a)*m, -a, a, -a]
  pathDataBody = _.flatten(pathDataBody).join ' '

  $('#check-path').attr 'd', pathDataInit+' '+pathDataBody

#
# Add tooltips
#
addTooltips = () ->
  $('#wave-signal-info').tooltip
    placement: 'right'
    container: 'body'
    delay:
      'show': 1000
      'hide': 500

game = new Vue
  el: '.container-fluid'

  data:
    locs: require('../locs.json')
    loc: getCookie('loc') or 'en'
    level: Number(getCookie('level')) or 1
    maxLevel: 7
    lives: Number(getCookie('lives')) or 3
    maxLives: 3
    quoteNumber: 1
    info:
      mass1: 10
      mass2: 10
      inclination: 90
    signalSrc: ""
    ob1:
      src: ""
      signal: 0
    ob2:
      src: ""
      signal: 0
    ob3:
      src: ""
      signal: 0
    ob4:
      src: ""
      signal: 0

  computed:
    levelText: () -> @locs[@loc].game.main['level-text']
    tutorial: () ->
      title1: @locs[@loc].tutorial['level-1']['title-1']
      text1: @locs[@loc].tutorial['level-1']['text-1']
      title2: @locs[@loc].tutorial['level-1']['title-2']
      text2: @locs[@loc].tutorial['level-1']['text-2']
      title3: @locs[@loc].tutorial['level-1']['title-3']
      text3: @locs[@loc].tutorial['level-1']['text-3']
      title4: @locs[@loc].tutorial['level-1']['title-4']
      text4: @locs[@loc].tutorial['level-1']['text-4']
    quote: () ->
      title: @locs[@loc].quotes.main['title']
      text: @locs[@loc].quotes["quote#{@quoteNumber}"]['quote']
      link: @locs[@loc].quotes["quote#{@quoteNumber}"]['weblink']
      linkText: @locs[@loc].quotes.main['weblink-text']
    signalText: () -> @locs[@loc].game.main['signal-text']
    dataText: () -> @locs[@loc].game.main['data-text']
    checkText: () -> @locs[@loc].game.main['check-text']
    correctText: () -> @locs[@loc].game.main['correct-text']
    incorrectText: () -> @locs[@loc].game.main['incorrect-text']
    continueText: () -> @locs[@loc].game.main['continue-text']
    wonText: () -> @locs[@loc].game.main['won-text']
    lostText: () -> @locs[@loc].game.main['lost-text']
    massText: () -> @locs[@loc].game.main['mass-text']
    inclinationText: () -> @locs[@loc].game.main['inclination-text']

  created: () ->
    # Generate paths to random noise waveforms
    sigBankIDs = (Math.floor(84*Math.random() + 1) for i in [0...4])
    for i in [0..3]
      @["ob#{i+1}"].src = "signalBank/sigbank#{sigBankIDs[i]}/noise.mp3"

    # Choose waveform that will contain a signal
    sigLoc = Math.floor 4*Math.random()
    sigID = sigBankIDs[sigLoc]
    @["ob#{sigLoc+1}"].src = "signalBank/sigbank#{sigID}/data#{@level}.mp3"
    @["ob#{sigLoc+1}"].signal = 1
    @signalSrc = "signalBank/sigbank#{sigID}/hplus.mp3"

    # Prepare signal metadata
    metadata = require "../signalBank.json"
    @info.mass1 = metadata["info#{sigID}"].mass1
    @info.mass2 = metadata["info#{sigID}"].mass2
    @info.inclination = metadata["info#{sigID}"].inclination

    # Chose random quote
    @quoteNumber = Math.floor(32*Math.random() + 1)

  mounted: () ->
    setRenderLives()
    genTut2Thumbs()
    genTut3Thumbs()
    addBackgroundTicks()
    carouselNormalization()
    genThumbs()
    addWaveforms()
    addCheckPreloader()
    addTooltips()

    locCookie = getCookie('loc') or 'en'
    $('[data-loc-sel="'+locCookie+'"]').addClass('active')
    $('[data-loc="'+locCookie+'"]').addClass('active')
    $('#play-now-loc').attr 'value', locCookie

  methods:
    play: () ->
      visibleWave().play()

    pause: () ->
      if visibleWave().isPlaying() # Prevents wf cursor reset on doubletap
        visibleWave().pause()

    repeat: () ->
      visibleWave().seekTo(0)
      visibleWave().play()

    display: (e) ->
      waveTarget = $(e.currentTarget).data('target')
      wave = $('#'+waveTarget)

      if wave.is(':hidden')       # Proceed only if hidden
        @pause()                  # Pause visible waveform if playing
        $('.wave-player').hide()  # Hide all waveforms
        wave.show()               # Show target waveform

      # Expose submission button only for data/non-signal waves
      # Expose signal info only for signal wave
      if waveTarget == 'wave-signal'
        $('#check').hide()
        $('#wave-signal-info').show()
      else
        $('#check').show()
        $('#wave-signal-info').hide()

    check: () ->
      # Toggle tick
      $('#tick').hide()
      $('#tick-noclick').show()

      # Show check preloader
      $('#wave-players').removeClass().addClass('dim-100-20')
      $('#check-preloader').removeClass().addClass('light-0-100')

      _.delay( (waveID) =>
        # Check if visible data contains the signal
        if $('#'+waveID).data('signal') is 1
          # Show continue
          $('#tick-noclick').hide()
          if $('#dial-col').data('max-level') == $('#dial-col').data('level')
            $('#won').show()
            @beginWonCountdown(5)
          else
            $('#continue').show()

          # Show correct preloader
          $('#check-preloader').removeClass().addClass('dim-100-0')
          $('#correct-preloader').removeClass().addClass('light-0-100')

          _.delay( () ->
            # Hide check preloader
            $('#correct-preloader').removeClass().addClass('dim-100-0')
            $('#wave-players').removeClass().addClass('light-20-100')
          , 1200)

        # If not reduce the number of lives
        else

          # With one life lost of one life remaining remove abbility to check
          if @lives == 1
            $('#tick-noclick').hide()
            $('#lost').show()
            @beginLostCountdown(5)
          else
            # Toggle tick
            $('#tick-noclick').hide()
            $('#tick').show()

          # Render new number of lives
          @lives -= 1
          renderLives(@lives)

          # Show incorrect preloader
          $('#check-preloader').removeClass().addClass('dim-100-0')
          $('#incorrect-preloader').removeClass().addClass('light-0-100')

          # Highlight life lost
          $('#dial-highlight').removeClass().addClass('bs-in')

          _.delay( () ->
            # Hide check preloader
            $('#incorrect-preloader').removeClass().addClass('dim-100-0')
            $('#wave-players').removeClass().addClass('light-20-100')

            # Remove life highlight
            $('#dial-highlight').removeClass().addClass('bs-out')
          , 1200)
      , 1200, visibleWaveID())

    nextLevel: () ->
      setCookie('lives', @lives)
      setCookie('level', @level+1)
      window.open('./game.html', '_self')

    lost: () ->
      window.open('./lost.html', '_self')

    complete: () ->
      window.open('./complete.html', '_self')

    #
    # Begin gameover countdown timer
    #
    # When the user has lost all their lives beginCountdown(t) will populate the
    # `GAME OVER ... {1:d}` with an integer counting down from t. At the end of
    # the countdown the function will trigger the `submit` action if the button
    # has not already been pressed.
    #
    # @param  {int} t Starting countdown value
    # @return {undefined}
    #
    beginLostCountdown: (t) ->
      setCookie('lives', 3)
      setCookie('level', 1)

      $('.counter').text t
      if t==0
        @lost()
      else
        _.delay @beginLostCountdown, 1000, t-1

    beginWonCountdown: (t) ->
      setCookie('lives', 3)
      setCookie('level', 1)

      $('.counter').text t
      if t==0
        @complete()
      else
        _.delay @beginWonCountdown, 1000, t-1

    selectLoc: (e) ->
      target = $(e.currentTarget)

      # Get localization value
      locVal = target.data 'loc-sel'
      @loc = locVal
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

      # Set form value for cgi
      locCookie = getCookie('loc') or 'en'
      $('#play-now-loc').attr 'value', locCookie
