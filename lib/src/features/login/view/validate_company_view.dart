import 'package:emgage_flutter/src/constants/login/login_constants.dart';
import 'package:emgage_flutter/src/features/login/view/employee_signin.dart';
import 'package:emgage_flutter/src/features/login/view/widgets/bottom_bar.dart';
import 'package:emgage_flutter/src/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../../../commonWidgets/common_widgets.dart';
import '../../../constants/image_path.dart';
import '../../../utils/forground_task_handler.dart';
import '../bloc/login_bloc.dart';

class ValidateCompanyView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  LoginBloc loginBloc = LoginBloc();
  ValidateCompanyView({super.key});

  @override
  Widget build(BuildContext context) {
    _initForegroundTask();
    return Scaffold(
      body: BlocProvider(
        create: (context) => loginBloc,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is ValidateCompanyState) {
              CommonFunction.pageRouteOrReplace(context, EmployeeSignin());
            }
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    children: [
                      Card(
                        margin: const EdgeInsets.only(right: 5, left: 5),
                        elevation: 1,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Image.asset(ImagePath.companyLogo),
                              const SizedBox(
                                height: 30,
                              ),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                  controller: _companyNameController,
                                  decoration: CommonWidgets.inputBoxDecoration(
                                      LoginConstants.companyNameLabel),
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return LoginConstants
                                          .validateCompanyErrorMessage;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: CommonWidgets.loginButtonStyle(),
                                  onPressed: () async {
                                    // startCallback();
                                    // await _startForegroundTask();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      loginBloc.add(SubmitDataEvent(context,
                                          _companyNameController.text));
                                    }
                                  },
                                  child:
                                      const Text(LoginConstants.submitLabel)),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                color: Colors.black38,
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child:
                                      Image.asset(ImagePath.powerByEmgageLogo)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomBar.bottomInfo(),
            ],
          ),
        ),
      ),
    );
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        // iconData: const NotificationIconData(
        //   resType: ResourceType.mipmap,
        //   resPrefix: ResourcePrefix.ic,
        //   name: 'launcher',
        // ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    // You can save data using the saveData function.
    // await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
    //
    // // Register the receivePort before starting the service.
    // final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    // final bool isRegistered = _registerReceivePort(receivePort);
    // if (!isRegistered) {
    //   print('Failed to register receivePort!');
    //   return false;
    // }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }
}
