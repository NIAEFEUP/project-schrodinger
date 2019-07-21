import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/HomePageModel.dart';
import 'package:app_feup/redux/Actions.dart';
import 'package:app_feup/view/widgets/ExamCard.dart';
import 'package:app_feup/view/widgets/GenericCard.dart';
import 'package:app_feup/view/widgets/ScheduleCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MainCardsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainCardsList();
}

class _MainCardsList extends State<MainCardsList> {

  bool editingMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: createScrollableCardView(context),
        floatingActionButton: this.editingMode ? createActionButton(context) : null,
    );
  }

  Widget createActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {}, //Add FAB functionality here
      tooltip: 'Add widget',
      child: Icon(Icons.add),
    );
  }

  Widget createScrollableCardView(BuildContext context) {
    return StoreConnector<AppState, List<FAVORITE_WIDGET_TYPE>>(
        converter: (store) => store.state.content['favoriteCards'],
        builder: (context, favoriteWidgets) {
          return Container(height: MediaQuery.of(context).size.height, margin: EdgeInsets.all(5.0),child:
          ReorderableListView(
            onReorder: (oldi, newi) => this.reorderCard(oldi, newi, favoriteWidgets),
            header: this.createTopBar(),
            children: this.createFavoriteWidgetsFromTypes(favoriteWidgets),
            //Cards go here
          ));
        }
    );
  }

  Widget createTopBar(){

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(
              'Favorites',
              style: Theme.of(context).textTheme.title.apply(fontSizeFactor: 1.3),
            ),
            GestureDetector(
                onTap: () => setState(() => editingMode = !editingMode),
                child: Text(
                  editingMode ? 'Exit editing' : 'Edit',
                  style: Theme.of(context).textTheme.subtitle.apply(decoration: TextDecoration.underline),
                )
            )
          ]),
    );
  }

  List<Widget> createFavoriteWidgetsFromTypes(List<FAVORITE_WIDGET_TYPE> cards) {
    List<Widget> result = List<Widget>();
    for(int i = 0; i < cards.length; i++) {
      result.add(this.createFavoriteWidgetFromType(cards[i], Key(i.toString())));
    }
    return result;
  }

  Widget createFavoriteWidgetFromType(FAVORITE_WIDGET_TYPE type, Key key){
    switch(type){
      case FAVORITE_WIDGET_TYPE.EXAMS:
        return this.createGenericCard("Exames", ExamCard(), key);
      case FAVORITE_WIDGET_TYPE.SCHEDULE:
        return this.createGenericCard("O teu Horário", ScheduleCard(), key);
    }
    return null;
  }

  Widget createGenericCard(String title, Widget child, Key key){
    return GenericCard(
        key: key,
        title: title,
        child: child,
        editingMode: this.editingMode,
        onDelete: (){}
    );
  }


  void reorderCard(int oldIndex, int newIndex, List<FAVORITE_WIDGET_TYPE> favorites) {
    FAVORITE_WIDGET_TYPE tmp = favorites[oldIndex];
    favorites.removeAt(oldIndex);
    favorites.insert(oldIndex < newIndex ? newIndex - 1 : newIndex, tmp);
    StoreProvider.of<AppState>(context).dispatch(new UpdateFavoriteCards(favorites));
  }
}