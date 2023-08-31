import 'package:flutter/material.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_form.dart';

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
  List<PlexFormField> getFields() {
    return [
      PlexFormField.input(title: "firstName", initialVaue: firstName, type: String, onChange: (value) => firstName = value ?? ""),
      PlexFormField.input(title: "lastName", initialVaue: lastName, type: String, onChange: (value) => lastName = value ?? ""),
      PlexFormField.input(title: "age", initialVaue: age, type: int, onChange: (value) => age = value ?? 0),
      PlexFormField.input(title: "dob", initialVaue: dob, type: DateTime, onChange: (value) => dob = value ?? DateTime.now()),
      PlexFormField.input(title: "male", initialVaue: male, type: bool, onChange: (value) => male = value),
      PlexFormField.dropDown(
          title: "objects",
          initialVaue: object,
          onChange: (value) => object = value,
          itemAsString: (item) {
            return item.toString();
          },
          items: ["Pak", "Ind", "Eng"]),
      PlexFormField.dropDown(
          title: "Data",
          initialVaue: "koko",
          onChange: (value) {},
          itemAsString: (item) {
            return item.toString();
          },
          items: ["Pak", "Ind", "Eng"]),
    ];
  }
}

class FormUsageScreen extends PlexScreen {
  const FormUsageScreen({Key? key}) : super(key: key);

  @override
  PlexState<FormUsageScreen> createState() => _FormUsageScreenState();
}

class _FormUsageScreenState extends PlexState<FormUsageScreen> {
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

    return PlexFormWidget<MyUser>(
      entity: myUser,
      onSubmit: (MyUser myUser) {
        print(myUser.toString());
      },
    );
  }
}
