// ignore_for_file: depend_on_referenced_packages

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

class PlexMethodModel {
  String returnType;
  String name;
  List<MapEntry<String, String>> parameters;

  PlexMethodModel(this.returnType, this.name, this.parameters);
}

class PlexFieldModel {
  String type;
  String name;

  PlexFieldModel(this.type, this.name);
}

class PlexModelVisitor extends SimpleElementVisitor<void> {
  String className = '';
  List<PlexFieldModel> fields = [];
  List<PlexMethodModel> methods = [];
  List<PlexMethodModel> constructors = [];

  bool allFieldsConstructorExists() => constructors.any((c) => c.parameters.length == fields.length);

  bool emptyConstructorExists() => constructors.any((c) => c.parameters.isEmpty);

  @override
  void visitConstructorElement(ConstructorElement element) {
    final returnType = element.returnType.toString();
    className = returnType;

    var parameters = element.parameters.map((e) => MapEntry(e.name, e.type.toString())).toList();
    constructors.add(PlexMethodModel(className, className, parameters));
  }

  @override
  void visitMethodElement(MethodElement element) {
    var method = PlexMethodModel(element.returnType.toString(), element.name, element.parameters.map((e) => MapEntry(e.name, e.type.toString())).toList());
    methods.add(method);
  }

  @override
  void visitFieldElement(FieldElement element) {
    var elementType = element.type.toString();
    fields.add(PlexFieldModel(elementType, element.name));
  }
}
