-- Love interface


function love.load()
   --------------------------------------------------
   -- On game load
   --------------------------------------------------
   
   input_buffer = ""  -- For logging text input

   initial_pause = true  -- So the change of focus at game start doesnt unpause
   paused = true
   
   last_time = love.timer.getTime()  -- For pacing matrix updates
   
   require "engine"
   
   Engine:create_cells()  -- Create initial cell map
end


function love.update(dt)
   --------------------------------------------------
   -- On every tick
   -- @param {number} dt Change in time since last update
   --------------------------------------------------
   
   if not paused and (not Engine.update_delay or love.timer.getTime() - last_time > Engine.update_delay) then
      Engine:update_states()
	  last_time = love.timer.getTime()  -- For pacing matrix updates
   end
end


function love.draw()
   --------------------------------------------------
   -- On every draw cycle
   -- Draw all cells w/ color as magnitude
   --------------------------------------------------
   
   Engine:draw_cells()
   
   if save_prompt then
      Engine:show_prompt()
	  
   elseif paused then
      Engine:show_pause()
   end
   
   if show_data then
      Engine:show_data()
   end
   
   
end


function love.mousepressed(x, y, button, istouch)
   --------------------------------------------------
   -- On mouse press
   -- @param {number} x X pos of cursor
   -- @param {number} y Y pos of cursor
   -- @param {mousebutton type} button Mouse button pressed
   -- @param {bool} istouch Is touch screen?
   --------------------------------------------------
   
   local loc = Engine:normalize_coords(x, y)

   Engine:mousepressed(loc[1], loc[2], button)
end
   
   
function love.mousereleased(x, y, button, istouch)
   --------------------------------------------------
   -- On mouse release
   -- @param {number} x X pos of cursor
   -- @param {number} y Y pos of cursor
   -- @param {mousebutton type} button Mouse button released
   -- @param {bool} istouch Is touch screen?
   --------------------------------------------------
   
   local loc = Engine:normalize_coords(x, y)

   Engine:mousereleased(loc[1], loc[2], button)
end
   
   
function love.keypressed(key)
   --------------------------------------------------
   -- On key press take action
   -- @param {love keyconstant} key Keyboard key pressed
   --------------------------------------------------
   
   if not get_text_intput then
      -- Pausing
      if key == 'space' or key == 'p' then
         initial_pause = false
         paused = not paused
      end 
   
      -- Show magnitude
      if key == 'lctrl' or key == 'rctrl' then
         show_data = not show_data
	     print(show_data and "Show data enabled" or "Show data disabled")
      end
   
      -- Step forward
      if key == 'right' or key == 'd' then
         Engine:update_states()
      end
   
      -- Save state
      if key == 's' then
         Engine:start_save_prompt()
		 
		 initial_s_fix = true  -- The s gets logged in the input
      end
   
      -- Game specific actions
      Engine:keypressed(key)
	  
   else
      if key == "backspace" then
	     if #get_input_buffer() > 0 then
		    set_input_buffer(get_input_buffer():sub(1, -2))
			print(get_input_buffer())
		 end
      elseif key == "escape" then
	     get_text_intput = false
		 save_prompt = false
	  elseif key == "return" then
	     if save_prompt then
	        get_text_intput = false
            save_prompt = false
			
            Engine:save_file(Engine.save_directory .. get_input_buffer())
         end
	  end
	  
   end
   
end


function love.keyreleased(key)
   --------------------------------------------------
   -- On key release take action
   -- @param {love keyconstant} key Keyboard key released
   --------------------------------------------------
   
   Engine:keyreleased(key)
end


function clear_input_buffer()
   --------------------------------------------------
   -- Sets input buffer to ""
   --------------------------------------------------

   input_buffer = ""
end


function get_input_buffer()
   --------------------------------------------------
   -- Input buffer getter
   --------------------------------------------------
   
   return input_buffer
end  


function set_input_buffer(value)
   --------------------------------------------------
   -- Input buffer setter
   --------------------------------------------------

   input_buffer = value
end   


function love.textinput(t)
   --------------------------------------------------
   -- Gets all standard keys pressed(Not return, backspace...)
   -- Handling backspaces and enter in love.keypressed() !
   -- @param {str} t Character input
   --------------------------------------------------

   if get_text_intput then
      if initial_s_fix then
	     initial_s_fix = false
		 return nil
	  end 
	  
      input_buffer = input_buffer .. t
      
	  print(input_buffer)
   end
end


function love.focus(focused)
   --------------------------------------------------
   -- When a change of focus occurs
   -- @param {bool} f State of focus
   --------------------------------------------------

   if not initial_pause then paused = not focused end
  
   print(focused and "GAINED FOCUS" or "LOST FOCUS")
end


function love.filedropped(file)
   --------------------------------------------------
   -- When a file is dropped on window
   -- @param {string} file Name of file dropped
   --------------------------------------------------
   
   print("Loading '" .. file:getFilename() .. "'!")
   Engine:load_file(file:getFilename())
end


function love.quit()
   --------------------------------------------------
   -- On quit game
   --------------------------------------------------
   
   print("Quitting...")
end


