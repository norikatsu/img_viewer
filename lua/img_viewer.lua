-- main module file

-- load module
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


    ---------- Sample api 
    M.hello = function()
        print("Hello at lua...")
    end

    ---------- nvim-tree api 
    M.tree_open = function()
        tree_api.tree.toggle()
    end

    M.tree_get = function()
        node = tree_api.tree.get_node_under_cursor()
        if node ~= nil then
            --tree_api.node.open.tab()
            print( node.absolute_path)  -- この方法で絶対パスが取得可能
            print( node.type)           -- この方法で絶対タイプ取得
        else
            print( "No!!")
        end

    end

    M.api_test = function()
        --module.is_wezterm_preview_open()
        --print( ("--format=%s"):format("json") )
        print(
          "wezterm " ..
          "cli " ..
          "list " ..
          ("--format=%s"):format("json") 
        )
    end

    ---------- User Command
    vim.api.nvim_create_user_command("MyHello", require("img_viewer").hello, {})
    vim.api.nvim_create_user_command("MyOpen",  require("img_viewer").tree_open, {})
    vim.api.nvim_create_user_command("MyGet",   require("img_viewer").tree_get, {})
end




return M


