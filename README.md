DGDialogAnimator
================

[![Swift Version](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Build Status](https://travis-ci.org/Digipolitan/dialog-animator-swift.svg?branch=master)](https://travis-ci.org/Digipolitan/dialog-animator-swift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DGDialogAnimator.svg)](https://img.shields.io/cocoapods/v/DGDialogAnimator.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/DGDialogAnimator.svg?style=flat)](http://cocoadocs.org/docsets/DGDialogAnimator.svg)
[![Twitter](https://img.shields.io/badge/twitter-@Digipolitan-blue.svg?style=flat)](http://twitter.com/Digipolitan)

`DGDialogAnimator` is a manager allowing you to quickly display **Dialogs** like **Toasts**, **Alerts** or even **Modal Form**, with only few lines of codes.

![Capture](https://github.com/Digipolitan/dialog-animator/blob/master/Screenshots/capture.gif?raw=true "Capture")

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

- Select the view to animate, its container, where the animation will start and where it will go.

```swift

let toast = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds/2, height: 100))    
DGDialogAnimator.default.animate(view: toast,
                                   in: self.view,
                                 path: DGDialogAnimator.AnimationPath(initial: .top, intermediate: .top))

let notification = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds, height: 250))    
DGDialogAnimator.default.animate(view: notification,
                                   in: self.view,
                                 path: DGDialogAnimator.AnimationPath(initial: [.top, .left], intermediate: [.top, .right]))
```

### Configuration

You can customize the component by enabling few options:

```swift
var options = DGDialogAnimator.Options()
options.hold = false
options.dismissDelay = 5
options.backdrop = false
options.blurEffectStyle = nil
// ....
DGDialogAnimator.default.animate(view: toast,
                                   in: self.view,
                                 with: options,
                                 path: DGDialogAnimator.AnimationPath(initial: .top, intermediate: .top))

```

Here the list of all available options :

| Property | type | Description  |
| --- | --- | --- |
| backdrop | `Bool` | Tells if the background behind the animated view will dismiss the view on touch |
| blurEffectStyle | `UIBlurEffectStyle` | The blur effect added to the background. 3 values are available `.light` `.extraLight` `.dark` |
| coverStatusBar | `Bool` | if set to `true` you must **NOT** set the container because the component will use automatically `UIWindow`. |
| animationDuration | `TimeInterval` | How long the animation will last. |
| dismissDelay | `TimeInterval` | How long the animated view will hold before dismissing itself |
| enterAnimationCurve | `UIViewAnimationCurve` | Let you configure the animation curve when the view comes in the container |
| leaveAnimationCurve | `UIViewAnimationCurve` | Let you configure the animation curve when the view leaves in the container |
| hold | `Bool` | The view won't dismiss after `dismissDelay`. It will wait a call to the `dismiss()` method |

## Built With

[Fastlane](https://fastlane.tools/)
Fastlane is a tool for iOS, Mac, and Android developers to automate tedious tasks like generating screenshots, dealing with provisioning profiles, and releasing your application.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details!

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report
unacceptable behavior to [contact@digipolitan.com](mailto:contact@digipolitan.com).

## License

DGDialogAnimator is licensed under the [BSD 3-Clause license](LICENSE).
