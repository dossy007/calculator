使用確認



https://rara-world.com/swift-button-layout-css/
btn装飾

http://cloudcafe.tech/?p=2633
btn影
<!-- scrollさせる
labelを3つ設置

=を押す
 historicalに値があれば、 ""でなければ
   historicalから値を取得label1 に代入
 なければ何もしない


clear labelを全て ""にすると
scrollを初期値に戻す

label 1が入ったらscroll height + 100
label2 に値が入ったらscroll height + 100
label3に値が入れば +100 -->



<!-- history1に値があれば hisotory1の値をhisotry2に
history2に値があれば hisotory2の値をhisotry3に -->


<!-- caretを使えば点滅barは使えるが、文字を打ててしまうのでどうする
caret無視で作った場合、編集したい場所にタップしても変化なしになる。
caret模索する
textviewで特定のbtnしか打てないようにできないか？

android↑

iphoneやとタップできない仕様やな。

どっちにするか？

iphoneはタップできない仕様になっているため、左に|を書いて点滅させるだけさせて
範囲選択などはさせないようにするか。 -->

上の枠
history_boxを二重にして影をつけて凹みを演出
今は、testの方で実装中

影を内側にすると、丸っこくできない問題にぶつかります。

なので、3重にして影をつける方法を取ろうと思います。

上、影は非常に難しいので！
先にbtnをやる！

btn
右下影
左上光

問題はっせい
影を二つ付けようとしたけれども、影はいっこだけしか反応してくれないみたいなんだ
だから方法を変えようと思う。

btnを二つ二重に作って片方に影片方に光をつけるのはどうか？
layer.maskToBounds
layer.cornerRadius 34.5

影光は一旦おk
位置調整を仕様
all clearを基準に y 375 
最下層は790ほど


https://dishware.sakura.ne.jp/swift/archives/329

http://cocoadays.blogspot.com/2011/08/calayer.html

https://majintools.com/2018/11/08/shadow/

///anime
https://qiita.com/hachinobu/items/57d4c305c907805b4a53#uiviewanimationoptionstransitioncrossdissolve


https://teratail.com/questions/195185
https://xd.adobe.com/view/42ab2284-8b29-4a4f-710c-2df3ee072f39-349a/