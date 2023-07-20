local GRID_SIZE  = 8
local OPEN       = "Open"
local CLOSED     = "Closed"
local PLUSSCORE  = 5
local MINUSSCORE = 2

-- Table to store image numbers and open/closed status of cells in the grid

local gridMap = {
}

-- track the number of cells that are open
local numberOfClicks = 0

-- track the cells that are clicked and currently open
local clickMap = {
}

-- Score
local score = 0

-- This function paints the grid 

function drawGrid()
  for row=1,GRID_SIZE do
    for col=1,GRID_SIZE do
      -- If the cell is closed then show hide image i.e. imageindex -1
      if (gridMap[row][col].status == CLOSED) then
        drawImage(row,col,-1)      
      else
      -- else show the actual image based on the image value stored
        drawImage(row,col,gridMap[row][col].value)
      end
    end
  end
  -- show the score
  love.graphics.print('Your Score : ' .. score, 420,50)
end

-- This function initializes the grid with image numbers at the beginning of the game
-- It randomly chooses image number for a cell using math library
-- It also puts the same image number in another cell of the grid, chosen randomly
-- It is done this way to make sure that every image has a pair

function initGrid()

   -- Set randomseed so that random numbers r generated differently in every run
   math.randomseed(os.time())

   -- create tables for every row
   for row=1,GRID_SIZE do
     gridMap[row] = {}
   end

   -- Now loop through each row of the grid
   for row=1,GRID_SIZE do
     -- loop through each column of that row
     for col=1,GRID_SIZE do
       -- check if the cell is already allocated or not
       -- if not allocated, do the processing
       if gridMap[row][col] == nil then
         -- get a random number and assign to the cell
         cell = {}
         local value = math.random(1, IMAGE_OPTIONS)
         cell.value = value
         cell.status = CLOSED
         gridMap[row][col] = cell
         -- Now get another cell randomly and make sure that cell is empty
         -- Once found, put the same value from the previous step into that cell
         newRow = row
         newCol = col
         while gridMap[newRow][newCol] ~= nil do
           newRow = math.random(1,GRID_SIZE)
           newCol = math.random(1,GRID_SIZE)
         end
         cell = {}
         cell.value = value
         cell.status = CLOSED
         gridMap[newRow][newCol] = cell
       end
     end 
   end
end

-- This function processs clicks in the grid

function processClickInGrid(x,y)
  -- Dont allow to click more than twice in the grid
  if numberOfClicks ~= 2 then
    -- Check if the click is outside the grid
    if    (x < GRID_X) or (y < GRID_Y)
       or (x >= GRID_X + GRID_SIZE * IMAGE_SIZE)  
       or (y >= GRID_Y + GRID_SIZE * IMAGE_SIZE)  then
    else 
       -- Identify the row and column of the grid where the user clicked
       row = math.floor((y - GRID_Y)/IMAGE_SIZE)+1
       col = math.floor((x - GRID_X)/IMAGE_SIZE)+1
       -- If that cell is empty then do nothing, else process
       if gridMap[row][col].value ~= 0 then
         -- 'Open' that cell and update click information
         -- Store only two clicks
         gridMap[row][col].status = OPEN
         local click = {}
         click.row = row
         click.col = col
         click.value = gridMap[row][col].value
         if next(clickMap) == nil then
           clickMap[0] = click
         else
           clickMap[1] = click
         end
         numberOfClicks = numberOfClicks + 1
       end
    end
  end
end


-- This function looks for match when two cells are clicked

function checkMatch()
  -- Check for match only when two cells are opened
  if numberOfClicks == 2 then
    -- There is a match
    -- Make the cells empty and update score
    -- Reset Click Information
    if clickMap[0].value == clickMap[1].value then
      gridMap[clickMap[0].row][clickMap[0].col].value = 0
      gridMap[clickMap[1].row][clickMap[1].col].value = 0
      score = score + PLUSSCORE
      numberOfClicks = 0
      clickMap = {}
    else
    -- There is No Match
    -- Close the cells and update score (negative)
    -- Reset Click Information
      gridMap[clickMap[0].row][clickMap[0].col].status = CLOSED
      gridMap[clickMap[1].row][clickMap[1].col].status = CLOSED
      score = score - MINUSSCORE
      numberOfClicks = 0
      clickMap = {}
    end
  end
end
