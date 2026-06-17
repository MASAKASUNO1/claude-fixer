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
        └── hooks/
            └── hooks.json      # Opus 4.8 向け hooks（中身は今後追加）
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
