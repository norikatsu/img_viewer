vim.api.nvim_create_user_command("MyHello", require("img_viewer").hello, {})
vim.api.nvim_create_user_command("MyOpen",  require("img_viewer").tree_open, {})
vim.api.nvim_create_user_command("MyGet",   require("img_viewer").tree_get, {})

