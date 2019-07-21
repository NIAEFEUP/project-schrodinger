import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/CourseUnit.dart';
import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/model/entities/Lecture.dart';
import 'package:app_feup/model/entities/Profile.dart';
import 'package:app_feup/model/entities/Session.dart';
import 'package:app_feup/model/HomePageModel.dart';

class SaveLoginDataAction {
  Session session;
  SaveLoginDataAction(this.session);
}

class SetLoginStatusAction {
  RequestStatus status;
  SetLoginStatusAction(this.status);
}

class SetExamsAction{
  List<Exam> exams;
  SetExamsAction(this.exams);
}

class SetExamsStatusAction{
  RequestStatus status;
  SetExamsStatusAction(this.status);
}

class SetScheduleAction{
  List<Lecture> lectures;
  SetScheduleAction(this.lectures);
}

class SetScheduleStatusAction{
  RequestStatus status;
  SetScheduleStatusAction(this.status);
}

class UpdateSelectedPageAction {
  String selected_page;
  UpdateSelectedPageAction(this.selected_page);
}

class SaveProfileAction {
  Profile profile;
  SaveProfileAction(this.profile);
}

class SaveUcsAction {
  List<CourseUnit> ucs;
  SaveUcsAction(this.ucs);
}

class SetPrintBalanceAction {
  String printBalance;
  SetPrintBalanceAction(this.printBalance);
}

class SetFeesBalanceAction {
  String feesBalance;
  SetFeesBalanceAction(this.feesBalance);
}

class SetFeesLimitAction{
  String feesLimit;
  SetFeesLimitAction(this.feesLimit);
}

class SetCoursesStatesAction{
  Map<String, String> coursesStates;
  SetCoursesStatesAction(this.coursesStates);
}
class UpdateFavoriteCards {
  List<FAVORITE_WIDGET_TYPE> favoriteCards;
  UpdateFavoriteCards(this.favoriteCards);
}