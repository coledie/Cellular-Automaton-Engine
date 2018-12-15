Entry = {
  title = "Cellular Automata Engine", version = "1.0",
  description = [[Customizable cellular automata engine]],
  author = "Cole Dieckhaus",
  url = "https://github.com/colesteroni"
}

Engine = {}


--
-- Defaults

local import_filename = "game_template"  -- File to import Engine data from

-- Pulled from conf.lua
Engine.update_delay = update_delay
Engine.save_directory = save_directory

-- Pulled from game file(import_filename)
Engine.cell_size = 25
Engine.states = {}

function Engine:mousepressed(normalized_x, normalized_y, button) end
function Engine:mousereleased(normalized_x, normalized_y, button) end
function Engine:keypressed(key) end
function Engine:keyreleased(key) end


--
-- Import engine data from file

local status, lfs = pcall(require, import_filename)
if not status then
   print("No game loaded!")

   love.window.setTitle(love.window.getTitle() .. " (No game loaded!)")  
end

--
-- Engine functionality

function Engine:create_cells()
   --------------------------------------------------
   -- Create cell matrix
   -- @params {int} grid_length Number of cells per row in matrix
   -- @params {int} grid_width Number of cells per column in matrix
   --------------------------------------------------
   grid_height = math.ceil(love.graphics.getHeight() / self.cell_size)
   grid_width = math.ceil(love.graphics.getWidth() / self.cell_size)
	
   --------------------------------------------------
   -- cells = 2D matrix of cell states
   --------------------------------------------------
   self.cells = {}
   
   for x=1, grid_width do
      self.cells[x] = {}
      
	  for y=1, grid_height do
         self.cells[x][y] = 1
      end
   end
   
   Engine.generation = 0
end


function Engine:update_states()
   --------------------------------------------------
   -- Update states of all cells
   --------------------------------------------------

   local function deepcopy(orig)
	  --------------------------------------------------
	  -- Creates a shallow copy of a nested table structure
	  -- @param {table} tbl Table to be copied
	  -- @returns {table} Shallow copy of tbl
	  --------------------------------------------------
      local orig_type = type(orig)
      local copy
    
	  if orig_type == 'table' then
         copy = {}
         
		 for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
         end
      
	  setmetatable(copy, deepcopy(getmetatable(orig)))
      
	  else -- number, string, boolean, etc
         copy = orig
      end
      
	  return copy
   end
	
   Engine.generation = Engine.generation + 1	

   local temp = deepcopy(self.cells)
   
   for x, column in ipairs(temp) do
      for y, cell in ipairs(column) do
   	     local curr_state = cell
		 
		 -- if func
		 if self.states[curr_state] and self.states[curr_state]['func'] then
		    local updated_state = self.states[curr_state]['func'](x, y, temp)
		 
		    self.cells[x][y] = updated_state
         end
	  end
   end
end


function Engine:get_color(state)
   --------------------------------------------------
   -- Generates color based on state
   -- @param {number} state Index of state to get color for
   -- @returns {int, int, int} Color value
   --------------------------------------------------
   
   
   local output_color, input_color = {}, self.states[state] and self.states[state]['color'] and self.states[state]['color'] or {255, 255, 255}
   
   for i, c in ipairs(input_color) do
      if c > 0 then
	     output_color[i] = c / 255  -- Standard rgb -> love's 0-1 range
      else
	     output_color[i] = c
	  end 
   end
   
   return output_color  
end


function Engine:draw_cells()
   --------------------------------------------------
   -- Shows all cells on screen w/ colors based on state
   --------------------------------------------------
   
   for x, column in ipairs(self.cells) do
      for y, cell in ipairs(column) do
         love.graphics.setColor(self:get_color(cell))
		 
         love.graphics.rectangle("fill", (x - 1) * self.cell_size, (y - 1) * self.cell_size, self.cell_size, self.cell_size)
      end
   end
end


function Engine:show_pause()
   --------------------------------------------------
   -- Shows pause button on screen
   --------------------------------------------------
   
   love.graphics.setColor(.6, .6, .6, .8)
      
   local center_w = love.graphics.getWidth() / 2
   local center_h = love.graphics.getHeight() / 2
	  
   love.graphics.rectangle("fill", center_w - 5 - 10, center_h - 40, 10, 40)
   love.graphics.rectangle("fill", center_w - 5 + 10, center_h - 40, 10, 40)
end


function Engine:show_data()
   --------------------------------------------------
   -- Show data of cell hovered over
   --------------------------------------------------
   
   local x, y = love.mouse.getX(), love.mouse.getY()
   local grid_x, grid_y = math.floor(x / self.cell_size) + 1, math.floor(y / self.cell_size) + 1  -- Normalized x & y from mouse pos
   
   local data = self.cells[grid_x][grid_y]  -- Get cell data
   
   -- Show data on screen
   love.graphics.setColor(0, 0, 0)
   love.graphics.print('Gen = ' .. Engine.generation .. '; Cell[' .. grid_x .. '][' .. grid_y .. '] = '.. data, 10, 10)
   
end
   

function Engine:show_prompt()
   --------------------------------------------------
   -- Text input & background(for readability) to serve as save filename prompt
   --------------------------------------------------

   -- Show small white background
   local center_w = love.graphics.getWidth() / 2
   local center_h = love.graphics.getHeight() / 2
   
   love.graphics.setColor(.8, .8, .8, .8)
   
   love.graphics.rectangle("fill", 5, center_h - 42, love.graphics.getWidth() - 10, 20)
   
   -- Show current text
   love.graphics.setColor(0, 0, 0)
   love.graphics.print(get_input_buffer(), 10, center_h - 40)
   
end


function Engine:normalize_coords(x, y)
   --------------------------------------------------
   -- Returns the cell location that x and y coords sit on
   --------------------------------------------------

   return {math.floor(x / self.cell_size) + 1, math.floor(y / self.cell_size) + 1}
end 


function Engine:load_file(filename)
   --------------------------------------------------
   -- Delete current matrix content and then load new from file
   -- @param {string} filename Name of file to load
   --------------------------------------------------
   
   print("Loading '" .. filename .. "'")
   
   Engine.cells = {}  -- Empty
   
   -- First load in data
   local file = io.open(filename, "rb")
   
   if not file then return nil end
   
   local raw_data = file:read "*a"
   
   file:close()
   
   -- Parse
   local parsed_data, letter = {{""}}, ""
   for x = 1, #raw_data do
      letter = raw_data:sub(x,x)
	  
      if letter == '\n' then
	     parsed_data[#parsed_data + 1] = {""}
      elseif letter == ',' then
	     parsed_data[#parsed_data][#parsed_data[#parsed_data]+1] = "0"
	  else
	     parsed_data[#parsed_data][#parsed_data[#parsed_data]] = parsed_data[#parsed_data][#parsed_data[#parsed_data]] .. letter
      end
   end
   
   -- Generate new list based on data dimensions
   -- If bigger than map will be truncated
   Engine:create_cells()
   
   -- Insert as int
   for x, column in ipairs(parsed_data) do
      for y, cell in ipairs(column) do
		 if x <= #Engine.cells and y <= #Engine.cells[x] then
		    Engine.cells[x][y] = tonumber(cell) <= #Engine.states and tonumber(cell) or 1
		 end
      end
   end
end


function Engine:save_file(filename)
   --------------------------------------------------
   -- Save cell matrix to file
   -- @param {string} filename Name of file to be written
   --------------------------------------------------
   
   print("Saving state to '" .. filename .. "'")
   
   local file = io.open(filename, 'w')
   
   if not file then return nil end
   
   for x, column in ipairs(Engine.cells) do
      for y, cell in ipairs(column) do
         file:write(cell .. ",")
	  end
	  
      file:write("\n")
   end
   
   file:close()
end


function Engine:start_save_prompt()
   --------------------------------------------------
   -- Start prompt to save file
   -- See engine.lua:Engine:show_prompt(),
   --     main.lua:love.textinput(t)
   --     main.lua:love.keypressed(key)
   --------------------------------------------------
   
   paused = true
   
   clear_input_buffer()
   get_text_intput = true
   
   save_prompt = true
end
