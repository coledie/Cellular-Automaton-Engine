function love.conf(t)
   t.window.width = 800
   t.window.height = 600
	
   t.window.resizable = false

   t.window.title = "Cellular Automata - Wireworld"
   t.window.icon = "img/icon.jpg"
	
   t.console = false  -- To display or not to display console
	
   update_delay = .1  -- Delay in seconds between updates
   save_directory = ""  -- Directory to save files to by default, use \\
end