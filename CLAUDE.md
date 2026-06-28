# TimeLens iOS — Claude Code 実装計画 / プロジェクト指示書

> **このファイルをリポジトリ直下の `CLAUDE.md` として保存する。**
> Claude Code は作業前に必ず全文を読み、この文書を仕様・優先順位・実装ルールの一次情報として扱うこと。

---

## 0. プロダクトの前提

### 仮称
**TimeLens**

### 一文でいうと
**いま立っている場所にカメラを向けると、消えた街の記憶が重なるiPhoneアプリ。**

### 体験の核
ユーザーは対象スポットでカメラを開き、現在の景色と過去の景色をスライダーで行き来する。

- 現在の建物や道路を見ている
- 看板・人影・音・建物の輪郭が少しずつ過去に変わる
- 「ここに何があったか」を短く知る
- 現在と過去が同居した状態で写真・動画を残す

### 事業の順番
この初回リリースは、いきなり自治体・デベロッパー向けに受託提案するための試作品ではない。

**一般ユーザーがApp Storeから入手でき、実際の場所で感動できるB2Cプロダクト**として先に公開する。

そのうえで、以下を営業資産にする。

1. 現地での体験動画
2. SNS投稿例
3. 課金・解放率
4. ルート完走率
5. 滞在時間・再訪率
6. 権利管理済みコンテンツ運用の実績

企業・自治体・再開発事業者へは、後から「ARアプリ開発」を売るのではなく、**地域の記憶を回遊・滞在・SNS発信に変える公開済みプロダクト**として提案する。

---

## 1. MVPの勝ち筋と絶対条件

### 最初の公開範囲
- **1エリアのみ**
- **1つの歴史テーマ／時代のみ**（例：昭和後期の商店街）
- **無料1スポット + 有料4スポット**
- **徒歩30〜45分の短いルート**
- そのうち1スポットを「Hero Scene」とし、最も強い変化を見せる

### Hero Sceneの要件
- 現在との変化がひと目で分かる
- 安全に立ち止まれる観覧位置がある
- カメラを向ける方向が明確
- 古写真／資料／再現モデルの権利処理が完了できる
- 15秒以内に「うわ、すごい」が起きる
- SNS向けの短い縦動画が撮れる

### MVPの成功指標（目標値）
数値は初期仮説であり、TestFlight後に更新する。

| 指標 | 初期目標 |
|---|---:|
| 初回起動から最初のAR変化を見るまで | 90秒以内 |
| 無料Hero Sceneの完了率 | 60%以上 |
| 有料ルート解放画面の到達率 | 25%以上 |
| 有料ルート購入率（到達者基準） | 8%以上 |
| 購入後のルート完走率 | 45%以上 |
| 共有画面への到達率 | 20%以上 |
| ARエラーで体験不能になる率 | 3%未満 |

### MVPで絶対に守ること
- 位置ズレで体験がゼロにならない
- カメラを見ながら歩かせない
- 実在資料・実在店舗・ロゴを無許可で使わない
- 事実・資料に基づく再構成・演出を混同しない
- 購入前に一度は感動を体験させる
- 初回版で会員登録を必須にしない

---

## 2. スコープ

### P0 — App Store公開に必須

1. 近くのスポットが見つかる地図画面
2. スポット詳細（短い導入、所要時間、安全案内、資料ラベル）
3. 無料Hero Scene
4. 現在⇄過去のタイムスライダー
5. ARの3段階フォールバック
6. ルート解放用の非消費型In-App Purchase
7. 購入復元
8. カメラ・位置情報の文脈的な許可導線
9. 写真／短尺動画の保存または共有導線
10. 出典・権利・再構成レベルを示すクレジット画面
11. 設定、プライバシー、問い合わせ、利用規約への導線
12. TestFlight配布とApp Store提出に耐えるエラー処理

### P1 — 初回公開後に追加

- Apple AR Geo Tracking対応地点での地理アンカー
- 3Dアセットのストリーミング配信
- 多言語（英語・繁体字・韓国語）
- 追加エリアの販売
- 年間パス／コレクション
- App Clip
- 事業者向けCMS
- アプリ内イベント・期間限定演出

### P2 — まだ作らない

- 全国対応
- ユーザー投稿の古写真
- コメント・DM・フォローなどのSNS機能
- 顔認識・人物識別
- 歩行中のARナビ
- 一般的な「どこでも昭和化」機能
- Android版
- Google Street View・スクレイピング依存の自動復元

---

## 3. 課金設計

### V1の課金方針
**月額課金は実装しない。**

街歩きは毎日使うユースケースではないため、V1は「1エリアの物語を買う」非消費型課金にする。

| 商品ID（仮） | 種別 | 価格仮説 | 内容 |
|---|---|---:|---|
| `route.<area>.showa.full` | Non-consumable | ¥980 | 有料4スポット、音、追加資料、撮影機能の解放 |
| `route.<area>.showa.supporter` | Non-consumable | ¥1,480 | 完全ルート + 制作支援特典（後日導入、V1では非表示可） |

### 無料体験
- 地図閲覧
- ルート概要
- Hero Scene 1本
- 「現在⇄過去」比較体験
- 資料の短い説明

### ペイウォールを出す場所
禁止：起動直後／位置情報許可前／Hero Scene体験前。

推奨：無料Hero Sceneを見終えた直後、次のスポットへ向かう文脈。

例文：

> この先に、消えた映画館があります。\
> 昭和の夜を続けますか？

### StoreKit実装要件
- StoreKit 2 を使用する
- 商品一覧、購入、保留、キャンセル、失敗、復元を実装する
- 権利状態は `Transaction.currentEntitlements` を基準に再構築する
- 購入状態をUI上のローカルフラグだけで判定しない
- StoreKit Configuration File を用意し、ローカル購入テストを可能にする
- App Store Connectの商品設定はリリース前チェックリストに明記する

---

## 4. 推奨技術構成

### 原則
初回版は **iOSネイティブ** で作る。クロスプラットフォーム化より、AR体験・カメラ・StoreKit・App Store品質を優先する。

### ランタイム
- 言語: Swift 6
- UI: SwiftUI
- 最低対応OS: iOS 18.0
- 対象: iPhone優先。iPadはP1まで最適化不要
- 画面向き: 縦固定を基本とし、AR体験中のみ必要なら横対応を検討

### Appleフレームワーク
- `SwiftUI`: 画面構築
- `MapKit`: 地図、注釈、ルート導線
- `CoreLocation`: 現在地、距離、方角、精度
- `ARKit`: カメラ、世界トラッキング、Geo Trackingの可用性判定
- `RealityKit`: 3Dアセット表示、光、簡単なアニメーション
- `StoreKit 2`: 非消費型IAP
- `AVFoundation`: カメラ／音声の必要最小限の制御
- `PhotosUI` / `Photos`: 保存許可が必要な場合のみ使用
- `OSLog`: ローカル診断ログ

### 外部サービス
V1で必須にする外部サービスはゼロに近づける。

- コンテンツ: アプリバンドル内JSON + バンドル内アセット
- 購入: App Storeのみ
- ユーザーアカウント: なし
- 分析: `AnalyticsSink` プロトコルを作るが、初期実装はローカル／同意済みの最小イベントのみ

### V1後のバックエンド候補
Cloudflare Workers + D1 + R2 を候補とするが、**初回体験がローカルコンテンツだけで完結してから**導入する。

用途：
- 追加ルート／アセットの配信
- コンテンツ改訂
- 権利失効時の即時非公開
- 匿名イベント集計
- 事業者向け分析ダッシュボード

### Map Provider方針
V1はMapKitを使う。

- Google Maps / Street Viewをアセット制作の参照元・トレース元・学習元に使わない
- 地図は「現在地から観覧地点へ行く」ための導線であり、歴史再現データのソースではない
- 歴史地図・古写真・3Dモデルは別管理の権利台帳を必須にする

---

## 5. AR設計：成功時の魔法と失敗時の逃げ道

### 絶対ルール
**AR精度が足りないときに、空白画面やエラー画面だけを出してはいけない。**

### 表示モード

#### Mode A: Manual Photo Alignment（P0必須）

現在のカメラ映像の上に、過去の写真／イラスト／半透明エフェクトを重ねる。

- ユーザーは指定された観覧位置で停止する
- 画面上に屋根・道路・看板などの合わせ目ガイドを出す
- ユーザーがスライダーで過去の表示量を動かす
- 必要なら、コンテンツ側で事前に用意した軽微な拡大／位置調整だけを許可する
- 「正確な復元」と断定せず、`記録` / `再構成` / `演出` を明示する

これは最優先。GPS／通信／AR Geo Trackingに依存しないため、最初の公開版を成立させる土台になる。

#### Mode B: Manual 3D Scene（P0必須、Hero Sceneのみ）

観覧地点から、道路の一部・看板・店舗正面・人影などをRealityKitで重ねる。

- 1スポットにつき、表示物を限定する
- 周囲360度の完全復元を目指さない
- 低ポリゴンまたは事前ベイクした表現で安定フレームレートを優先する
- 位置・角度の補正UIを用意する
- 実在ロゴ・実在商品・実在人物を無許可で再現しない

#### Mode C: Geo Tracking（P1）

ARGeoTrackingConfigurationがその地点・端末で利用可能な場合にのみ利用する。

- `checkAvailability` を必ず実行する
- 利用不可、精度未確定、低光量、通信不良の場合はMode AまたはBへ即時フォールバックする
- Geo Trackingが使えることを購入条件にしない

#### Mode D: Cinematic Fallback（P0必須）

ARが使えない場合でも、現在地・向き・スポット文脈に合わせた短い映像／音／比較スライダーを表示する。

- 「使えません」ではなく「別の見え方で、街の記憶を見せる」
- 体験の核心（現在と過去の比較）を失わない

### ARセッション状態

```swift
enum ExperienceMode {
    case manualPhoto
    case manual3D
    case geoTracking
    case cinematicFallback
}

enum ExperienceState {
    case idle
    case checkingPermissions
    case locating
    case safetyCheck
    case calibrating
    case presenting
    case purchaseRequired
    case unavailable(reason: String)
    case error(recovery: RecoveryAction)
}
```

### AR品質ガード
- 位置精度が悪い場合は、精密3Dを開始しない
- カメラ権限拒否時はCinematic Fallbackへ誘導する
- 位置情報拒否時は地図検索／手動選択を可能にする
- ARKit非対応端末では、比較ビューだけで体験を完結させる
- 実機検証なしにAR完了としない

---

## 6. 画面設計

### 画面一覧

1. **Onboarding**
   - 体験の短い説明
   - 「歩きながら見ない」安全ルール
   - 位置情報／カメラの許可は必要になったタイミングで要求する

2. **Discover Map**
   - 現在地付近のスポット
   - 無料／有料、所要時間、距離、安全情報
   - 地図が使えない場合もスポット一覧へ切り替え可能

3. **Spot Detail**
   - 現在の場所と過去のテーマ
   - 体験時間
   - 観覧位置の写真／図
   - 安全な立ち位置
   - 資料ラベル（記録／再構成／演出）
   - 「体験を始める」

4. **Safety Gate**
   - 「安全な場所に立ち止まってから開始してください」
   - 車道、横断歩道、混雑地点では使わない
   - 必要なら `I am stopped` を明示操作

5. **AR Experience**
   - カメラ／映像
   - 現在⇄過去のタイムスライダー
   - 合わせ目ガイド
   - 音量
   - クレジットボタン
   - 共有／保存
   - エラー時の自然なフォールバック

6. **Unlock Route**
   - 無料Hero Scene後に表示
   - 物語の続きを見せる
   - 価格、復元、購入規約リンク

7. **Route Progress**
   - 次のスポット
   - 徒歩導線
   - 今は歩行パートであり、AR表示はしない

8. **Library / Credits**
   - 解放済みルート
   - 出典
   - 表現区分
   - 権利表記
   - 問い合わせ

9. **Settings**
   - 位置情報・カメラ許可状態
   - 分析同意
   - データ削除（将来アカウントを導入した場合）
   - 法務情報

### UI原則
- 初期画面で説明を読ませすぎない
- 画面内テキストは短く、情緒を優先する
- 歴史の説明は一画面70〜120文字を目安にする
- 「購入」より「続きを見る」を優先する
- アクセシビリティのため、字幕・音量調整・音なしでも成立する設計を入れる

---

## 7. コンテンツデータと権利台帳

### 重要原則
アプリに表示されるすべての歴史素材・3Dモデル・音声・文章・ロゴ風表現は、**コンテンツ単位で利用根拠を持つ**。

素材が美しい、古い、ネットにある、生成AIで作った、という理由だけで公開してはいけない。

### 表現区分
各スポットと各アセットには必ず次のいずれかを設定する。

- `recorded`: 資料そのもの／史料確認済み
- `reconstructed`: 複数資料に基づく再構成
- `dramatised`: 空気感・人物・光・音などを含む演出的再現

UIでは「記録」「再構成」「演出」と日本語で表示する。

### コンテンツモデル例

```swift
struct Route: Codable, Identifiable {
    let id: String
    let title: String
    let eraLabel: String
    let isFreePreview: Bool
    let productID: String?
    let spots: [Spot]
}

struct Spot: Codable, Identifiable {
    let id: String
    let title: String
    let coordinate: Coordinate
    let viewingPoint: ViewingPoint
    let safety: SafetyRule
    let experience: ExperienceDefinition
    let evidence: [Evidence]
}

struct Evidence: Codable, Identifiable {
    let id: String
    let expressionLevel: ExpressionLevel
    let sourceName: String
    let rightsStatus: RightsStatus
    let attribution: String
    let permittedUses: [PermittedUse]
    let permissionRecordID: String?
    let reviewDueAt: Date?
}
```

### 公開ブロック条件
次のいずれかが欠けるアセットは、プロダクションビルドで表示しない。

- `sourceName`
- `rightsStatus`
- `attribution`（不要な場合も `notRequired` と明記）
- `permittedUses`
- `expressionLevel`
- `contentOwner`
- `reviewedAt`

### 禁止事項
- Google Maps / Street Viewの画像・地物をトレースして3D化しない
- SNS投稿の古写真を無断転載しない
- 実在店舗のロゴ、商品パッケージ、看板をそのまま再現しない
- 特定の写真家・イラストレーター・映画・アニメの表現を模倣する指示でAI生成しない
- 「史実」と断定できないものを史実と表示しない

### 最低限の権利台帳
リポジトリ内ではなく、アクセス制限された運用台帳にも保存する。

| 項目 | 内容 |
|---|---|
| Asset ID | アプリ内アセットと一致するID |
| 制作者／権利者 | 個人・団体名 |
| 出典 | 資料名、URL、保管場所 |
| 利用許諾 | 契約書・メール・ライセンス番号 |
| 利用範囲 | アプリ、広告、SNS、イベント、海外配信 |
| 二次創作可否 | 3D化・色補正・AI補助の可否 |
| クレジット | 表記文言 |
| 期限 | 更新・失効日 |
| 表現区分 | 記録／再構成／演出 |
| 担当者 | 最終確認責任者 |

---

## 8. 安全・プライバシー

### 安全UX
このアプリは「歩行中のAR」ではない。

- ARは必ず安全な観覧地点で、立ち止まって見る
- スポットコンテンツに `safeViewingArea` を必須で持たせる
- 車道、横断歩道、階段、駅ホーム、私有地の入口付近にはAR観覧地点を置かない
- 次のスポットへ移動中は、地図・音声・短文だけを出し、カメラARは開始させない
- GPS速度が明確に高い場合は「立ち止まると過去が見えます」と案内し、AR描画を弱める
- 夜間・荒天・混雑で危険になり得るスポットには運用上の注意を設定できるようにする

### プライバシー原則
- 位置情報は `When In Use` のみ要求する
- 背景位置情報を使わない
- カメラフレームをサーバーへ送信しない
- 顔認識・人物識別を実装しない
- アカウント登録をV1で要求しない
- 保存はユーザーの明示操作時だけ行う
- 分析は最小化し、個人の移動履歴を追跡しない

### Info.plistの目的文言案

```text
NSCameraUsageDescription:
現在の街並みに過去の風景を重ねて表示するために、カメラを使用します。

NSLocationWhenInUseUsageDescription:
近くにある「時代の窓」と安全な観覧地点を案内するために、現在地を使用します。

NSPhotoLibraryAddUsageDescription:
作成した現在と過去の比較画像・動画を写真ライブラリに保存するために使用します。
```

### 分析イベント（V1）
個人を特定しない最小限のイベントだけを設計する。

```text
app_opened
onboarding_completed
spot_detail_viewed
experience_started
experience_mode_selected
experience_completed
experience_fallback_used
paywall_viewed
purchase_started
purchase_completed
purchase_restored
share_opened
share_completed
safety_gate_shown
permission_denied
```

イベントに生の緯度経度、カメラ画像、氏名、連絡先を含めない。

---

## 9. 推奨ディレクトリ構成

```text
TimeLens/
├── App/
│   ├── TimeLensApp.swift
│   ├── AppRouter.swift
│   └── AppDependencies.swift
├── Features/
│   ├── Onboarding/
│   ├── Discover/
│   ├── SpotDetail/
│   ├── Experience/
│   │   ├── AR/
│   │   ├── PhotoAlignment/
│   │   ├── CinematicFallback/
│   │   └── SafetyGate/
│   ├── Paywall/
│   ├── Purchases/
│   ├── RouteProgress/
│   ├── Library/
│   └── Settings/
├── Domain/
│   ├── Models/
│   ├── Repositories/
│   ├── UseCases/
│   └── Validation/
├── Infrastructure/
│   ├── Location/
│   ├── AR/
│   ├── StoreKit/
│   ├── Analytics/
│   ├── Content/
│   └── Diagnostics/
├── DesignSystem/
│   ├── Components/
│   ├── Tokens/
│   └── Accessibility/
├── Resources/
│   ├── Content/
│   │   ├── routes.json
│   │   ├── rights-ledger.sample.json
│   │   └── sample-route.json
│   ├── Assets.xcassets/
│   ├── RealityAssets/
│   └── Localizable.xcstrings
├── Tests/
│   ├── Unit/
│   ├── UI/
│   └── Fixtures/
└── Docs/
    ├── CONTENT_RIGHTS_PROCESS.md
    ├── APP_STORE_RELEASE_CHECKLIST.md
    ├── FIELD_TEST_CHECKLIST.md
    └── PRODUCT_METRICS.md
```

### 依存性ルール
- `Features` は `Domain` のモデルとユースケースに依存してよい
- `Domain` はSwift標準ライブラリ以外に依存しない
- `Infrastructure` はフレームワーク依存を閉じ込める
- `SwiftUI View` の中でStoreKitやCoreLocationを直接扱わない
- ARKitの細部を画面Viewに漏らさない
- 外部APIのSDKを導入する前に、代替案とプライバシー影響を文書化する

---

## 10. 実装フェーズ

### Phase 0 — リポジトリ初期化と土台

#### やること
- Xcodeプロジェクト作成
- SwiftUI App、iOS 18 target
- 上記ディレクトリ構成を作成
- `Route` / `Spot` / `Evidence` / `Entitlement` のドメインモデルを定義
- サンプルコンテンツJSONを1ルート分作成
- `ContentRepository` をプロトコル化し、最初は `BundledContentRepository` を実装
- `AppRouter` と最小ナビゲーションを実装
- `OSLog` とクラッシュしないエラー表示の土台を作成
- Unit Testターゲット、UI Testターゲットを作成

#### 完了条件
- シミュレータで起動する
- 地図／一覧からサンプルスポット詳細まで遷移できる
- JSONが壊れている場合にクラッシュせず、開発向け診断が出る
- `xcodebuild test` が通る

---

### Phase 1 — Discover / Spot Detail / 位置情報

#### やること
- MapKit地図
- スポットピンと一覧切替
- 現在地周辺の距離表示
- 位置情報拒否時の手動スポット選択
- Spot Detail画面
- 観覧位置の案内図
- 安全注意表示
- 位置情報の文脈的許可

#### 完了条件
- 位置情報あり／なしの両方でスポットを選べる
- 許可拒否でアプリが詰まらない
- 地図は補助であり、体験開始が地図依存にならない

---

### Phase 2 — 無料Hero Scene（最重要）

#### やること
- カメラ権限の文脈的要求
- `ExperienceState` による状態遷移
- Safety Gate
- Mode A: Manual Photo Alignment
- 現在⇄過去のタイムスライダー
- 音のフェードイン／フェードアウト
- 資料ラベルとクレジット表示
- モックではなく、最低1本の実デバイス体験を作る

#### 完了条件
- 実機で、観覧地点に立ち、30秒以内に比較体験ができる
- カメラ拒否時にCinematic Fallbackへ遷移する
- 過去表示量0%と100%の違いが明確
- エラー状態で白画面／黒画面／無反応にならない

---

### Phase 3 — Hero Sceneの軽量3D化

#### やること
- RealityKitを `ARExperienceEngine` の中に閉じ込める
- USDZの読み込み
- 看板、店舗正面、路面、人物シルエットなど限定要素を配置
- 軽量アニメーションと環境音
- 端末性能・トラッキング品質により2D版へフォールバック
- 実機フレームレート測定とメモリ監視

#### 完了条件
- 現行の一般的なiPhoneで体験が破綻しない
- 3Dが失敗しても2D比較体験が使える
- 現実の街を完全置換しようとしない

---

### Phase 4 — 有料ルートとStoreKit

#### やること
- ルートロック状態
- 文脈型ペイウォール
- StoreKit 2購入・復元
- `EntitlementRepository`
- ローカルStoreKitテスト
- 購入完了後の即時解放
- キャンセル・保留・通信エラー表示
- App Store Connect設定手順の文書化

#### 完了条件
- サンドボックスで購入・復元できる
- アプリ再インストール後も権利が正しく反映される
- 無料体験が購入導線により壊れない

---

### Phase 5 — ルート体験、共有、分析

#### やること
- 4スポットの導線
- Route Progress
- 共有用の縦長カード／比較画像
- 可能なら短尺動画の書き出し
- 分析イベント
- 失敗モードの集計
- コンテンツのローカルキャッシュ

#### 完了条件
- ユーザーが迷わず次のスポットへ行ける
- 共有したくなる成果物が1枚または1本残る
- ユーザー個人の移動履歴を保存しない

---

### Phase 6 — フィールドテストとリリース

#### やること
- 異なる端末・通信・時間帯で現地検証
- 安全な滞留場所の再確認
- 位置ズレ許容範囲を実測
- 購入・復元・権限拒否・低電力・オフラインに近い状況の確認
- プライバシーポリシー、利用規約、クレジット、サポート導線
- App Storeメタデータ、スクリーンショット、レビューノート
- TestFlightの定性インタビュー設計

#### 完了条件
- 公開候補地点すべてで、安全に30秒以上体験できる
- 権利台帳が全アセットをカバーしている
- App Reviewに必要な体験手順がレビューノートに明記されている
- ブロッカーなしでTestFlight配布できる

---

## 11. テスト戦略

### Unit Tests
必須テスト対象：

- JSONデコード
- 必須権利情報のバリデーション
- 無料／有料スポットのロック判定
- Entitlement更新
- 位置情報拒否時のルーティング
- ARモード選択ロジック
- AR不可時のフォールバック
- 安全Gateの状態遷移

### UI Tests
- 初回オンボーディング
- 位置情報拒否
- カメラ拒否
- 無料Hero Scene到達
- ペイウォール表示
- 購入復元導線
- クレジット表示

### 実機フィールドテスト
シミュレータはAR品質検証の代替にならない。

| 条件 | 確認項目 |
|---|---|
| 晴天 | 画面視認性、位置合わせ |
| 曇天・夕方 | カメラ認識、UIコントラスト |
| 通信不安定 | フォールバック、ローカル動作 |
| 位置情報拒否 | 一覧・手動到達 |
| カメラ拒否 | Cinematic Fallback |
| 非LiDAR端末 | 2Dモード品質 |
| 小型画面 | 操作性・字幕 |
| 混雑時 | 滞留安全性 |

### パフォーマンス目安
- AR開始時にUIが固まらない
- 低品質モードへ切り替える仕組みを持つ
- 大型アセットは必要なスポット直前まで読み込まない
- 強い発熱や電池消耗が起きる場合は、3D密度より体験時間を短くする

---

## 12. App Store提出前チェックリスト

- [ ] 実機で全スポットを確認した
- [ ] すべてのアセットに権利台帳がある
- [ ] 事実／再構成／演出のラベルがある
- [ ] カメラ利用目的が明確
- [ ] 位置情報利用目的が明確
- [ ] 背景位置情報を使っていない
- [ ] カメラフレームを外部送信していない
- [ ] 購入・復元・キャンセルを検証した
- [ ] ペイウォール前に無料体験がある
- [ ] 位置情報・カメラ拒否時でも主要価値が残る
- [ ] 安全な観覧地点をすべて確認した
- [ ] 利用規約、プライバシーポリシー、問い合わせ先を用意した
- [ ] App Storeのプライバシー申告を実装実態と一致させた
- [ ] App Review向けのテスト手順・対象座標・購入テスト方法を用意した

---

## 13. B2B提案へつなげるための公開後データ

V1の一般公開後、最低限これを見られるようにする。

### 体験価値
- Hero Scene到達率
- 体験完了率
- 共有率
- 自由記述の感想
- SNS投稿の質的例

### 事業価値
- ルート開始数
- スポット間の回遊率
- ルート完走率
- 有料解放率
- 再訪率
- 時間帯別の利用傾向（粒度を粗くし、個人追跡をしない）

### 営業資料にするもの
- 実際の利用者が写る許諾済み体験動画
- 現在⇄過去の比較動画
- 「何分滞在し、何スポット巡ったか」の集計
- 権利・安全・プライバシー運用の仕組み図
- 「1地点だけの軽量導入」から始められるメニュー

---

## 14. Claude Code の作業ルール

### 作業開始時
1. この `CLAUDE.md` を読む
2. 現在のリポジトリ構造を確認する
3. 実装対象のPhaseと完了条件を短く要約する
4. 影響ファイルを列挙する
5. 既存のテストを確認してから変更する

### 実装中
- 一度に複数Phaseを飛ばさない
- UIだけ先に作って「動いたふり」をしない
- `Feature -> Domain -> Infrastructure` の責務を崩さない
- 依存ライブラリ追加は、標準フレームワークで不可能な場合だけ提案して承認を待つ
- 外部APIキー、秘密情報、実在の権利資料をリポジトリにコミットしない
- テスト不能な設計を避ける
- ハードコードした歴史的事実や許諾状態をView内に置かない
- プレースホルダは必ず `SAMPLE` または `PLACEHOLDER` と表示する
- 未確認の歴史的事実を生成・断定しない

### 変更後
1. ビルドする
2. 可能なテストを実行する
3. テスト結果を報告する
4. 変更ファイルと意図を短くまとめる
5. 次のPhaseへ進む前に、未解決のリスクを列挙する

### エラー対応
- AR／位置情報／カメラの失敗は、ユーザー向けには回復案を出す
- 開発者向け詳細は `OSLog` に残す
- `fatalError`、強制アンラップ、無言の `catch {}` をプロダクションコードに入れない
- 位置情報、購入、アセット読み込みの非同期処理はキャンセル・再試行・状態遷移を明示する

---

## 15. 最初にClaude Codeへ送る実行指示

```text
このリポジトリの CLAUDE.md を全文読んでください。

Phase 0だけを実装してください。以下を守ってください。
- 先に現状のファイル構成と、作成・変更するファイルの一覧を示す
- SwiftUI / Swift 6 / iOS 18 を前提にする
- 依存ライブラリを追加しない
- Domainモデル、BundledContentRepository、サンプルJSON、最小のDiscover→Spot Detail遷移、Unit Testまで作る
- JSONの権利フィールドが不足した場合に、プロダクションでは公開しない設計にする
- ビルドとテストを実行する
- 完了後、実行したコマンド、結果、残るリスクを報告する
- Phase 1以降には進まない
```

---

## 16. 公式ドキュメント参照（実装前に確認）

- Claude Code Overview: https://docs.anthropic.com/ja/docs/claude-code/overview
- Claude Code Memory / CLAUDE.md: https://docs.anthropic.com/ja/docs/claude-code/memory
- Apple ARKit: https://developer.apple.com/documentation/arkit
- Tracking geographic locations in AR: https://developer.apple.com/documentation/ARKit/tracking-geographic-locations-in-ar
- ARGeoTrackingConfiguration availability: https://developer.apple.com/documentation/arkit/argeotrackingconfiguration
- MapKit: https://developer.apple.com/documentation/mapkit/
- Core Location authorization: https://developer.apple.com/documentation/corelocation/requesting-authorization-to-use-location-services
- StoreKit non-consumable IAP: https://developer.apple.com/documentation/storekit/product/producttype/nonconsumable
- App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/

---

## 17. 判断に迷ったときの優先順位

1. ユーザーの安全
2. 素材・史料・ブランドの権利
3. 実機で確実に感動が起きること
4. 位置ズレ時にも体験が残ること
5. 最小の課金導線で継続可能にすること
6. 見栄えより、公開・運用・拡張できる設計
7. 未来のB2B提案は、公開済みB2C実績の後に作る
