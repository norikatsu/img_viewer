---@class CustomModule
-- Ref URL : https://zenn.dev/vim_jp/articles/5b5f704de07673

local command  = require("neo-tree.command")
local manager  = require("neo-tree.sources.manager")


local M = {}

---Debounce a function
---@param func function
---@param wait number
local function debounce(func, wait)
    local timer_id
    ---@vararg any
    return function(...)
        if timer_id ~= nil then
            vim.uv.timer_stop(timer_id)
        end
        local args = { ... }
        timer_id = assert(vim.uv.new_timer())
        vim.uv.timer_start(timer_id, wait, 0, function()
            func(unpack(args))
            timer_id = nil
        end)
    end
end



local function isImage(url)
    local extension = url:match("^.+(%..+)$")
    local imageExt = { ".bmp", ".jpg", ".jpeg", ".png", ".gif" }

    for i = 1 , #imageExt do
        if (imageExt[i] == extension) then
            return true
        end
    end
    return false
end


local function geEntryAbsolutePath()
    
    --local nvim_tree_api  = require("nvim-tree.api")

    --node = nvim_tree_api.tree.get_node_under_cursor()

    --if node ~= nil then
    --    --tree_api.node.open.tab()
    --    return node.absolute_path   -- 絶対パス
    --else
    --    return nil
    --end

    if (vim.o.filetype == "neo-tree") then
        local position = vim.api.nvim_buf_get_var(0, "neo_tree_position")
        local source   = vim.api.nvim_buf_get_var(0, "neo_tree_source")

        if position ~= "current" then
            local state = manager.get_state(source)
            if state ~= nil then
                --print ("state : " , state)

                local node = state.tree:get_node()
                local filepath = node:get_id()
                --local filename = node.name
                --local type     = node.type
                --local modify = vim.fn.fnamemodify
                return filepath
            end
        end
    end

    -- 条件外の場合
    return nil

end


--***** この機能は一旦保留
--M.openWithQuickLook = {
--     callback = function()
--          local path = assert((geEntryAbsolutePath()))
--
--          require("core.utils").open_file_with_quicklook(path)
--     end,
--     desc = "Open with QuickLook",
--}




--local OIL_PREVIEW_ENTRY_ID_VAR_NAME = "OIL_PREVIEW_ENTRY_ID"
local function getNeovimWeztermPane()
    local wezterm_pane_id = vim.env.WEZTERM_PANE               -- 現在の pane id を環境変数から参照
    if not wezterm_pane_id then
        vim.notify("Wezterm pane not found", vim.log.levels.ERROR)
        return
    end
    return tonumber(wezterm_pane_id)
end

local activeWeztermPane = function(wezterm_pane_id)
    cmd = vim.fn.system( 
        "wezterm "         ..
        "cli "             ..
        "activate-pane "   ..
        (" --pane-id %d"):format(wezterm_pane_id) 
    )
    return cmd
end



---@param opt table
local openNewWeztermPane = function(opt)
    local _opt = opt or {}
    local percent = _opt.percent or 30
    local direction = _opt.direction or "right"

    local cmd = vim.fn.system(
         "wezterm "                    ..
         "cli "                        ..
         "split-pane "                 ..
         (" --percent=%d"):format(percent) ..
         (" --%s"):format(direction)   ..
         " -- "                        ..
         "pwsh"
         )

    local wezterm_pane_id = assert(tonumber(cmd))
    return wezterm_pane_id
end

local closeWeztermPane = function(wezterm_pane_id)
    local cmd = vim.fm.system(
         "wezterm "        ..
         "cli "            ..
         "kill-pane "      ..
         ("--pane-id=%d"):format(wezterm_pane_id)
    )
    return cmd
end


local sendCommandToWeztermPane = function(wezterm_pane_id, command)
    local cmd = vim.fm.system(
          "echo "           ..
          ("'%s' "):format(command) ..
          " | "             ..
          "wezterm "        ..
          "cli "            ..
          "send-text "      ..
          "--no-paste "     ..
          (" --pane-id=%d"):format(wezterm_pane_id)
    )
    return cmd
end


local function listWeztermPanes()

    local cli_result = vim.fn.system(
         "wezterm " ..
         "cli "     ..
         "list "    ..
         ("--format=%s"):format("json")
         )
    local json = vim.json.decode( cli_result )

    -- iter() の代わりに for loop 
    panes = {}
    for i = 1 , #json do
        local pane = {pane_id = json[i].pane_id, tab_id = json[i].tab_id}
        table.insert( panes, pane)
    end

    return panes

    ------------ Original Code
    --local cli_result = vim.system({
    --     "wezterm",
    --     "cli",
    --     "list",
    --     ("--format=%s"):format("json"),
    --}, { text = true }):wait() --  waitがない場合終了を待たないで次のスクリプトを実行する
    --                           -- vim の system  vim.fn.system() はデフォルトでブロック処理を行う
    --local json = vim.json.decode(cli_result.stdout)
    --local panes = vim.iter(json):map(_l("obj: { pane_id = obj.pane_id, tab_id = obj.tab_id }"))  -- 複数あるタブの pane id, tab id のリストを作成

    --return panes
end



local function getPreviewWeztermPaneId()
    local panes = listWeztermPanes()
    local neovim_wezterm_pane_id = getNeovimWeztermPane()


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
        --print( "preview_pane.pane_id :", preview_pane.pane_id) 
        return preview_pane.pane_id
    else
        -- print( "nil") 
        return nil
    end

    ------------ Original Code
    -- local current_tab_id = assert(panes:find(function(obj)                 -- 現在の pane が存在する タブの tab idを取得
    --      return obj.pane_id == neovim_wezterm_pane_id
    -- end)).tab_id

    -- local preview_pane = panes:find(function(obj)                          -- panes リスト内で function 内条件が成立するモノを返す
    --      return --
    --           obj.tab_id == current_tab_id --  -- 現在のタブで 克 現在のpane より大きい値のpane id 
    --                and tonumber(obj.pane_id) > tonumber(neovim_wezterm_pane_id) -- new pane id should be greater than current pane id
    -- end)
    -- return preview_pane ~= nil and preview_pane.pane_id or nil      -- preview_pane がnil でない場合には そのpane_id を返し、そうでないならnil を返す
end


local function openWeztermPreviewPane()
    local preview_pane_id = getPreviewWeztermPaneId()
    if preview_pane_id == nil then
         preview_pane_id = openNewWeztermPane({ percent = 30, direction = "right" })
    end
    return preview_pane_id
end

local is_wezterm_preview_open = function()
    return getPreviewWeztermPaneId() ~= nil
end


------------------------------ Main Function ------------------------------ 
M.weztermPreview = {
    callback = function()
        if is_wezterm_preview_open() then
            closeWeztermPane(getPreviewWeztermPaneId())
        end

        --local oil = require("oil")
        --local util = require("oil.util")

        local nvim_tree_api = require("nvim-tree.api")

        local perviw_entry_id = nil
        local prev_cmd = nil
        local neovim_wezterm_pane_id = getNeovimWeztermPane()
        local bufnr = vim.api.nvim_get_current_buf()

        local updateWeztermPreview = debounce(
            vim.schedule_wrap(function()
                if vim.api.nvim_get_current_buf() ~= bufnr then
                    return
                end

                --local entry = oil.get_cursor_entry()
                --local entry = nvim_tree_api.tree.get_node_under_cursor()
                local node = nil  --  元はentry だったが node に変更
                if (vim.o.filetype == "neo-tree") then
                    local position = vim.api.nvim_buf_get_var(0, "neo_tree_position")
                    local source   = vim.api.nvim_buf_get_var(0, "neo_tree_source")
                    --print("position : ", position, "  \\  source : ", source)

                    if position ~= "current" then
                        -- close_if_last_window just doesn't make sense for a split style
                        local state = manager.get_state(source)
                        if state ~= nil then
                            node = state.tree:get_node()
                        end
                    end
                end

                -- Don't update in visual mode. Visual mode implies editing not browsing,
                -- and updating the preview can cause flicker and stutter.


                --if entry ~= nil and not util.is_visual_mode() then
                if node ~= nil then
                    local preview_pane_id = openWeztermPreviewPane()
                    activeWeztermPane(neovim_wezterm_pane_id)

                    --for "oil plugin"
                    --if perviw_entry_id == entry.id then
                    --    return
                    --end

                    if prev_cmd == "bat" then
                        sendCommandToWeztermPane(preview_pane_id, "q")
                        prev_cmd = nil
                    end

                    local path = assert(geEntryAbsolutePath())
                    local command = ""
                    if node.type == "directory" then
                        local cmd = "ls -l"
                        command = command .. ("%s %s"):format(cmd, path)
                        prev_cmd = cmd
                    elseif node.type == "file" and isImage(path) then
                        local cmd = "wezterm imgcat"
                        command = command .. ("%s %s"):format(cmd, path)
                        prev_cmd = cmd
                    elseif node.type == "file" then
                        local cmd = "bat"
                        command = command .. ("%s %s"):format(cmd, path)
                        prev_cmd = cmd
                    end

                    sendCommandToWeztermPane(preview_pane_id, command)
                    --previw_entry_id = entry.id
                end
            end),
            50
        )

        updateWeztermPreview()

        local config = require("oil.config")
        if config.preview.update_on_cursor_moved then
            vim.api.nvim_create_autocmd("CursorMoved", {
                desc = "Update oil wezterm preview",
                group = "Oil",
                buffer = bufnr,
                callback = function()
                    updateWeztermPreview()
                end,
            })
        end

        vim.api.nvim_create_autocmd({ "BufLeave", "BufDelete", "VimLeave" }, {
            desc = "Close oil wezterm preview",
            group = "Oil",
            buffer = bufnr,
            callback = function()
                 closeWeztermPane(getPreviewWeztermPaneId())
            end,
        })
    end,
    desc = "Preview with Wezterm",
}


-------------------------------------------------- Debug Code
M.is_wezterm_preview_open = is_wezterm_preview_open

return M
