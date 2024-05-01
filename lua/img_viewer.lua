-- main module file
local module = require("img_viewer.module")

local nvim_tree = require("nvim-tree")
local tree_api  = require("nvim-tree.api")



---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
    --M.config = vim.tbl_deep_extend("force", M.config, args or {})


    --# ---------- Sample api 
    --# M.hello = function()
    --#     print("Hello at lua...")
    --# end

    --# ---------- nvim-tree api 
    --# M.tree_open = function()
    --#     tree_api.tree.toggle()
    --# end

    --# M.tree_get = function()
    --#     file_name = tree_api.tree.get_node_under_cursor()
    --#     print( file_name )
    --# end

end



---------- Sample api 
M.hello = function()
    print("Hello at lua...")
end

---------- nvim-tree api 
M.tree_open = function()
    tree_api.tree.toggle()
end

M.tree_get = function()
    file_name = tree_api.tree.get_node_under_cursor()
    print( file_name )
end

return M


