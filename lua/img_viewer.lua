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
            print( node.absolute_path)   -- この方法で絶対パスが取得可能
            print( node.type)            -- この方法で file / dir が判別可能
            print( node.Node )
        else
            print( "No!!")
        end

    end


    local function tprint (tbl, indent)
        if not indent then indent = 0 end
        local toprint = string.rep(" ", indent) .. "{\r\n"
        indent = indent + 2 
        for k, v in pairs(tbl) do
            toprint = toprint .. string.rep(" ", indent)
            if (type(k) == "number") then
                toprint = toprint .. "[" .. k .. "] = "
            elseif (type(k) == "string") then
                toprint = toprint  .. k ..  "= "   
            end
            if (type(v) == "number") then
                toprint = toprint .. v .. ",\r\n"
            elseif (type(v) == "string") then
                toprint = toprint .. "\"" .. v .. "\",\r\n"
            elseif (type(v) == "table") then
                toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
            else
                toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
            end
        end
        toprint = toprint .. string.rep(" ", indent-2) .. "}"
        return toprint
    end


    M.api_test = function()
        --module.is_wezterm_preview_open()
        --print( ("--format=%s"):format("json") )

        local cli_result = vim.fn.system(
             "wezterm " ..
             "cli "     ..
             "list "    ..
             ("--format=%s"):format("json")
             )
        --print(cli_result) 
        local json = vim.json.decode( cli_result )
        --local panes = vim.iter( json ):map(_l("obj: { pane_id = obj.pane_id, tab_id = obj.tab_id }"))   --NGNGNG ???
        --print( panes)

        --print( vim.inspect(json[1]) )
        --print( #json ) --リスト要素数参照

        local json = vim.json.decode('{"bar":[],"foo":{},"zub":null} ')  
        --print( vim.inspect(json) )
        local panes = vim.iter( json )
        print( panes)


        --vim.print( vim.json.decode('{"bar":[],"foo":{},"zub":null} ') )   -- vim.print() を使うとオブジェクトが正しく表示
        --vim.print(json["bar"])

        -- 辞書型の分解参照 OKバージョン
        -- for k, v in pairs(json) do
        --     print(k)
        --     --print( vim.inspect(v) )
        --     print( v.cursor_x ) 
        -- end



        --local tbl0 = { "first", "Second", "Third"}
        --table.insert(tbl0,"Fortth")
        ----print( vim.inspect(tbl0) )  --
        --print( tbl0[1] )

        --vim.print( json[0] ) 
        --local panes = vim.iter( json ):map(_l("obj: { pane_id = obj.pane_id, tab_id = obj.tab_id }"))
        --print( panes ) 



        ------- iter sample
        local map = {
          item = {
            file = 'test',
          },
          item_2 = {
            file = 'test',
          },
          item_3 = {
            file = 'test',
          },
        }

        -- NOTE: removing the `pairs` results in the same output
        local output = vim.iter(pairs(map)):map(function(key, value)
          return { [key] = value.file }
        end):totable()

        print(
          vim.inspect(output)
        )




    end

    ---------- User Command
    vim.api.nvim_create_user_command("MyHello", require("img_viewer").hello, {})
    vim.api.nvim_create_user_command("MyOpen",  require("img_viewer").tree_open, {})
    vim.api.nvim_create_user_command("MyGet",   require("img_viewer").tree_get, {})
end




return M


