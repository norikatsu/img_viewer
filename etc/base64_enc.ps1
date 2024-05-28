## base64 coverter by PowerShell
param (
    [parameter(Mandatory=$true,ValueFromPipeline=$false,HelpMessage="入力画像ファイル")]
    [string]$imagePath
)

begin{
    ## 初期化処理等
}
process{
    ## パイプライン処理 でデータ受信毎に実行される処理
}
end{
    ## パイプライン処理終了後に 一度だけ実行される
    # ここをメイン関数みたいに使うのがすっきりする
    if (-not (Test-Path $imagePath)) {
        Write-Host "Error: ファイルが見つかりません"
        exit 1
    }
    # ファイルをバイト配列として読み込む
    try {
        $imageBytes = [System.IO.File]::ReadAllBytes($imagePath)
    }
    catch {
        Write-Host "Error: ファイルを読み込めませんでした"
        exit
    }
    
    # バイト配列をbase64形式のテキストデータに変換
    $base64String = [System.Convert]::ToBase64String($imageBytes)
    
    # 結果を標準出力に出力 (パイプで接続できるように return で返す)
    #Write-Host $base64String
    return $base64String
}
