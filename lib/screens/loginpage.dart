import 'package:firebase_app/helpers/fcm_helper.dart';
import 'package:firebase_app/helpers/firebase_auth_helper.dart';
import 'package:firebase_app/helpers/logic_notification_heper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final GlobalKey<FormState> insertSignupKey = GlobalKey<FormState>();
  final GlobalKey<FormState> SignInKey = GlobalKey<FormState>();

  final TextEditingController SignIn_emailController = TextEditingController();
  final TextEditingController SignIn_passwordController =
      TextEditingController();

  final TextEditingController SignUp_emailController = TextEditingController();
  final TextEditingController SignUp_passwordController =
      TextEditingController();

  String? email;
  String? password;

  /// Internet Connectivity ...
  // String status = "waiting...";
  // Connectivity _connectivity = Connectivity();
  //
  // late StreamSubscription _streamSubscription;
  //
  // void checkConnectivity() async {
  //   var connectionResult = await _connectivity.checkConnectivity();
  //
  //   if (connectionResult == ConnectivityResult.mobile) {
  //     status = "MobileData";
  //   } else if (connectionResult == ConnectivityResult.wifi) {
  //     status = "WIFI";
  //   } else {
  //     status = "Not Connected";
  //   }
  //   setState(() {});
  // }
  //
  // void checkRealtimeConnection() {
  //   _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
  //     if (event == ConnectivityResult.mobile) {
  //       status = "MobileData";
  //     } else if (event == ConnectivityResult.wifi) {
  //       status = "Wifi";
  //     } else {
  //       status = "Not Connected";
  //     }
  //     setState(() {});
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _streamSubscription.cancel();
  // }

  /// Notification Initialization Process ...

  // @override
  // void initState() {
  //   super.initState();
  //   //// Compulsory initalization this method
  //   WidgetsBinding.instance.addObserver(this);
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance.removeObserver(this);
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print("===============================");
  //   print("Current State: $state");
  //   print("===============================");
  //
  //   if (state == AppLifecycleState.paused) {
  //     print("************************");
  //     print("FETCH API");
  //     print("************************");
  //   } else if (state == AppLifecycleState.resumed) {
  //     print("************************");
  //     print("Welcome back");
  //     print("************************");
  //   } else if (state == AppLifecycleState.detached) {
  //     print("************************");
  //     print("STORE DATA INTO DB");
  //     print("************************");
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  /// Fetch tokens
  fetchtoken() async {
    String? token = await FCMHelper.fcmHelper.fetchFCMToken();

    print("=========================");
    print(token);
    print("=========================");
  }

  /// Notification show in our Ui ....

  @override
  void initState() {
    super.initState();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings();

    InitializationSettings initializationsettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    LocalNotificationHelper.flutterLocalNotificationsPlugin
        .initialize(initializationsettings,
            onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("======================");
      print(response.payload);
      print("======================");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/login.png",
              scale: 14,
              color: Colors.yellow,
            ),
            const SizedBox(width: 10),
            const Text(
              "Login Page",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(height: 15),
          const Spacer(flex: 3),
          const Text(
            "Login Buttons",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.w400,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: () async {
              //checkConnectivity();
              User? user = await FirebaseAuthHelper.firebaseAuthHelper
                  .signInAnonymously();

              if (user != null) {
                //Globals.user = user;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Login Successful\nUID:${user.uid},"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Navigator.of(context)
                    .pushReplacementNamed('/', arguments: user);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Login failed"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: SizedBox(
              width: 150,
              child: Row(
                children: const [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Anonymous",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: validatorandinsertSignUp,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 18),
                ),
              ),
              ElevatedButton(
                // onPressed: () {
                //   validatorandSignIn();
                // },
                onPressed: validatorandSignIn,
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 18),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              User? user = await FirebaseAuthHelper.firebaseAuthHelper
                  .signInWithGoogle();

              if (user != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Login Successful\nUID: ${user.uid}"),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context)
                    .pushReplacementNamed('/', arguments: user);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Login failed ..."),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: SizedBox(
              width: 170,
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/google.png",
                    scale: 20,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Sign with google",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            "Notification Buttons",
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.w400,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: () async {
              await LocalNotificationHelper.localNotificationHelper
                  .sendSimpleNotification();
            },
            child: const Text(
              "Simple Notification",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 17),
            ),
            //style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await LocalNotificationHelper
                        .localNotificationHelper.sendBigPictureNotification;
                  },
                  child: const Text(
                    "Big Notification",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 17),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await LocalNotificationHelper
                        .localNotificationHelper.sendMediaNotification;
                  },
                  child: const Text(
                    "Media Notification",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 17),
                  )),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                await LocalNotificationHelper.localNotificationHelper
                    .sendScheduleNotification();
              },
              child: const Text(
                "Schedule Notification",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 17),
              )),

          const Spacer(flex: 7),
        ],
      ),
    );
  }

  validatorandinsertSignUp() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Container(
                  alignment: const Alignment(0, 0),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  )),
              content: Form(
                key: insertSignupKey,
                child: Container(
                  height: 200,
                  width: 200,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        controller: SignIn_emailController,
                        validator: (val) =>
                            (val!.isEmpty) ? "Enter email first..." : null,
                        // email = val;
                        // if (val!.isEmpty) {
                        //   return "Enter email first ...";
                        // }
                        // return null;

                        onSaved: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          label: Text("Email"),
                          hintText: "Enter email first ...",
                          //errorText: "Enter email first ...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: SignIn_passwordController,
                        obscureText: true,
                        validator: (val) =>
                            (val!.isEmpty) ? "Enter password first..." : null,
                        onSaved: (val) {
                          password = val;
                        },
                        decoration: const InputDecoration(
                          label: Text("Password"),
                          hintText: "Enter password first ...",
                          //errorText: "Enter pswd first ...",
                          border: OutlineInputBorder(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (insertSignupKey.currentState!.validate()) {
                      insertSignupKey.currentState!.save();

                      User? user = await FirebaseAuthHelper.firebaseAuthHelper
                          .signUpUser(email: email!, password: password!);

                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Sign Up Successful\n UID:${user.uid}"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                        //Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushReplacementNamed('/', arguments: user);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Sign Up failed"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }

                      // print("==================================");
                      // print("Email");
                      // print("===================================");
                      // print("password");

                      SignIn_emailController.clear();
                      SignIn_passwordController.clear();
                      setState(() {
                        email = "";
                        password = "";
                      });
                    }
                    //Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 14),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    SignIn_emailController.clear();
                    SignIn_passwordController.clear();
                    setState(() {
                      email = "";
                      password = "";
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  validatorandSignIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
            alignment: const Alignment(0, 0),
            child: const Text(
              "Sign In",
              style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.w300,
                  fontSize: 18),
            )),
        content: Form(
          key: SignInKey,
          child: Container(
            height: 200,
            width: 200,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  controller: SignIn_emailController,
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter email first..." : null,
                  onSaved: (val) {
                    //email = val;
                    setState(() {
                      email = val;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    hintText: "Enter email first ...",
                    //errorText: "Enter email first ...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: SignIn_passwordController,
                  obscureText: true,
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter password first..." : null,
                  onSaved: (val) {
                    password = val;
                  },
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    hintText: "Enter password first ...",
                    //errorText: "Enter pswd first ...",
                    border: OutlineInputBorder(),
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (SignInKey.currentState!.validate()) {
                SignInKey.currentState!.save();

                User? user = await FirebaseAuthHelper.firebaseAuthHelper
                    .signInUser(email: email!, password: password!);

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign In Successful\n UID:${user.uid}"),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                  //Navigator.of(context).pop();

                  Navigator.of(context)
                      .pushReplacementNamed('/', arguments: user);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sign In failed"),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  // Navigator.of(context).pop();
                }

                SignIn_emailController.clear();
                SignIn_passwordController.clear();
                setState(() {
                  email = "";
                  password = "";
                });
              }
              // Navigator.of(context).pop();
            },
            child: const Text(
              "Sign In",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 14),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              SignIn_emailController.clear();
              SignIn_passwordController.clear();
              setState(() {
                email = "";
                password = "";
              });
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }
}
