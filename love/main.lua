require("image")
require("grid")

GRID_X = 250
GRID_Y = 104
IMAGE_SIZE = 70
IMAGE_OPTIONS = 10

function love.load()
  -- Load the Images in Memory
  loadImages()

  -- Load font and background music
  font = love.graphics.newFont(30)
  love.graphics.setFont(font)
  source = love.audio.newSource("music/background.mp3", "stream")

  -- Initialize the grid with Images
  initGrid();
end

local dtotal = 0
function love.update(dt)
  dtotal = dtotal + dt
  if dtotal >= 1 then
    -- Check For Match of Pairs every 1 second
    checkMatch()
    dtotal = 0
  end
  if not source:isPlaying( ) then
    love.audio.play( source )
  end
end

function love.draw()
  -- Render the grid
  drawGrid()
end

function love.mousepressed(x, y, button)
  if button == 1 then
    -- Handle click
    processClickInGrid(x, y)
  end
end
