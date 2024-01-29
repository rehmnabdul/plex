import 'package:flutter/material.dart';
import 'package:plex/plex_di/plex_dependency_injection.dart';
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
  List<int> codes;

  MyUser(this.firstName, this.lastName, this.age, this.dob, this.male, this.object, this.codes);

  @override
  String toString() {
    return 'MyUser{firstName: $firstName, lastName: $lastName, age: $age, dob: $dob, male: $male, object: $object}';
  }

  @override
  List<PlexFormField> getFields() {
    return [
      PlexFormField.input(title: "firstName", initialValue: firstName, type: String, onChange: (value) => firstName = value ?? ""),
      PlexFormField.input(title: "lastName", initialValue: lastName, inputType: TextInputType.name, type: String, onChange: (value) => lastName = value ?? ""),
      PlexFormField.input(title: "dob", initialValue: dob, type: DateTime, onChange: (value) => dob = value ?? DateTime.now()),
      PlexFormField.input(title: "male", initialValue: male, type: bool, onChange: (value) => male = value),
      PlexFormField.multiselect(
        title: "codes",
        onChange: (dynamic value) {
          codes = (value as List).cast<int>().toList();
        },
        initialSelection: codes,
        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
      ),
      PlexFormField.dropDown(
          title: "objects",
          initialValue: object,
          onChange: (value) => object = value,
          items: ["Pak", "Ind", "Eng", "Ifg", "New", "China", "Sri Lanka", "Bang", "Russ", "Aus", "USA", "UAE", "KSA", "EUR", "Itly", "Germ", "Egypt", "Africa"],
          itemAsString: (item) {
            return item.toString();
          }),
      PlexFormField.dropDown(
          title: "Data",
          initialValue: "koko",
          onChange: (value) {},
          itemAsString: (item) {
            return item.toString();
          },
          items: ["Pak", "Ind", "Eng"]),
      PlexFormField.input(title: "age", initialValue: age, type: int, onChange: (value) => age = value ?? 0),
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
    var myUser = MyUser("Abdur", "Rahman", 5, DateTime.now(), true, "Pak", [1]);
    print(myUser.toString());

    var user = fromPlex<MyUser>("user");

    return PlexFormWidget<MyUser>(
      entity: myUser,
      onSubmit: (dynamic myUser) {
        Future(
          () async {
            showLoading();
            await Future.delayed(const Duration(milliseconds: 5000));
            hideLoading();
          },
        );
        print(myUser.toString());
      },
    );
  }
}
