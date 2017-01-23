DGDialogAnimator
================

[![Build Status](https://travis-ci.org/Digipolitan/collection-view-grid-layout-swift.svg?branch=master)](https://travis-ci.org/Digipolitan/dialog-animator)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DGDialogAnimator.svg)](https://img.shields.io/cocoapods/v/DGDialogAnimator.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/DGDialogAnimator.svg?style=flat)](http://cocoadocs.org/docsets/DGDialogAnimator.svg)
[![Twitter](https://img.shields.io/badge/twitter-@Digipolitan-blue.svg?style=flat)](http://twitter.com/Digipolitan)


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Works with iOS 8+, tested on Xcode 8.2

### Installing

To install the DGDialogAnimator using **cocoapods**

- Add an entry in your Podfile  

```
# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

target 'YourTarget' do
  frameworks
   use_frameworks!

  # Pods for YourTarget
  pod 'DGDialogAnimator'
end
```

- Then install the dependency with the `pod install` command.

## Usage

- Select the view to animate, select the container, where the view will start the animation, where it will go.

```swift

let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))    
DGDialogAnimator.default.animate(view: toast, in: self.view, with: nil, from: .top, to: .top)
```

### Configuration

You can customize the component by enabling few options:

```swift
var options = DGDialogAnimator.Options()
options.waiting = false
options.hold = 5
options.backDrop = false
options.blurEffect = nil
// ....
DGDialogAnimator.default.animate(view: toast, in: self.view, with: options, from: .top, to: .top)

```

Here the list of all available options :

| Property | type | Description  |
| --- | --- | --- |
| backdrop | `Bool` | Tells if the background behind the animated view will dismiss the view on touch |
| blurEffect | `UIBlurEffectStyle?` | The blur effect added to the background. 3 values are available `.light` `.extraLight` `.dark` |
| coverStatusBar | `Bool` | if set to `true` you must **NOT** set the container because the component will use automatically `UIWindow`. |
| duration | `TimeInterval` | How long the animation will last. |
| hold | `TimeInterval` | How long the animated view will hold before dismissing itself |
| enterAnimationOptions | `UIViewAnimationOptions` | Let you configure the animation options when the view comes in the container |
| leaveAnimationOptions | `UIViewAnimationOptions` | Let you configure the animation options when the view leaves in the container |
| waiting | `Bool` | The view won't dismiss after `hold` delay. It will wait a call to the `dismiss()` method |
| blurIntensity | `CGFloat` | Modify the alpha of the background. Kind of buggy, but the last option available to limit the intensity of the blur. |

## Built With

[Fastlane](https://fastlane.tools/)
Fastlane is a tool for iOS, Mac, and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details!

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report
unacceptable behavior to [contact@digipolitan.com](mailto:contact@digipolitan.com).

## License

DGCollectionGridViewLayout is licensed under the [BSD 3-Clause license](LICENSE).

