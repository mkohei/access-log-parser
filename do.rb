require 'apachelogregex'

# コマンドライン引数でファイル名の指定
unless ARGV[0].nil? then
    #
else
    puts "Please specify file path with command line argument.\nex) $ruby do.rb access_log"
end

# LogFormat のフォーマットをそのまま使用してパーサの初期化
format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"' # combined
=begin
    combined
        - %h : リモートホスト
        - %l : 	(identd からもし提供されていれば) リモートログ名。 これは mod_ident がサーバに存在して、 IdentityCheck ディレクティブが On に設定されていない限り、 - になります。
        - %u : リモートユーザ (認証によるもの。ステータス (%s) が 401 のときは意味がないものである可能性がある)
        - %t : 時刻
        - %r : リクエストの最初の行
        - %>s : ステータス。内部でリダイレクトされたリクエストは、元々の リクエストのステータス --- 最後のステータスは %>s
        - %b : レスポンスのバイト数。HTTP ヘッダは除く。CLF 書式。 すなわち、1 バイトも送られなかったときは 0 ではなく、 '-' になる
        - %{Referer}i : サーバに送られたリクエストの Foobar: ヘッダの内容
            -> アクセス先のファイル？
        - %{User-Agent}i : ...
            -> ユーザーエージェント，Chromeとか 
=end
logParser = ApacheLogRegex.new(format)

# ファイル読込
begin
    File.open(ARGV[0], 'r') do |file|
        i = 0
        file.each_line do |line|
            #puts line
            result = logParser.parse(line)
            p result
            i += 1
            if i > 5
                break
            end
        end
    end
# 例外は小さい単位で捕捉する(らしいです)
rescue SystemCallError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
rescue IOError => e
    puts %Q(class=[#{e.class}] message=[#{e.message}])
end
