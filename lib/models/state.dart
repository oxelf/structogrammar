import 'package:equatable/equatable.dart';


class AppState extends Equatable {
String selectedStruct = "";

AppState({this.selectedStruct = ""});

@override
List<Object> get props => [selectedStruct];
}