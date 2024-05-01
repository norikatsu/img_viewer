-- for Debug 

-- キャッシュされたモジュールを削除
package.loaded['img_viewer'] = nil
package.loaded['img_viewer/module'] = nil

-- モジュールを呼び出す
local img_viewer = require('img_viewer')

-- 関数呼び出し
img_viewer.setup()
img_viewer.hello2()
