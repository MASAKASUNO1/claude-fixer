#!/usr/bin/env sh
# UserPromptSubmit hook 用。毎ターン、応答の文末報告を平易にするルールを注入する。
# additionalContext はユーザープロンプトに添えて Claude に渡される。
# ルールの中身を変えたいときはこの heredoc を編集する。

cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "【文末の報告ルール】応答、とくに文末のまとめ・報告は堅い定型文を避けて平易に書くこと。避ける言い回し:『〜を実施いたしました』『〜に寄与するものと考えられます』『ご不明な点がございましたらお気軽に』のような硬い・回りくどい・へりくだりすぎる表現。やること:結論を先に、短い文で、普通の口語で。冗長な前置きと締めの定型句は省く。一文は短く。"
  }
}
JSON
