# Blusalt MNO Liveness Swift Package Library Integration Guide

## Overview
This guide will help you integrate the Blusalt MNO Liveness library into your SwiftUI project using Swift Package Manager (SPM). Blusalt MNO Liveness provides a collection of reusable SwiftUI components.

## Requirements
- Xcode 14.0 or later
- iOS 14.0+ / macOS 12.0+
- Swift 5+

## Features

#### Facial comparison (LivenessFacialComparisonType)
1. Dynamic Liveness Detection (Motional):
   This method verifies liveness by requiring the user to perform specific actions like opening their mouth or shaking their head.
   It's strict because attempts to bypass the action (like holding a still image) will be detected and likely terminate the process.
2. Static Liveness Detection (Still):
   This approach asks users to position their face within the camera frame and validates liveness based on facial data points.
   It's less strict than the dynamic method. If users struggle with finding the right camera position, the process might not automatically terminate, allowing them to adjust.
   
## Installation

### Using Xcode
1. Open your project in Xcode
2. Click on `File` → `Add Packages...`
3. In the search field of the Swift Package Manager window, paste the repository URL:
   ```
   https://github.com/Blusalt-FS/Blusalt_MNO_Liveness_Swift_Package
   ```
4. Select the version rule:
   - Exact Version: Choose a specific version
   - Up to Next Major Version: Automatically update to minor versions
   - Up to Next Minor Version: Automatically update to patch versions
5. Click `Add Package`
6. Select the target where you want to add the package
7. Click `Add Package` to finalize the installation

## Usage

1. Import the package in your SwiftUI view:
```swift
import MNO_Verification_Framework
import SwiftUI
```

2. Start using the components:
```swift
struct ContentView: View {
    @State private var clientId: String = ""
    @State private var appName: String = ""
    @State private var apiKey: String = ""
    @State private var isDev: Bool = true

  @State private var imageFile: Data? = nil

  @State private var resultText: String = "Awaiting Verification..."

  @State private var livenessResult: Data? = nil

  @State private var showImagePicker = false

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Configuration")) {
          TextField("Client ID", text: $clientId)
            .autocapitalization(.none)
          TextField("App Name", text: $appName)
            .autocapitalization(.none)
          TextField("API Key", text: $apiKey)
            .autocapitalization(.none)
          Toggle("Is Development Environment", isOn: $isDev)
        }

        if let livenessResult = livenessResult, let uiImage = UIImage(data: livenessResult) {
          Image(uiImage: uiImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .layoutPriority(1)

        } else {
          Text(
            "Your processed image will display here.\n You are required to pick an image containing your face so it can do comparison"
          )
          .multilineTextAlignment(.center)
          .foregroundColor(Color.black)
        }

        Section {

          Text("Start SDK")
            .frame(maxWidth: .infinity, alignment: .center)
            .foregroundColor(.blue).onTapGesture {
              showImagePicker.toggle()
            }

            .ignoresSafeArea(.all).sheet(isPresented: $showImagePicker) {
              CustomImagePicker {
                url in
                if url != nil {

                  // Pick image from gallery and pass to SDK
                  let data: Data? = try? Data(contentsOf: url!)
                  if let data = data {

                    //                      print("image picked")
                    //                      print(clientId)
                    imageFile = data

                    if let windowScene = UIApplication.shared.connectedScenes.first
                      as? UIWindowScene,
                      let viewController = windowScene.windows.first?.rootViewController
                    {

                      let flutterVerificationManager = FlutterVerificationManager.shared
                      flutterVerificationManager.startVerificationSDK(
                        viewController, clientId: clientId, appName: appName, apiKey: apiKey,
                        isDev: isDev, sourceImage: data,
                        livenessFacialComparisonType: .MOTIONAL,
                        startProcessOnGettingToFirstScreen: true,
                        showLivenessResult: true,
                        showScore: true,
                        showThreshold: true,
                        webhookUrl: "https://blusalt.net/webhookcalbacl",
                        reference: "reference",
                        onComplete: { jsonRawValue, verificationResponse in

                          if let base64 = verificationResponse.livenessSuccess?.faceDetectionData?
                            .livenessImage
                          {
                            livenessResult = Data(base64Encoded: base64)
                          }

                          //                          print("startFacialComparisonSDK Demo app is called and is successful")
                          //                          print(
                          //                            "\(String(describing: livenessSuccess.isProcedureValidationPassed))")

                        },
                        onFailure: { statusCode, errorText in

                          print(
                            "startFacialComparisonSDK Demo app is called and is failed: \(statusCode) \(errorText)"
                          )

                        })
                    }

                  }
                }
              }
            }
        }
      }

      Section(header: Text("Result")) {
        Text(resultText)
          .font(.footnote)
          .foregroundColor(.secondary)
      }
    }
    .navigationTitle("MNO Verification")
  }

}
```

## Troubleshooting

### Common Issues

1. **Package Loading Failed**
   - Verify your internet connection
   - Check if the repository URL is correct
   - Ensure you have access to the repository
   - Try File → Packages → Reset Package Caches

2. **Version Compatibility**
   - Verify the package supports your deployment target
   - Check the package's minimum required Xcode version

3. **Build Errors**
   - Clean the build folder (Shift + Command + K)
   - Clean the build cache and restart Xcode
   - Update to the latest package version

### Still Having Issues?
- Check our [Issues](https://github.com/Blusalt-FS/MNO_Verification_Swift_Package/issues) page
- Create a new issue with detailed reproduction steps
- Contact support at support@blusalt.net

## Contributing
We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
