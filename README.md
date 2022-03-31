# iOS

The Vizia iOS app is responsible for receiving the AI inference results from the server and performing speech synthesis and playback on it. The app is also capable of functioning without the glasses, as an image can also be taken from the iOS device's camera and sent to the server for processing. Playback controls are also made available, allowing the user to play/pause, restart, and speed up/slow down the audio transcription.

## Folders
* `FYDP Test App`: A small test application used during early development to try out image capture, on-device machine learning inference using Tesseract OCR, speech synthesis, and socket communication. All of these features were transferred to the final app once the UI/UX design was complete.
* `Vizia`: Code for the final Vizia app.

## Running the App
The only way to download and run the app is using [XCode](https://developer.apple.com/xcode/), software that is currently only available on a macOS device. To open the project in XCode:
```
open Vizia/Vizia.xcodeproj
```

The app can run in the simulator but will crash if you try to access the camera. You can switch it to access the photo library instead of the on-device camera in [ImagePicker.swift](Vizia/Vizia/Utils/ImagePicker.swift) by changing the `sourceType` to `.photoLibrary`:
```
// picker.sourceType = .camera;
picker.sourceType = .photoLibrary
```

It is best to run it on a physical iOS device and use the camera. Before running the app, ensure the server is running and update the [serverUrl](https://github.com/vizia-fydp/iOS/blob/4000ec35c28bfa1d76f5c0ea743417d9c471aa40/Vizia/Vizia/Views/HomeView.swift#L25) in [HomeView.swift](Vizia/Vizia/Views/HomeView.swift) if necessary.