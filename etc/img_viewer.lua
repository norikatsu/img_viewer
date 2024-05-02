-- ******************************************************************************
-- 
--   File Name :  開発中.lua
--   Type      :  neovim Plugin Setting file
--   Function  :  Setting 開発中
--   Author    :  Yoshida Norikatsu
--                2024/05/01 Start 
-- 
-- ******************************************************************************


-- **************************************************
-- *  Config plugin
-- **************************************************

return {
    {
        dir = 'img_viewer', 
        dev = {true},              -- > Need Dev version ( Put project in local path)
        -- lazy = true,
        -- event = 'VeryLazy',     -- Load after VimEnter (All boot processes are completed)
        dependencies = {
            'nvim-tree/nvim-tree.lua',
        },

        config = function()
            require("img_viewer").setup({
            })
        end,
    },
}



