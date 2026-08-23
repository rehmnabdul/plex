import 'package:flutter/material.dart';
import 'package:plex/plex_screens/plex_screen.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_form.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';
import 'package:plex_app/screens/example_chrome.dart';

class MyUser extends PlexForm {
  String firstName;
  String? lastName;
  int age;
  DateTime dob;
  bool male;
  dynamic object;
  List<int> codes;

  MyUser(this.firstName, this.lastName, this.age, this.dob, this.male,
      this.object, this.codes);

  @override
  String toString() {
    return 'MyUser{firstName: $firstName, lastName: $lastName, age: $age, dob: $dob, male: $male, object: $object}';
  }

  @override
  List<PlexFormField> getFields(State<StatefulWidget> context) {
    return [
      if (male) ...{
        PlexFormField.input(
            title: "firstName",
            initialValue: firstName,
            type: String,
            onChange: (value) => firstName = value ?? ""),
        PlexFormField.input(
            title: "lastName",
            initialValue: lastName,
            inputType: TextInputType.name,
            type: String,
            onChange: (value) => lastName = value ?? ""),
        PlexFormField.input(
            title: "dob",
            initialValue: dob,
            type: DateTime,
            onChange: (value) => dob = value ?? DateTime.now()),
      },
      PlexFormField.input(
          title: "male",
          initialValue: male,
          type: bool,
          onChange: (value) {
            male = value;
            // PlexForm rebuilds fields when this flag changes.
            // ignore: invalid_use_of_protected_member
            context.setState(() {});
          }),
      PlexFormField.multiselect(
        title: "codes",
        itemAsString: (item) => item.toString(),
        onChange: (dynamic value) {
          codes = (value as List).cast<int>().toList();
        },
        initialSelection: codes,
        items: [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20
        ],
      ),
      PlexFormField.dropDown(
          title: "objects",
          initialValue: object,
          onChange: (value) => object = value,
          items: [
            "Pak",
            "Ind",
            "Eng",
            "Ifg",
            "New",
            "China",
            "Sri Lanka",
            "Bang",
            "Russ",
            "Aus",
            "USA",
            "UAE",
            "KSA",
            "EUR",
            "Itly",
            "Germ",
            "Egypt",
            "Africa"
          ],
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
      PlexFormField.input(
          title: "age",
          initialValue: age,
          type: int,
          onChange: (value) => age = value ?? 0),
    ];
  }
}

class FormUsageScreen extends PlexScreen {
  const FormUsageScreen({super.key}) : super(useScaffold: false);

  @override
  PlexState<FormUsageScreen> createState() => _FormUsageScreenState();
}

class _FormUsageScreenState extends PlexState<FormUsageScreen> {
  @override
  Widget buildBody() {
    var myUser = MyUser("Abdur", "Rahman", 5, DateTime.now(), true, "Pak", [1]);
    return Padding(
      padding: const EdgeInsets.all(PlexDim.medium),
      child: Column(
        children: [
          ExampleCard(
            title: "PlexFormWidget",
            subtitle: "Build a form from a PlexForm model",
            child: PlexFormFieldButton(
              properties: const PlexFormFieldGeneric(
                title: "Sample outlined action",
                useMargin: false,
              ),
              buttonIcon: const Icon(Icons.abc),
              buttonType: PlexButtonType.outlined,
              buttonClick: () {},
            ),
          ),
          const SizedBox(height: PlexDim.medium),
          Expanded(
            child: ExampleCard(
              title: "Generated fields",
              flush: true,
              child: PlexFormWidget<MyUser>(
                entity: myUser,
                onSubmit: (dynamic myUser) {
                  Future(
                    () async {
                      showLoading();
                      await Future.delayed(const Duration(milliseconds: 5000));
                      hideLoading();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
