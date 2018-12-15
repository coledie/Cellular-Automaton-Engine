-- Some helper functions to aid in game creation
-- Require this in your game file


function count_neighbors_full(center_x, center_y, cell_matrix, state)
   --------------------------------------------------
   -- Counts neighbors of cell that are a given state
   -- @param {number} center_x X pos of centerpoint
   -- @param {number} center_y Y pos of centerpoint
   -- @param {table{table{number}} cell_matrix Cell matrix
   -- @param {number} state State to count, default=cell_matrix[center_x][center_y]
   -- @returns Number of neighboring cells of specific state
   --------------------------------------------------
   
   if not state then state = cell_matrix[center_x][center_y] end  -- Set state to default if nil

   -- Get size of search space
   local search_x, search_y = {center_x}, {center_y}
   
   if cell_matrix[center_x - 1] then table.insert(search_x, center_x - 1) end
   if cell_matrix[center_x + 1] then table.insert(search_x, center_x + 1) end
   
   if cell_matrix[center_x][center_y - 1] then table.insert(search_y, center_y - 1) end
   if cell_matrix[center_x][center_y + 1] then table.insert(search_y, center_y + 1) end
   
   -- Count
   count = 0
   
   for i, x in ipairs(search_x) do 
      for j, y in ipairs(search_y) do
	     if cell_matrix[x][y] == state and not (x == center_x and y == center_y) then
		    count = count + 1
		 end
	  end 
   end

   return count
end


function count_neighbors_adjacent(center_x, center_y, cell_matrix, state)
   --------------------------------------------------
   -- Counts neighbors of cell that are a given state
   -- @param {number} center_x X pos of centerpoint
   -- @param {number} center_y Y pos of centerpoint
   -- @param {table{table{number}} cell_matrix Cell matrix
   -- @param {number} state State to count, default=cell_matrix[center_x][center_y]
   -- @returns Number of neighboring cells of specific state
   --------------------------------------------------
   
   if not state then state = cell_matrix[center_x][center_y] end  -- Set state to default if nil

   -- Count
   count = 0
   
   if cell_matrix[center_x - 1] then
      if cell_matrix[center_x - 1][center_y] == state then count = count + 1 end
   end
   if cell_matrix[center_x + 1] then
      if cell_matrix[center_x + 1][center_y] == state then count = count + 1 end
   end
   
   if cell_matrix[center_x][center_y - 1] then 
      if cell_matrix[center_x][center_y - 1] == state then count = count + 1 end
   end
   if cell_matrix[center_x][center_y + 1] then 
      if cell_matrix[center_x][center_y + 1] == state then count = count + 1 end
   end

   return count
end
