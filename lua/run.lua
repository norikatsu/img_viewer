-- for Debug 

-- キャッシュされたモジュールを削除
package.loaded['img_viewer'] = nil
package.loaded['img_viewer/module'] = nil

-- モジュールを呼び出す
local img_viewer = require('img_viewer')



-- 関数呼び出し
img_viewer.setup() -- setup() しないと使えないように作成した場合には必須

-- 確認したい関数
--img_viewer.hello()
img_viewer.tree_open()
--img_viewer.tree_get()


