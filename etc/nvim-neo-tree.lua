-- ******************************************************************************
-- 
--   File Name :  nvim-tree.lua
--   Type      :  neovim Plugin Setting file
--   Function  :  Setting Filer Plugin  ... nvim-tree & nvim-web-devicons 
--   Author    :  Yoshida Norikatsu
--                2023/01/25 Start 
-- 
-- ******************************************************************************


-- **************************************************
-- *  Config plugin
-- **************************************************

return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        event = 'VeryLazy',     -- Load after VimEnter (All boot processes are completed)
        config = function()
            require("neo-tree").setup({

                window = {
                    mappings = {
                        ["P"] = function(state)
                            local node = state.tree:get_node()
                            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                        end,

                        ["u"] = "navigate_up",
                    }
                },

                event_handlers = {
                    {
                        event = "file_opened",
                        handler = function(file_path)
                            -- auto close
                            -- vimc.cmd("Neotree close")
                            -- OR
                            require("neo-tree.command").execute({ action = "close" })
                        end
                    },

                    {
                        event = "vim_cursor_moved",
                        handler = function()
                            local img_viewer = require("img_viewer")
                            img_viewer.tree_get()
                        end
                    },
                },
            })
        end,
        init = function()
            if vim.g.vscode then
                vim.keymap.set("n", "<leader>e", "<cmd>call VSCodeNotify('workbench.view.explorer')<CR>")
            else
                vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
            end
        end,
        -- keys = {
        --     { "<leader>e", ":NvimTreeToggle<CR>", mode = "n", },
        -- },
    },
}



