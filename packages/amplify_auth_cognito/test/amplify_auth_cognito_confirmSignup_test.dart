/*
 * Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';

void main() {
  const MethodChannel authChannel = MethodChannel('com.amazonaws.amplify/auth_cognito');
  const MethodChannel coreChannel = MethodChannel('com.amazonaws.amplify/core');

  Amplify amplify = new Amplify();
  AmplifyAuthCognito auth = AmplifyAuthCognito();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    authChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == "confirmSignUp") {
        return {
          "isSignUpComplete": false,
          "nextStep": {
            "signUpStep": "DONE",
            "codeDeliveryDetails":  { "atttibuteName": "email" }
          }
        };
      } else {
        return true;
      }     
    });
    coreChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    authChannel.setMockMethodCallHandler(null);
    coreChannel.setMockMethodCallHandler(null);
  });

  test('signUp request returns a ConfirmSignUpResult', () async {
    await amplify.addPlugin(authPlugins: [auth]);
    await amplify.configure("{}");
    expect(await Amplify.Auth.confirmSignUp(username: 'testUser',
      confirmationCode: '123'), isInstanceOf<SignUpResult>());
  });
}
