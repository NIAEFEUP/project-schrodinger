import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../widgets/NavigationDrawer.dart';

class ExamsPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreProvider.of<AppState>(context)
        .dispatch(updateSelectedPage(NavigationDrawerState.drawerItems[4]));
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(StoreProvider.of<AppState>(context)
              .state
              .content["selected_page"])),
      drawer: new NavigationDrawer(),
      body: Center(
        child: Text("Exames"),
      ),
    );
  }
}
