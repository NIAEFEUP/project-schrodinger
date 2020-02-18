import 'package:app_feup/controller/LoadInfo.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/view/Pages/HomePageView.dart';
import 'package:app_feup/view/Pages/LoginPageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../view/Theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startTimeAndChangeRoute();
  }

  MediaQueryData queryData;

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return new Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: applicationTheme.backgroundColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: queryData.size.height / 4)),
              createTitle(),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                      padding:
                          EdgeInsets.only(bottom: queryData.size.height / 16)),
                  createNILogo(),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: queryData.size.height / 6))
            ],
          )
        ],
      ),
    );
  }

  Widget createTitle() {
    return new ConstrainedBox(
        constraints: new BoxConstraints(
          minWidth: queryData.size.width / 8,
          minHeight: queryData.size.height / 6,
        ),
        child: SizedBox(
            child: SvgPicture.asset(
              'assets/images/logo_dark.svg',
              color: Theme.of(context).primaryColor,
            ),
            width: 150.0));
  }

  Widget createNILogo() {
    return SvgPicture.asset(
      'assets/images/by_niaefeup.svg',
      color: Theme.of(context).primaryColor,
      width: queryData.size.width * 0.45,
    );
  }

  void startTimeAndChangeRoute() async {
    Route<Object> nextRoute;

    try {
      nextRoute =
        new MaterialPageRoute(builder: (context) => new HomePageView());
      await loadReloginInfo(StoreProvider.of<AppState>(context));
    }
    catch(e) {
      if(!(e is RequestStatus))
        nextRoute = new MaterialPageRoute(builder: (context) => new LoginPageView());
    }

    Navigator.pushReplacement(context, nextRoute);
  }
}
