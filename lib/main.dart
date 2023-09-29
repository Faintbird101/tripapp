import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/amplifyconfiguration.dart';
import 'package:trip_planner/models/ModelProvider.dart';
import 'package:trip_planner/trip.planner.app.dart';
import 'package:amplify_api/amplify_api.dart';

import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify configuration failed.');
  }
  runApp(
    const ProviderScope(
      child: TripsPlannerApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  try {
    if (!Amplify.isConfigured)
    // final amplifyAuthCognito = AmplifyAuthCognito();
    {
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyAPI(modelProvider: ModelProvider.instance),
        AmplifyStorageS3(),
      ]);
      log('Amplify plugins loading!!');

      //configure Amplify
      await Amplify.configure(amplifyconfig);
      log('Amplify configured successfully');
    }
  } catch (e) {
    log('An error occurred while configuring Amplify: $e');
  }
}
