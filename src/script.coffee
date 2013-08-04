colorEnum =
  'r': 'red'
  'b': 'black'

pxMap = [
 #0....½....1....½....2....½....3
  "bbbbbbbbbbbbbbbbbbbb"
  "             b      "
  "   bb bb bb bbb bb  "
  " r bb b  bb  b  bb  "
  "   b                "
  "bbbbbbbbbbbbbbbbbbbb"
]

pixelColor = (x, y) ->
  if pxMap[y][x] isnt " "
    colorEnum[ pxMap[y][x] ]
  else
    "transparent"

elementDimensions = (element = document.documentElement) ->
  width   = element.clientWidth
  height  = element.clientHeight
  { width, height }

pxMapDimensions = () ->
  width   = pxMap[0].length
  height  = pxMap.length
  { width, height }

# Based on http://stackoverflow.com/questions/7764319/how-to-remove-duplicate-white-spaces-in-a-string
trimAll   = (str) ->
  str.trim().replace /(\s)\s*/g, '$1'

# Assumes pixels are square and that the final image width == document width
pixelData = (x, y, unit) ->

  # Determine constraints
  docSize = elementDimensions document.documentElement
  mapSize = pxMapDimensions()

  # Define pixel attributes
  color   = pixelColor x, y


  if unit is "px"
    width   = docSize.width / mapSize.width # pixel
  else if unit is "%" or "percent"
    width   = 1 / mapSize.width * 100 # percent
  else
    return null

  height  = width
  x       = x * width
  y       = y * height
  { x, y, height, width, color }

createElement = (x, y) ->
  unit    = "px"
  pixel   = pixelData x, y, unit
  # early out transparent pixels -- no need to create superfluous DOM elements
  return if pixel.color is "transparent"

  div     = document.createElement "div"
  div.setAttribute "id", "px#{x}-#{y}"
  div.setAttribute "class", "pixel #{pixel.color}"
  div.setAttribute "style", trimAll "
    height: #{ Math.round pixel.height }#{unit};
    width:  #{ Math.round pixel.width }#{unit};
    left:   #{ Math.round pixel.x }#{unit};
    top:    #{ Math.round pixel.y }#{unit};"
  document.body.appendChild div

pixels = ( createElement x, y for value, x in row for row, y in pxMap )

resizePixels = (x, y, pixels) ->
  unit = "px"
  pixel = pixelData x, y, unit
  current = pixels[y][x]
  if current
    current.setAttribute "style", trimAll "
      height: #{ Math.round pixel.height }#{unit};
      width:  #{ Math.round pixel.width }#{unit};
      left:   #{ Math.round pixel.x }#{unit};
      top:    #{ Math.round pixel.y }#{unit};"
  true

window.addEventListener 'resize', (event) =>
  ( resizePixels x, y, pixels for value, x in row for row, y in pxMap )
