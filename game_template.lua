-- Cellular automaton engine game template
-- Require this file in engine.lua


--
-- Setup

Engine.cell_size = 10

require "game_helper"


--
-- Cell State Setup

-- Sample Conway's game of life

function state_func_1(x, y, cell_matrix)
   --------------------------------------------------
   -- Update command for state 1 cells
   -- @param {number} x X coord of cell
   -- @param {number} y Y coord of cell
   -- @param {table{table{number}}} cell_matrix 2d matrix of cell states
   -- @returns {number} New cell state
   --------------------------------------------------
   
   -- If three alive neighbors, become alive by reproduction
   if count_neighbors_full(x, y, cell_matrix, 2) == 3 then
      return 2
   end
   
   -- Else, stay same state
   return 1
end


function state_func_2(x, y, cell_matrix)
   --------------------------------------------------
   -- Update command for state 2 cells
   -- @param {number} x X coord of cell
   -- @param {number} y Y coord of cell
   -- @param {table{table{number}}} cell_matrix 2d matrix of cell states
   -- @returns {number} New cell state
   --------------------------------------------------
   
   -- If less than two alive neighbors, die by underpopulation
   if count_neighbors_full(x, y, cell_matrix, 2) < 2 then
      return 1
   end
   
   -- If more than three alive neighbors, die by overpopulation
   if count_neighbors_full(x, y, cell_matrix, 2) > 3 then
      return 1
   end 
   
   -- Else, stay same state
   return 2
end 

-- All states have attributes - name, color(default={255,255,255}), func(default=stay same state)
Engine.states[1]={name='dead',  color={255, 255, 255}, func=state_func_1} 
Engine.states[2]={name='alive', color={0, 0, 0},       func=state_func_2}


--
-- User Control setup

function Engine:mousepressed(normalized_x, normalized_y, button)
   --------------------------------------------------
   -- Action to take on click
   -- @param {number} normalized_x Normalized x pos of mouse
   -- @param {number} normalized_y Normalized y pos of mouse
   -- @param {left=1, right=2, middle=3} button Mouse button pressed
   --------------------------------------------------

   if button == 1 then
      self.cells[normalized_x][normalized_y] = 2
   elseif button == 2 then
      self.cells[normalized_x][normalized_y] = 1
   end
end 


function Engine:mousereleased(normalized_x, normalized_y, button)
   --------------------------------------------------
   -- Action to take on unclick
   -- @param {number} normalized_x Normalized x pos of mouse
   -- @param {number} normalized_y Normalized y pos of mouse
   -- @param {left=1, right=2, middle=3} button Mouse button released
   --------------------------------------------------

end


function Engine:keypress(key)
   --------------------------------------------------
   -- On key press take action
   -- @param {love keyconstant} key Keyboard key pressed
   --------------------------------------------------
   
end


function Engine:keyreleased(key)
   --------------------------------------------------
   -- On key release take action
   -- @param {love keyconstant} key Keyboard key released
   --------------------------------------------------
   
end
