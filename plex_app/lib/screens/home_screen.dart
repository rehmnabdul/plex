import 'package:flutter/material.dart';
import 'package:plex_package/plex_screens/plex_screen.dart';
import 'package:plex_package/plex_utils/plex_dimensions.dart';
import 'package:plex_package/plex_widgets/plex_date_picker_widget.dart';
import 'package:plex_package/plex_widgets/plex_form.dart';

class MyUser extends PlexForm {
  String firstName;
  String? lastName;
  int age;
  DateTime dob;
  bool male;
  dynamic object;

  MyUser(this.firstName, this.lastName, this.age, this.dob, this.male, this.object);

  @override
  String toString() {
    return 'MyUser{firstName: $firstName, lastName: $lastName, age: $age, dob: $dob, male: $male, object: $object}';
  }

  @override
  List<PlexField> getFields() {
    return [
      PlexField.input(title: "firstName", initialVaue: firstName, type: String, onChange: (value) => firstName = value ?? ""),
      PlexField.input(title: "lastName", initialVaue: lastName, type: String, onChange: (value) => lastName = value ?? ""),
      PlexField.input(title: "age", initialVaue: age, type: int, onChange: (value) => age = value ?? 0),
      PlexField.input(title: "dob", initialVaue: dob, type: DateTime, onChange: (value) => dob = value ?? DateTime.now()),
      PlexField.input(title: "male", initialVaue: male, type: bool, onChange: (value) => male = value),
      PlexField.dropDown(
          title: "objects",
          initialVaue: object,
          onChange: (value) => object = value,
          itemAsString: (item) {
            return item.toString();
          },
          dropDownItems: ["Pak", "Ind", "Eng"]),
      PlexField.dropDown(
          title: "Data",
          initialVaue: "koko",
          onChange: (value) {},
          itemAsString: (item) {
            return item.toString();
          },
          dropDownItems: ["Pak", "Ind", "Eng"]),
    ];
  }
}

class HomeScreen extends PlexScreen {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  PlexState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends PlexState<HomeScreen> {
  @override
  AppBar? buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: Dim.medium,
      title: const Text("Home", style: TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  @override
  Widget buildBody() {
    var myUser = MyUser("Abdur", "Rahman", 5, DateTime.now(), true, "Pak");
    print(myUser.toString());

    return Column(children: [
      PlexFormWidget(
        entity: myUser,
        onSubmit: () {
          print(myUser.toString());
        },
      ),
    ]);
  }
}
