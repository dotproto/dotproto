colorEnum =
    'r': 'red'
    'b': 'black'

pxMap = [
   #0....½....1....½....2....½....3
    "             b     "
    "   bb bb bb bbb bb "
    " r bb b  bb  b  bb "
    "   b               "

    # "bbbbbbbbbbbbbbbbbbbbbbbbb"
    # "                 b       "
    # "     bbb bb bbb bbb bbb  "
    # "  r  b b b  b b  b  b b  "
    # "     bbb b  bbb  b  bbb  "
    # "     b                   "
    # "bbbbbbbbbbbbbbbbbbbbbbbbb"
]

elementDimensions = (element = document.documentElement) ->
    width  = element.clientWidth
    height = element.clientHeight

    { width, height }

pxMapDimensions = () ->
    width  = pxMap.length
    height = pxMap[0].length

    { width, height }

pixelColor = (x, y) ->
    return pxMap[y][x] is " " ? "transparent" :

    if pxMap[y][x] is " "
        return "transparent"
    else
        return colorEnum[ pxMap[y][x] ]

# Assumes pixel are square and that the final image as wide as the document
pixelData = (x, y) ->
    # Determine constraints
    docSize = elementDimensions document.documentElement
    mapSize = pxMapDimensions()

    width   = docSize.width / mapSize.width
    height  = width
    color   = pixelColor x, y
    x       = Math.floor(x * width)
    y       = Math.floor(y * height)

    { x, y, height, width, color }

createElement = (x, y) ->
    pixel = pixelData x, y

    # don't generate divs for transparent pixels
    if pixel.color is "transparent"
        return

    div = document.createElement "div"
    div.setAttribute "id", "px#{x}-#{y}"
    div.setAttribute "class", "pixel #{pixel.color}"
    div.setAttribute "style", "
        height: #{ pixel.height };
        width:  #{ pixel.width };
        left:   #{ pixel.x };
        top:    #{ pixel.y };"
    document.body.appendChild div

pixels = ( createElement x, y for value, x in row for row, y in pxMap )

console.log pixels
