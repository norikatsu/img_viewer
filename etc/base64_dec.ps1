###########
# StdinPipe.ps1 [-InputObject] <string[]> [-OutputFile] <string> [[-OptionalParam] <string>] [<CommonParameters>]
[CmdletBinding()]
param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="標準入力か引数で受け取るデータ")]
    [string[]]$InputObject,
    [parameter(Mandatory=$false,ValueFromPipeline=$false,HelpMessage="出力ファイル名")]
    [string]$OutputFile="output.dat"
    ##[parameter(Mandatory=$false,ValueFromPipeline=$false,HelpMessage="オプションパラメータ")]
    ##[string]$OptionalParam
)

begin{
    ## 初期化処理等 最初に一度だけ実行される
    ## 関数等はここで定義しておく
    Set-StrictMode -Version Latest
    [string[]]$inputParam = @()

    ## function Func( [Object]$dispParam ){
    ##     $dispParam | Out-String
    ## }
}
process{
    ## パイプライン処理 でデータ受信毎に実行される処理
    Write-Verbose "Called-`"$InputObject`""
    $inputParam += $InputObject
}
end{
    ## パイプライン処理終了後に 一度だけ実行される
    # ここをメイン関数みたいに使うのがすっきりする

    # $inputParam は sting[]なのでそのままでは Write-Verbose出来ないため文字列に変換してやる
    Write-Verbose "Write-Verbose `"`$inputParam`""
    Write-Verbose "$inputParam"

    ## DBG  Write-Host "Rcv : $inputParam"

    # base64形式の文字列をバイト配列に変換
    try {
        $bytes = [System.Convert]::FromBase64String($inputParam)
    }
    catch {
        Write-Host "Error: Base64デコードに失敗しました"
        exit
    }
    
    # バイト配列をファイルに書き込む
    try {
        #[System.IO.File]::WriteAllBytes($outputFileName, $bytes)
        [System.IO.File]::WriteAllBytes( $OutputFile, $bytes)
        Write-Host "ファイルが正常に保存されました"
    }
    catch {
        Write-Host "Error: ファイルを保存できませんでした"
    }

    # 次にパイプ処理する場合には return で渡したい値を返す
    # return $inputParam
    # バッチファイルのように失敗を明確化して返したい場合はexitを呼び出してやる($LASTEXITCODEで値が取れるようになる)
    # exit 数値
}




