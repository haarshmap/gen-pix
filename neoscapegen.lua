local canvasWidth = 200
local canvasHeight = 300

sprite = Sprite(canvasWidth, canvasHeight)
app.activeSprite = sprite

app.refresh()

-- colour generation
local baseHue = math.random(360)
local baseSat = math.random(15, 40) / 100
local baseVal = math.random(81, 100) / 100
local baseColour = Color{ h=baseHue, s=baseSat, v=baseVal, a=255 }

-- creating a new layer and a cell
local skyLayer = sprite:newLayer()
skyLayer.name = "sky"
local cel = sprite:newCel(skyLayer, 1)

-- defining a brush
local brush1 = Brush {
  type = BrushType.CIRCLE,
  size = 1
}
local brush2 = Brush {
  type = BrushType.CIRCLE,
  size = 2
}

local tableBrushes = {brush1, brush2}

-- paint bucket for a said point
app.useTool {
  tool = "paint_bucket",
  color = baseColour,
  brush = brush1,
  points = { Point(1, 1) },
  cel = cel,
  layer = skyLayer
}

-- Creating another layer for the stars
local starLayer = sprite:newLayer()
starLayer.name = "stars"
local cel = sprite:newCel(starLayer, 1)

-- multiple stars
local numberStars = math.random(20, 80)

local i
for i = 0, numberStars, 1 do
  local starXCoord = math.random(0, canvasWidth)
  local starYCoord = math.random(0, canvasHeight)

  local chosenBrush = tableBrushes[math.random(#tableBrushes)]

  app.useTool {
    tool = "pencil",
    color = Color { h = 0, s = 0, v = 1, a = 255 },
    brush = chosenBrush,
    points = { Point(starXCoord, starYCoord) },
    cel = cel,
    layer = starLayer
  }

end

-- ellipse fill tool
local sphereXCoord = math.random(6, canvasWidth - 6)
local sphereYCoord = math.random(6, canvasHeight / 3)
local sphereDiameter = math.random(10, 40)

-- Shape tool from point to point + diameter
app.useTool {
  tool = "filled_ellipse",
  color = Color { h = 0, s = 0, v = 1, a = 255 },
  brush = brush1,
  points = {
    Point(sphereXCoord, sphereYCoord),
    Point(sphereXCoord + sphereDiameter, sphereYCoord + sphereDiameter)
  },
  cel = cel,
  layer = startLayer
}

function genWindows(buildingStartX, buildingEndX, buildingStartY, buildingEndY, windowWidth, windowHeight, windowColour1, windowColour2)

-- Working out window size and number
local buildingWidth = buildingEndX - buildingStartX
local buildingHeight = buildingEndY - buildingStartY
local windowsInRow = (buildingWidth - 2) / windowWidth
local windowsInColumn = (buildingHeight - 2) / windowHeight

-- Window loops
local iy
local ix
for iy = 0, windowsInColumn, 1 do

  for ix = 0, windowsInRow, 1 do

    local windowStartX = buildingStartX + 1 + (ix * windowWidth)
    local windowStartY = buildingStartY + 3 + (iy * windowHeight)
    local windowEndX = windowStartX + windowWidth - 2
    local windowEndY = windowStartY + windowHeight - 3

    if windowEndX < buildingEndX then

      local drawWindowChance = math.random(1, 10)

      if drawWindowChance >= 7 then

        local colourTable = {windowColour1, windowColour1, windowColour1, windowColour2}
        local chosenColour = colourTable[math.random(#colourTable)]

        app.useTool {
          tool = "filled_rectangle",
          color = chosenColour,
          brush = brush1,
          points = {
            Point(windowStartX, windowStartY),
            Point(windowEndX, windowEndY)
          },
          cel = cel,
          layer = layer
        }
        end
      end
    end
    ix = 0
  end
end

local featureTable = {
  "Box",
  "Dome",
  "Light",
  "Platform",
}
local chosenFeature = featureTable[math.random(#featureTable)]

function genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour, windowWidth, windowHeight, windowColour1, windowColour2, chosenFeature)

  -- Building creation loop
  local i
  for i = 0, buildingWidth, 1 do

  local chosenFeature = featureTable[math.random(#featureTable)]
    buildingStartX = buildingWidth * i + math.random( -buildingWidth, buildingWidth)
    local buildingStartY = buildingHeight + math.random( -15, 15)
    local buildingEndX = buildingStartX + buildingWidth + math.random(-10, 10)
    local buildingEndY = canvasHeight

    app.useTool {
      tool = "filled_rectangle",
      color = buildingColour,
      brush = brush1,
      points = {
        Point(buildingStartX, buildingStartY),
        Point(buildingEndX, buildingEndY)
      },
      cel = cel,
      layer = layer
    }

  if chosenFeature == "Box" then

    local boxStartX = math.random(buildingStartX, buildingStartX + (buildingWidth/2))
    local boxStartY = math.random(buildingStartY - 5, buildingStartY - 1)
    local boxEndX = math.random(buildingStartX + (buildingWidth/2), buildingEndX)
    local boxEndY = buildingStartY

    app.useTool {
      tool = "filled_rectangle",
      color = buildingColour,
      brush = brush1,
      points = {
        Point(boxStartX, boxStartY),
        Point(boxEndX, boxEndY)
      },
      cel = cel,
    layer = layer
    }

  elseif chosenFeature == "Dome" then

  local domeDiameterMin = (buildingEndX - buildingStartX)/2
  local domeDiameterMax = buildingEndX - buildingStartX
  local domeDiameter = math.random(domeDiameterMin, domeDiameterMax)
  local domeRadius = domeDiameter/2

  local domeStartX = (buildingStartX + ((buildingEndX - buildingStartX)/2)) - domeRadius
  local domeStartY = math.random(buildingStartY - domeRadius, buildingStartY - (domeRadius/2))
  local domeEndX = (buildingStartX + ((buildingEndX - buildingStartX)/2)) + domeRadius
  local domeEndY = math.random(buildingStartY + (domeRadius/2), buildingStartY + domeRadius)

  app.useTool {
    tool = "filled_ellipse",
    color = buildingColour,
    brush = brush1,
    points = {
      Point(domeStartX, domeStartY),
      Point(domeEndX, domeEndY)
    },
    cel = cel,
    layer = layer
  }

  elseif chosenFeature == "Light" then

    local lightColour = Color{ h=5, s=0.6, v=1, a=255 }

    app.useTool {
      tool = "pencil",
      color = lightColour,
      brush = brush1,
      points = {Point(buildingStartX + 2, buildingStartY - 1)},
      cel = cel,
      layer = layer
    }
    app.useTool {
      tool = "pencil",
      color = lightColour,
      brush = brush1,
      points = {Point(buildingEndX - 1, buildingStartY - 1)},
      cel = cel,
      layer = layer
    }


  elseif chosenFeature == "Light" then

    local lightColour = Color{ h=5, s=0.6, v=1, a=255 }

    app.useTool {
      tool = "pencil",
      color = lightColour,
      brush = brush1,
      points = {Point(buildingStartX + 2, buildingStartY - 1)},
      cel = cel,
      layer = layer
    }
    app.useTool {
      tool = "pencil",
      color = lightColour,
      brush = brush1,
      points = {Point(buildingEndX - 1, buildingStartY - 1)},
      cel = cel,
      layer = layer
    }

  end

    -- Windows
    windowWidthCurrent = math.random(windowWidth - 1, windowWidth + 1)
    windowHeightCurrent = math.random(windowHeight - 1, windowHeight + 1)
    genWindows(buildingStartX, buildingEndX, buildingStartY, buildingEndY, windowWidthCurrent, windowHeightCurrent, windowColour1, windowColour2)
  end
end

-- generating lights and roads
function genRoads(roadPositionY, roadThickness, roadColour)
  app.useTool {
    tool = "fill_rectangle",
    colour = roadColour,
    brush = brush1,
    points = {
      Point(0, roadPositionY),
      Point(canvasWidth, roadPositonY + roadThickness)
    },
    cel = cel,
    layer = layer
  }
end

-- buildings 1
local buildingsLayer1 = sprite:newLayer()
buildingsLayer1.name = "buildings, 1"
local cel = sprite:newCel(buildingsLayer1, 1)
local buildingWidth = canvasWidth / 10
local buildingHeight = canvasHeight - (canvasHeight * 0.65)
local buildingColour1 = Color{ h=baseHue - math.random(5, 10), s=baseSat + (math.random(5, 10)/100), v=baseVal - (math.random(6, 10)/100), a=255 }

local windowWidth = 2
local windowHeight = 4
local windowColour1a = baseColour
local windowColour1b = baseColour
windowWidthCurrent = math.random(windowWidth - 1, windowWidth + 1)
windowHeightCurrent = math.random(windowHeight - 1, windowHeight + 1)

local windowsInRow = (buildingWidth - 2) / windowWidth
local windowsInColumn = (buildingHeight - 2) / windowHeight

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour1, windowWidth, windowHeight, windowColour1a, windowColour1b, chosenFeature)


-- buildings 2
local buildingsLayer2 = sprite:newLayer()
buildingsLayer2.name = "buildings, 2"
local cel = sprite:newCel(buildingsLayer2, 1)
local layer = buildingsLayer2

-- Set building and window parameters
local buildingWidth = canvasWidth/9
local buildingHeight = canvasHeight - (canvasHeight * 0.60)
local buildingStartX = 0
local buildingColour2 = Color{ h=baseHue - math.random(30, 40), s=baseSat + (math.random(5, 10)/100), v=baseVal - (math.random(35, 50)/100), a=255 }
local windowWidth = 3
local windowHeight = 5
local windowColour2a = baseColour
local windowColour2b = buildingColour1

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour2, windowWidth, windowHeight, windowColour2a, windowColour2b, chosenFeature)

-- buildings 3
local buildingsLayer3 = sprite:newLayer()
buildingsLayer3.name = "buildings, 3"
local cel = sprite:newCel(buildingsLayer3, 1)
local layer = buildingsLayer3

-- Set building and window parameters
local buildingWidth = canvasWidth/9
local buildingHeight = canvasHeight - (canvasHeight * 0.50)
local buildingStartX = 0
local buildingColour3 = Color{ h=baseHue - math.random(50, 60), s=baseSat + (math.random(5, 10)/100), v=baseVal - (math.random(50, 60)/100), a=255 }
local windowWidth = 3
local windowHeight = 5
local windowColour3a = baseColour
local windowColour3b = buildingColour1

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour3, windowWidth, windowHeight, windowColour3a, windowColour3b, chosenFeature)

-- buildings 4
local buildingsLayer4 = sprite:newLayer()
buildingsLayer4.name = "buildings, 4"
local cel = sprite:newCel(buildingsLayer4, 1)
local layer = buildingsLayer4

-- Set building and window parameters
local buildingWidth = canvasWidth/9
local buildingHeight = canvasHeight - (canvasHeight * 0.45)
local buildingStartX = 0
local buildingColour4 = Color{ h = baseHue - math.random(50, 70), s=baseSat + (math.random(5, 10)/100), v=baseVal - (math.random(70, 80)/100), a=255 }
local windowWidth = 3
local windowHeight = 5
local windowColour4a = baseColour
local windowColour4b = buildingColour1

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour4, windowWidth, windowHeight, windowColour4a, windowColour4b, chosenFeature)
