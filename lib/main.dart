import 'dart:async';

import 'package:emgage_flutter/src/Localization/LocaleString.dart';
import 'package:emgage_flutter/src/commonWidgets/phone_theme.dart';
import 'dart:io';

import 'package:emgage_flutter/src/features/splash/splash_screen.dart';
import 'package:emgage_flutter/src/homescreenwidgets/Widgetspunchin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:in_app_update/in_app_update.dart';

// import 'package:upgrader/upgrader.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<bool> checkLocationPermission() async {
  if (await Geolocator.checkPermission() == LocationPermission.denied) {
    return false;
  } else {
    return true;
  }
}

Future<Position?> getLoaction() async {
  if (!await Geolocator.isLocationServiceEnabled()) {
    return null;
  } else {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

Map<String, String> latLong = {};

// @pragma('vm:entry-point')
// callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     DartPluginRegistrant.ensureInitialized();
//     try {
//       if (await checkLocationPermission()) {
//         Position? position = await getLoaction();
//         if (position != null) {
//           latLong["name"] = position.latitude.toString();
//           latLong["price"] = position.longitude.toString();
//           latLong["description"] = DateTime.now().toString();
//           // latLong["latitude"] = position.latitude;
//           // latLong["longitude"] = position.longitude;
//           print(position.latitude.toString());
//
//           da.FormData bodydata = da.FormData.fromMap(latLong);
//
//           var data = await da.Dio().postUri(
//               Uri.parse(
//                   "http://192.168.43.184/android_connect/create_product.php"),
//               data: bodydata);
//           print(data);
//         }
//       }
//     } catch (e) {
//       print(e);
//     }
//     return await Future.value(true);
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager().registerOneOffTask("uniquename", "taskName");
  // Workmanager().registerPeriodicTask("uniqueName", "Location",
  //     inputData: latLong, frequency: const Duration(minutes: 15));
  HomeWidget.registerBackgroundCallback(Widgetspunchin.puchincallback);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  AppUpdateInfo? _updateInfo;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    checkForUpdate();
    imideateUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Emgage Attendance',
      theme: PhoneTheme.theme(),
      home: imideateUpdate(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      translations: LocaleString(),
    );
  }

  // getScreen() {
  //   try{
  //     if(Platform.isIOS || Platform.isAndroid){
  //       return UpgradeAlert(
  //         upgrader: Upgrader(
  //             dialogStyle: Platform.isIOS
  //                 ? UpgradeDialogStyle.cupertino
  //                 : UpgradeDialogStyle.material),
  //         child: splash_screen(),
  //       );
  //     }
  //   }catch(Exception){
  //
  //   }
  //   return splash_screen();
  //
  //
  // }

  imideateUpdate() {
    try {
      _updateInfo?.updateAvailability == UpdateAvailability.updateAvailable
          ? InAppUpdate.performImmediateUpdate()
              .catchError((e) => showSnack(e.toString()))
          : null;
    } catch (exception) {}
    return const SplashScreen();
  }
}
