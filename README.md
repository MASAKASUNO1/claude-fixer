# claude-fixer marketplace

Claude Code 用の自作プラグインを管理する marketplace。

## 構成

```
.
├── .claude-plugin/
│   └── marketplace.json        # marketplace "claude-fixer" の定義
└── plugins/
    └── opus48/                 # plugin "opus48"
        ├── .claude-plugin/
        │   └── plugin.json
        ├── hooks/
        │   └── hooks.json      # UserPromptSubmit で読みやすさルールを注入
        └── scripts/
            └── inject-readability-anchor.sh  # 注入ルール本体（heredoc を編集して変更）
```

## ローカルでの登録・利用

```bash
# 1. marketplace を登録（このディレクトリを指定）
/plugin marketplace add /Users/eren/playground/opus48

# 2. plugin をインストール
/plugin install opus48@claude-fixer

# 3. マニフェスト検証（任意）
/plugin validate /Users/eren/playground/opus48
```

更新したら `/plugin marketplace update claude-fixer` で再読み込みする。

## opus48 plugin

`hooks/hooks.json` に Opus 4.8 (`claude-opus-4-8`) 利用時の hooks を定義する。
スクリプトを置く場合は plugin ルートからの絶対参照に `${CLAUDE_PLUGIN_ROOT}` を使う。

### inject-readability-anchor.sh

`UserPromptSubmit` hook。毎ターン、Claude がユーザーに返す**文末の報告・通知・確認依頼**を
読みやすくするルールを `additionalContext` として注入する。基準は `ref-readability-essence` の
`visual_short`（短文）アンカー — 結論を冒頭 / 先頭2語=内容語 / 改行=意味単位 / 前置きゼロ /
一文一義 / cushion・へりくだり定型句の回避。WHY（作業記憶の負荷を肩代わりし再読ゼロにする理由）と
bad→good の few-shot を内包し、旧 `inject-report-style.sh` の上位互換。

- ルールを変えるときは同スクリプト内の heredoc を編集する。
- JSON 化に `jq` を使う。`jq` が無い環境では何も注入せず no-op になり、セッションは継続する。
- A/B 検証（visual_short rubric 採点）で baseline 22–28 点 → ルール適用後 92–95 点（4/4 シナリオ改善）。
