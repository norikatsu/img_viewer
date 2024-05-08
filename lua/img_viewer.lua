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
            --$ print( node.absolute_path)   -- この方法で絶対パスが取得可能
            --$ print( node.type)            -- この方法で file / dir が判別可能
            --$ print( node.Node )


            -- Debug : Check All Data 
            print( "ParentNode", node.ParentNode)
            print( "name", node.name )
            print( "BaseNode", node.BaseNode)
            print( "absolute_path", node.absolute_path )
            print( "executable", node.executable )
            print( "fs_stat", node.fs_stat )
            print( "git_status", node.git_status )
            print( "hidden", node.hidden )
            print( "name", node.name )
            print( "parent", node.parent )
            print( "type", node.type )
            print( "watcher", node.watcher )
            print( "diag_status", node.diag_status )
            print( "DirNode", node.DirNode )
            print( "has_children", node.has_children )
            print( "group_next", node.group_next )
            print( "nodes", node.nodes )
            print( "open", node.open )
            print( "FileNode", node.FileNode )
            print( "extension", node.extension )
            print( "SymlinkDirNode", node.SymlinkDirNode )
            print( "link_to", node.link_to )
            print( "SymlinkFileNode", node.SymlinkFileNode )
            print( "link_to", node.link_to )
            print( "SymlinkNode", node.SymlinkNode )
            print( "Node", node.Node )

        else
            print( "No!!")
        end
    end


    M.api_test = function()
        --module.is_wezterm_preview_open()
        --print( ("--format=%s"):format("json") )


        -- 正規表現テスト
        --local url = "imagefile.jpg"
        --local extension = url:match("^.+(%..+)$")
        --local imageExt = { ".bmp", ".jpg", ".jpeg", ".png", ".gif" }
        --print("extension : ", extension)




        -- wezterm cli  : split pane exe
        --local _opt = opt or {}
        --local percent = _opt.percent or 30
        --local direction = _opt.direction or "right"

        --local cmd = vim.fn.system( 
        --     "wezterm "     ..
        --     "cli "         ..
        --     "split-pane "  ..
        --     (" --percent=%d"):format(percent) ..
        --     (" --%s"):format(direction) ..
        --     " -- "        ..
        --     "pwsh"
        --     )

        --local wezterm_pane_id = assert(tonumber( cmd ))
        --print( "Open ID :" , wezterm_pane_id )



        -- wezterm cli  : get list
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

        --print( vim.inspect(json) )
        --print( #json ) --リスト要素数参照

        --local json = vim.json.decode('{"bar":[],"foo":{},"zub":null} ')  
        --print( vim.inspect(json) )
        --local panes = vim.iter( json )
        --print( panes)


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




        --============================================================================================================
        ------- iter sample --> iter が読み込めないのでfor で代用
        panes = {}
        for i = 1 , #json do
            local pane = {pane_id = json[i].pane_id, tab_id = json[i].tab_id}
            table.insert( panes, pane)
        end
        -- print( vim.inspect(panes))


        local wezterm_pane_id = vim.env.WEZTERM_PANE               -- 現在の pane id を環境変数から参照
        -- print (wezterm_pane_id)
        local neovim_wezterm_pane_id = tonumber(wezterm_pane_id) --getNeovimWeztermPane()

        -- 現在の TABのtab_id を返す
        local current_tab_id = nil
        for i = 1 , #panes do
            print( i, panes[i].pane_id)
            if (panes[i].pane_id == neovim_wezterm_pane_id) then
                current_tab_id = panes[i].tab_id
                print("Hit:", panes[i].pane_id, panes[i].tab_id)
            end
        end
        -- print("current_tab_id : ", current_tab_id)



        -- 現在の TAB の pane の中で現在の paneより大きい pane_id を返す
        local preview_pane = nil                          -- panes リスト内で function 内条件が成立するモノを返す
        for i = 1 , #panes do
            if (panes[i].tab_id == current_tab_id) then
                if (panes[i].pane_id > neovim_wezterm_pane_id) then
                --if (panes[i].pane_id > -1 ) then
                    print( "Large Hit!")
                    preview_pane = panes[i]
                    break
                end
            end
        end

        if (preview_pane ~= nil) then
            --return preview_pane.pane_id
            --print( "preview_pane.pane_id :", preview_pane.pane_id) 
        else
            --return nil
            -- print( "nil") 
        end


        





        --local preview_pane = panes:find(function(obj)                          -- panes リスト内で function 内条件が成立するモノを返す
        --     return --
        --          obj.tab_id == current_tab_id --  -- 現在のタブで 克 現在のpane より大きい値のpane id 
        --               and tonumber(obj.pane_id) > tonumber(neovim_wezterm_pane_id) -- new pane id should be greater than current pane id
        --end)
        --return preview_pane ~= nil and preview_pane.pane_id or nil      -- preview_pane がnil でない場合には そのpane_id を返し、そうでないならnil を返す


        --============================================================================================================


    end

    ---------- User Command
    vim.api.nvim_create_user_command("MyHello", require("img_viewer").hello, {})
    vim.api.nvim_create_user_command("MyOpen",  require("img_viewer").tree_open, {})
    vim.api.nvim_create_user_command("MyGet",   require("img_viewer").tree_get, {})
end




return M


