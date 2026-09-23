local canvasWidth = math.random(250, 300)
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

-- generating lights and roads
function genRoads(roadPositionY, roadThickness, roadColour)
  app.useTool {
    tool = "filled_rectangle",
    color = roadColour,
    brush = brush1,
    points = {
      Point(0, roadPositionY),
      Point(canvasWidth, roadPositionY + roadThickness)
    },

    cel = cel,
    layer = layer
  }
    local numberOfStruts = canvasWidth/roadThickness
    local strutWidth = (roadThickness/3) * 2
    local strutInterval = strutWidth * 5

    local i
    for i = 0, numberOfStruts, 1 do
      strutPosition = i * strutInterval + (i * strutWidth)

      app.useTool {
        tool = "filled_rectangle",
        brush = brush1,
        color = roadColour,
        points = {
          Point(strutPosition, roadPositionY),
          Point(strutPosition + strutWidth, canvasHeight)
        },
        cel = cel,
        layer = layer
      }
    end

  app.useTool {
    tool = "line",
    color = roadColour,
    brush = brush1,
    points = {
      Point(strutPosition - 4, roadPositionY + roadThickness + 1),
      Point(strutPosition + strutWidth + 4, roadPositionY + roadThickness + 1)
      },
    }

    -- adding some rails

  local railingChance = math.random(0, 1)

  if railingChance > 0 then

  -- Draw railing/barrier
  app.useTool {
    tool = "line",
    color = roadColour,
    brush = brush1,
    points = {
      Point(0, roadPositionY - roadThickness/2),
      Point(canvasWidth, roadPositionY - roadThickness/2)
    },
    cel = cel,
    layer = layer
  }

  local numberOfPoles = canvasWidth/2
  local poleWidth = 1
  local poleInterval = 2
  local poleStart = math.random(-10, 10)

  -- Loop to draw railing poles
  local i
  for i = 0, numberOfPoles, 1 do

  local polePosition = poleStart + i * poleInterval + (i * poleWidth)

    -- Draw struts
    app.useTool {
      tool = "filled_rectangle",
      color = roadColour,
      brush = brush1,
      points = {
        Point(polePosition, roadPositionY - roadThickness/2),
        Point(polePosition + poleWidth, roadPositionY)
      },
      cel = cel,
      layer = layer
    }

  end
end
    -- adding street lamps
    local numberOfLamps = canvasWidth/4
    local lampWidth = 1
    local lampHeight = 8
    local lampInterval = 24
    local lampStart = math.random(-10, 10)

    local i
    for i = 0, numberOfLamps, 1 do
      local lampPosition = lampStart + i * lampInterval + (i * lampWidth)

      app.useTool {
        tool = "filled_rectangle",
        brush = brush1,
        color = roadColour,
        points = {
          Point(lampPosition, roadPositionY - lampHeight),
          Point(lampPosition + lampWidth - 1, roadPositionY)
        },
        cel = cel,
        layer = layer
      }
      app.useTool {
        tool = "filled_rectangle",
        brush = brush1,
        color = roadColour,
        points = {
          Point(lampPosition, roadPositionY - lampHeight),
          Point(lampPosition + lampWidth + 1, roadPositionY - lampHeight + 1)
        },
        cel = cel,
        layer = layer
      }
      app.useTool {
        tool = "pencil",
        color = Color{ h=45, s=0.1, v=1, a=255 },
        brush = brush2,
        points = { Point(lampPosition + 3, roadPositionY - lampHeight + 2)},
        cel = cel,
        layer = layer
      }

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

-- buildings 1
local buildingsLayer1 = sprite:newLayer()
buildingsLayer1.name = "buildings, 1"
local cel = sprite:newCel(buildingsLayer1, 1)
local buildingWidth = canvasWidth / 10
local buildingHeight = canvasHeight - (canvasHeight * 0.65)
local buildingColour1 = Color{ h=baseHue - math.random(5, 10), s=baseSat + (math.random(5, 10)/100), v=baseVal - (math.random(6, 10)/100), a=255 }

-- windows 1
local windowWidth = 2
local windowHeight = 4
local windowColour1a = baseColour
local windowColour1b = baseColour
windowWidthCurrent = math.random(windowWidth - 1, windowWidth + 1)
windowHeightCurrent = math.random(windowHeight - 1, windowHeight + 1)

local windowsInRow = (buildingWidth - 2) / windowWidth
local windowsInColumn = (buildingHeight - 2) / windowHeight

-- roads 1
local roadPositionMin = canvasHeight * 0.40
local roadPositionMax = canvasHeight * 0.45

local roadThickness = 2
local roadColour1 = buildingColour1
local roadPositionY1 = math.random(roadPositionMin, roadPositionMax)

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour1, windowWidth, windowHeight, windowColour1a, windowColour1b, chosenFeature)

local roadsBackgroundLayer1 = sprite:newLayer()
roadsBackgroundLayer1.name = "roads, 1"
local cel = sprite:newCel(roadsBackgroundLayer1, 1)

genRoads(roadPositionY1, roadThickness, roadColour1)

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

-- windows 2
local windowWidth = 3
local windowHeight = 5
local windowColour2a = baseColour
local windowColour2b = buildingColour1

-- roads 2
local roadPositionMin = canvasHeight * 0.45
local roadPositionMax = canvasHeight * 0.55
local roadThickness = 2
local roadColour2 = buildingColour2
local roadPositionY2 = math.random(roadPositionMin, roadPositionMax)

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour2, windowWidth, windowHeight, windowColour2a, windowColour2b, chosenFeature)

local roadsBackgroundLayer2 = sprite:newLayer()
roadsBackgroundLayer2.name = "roads, 2"
local cel = sprite:newCel(roadsBackgroundLayer2, 1)

genRoads(roadPositionY2, roadThickness, roadColour2)

-- buildings 3
local buildingsLayer3 = sprite:newLayer()
buildingsLayer3.name = "buildings, 3"
local cel = sprite:newCel(buildingsLayer3, 1)
local layer = buildingsLayer3

-- building params
local buildingWidth = canvasWidth/9
local buildingHeight = canvasHeight - (canvasHeight * 0.50)
local buildingStartX = 0
local buildingColour3 = Color{ h=baseHue - math.random(50, 60), s=baseSat + (math.random(5, 10)/100), v=baseVal - (math.random(50, 60)/100), a=255 }

-- windows 3
local windowWidth = 3
local windowHeight = 5
local windowColour3a = baseColour
local windowColour3b = buildingColour1

-- roads 3

local roadPositionMin = canvasHeight * 0.60
local roadPositionMax = canvasHeight * 0.65

local roadThickness = 5
local roadColour3 = buildingColour3
local roadPositionY3 = math.random(roadPositionMin, roadPositionMax)

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour3, windowWidth, windowHeight, windowColour3a, windowColour3b, chosenFeature)

local roadsBackgroundLayer3 = sprite:newLayer()
roadsBackgroundLayer3.name = "roads, 3"
local cel = sprite:newCel(roadsBackgroundLayer3, 1)

genRoads(roadPositionY3, roadThickness, roadColour3)

-- buildings 4
local buildingsLayer4 = sprite:newLayer()
buildingsLayer4.name = "buildings, 4"
local cel = sprite:newCel(buildingsLayer4, 1)
local layer = buildingsLayer4

-- building params
local buildingWidth = canvasWidth/7
local buildingHeight = canvasHeight - (canvasHeight * 0.45)
local buildingStartX = 0
local buildingColour4 = Color{ h = baseHue - math.random(50, 70), s=baseSat + (math.random(5, 10)/100), v=baseVal - (math.random(70, 80)/100), a=255 }

-- windows 4
local windowWidth = 3
local windowHeight = 5
local windowColour4a = baseColour
local windowColour4b = buildingColour1

-- roads 4

local roadPositionMin = canvasHeight * 0.65
local roadPositionMax = canvasHeight * 0.70

local roadThickness = 7
local roadColour4 = buildingColour4
local roadPositionY4 = math.random(roadPositionMin, roadPositionMax)

genBuildings(buildingWidth, buildingHeight, buildingStartX, buildingColour4, windowWidth, windowHeight, windowColour4a, windowColour4b, chosenFeature)

local roadsBackgroundLayer4 = sprite:newLayer()
roadsBackgroundLayer4.name = "roads, 4"
local cel = sprite:newCel(roadsBackgroundLayer4, 1)

genRoads(roadPositionY4, roadThickness, roadColour4)

-- water layer
local waterLayer = sprite:newLayer()
waterLayer.name = "water"
local cel = sprite:newCel(waterLayer, 1)

app.useTool {
  tool = "filled_rectangle",
  color = buildingColour4,
  brush = brush1,
  points = {
    Point(0, canvasHeight * 0.74),
    Point(canvasWidth, canvasHeight)
  },
  cel = cel,
  layer = waterLayer
}

app.useTool {
  tool = "line",
  color = baseColour,
  brush = brush1,
  points = {
    Point(0, canvasHeight * 0.74),
    Point(canvasWidth, canvasHeight * 0.74)
  },
  cel = cel,
  layer = waterLayer
}

local home = os.getenv("HOME")
local filename = home .. "/Downloads/city_" .. os.date("%Y%m%d_%H%M%S") .. ".png"

local x = sprite:saveCopyAs(filename)
if x then
    app.tip("Saved: " .. filename)
else
    app.tip("Failed to save.")
end
