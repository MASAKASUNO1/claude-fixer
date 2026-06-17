# claude-fixer

Claude Code 用プラグインの marketplace。中身は **opus48** — Claude の報告・通知・確認依頼を、事実を保ったまま一目で掴める形にする hook。

## 導入（GitHub 経由）

```bash
# 1. marketplace を登録（GitHub リポジトリを指定）
claude plugin marketplace add MASAKASUNO1/claude-fixer
#    URL でも可: claude plugin marketplace add https://github.com/MASAKASUNO1/claude-fixer

# 2. plugin をインストール（user scope = 全プロジェクトで有効。既定）
claude plugin install opus48@claude-fixer

# プロジェクト単位で入れるなら、そのディレクトリで:
claude plugin install opus48@claude-fixer --scope project
```

Claude Code 内なら `/plugin` でも同じことができる:

```
/plugin marketplace add MASAKASUNO1/claude-fixer
/plugin install opus48@claude-fixer
```

更新・削除:

```bash
claude plugin marketplace update claude-fixer   # 最新を取り込む
claude plugin uninstall opus48@claude-fixer
```

要件: `jq`。無い環境では hook は無出力（no-op）になり、セッションは壊れず継続する。

## opus48 が何をするか

`UserPromptSubmit` hook が毎ターン、Claude の**報告・通知・確認依頼**を読みやすくするルールを `additionalContext` として注入する。

- **結論と要対応を冒頭に。** 前置き・cushion・へりくだり定型句を排す。
- **短い通知も長い構造化報告も両対応**（v0.1.2）。複数項目の報告では危険情報（破壊的変更・失敗・承認待ち）を前出しし、見出しを幹だけに畳む。
- **情報パリティ防護。** 短くするのは表現だけ。一次事実（ファイル名・数値・失敗/flaky・破壊的変更・残作業・不確実性・根本原因）は削らない。読みやすさと情報量が衝突したら情報量を優先。
- 対象は読みやすさのみ（正しさ・情報量・トーンは別軸）。

理論（なぜ効くか／報告型ごとの「削るな」リスト）は **[docs/THEORY.md](docs/THEORY.md)**。

実測（A/B・複雑な完了報告）: 読みやすさ採点 OFF 79 → ON 92、字数 約41%減でも一次事実は全保持。

## 構成

```
.
├── .claude-plugin/
│   └── marketplace.json                          # marketplace "claude-fixer"
├── plugins/
│   └── opus48/
│       ├── .claude-plugin/plugin.json
│       ├── hooks/hooks.json                       # UserPromptSubmit → スクリプトへ
│       └── scripts/inject-readability-anchor.sh   # ルール本体（heredoc を編集）
└── docs/
    ├── THEORY.md                                  # 認知的根拠・報告型タクソノミー
    └── readability-anchor.html                    # 設計・検証の解説
```

## ルールを変える

`plugins/opus48/scripts/inject-readability-anchor.sh` の heredoc を編集してコミットする。GitHub 経由で入れた利用者は `claude plugin marketplace update claude-fixer` で取り込む。

ローカルで試すなら、クローンしたディレクトリを直接登録できる:

```bash
claude plugin marketplace add ./claude-fixer      # ローカルパスを指定
claude plugin validate ./claude-fixer             # マニフェスト検証（任意）
```
