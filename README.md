# TimeLens (仮称)

> いま立っている場所にカメラを向けると、消えた街の記憶が重なる iPhone アプリ。

実装の仕様・優先順位・ルールはすべて [`CLAUDE.md`](CLAUDE.md) を一次情報とする。作業前に必ず全文を読むこと。

## 技術構成
- Swift 6 / SwiftUI / iOS 18+
- ARKit / RealityKit / MapKit / CoreLocation / StoreKit 2
- 外部依存ライブラリ: なし（標準フレームワークのみ）

## ビルド（Mac 不要・CI ビルド前提）
このリポジトリは Windows で著作され、Xcode プロジェクトは **XcodeGen** で生成する。
`.xcodeproj` はコミットしない（`project.yml` が唯一の真実）。

```bash
# macOS 上で
brew install xcodegen
xcodegen generate
xcodebuild -scheme TimeLens -destination 'platform=iOS Simulator,name=iPhone 16' test
```

CI（GitHub Actions macOS runner）が `.github/workflows/ios-build.yml` で同等を実行する。

## 主要ドキュメント
- [Docs/PLAN_V2.md](Docs/PLAN_V2.md) — ロードマップ現行版（Track C 並走 / 3D は P1 / 実機体験ゲート）
- [Docs/EXPERIENCE_QUALITY.md](Docs/EXPERIENCE_QUALITY.md) — Hero Scene 体験品質仕様（構図一致アセット / リビール振付 / 3層ブレンド / 審査デモモード）

## 進捗（ロードマップ現行版: [Docs/PLAN_V2.md](Docs/PLAN_V2.md)）
- [x] Phase 0 — リポジトリ初期化と土台（CI green・33 tests）
- [ ] Phase 1 — Discover / Spot Detail / 位置情報
- [ ] Phase 1.5 — ASC app + TestFlight 配布パイプライン
- [ ] Track C — コンテンツ制作（エリア決定 / 生成素材 / 権利台帳）※ Phase 1〜2 と並走
- [ ] Phase 2 — 無料 Hero Scene（Mode A スライダー + Mode D）
- [ ] Phase 2.5 — 実機体験ゲート（15秒 wow 判定）
- [ ] Phase 4 — 有料ルートと StoreKit + 名称クリアランス
- [ ] Phase 5 — ルート体験 / 共有 / 分析
- [ ] Phase 6 — フィールドテストとリリース
- [ ] (P1) 旧 Phase 3 — Hero Scene の軽量 3D 化（ゲート結果次第で V1 復活）

## ディレクトリ
`CLAUDE.md` §9 の構成に準拠。`Features → Domain → Infrastructure` の責務境界を崩さない。

## ライセンス / 権利
- 歴史素材・3Dモデル・音声・文章はすべてアセット単位で利用根拠（権利台帳）を持つ。
- `Resources/Content/rights-ledger.sample.json` はサンプルのみ。実台帳はコミットしない。
