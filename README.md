# hacocms-ios-sdk

[hacoCMS](https://hacocms.com/)のiOS用 API クライアントライブラリです。

- **Platform**: iOS 13.0+
- **Minimum Swift Version**: 5.x


# Step 1. hacoCMSのAPIスキーマ設定
お持ちのhacoCMSアカウントの適当なプロジェクト（無ければ作成してください）に、ブログ記事のAPIを以下の設定で作成してください。[APIの作成方法についてはhacoCMSのドキュメント](https://hacocms.com/docs/entry/api-create)をご確認ください。

- API名：`記事`（任意）
- エンドポイント：`entries`
- 説明文：（任意）
- APIの型：`リスト形式`
- APIスキーマ：`下記の表と画像を参照`

| # | details              | フィールド名（任意） | フィールド ID     |
| --|----------------------| -----------------|-----------------|
| 1 | テキストフィールド       | タイトル          | `title`          |
| 2 | テキストフィールド       | 概要             | `description`    |
| 3 | リッチテキスト          | 本文             | `body`           |

記事APIを作成できたら、適当な記事をいくつか作成してみましょう。[コンテンツの作成方法についてはhacoCMSのドキュメント](https://hacocms.com/docs/entry/contents-create)をご確認ください。

# Step 2. hacoCMS SDKのインストール

hacoCMS APIをiOSで呼び出すためのSDKであるhacoCMSiOSSDKを以下の３つの方法のいずれかでインストールできます。

## CocoaPods

まず、Podfileファイルに下記を追加してください。
```
pod 'hacoCMSiOSSDK'
```
次に、Terminal内でpod installを実行してください。

## Carthage

Cartfileファイルに下記を追加してください。
```
github "hacocms/hacocms-ios-sdk"
```

## Swift Package Manager

Package.swiftファイルに下記を追加してください。

```swift
import PackageDescription

let package = Package(
    [...]
    dependencies: [
        .package(url: "https://github.com/hacocms/hacocms-ios-sdk.git", from: "1.0.0"),
    ]
)
```

# Step 3. 使い方

**クライアント対象の作成**
```swift
let client = HacoCmsClient(
    subDomain: SUB_DOMAIN, // Sub domain in project basic settings
    accessToken: ACCESS_TOKEN, // Access-Token for the project
    draftToken: PROJECT_DRAFT_TOKEN, // Optional: Project-Draft-Token for your project
    loggingRequest: true // Optional: Using for log for request
)
```

APIから返ってきた結果をmapingするために、 CodableからextendsされたObjectを作ります。

```swift
class HacoContent: Codable {
    let data: [Entry]
}

class Entry: Codable {
    let id: String
    let title: String
    let description: String
    let body: String
}
```

APIから返ってきた結果を処理するために、Closures もしくは Combineを通して処理します。


## Closuresの使用

```swift

// Get Content List
// returnType: Object is extended from Codable
// includingDraft: Retrieve the list of content that include draft articles
client.getListContent(returnType: HacoContent.self, path: "/entries") { result in
    switch result {
    case .success(let response):
        print(response.data)
    case .failure(let error):
        print(error)
    }
}

// Get Single Content
client.getSingleContent(returnType: User.self, path: "/user"){ result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error)
    }
}

// Get Detail Content
client.getDetailContent(returnType: Content.self, path: "/posts", contentId: "contentID", draftToken: "draft_token") { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error)
    }
}
```

## Combineの使用

```swift

// Get Content List
// returnType: Object is extended from Codable
// includingDraft: Retrieve the list of content that include draft articles
client.getListContent(returnType: HacoContent.self, path: "/entries", query: query, includingDraft: false)
    .convertToResult()
    .sink(receiveValue: { result in
        switch result {
        case .success(let response):
            print(response.data)
        case .failure(let error):
            print(error)
        }
    })
    .store(in: &subscriptions)


// Get Single Content
client.getSingleContent(returnType: User.self, path: "/user")
    .convertToResult()
    .sink(receiveValue: { result in
        switch result {
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
    })
    .store(in: &subscriptions)


// Get Detail Content
client.getDetailContent(returnType: Content.self, path: "/posts", contentId: "contentID", draftToken: "draft_token")
    .convertToResult()
    .sink(receiveValue: { result in
        switch result {
        case .success(let response):
            print(response)
        case .failure(let error):
            print(error)
        }
    })
    .store(in: &subscriptions)


```

# Parameters
APIリクエスト時に指定する必要があるパラメータを定義することもできます。

```swift
client.getListContent(returnType: ResponseData.self, path: "/posts", query: QueryBuilder(limit: 3, s: "-updatedAt")) { result in
    switch result {
    case .success(let response):
        print(response.data)
    case .failure(let error):
        print(error)
    }
}
```
[hacoCMS APIリファレンス](https://hacocms.com/references/content-api)

# LICENSE

MIT license
