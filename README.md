# AirSearchBar

![Static Badge](https://img.shields.io/badge/license-MIT-lightgray)
![Static Badge](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Static Badge](https://img.shields.io/badge/SPM-compatible-brightgreen)
![SwiftUI](https://img.shields.io/badge/SwiftUI--orange)

![AirSearchBar_Project Banner_Github](https://github.com/airappsco/AirSearchBar/assets/107951300/e91864f8-e737-4b89-a850-6f8ad56e1687)

## 📋 Requirements

- iOS 12.0+ (if you use only UIKit/AppKit)
- iOS 15.0+ (if you use it in SwiftUI)
- Swift 5.0+

> | UIKit | SwiftUI | AirSearchBar |
> |---|---|---|
> | iOS 12+ | iOS 13+ | `feature/ios-12-support` |
> | iOS 15+ | iOS 15+ | ~> 1.0.0 |


## 🌟 Features
- Swift Package Manager support 📦

## 🔧 Installation
AirSearchBar is distributed via **Swift Package Manager** 📦. 

To install AirSearchBar, please add the following line to the `dependencies:` section in your `Package.swift` file:

```swift
.package(url: "https://github.com/airappsco/AirSearchBar.git", .upToNextMinor(from: "1.0.0")),
```

## 🚀 Usage

Import module in the file which will be used in
```swift
import AirSearchBar
```

Initialize the AirSearchBar with the needed parameters
```swift
    let airSearchBarViewModel = AirSearchBarViewModel(
        initialDataSource: ["Nebulizer", "Nebulize", "Nebulous", "Nebula"]
    )

    AirSearchBar(
        style: .init(placeholder: "Search..."), 
        isSearching: $isSearching,
        viewModel: airSearchBarViewModel
    )
```

To update the dataSource from view model do the following:
```swift
    .onReceive(airSearchBarViewModel.didSearchKeywordSubject, perform: { keyword in
        if keyword.isEmpty == false {
            airSearchBarViewModel.update(dataSource: ["Star Wars"])
            print("didSearchKeywordPublisher: \(keyword)")
        }
    })
```

To handle the search when finished do the following: 
```swift
    .onReceive(airSearchBarViewModel.didFinishSearchKeywordSubject, perform: { keyword in
        print("didFinishSearchKeywordPublisher: \(keyword)")
    })
```

To handle analytics do the following: 
```swift
    .onReceive(airSearchBarViewModel.analyticsSubject, perform: { event in
        print(event)
    })
```

You can also check the **[Example project](./AirSearchBarDemo)** for usage.

## Validation

This framework has been validated and tested through integration into our app [Translate Now](https://apps.apple.com/us/app/translate-now-translator/id1348028646).

## Contributing to Air Apps
Want to contribute to **Air Apps**? Please refer to the following guide [here](./CONTRIBUTING.md).

## About Air Apps

Air Apps is a leading mobile application publisher dedicated to creating practical solutions for everyday challenges. With a portfolio of over 30 mobile applications spanning Fitness, Productivity, Creative, and Learning, we aim to simplify lives. Our unique approach includes a fully remote work environment, allowing our diverse team to collaborate from around the world. As an AI-first company, we stay up-to-date with technology trends, integrating them into our products to enhance user experiences. Our ongoing mission is to provide value to both our users and our team, fostering continuous improvement and a commitment to making life easier.

Learn more about us in the following links:

**Website:** [airapps.co](https://airapps.co/)  
**Our Apps:** [View on App Store](https://apps.apple.com/us/developer/wzp-solutions-lda/id1316153435)  
**Careers:** [airapps.co/careers](https://airapps.co/careers/)  
**Linkedin:** [linkedin.com/company/airapps](http://linkedin.com/company/airapps/)  
**Blog:** [blog.airapps.co](https://blog.airapps.co/)  
**Instagram:** [@airappsco](https://www.instagram.com/airappsco/)  
**Twitter:** [@airappsco](https://twitter.com/airappsco/)  
**Facebook:** [facebook.com/airappsco](https://www.facebook.com/airappsco/)  
**Youtube:** [Youtube @airapps](https://www.youtube.com/@airapps)

## License
MIT License

Copyright (c) 2023  Air Apps (Air Apps, Inc. and Affiliates)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
