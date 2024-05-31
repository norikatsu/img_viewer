-- for Debug 

-- キャッシュされたモジュールを削除
package.loaded['img_viewer'] = nil
package.loaded['img_viewer.module'] = nil

-- モジュールを呼び出す
local img_viewer = require('img_viewer')
local module     = require("img_viewer.module")


-- 関数呼び出し
----- 事前準備 setup() しないと使えないように作成した場合には必須
img_viewer.setup()  


-- 確認したい関数
--img_viewer.hello()
--img_viewer.tree_open()
--img_viewer.tree_close()
--img_viewer.tree_get()
--img_viewer.event()


-- wezterm APIs
--img_viewer.getNeovimWeztermPane()
--img_viewer.activeWeztermPane( 3 )
--img_viewer.openNewWeztermPane() 

-- Main function
img_viewer.weztermPreview()



--img_viewer.api_test()
--module.is_wezterm_preview_open()

