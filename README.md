<img src="https://s3.amazonaws.com/aws-mobile-hub-images/aws-amplify-logo.png" alt="AWS Amplify" width="550" >

<p>
    <a href="https://discord.gg/jWVbPfC" target="_blank">
        <img src="https://img.shields.io/discord/308323056592486420?logo=discord"" alt="Discord Chat" />  
    </a>
</p>

## Amplify Flutter (Developer Preview)

AWS Amplify provides a declarative and easy-to-use interface across different categories of cloud operations. Our default implementation works with Amazon Web Services (AWS), but AWS Amplify is designed to be open and pluggable for any custom backend or service. See [AWS Amplify](https://docs.amplify.aws) for further details about the Amplify Framework.

⚠️ **Amplify for Flutter is in developer preview and not yet recommended for production.**

We are iterating and looking for feedback and collaboration, so please [**let us know your feedback**](https://github.com/aws-amplify/amplify-flutter/issues/5) on our direction and roadmap.

## Supported Amplify Categories

- [**Authentication**](https://docs.amplify.aws/lib/auth/getting-started/q/platform/flutter): APIs and building blocks to create user authentication experiences.
- [**Analytics**](https://docs.amplify.aws/lib/analytics/getting-started/q/platform/flutter): Collect analytics data for your app. Analytics data includes user sessions and other custom events that you want to track in your app.
- [**Storage**](https://docs.amplify.aws/lib/storage/getting-started/q/platform/flutter): Provides a simple mechanism for managing user content for your app in public, protected or private storage buckets.

### To Be Implemented

 - API (REST/GraphQL)
 - Predictions
 - Datastore
 - Hub Events (Listening to the Amplify events)
 - iOS Error Events in Amplify Analytics

> Amplify for Flutter is in preview, and is not recommended for production use at this time. During this phase, we are iterating on the code base, and looking for your feedback and collaboration. [**WE'D LOVE TO GET YOUR FEEDBACK! :-).**](https://github.com/aws-amplify/amplify-flutter/issues/5).

Amplify for Flutter currently supports **iOS** and **Android** platforms.

## Documentation

- [Getting Started with Amplify Flutter](https://docs.amplify.aws/start/getting-started/installation/q/integration/flutter)
- [Amplify Framework](https://docs.amplify.aws/)
- [Install the Amplify CLI](https://docs.amplify.aws/cli/start/install)
- [Contributing to Amplify Flutter](CONTRIBUTING.md)

## Flutter Development Guide

Amplify for Flutter is an open-source project and welcomes contributions from the Flutter community, see [Contributing](CONTRIBUTING.md).

#### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Amplify CLI](https://docs.amplify.aws/cli/start/install)

#### Getting Started with Flutter app development and Amplify

* Clone this repository
* Install Amplify in a Flutter project
* Add basic Amplify functionality to your project using one of the supported categories

1. ```git clone git@github.com:aws-amplify/amplify-flutter.git```

2. Open your Flutter project. If you do not have an active Flutter project, you can create one after installing the [Flutter development tooling](https://flutter.dev/docs/get-started/install) and running `flutter create <project-name>` in your terminal.

3. Using the Amplify CLI, run `amplify init` from the root of your project:

See [Amplify CLI Installation](https://github.com/aws-amplify/amplify-cli#install-the-cli)

```bash
==> amplify init
Note: It is recommended to run this command from the root of your app directory
? Enter a name for the project helloAmplify
? Enter a name for the environment dev
? Choose your default editor: Visual Studio Code
? Choose the type of app that you\'re building flutter
Please tell us about your project
⚠️  Flutter project support in the Amplify CLI is in DEVELOPER PREVIEW status.
Only the following resource types are supported:
 * Auth
 * Analytics
 * Storage
? Where do you want to store your configuration file? ./lib/
```

4. Add Amplify categories (choose defaults for this example):

    ```bash
    $ amplify add auth
    $ amplify add analytics
    ```

5. In your pubspec.yaml file, add the following to `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  amplify_core:
    path: /{path to your local amplify-flutter}/amplify-flutter/packages/amplify_core 
  amplify_analytics_pinpoint:
    path: /{path to your local amplify-flutter}/amplify-flutter/packages/amplify_analytics_pinpoint
  amplify_auth_cognito:
    path: /{path to your local amplify-flutter}/amplify-flutter/packages/amplify_auth_cognito
```

6. From the terminal run

```bash
flutter pub get
```

7. In your main.dart file, add:

```dart
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  // Instantiate Amplify
  Amplify amplifyInstance = new Amplify();

  @override
  void initState() {
    super.initState();
  }

  void _configureAmplify() async {
    if (!mounted) return;

    // Add Pinpoint and Cognito Plugins
    AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
    amplifyInstance.addPlugin(authPlugins: [authPlugin]);
    amplifyInstance.addPlugin(analyticsPlugins: [analyticsPlugin]);

    // Once Plugins are added, configure Amplify
    await amplifyInstance.configure(amplifyconfig);
    try {
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }

  }

  // Send an event to Pinpoint
  void _recordEvent() async {
    AnalyticsEvent event = AnalyticsEvent("test");
    event.properties.addBoolProperty("boolKey", true);
    event.properties.addDoubleProperty("doubleKey", 10.0);
    event.properties.addIntProperty("intKey", 10);
    event.properties.addStringProperty("stringKey", "stringValue");
    Amplify.Analytics.recordEvent(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Amplify Core example app'),
          ),
          body: ListView(padding: EdgeInsets.all(10.0), children: <Widget>[
            Center( 
              child: Column (
                children: [
                  const Padding(padding: EdgeInsets.all(5.0)),
                  RaisedButton(
                    onPressed: _amplifyConfigured ? null : _configureAmplify,
                    child: const Text('configure Amplify')
                  ),
                  RaisedButton(
                    onPressed: _amplifyConfigured ? _recordEvent : null,
                    child: const Text('record event')
                  )
                ]
              ),
            )
          ])
      )
    );
  }
}
```

For iOS builds complete the following steps (from the root of your project):

- `rm ios/Podfile`
- `flutter build ios`
- Modify the `ios/Podfile` and replace the second line with: `platform :ios, '11.0'`.

This ensures that your Flutter project is running the same ios version that the Amplify plugins are built on.

8. From the root of your project, execute `flutter run` in the terminal.

> Make sure that an Android or iOS device is already running; this can be a virtual device started from Android Studio.

Click **Configure Amplify**, then **Record Event**. From the terminal (in the root of your project) run `amplify console analytics`. This will open the Amazon Pinpoint console for your project in your default web browser. Within about a minute you should start seeing the events populating in the Events section of then Pinpoint console. 

For further documentation and Amplify Category API usage, see the [documentation](https://docs.amplify.aws/lib/q/platform/js).

---

Flutter and the related logo are trademarks of Google LLC. We are not endorsed by or affiliated with Google LLC.
