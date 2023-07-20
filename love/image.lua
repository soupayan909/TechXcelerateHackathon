-- Table to store Images used in the game

imageMap = {
}

-- This function loads all the images in memory

function loadImages()
  -- Image for hiding the cell
  imageMap[-1]  = love.graphics.newImage('images/hide.png')
  -- Image for showing empty cell
  imageMap[0]   = love.graphics.newImage('images/empty.png')
  -- Images for cells 
  for i=1,IMAGE_OPTIONS do
    imageMap[i] = love.graphics.newImage('images/image' .. tostring(i) .. '.png')
  end
end

-- This function draws appropriate image based on row and column of the grid
-- and the image that is specificed by its index

function drawImage(row,col,imageIndex)
  x = GRID_X + (col-1) * IMAGE_SIZE
  y = GRID_Y + (row-1) * IMAGE_SIZE 
  love.graphics.draw(imageMap[imageIndex],x,y)
end
