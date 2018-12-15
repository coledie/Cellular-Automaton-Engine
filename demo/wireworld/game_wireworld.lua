-- Wireworld game


--
-- Setup

Engine.cell_size = 10

require "game_helper"


--
-- Cell State Setup

function wire(x, y, cell_matrix)
   --------------------------------------------------
   -- Update command for state 2 cells
   -- @param {number} x X coord of cell
   -- @param {number} y Y coord of cell
   -- @param {table{table{number}}} cell_matrix 2d matrix of cell states
   -- @returns {number} New cell state
   --------------------------------------------------
   
   -- If one or two heads neighboring, turn to head
   if count_neighbors_full(x, y, cell_matrix, 4) == 1 or count_neighbors_full(x, y, cell_matrix, 4) == 2 then
      return 4
   end
   
   -- Else, stay same state
   return 2
end 


function tail(x, y, cell_matrix)
   --------------------------------------------------
   -- Update command for state 1 cells
   -- @param {number} x X coord of cell
   -- @param {number} y Y coord of cell
   -- @param {table{table{number}}} cell_matrix 2d matrix of cell states
   -- @returns {number} New cell state
   --------------------------------------------------
   
   -- turn to wire
   return 2
end


function head(x, y, cell_matrix)
   --------------------------------------------------
   -- Update command for state 2 cells
   -- @param {number} x X coord of cell
   -- @param {number} y Y coord of cell
   -- @param {table{table{number}}} cell_matrix 2d matrix of cell states
   -- @returns {number} New cell state
   --------------------------------------------------
   
   -- turn to tail
   return 3
end 




-- All states have attributes - name, color(default={255,255,255}), func(default=stay same state)
Engine.states[1]={name='empty', color={255, 255, 255}} 
Engine.states[2]={name='wire',  color={0, 0, 0}, 		func=wire}
Engine.states[3]={name='tail',  color={240, 230, 140},  func=tail}
Engine.states[4]={name='head',  color={150, 200, 50},   func=head}


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
      if self.cells[normalized_x][normalized_y] == 1 then
         self.cells[normalized_x][normalized_y] = 2
      else
	     self.cells[normalized_x][normalized_y] = 1 
	  end 
   elseif button == 2 then
      self.cells[normalized_x][normalized_y] = 4
   end
end 
