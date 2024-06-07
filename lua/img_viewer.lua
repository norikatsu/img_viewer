-- main module file

-- load module
local module = require("img_viewer.module")

local neo_tree = require("neo-tree")
local command  = require("neo-tree.command")
local manager  = require("neo-tree.sources.manager")


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


    ---------- Main Function  ----------
    M.weztermPreview = function()
        module.weztermPreview.callback()
    end



    ---------- wezterm APIs ----------
    M.getNeovimWeztermPane = function()
        ret = module.getNeovimWeztermPane()
        print("Call API", ret)
    end

    M.activeWeztermPane = function( pane_id )
        ret = module.activeWeztermPane( pane_id )
        print("activeWeztermPane",ret)
    end


    M.openNewWeztermPane = function() 
        ret = module.openNewWeztermPane()
        print("openNewWeztermPane", ret)
    end



    M.weztermPreviewInit = function()
        module.weztermPreviewInit()
    end
    
    
    M.weztermPreviewRun = function()
        module.weztermPreviewRun()
    end


    ---------- neo-tree APIs ----------
    ----------  focus (open <> close  , toggle)
    M.tree_open = function()
        command.execute({ 
            action = "focus",
            toggle = true ,
        })
    end

    ---------- close 
    M.tree_close = function()
        command.execute({ action = "close" })
    end

    ------------ nvim-tree api Event  -->  nvim-neo-tree ではイベント検出用API が存在しない
    --M.event = function()
    --    local Event = tree_api.events.Event

    --    --tree_api.events.subscribe(Event.TreeOpen, function()
    --    --    print("TreeOpen")
    --    --end)

    --    tree_api.events.subscribe(Event.TreeRendered, function()
    --        print("TreeRendered")
    --    end)
    --end




    -----

    M.tree_get = function()
        if (vim.o.filetype == "neo-tree") then
            local position = vim.api.nvim_buf_get_var(0, "neo_tree_position")
            local source   = vim.api.nvim_buf_get_var(0, "neo_tree_source")
            --print("position : ", position, "  \\  source : ", source)

            if position ~= "current" then
                -- close_if_last_window just doesn't make sense for a split style
                local state = manager.get_state(source)
                if state ~= nil then
                    if state.tree ~= nil then
                        local node = state.tree:get_node() --これが機能しない場合あり
                        if node ~=nil then
                            local filepath = node:get_id()
                            local filename = node.name
                            -- local type     = node.type
                            -- local modify = vim.fn.fnamemodify
                            print("file :", filepath )
                        end
                    end
                end
            end
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


        local wezterm_pane_id = vim.env.WEZTERM_PANE               -- 現在の pane id を環境変数から参照
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


        --============================================================================================================


    end

    ---------- User Command
    vim.api.nvim_create_user_command("MyHello", require("img_viewer").hello, {})
    --vim.api.nvim_create_user_command("MyOpen",  require("img_viewer").tree_open, {})
    vim.api.nvim_create_user_command("MyGet",   require("img_viewer").tree_get, {})


    ---------- Main Function  ----------
    vim.api.nvim_create_user_command("MywezPreview",     require("img_viewer").weztermPreview , {})
    vim.api.nvim_create_user_command("MywezPreviewInit", require("img_viewer").weztermPreviewInit , {})
    vim.api.nvim_create_user_command("MywezPreviewRun",  require("img_viewer").weztermPreviewRun , {})

end




return M


