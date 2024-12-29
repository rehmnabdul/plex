// ignore_for_file: depend_on_referenced_packages

// import 'package:analyzer/dart/element/element.dart';
// import 'package:build/build.dart';
// import 'package:plex/plex_annotations/plex_annotations.dart';
// import 'package:plex/plex_annotations/plex_visitors/plex_model_visitor.dart';
// import 'package:source_gen/source_gen.dart';
//
// class PlexModelGenerator extends GeneratorForAnnotation<PlexAnnotationModel> {
//   @override
//   String generateForAnnotatedElement(
//     Element element,
//     ConstantReader annotation,
//     BuildStep buildStep,
//   ) {
//     final visitor = PlexModelVisitor();
//     element.visitChildren(visitor);
//
//     final buffer = StringBuffer();
//     String className = visitor.className;
//     buffer.writeln('\n');
//
//     buffer.writeln('extension ${className}Extensions on $className {');
//     buffer.writeln('\n');
//     if (!visitor.emptyConstructorExists()) {
//       throw Exception('\n'
//           '-----------------------------------------------------------------------------\n'
//           '                       Plex Code Generation Exception\n'
//           '          Please create a empty constructor with no arguments.\n'
//           '          Error:  ->  var modelObject = $className();\n'
//           '-----------------------------------------------------------------------------\n'
//           '');
//     }
//
//     buffer.writeln('  $className copy() {');
//     buffer.writeln('\n');
//     buffer.writeln('    var copyObj = $className();');
//     for (var field in visitor.fields) {
//       buffer.writeln('    copyObj.${field.name} = ${field.name};');
//     }
//     buffer.writeln('    return copyObj;');
//     buffer.writeln('  }');
//     buffer.writeln('\n');
//     buffer.writeln('  String asString() {');
//     buffer.writeln(
//         '    return "$className(${visitor.fields.map((e) => '${e.name}: \$${e.name}').toList().join(', ')})";');
//     buffer.writeln('  }');
//     buffer.writeln('\n');
//     buffer.writeln('}');
//     return buffer.toString();
//   }
//
//   printConstructorsAndMethods(StringBuffer buffer, PlexModelVisitor visitor) {
//     //Print Constructors and Methods
//     for (var cons in visitor.constructors) {
//       buffer.writeln(
//           '//${cons.name} : ${cons.parameters.map((e) => '${e.key}:${e.value}').join(',')}');
//     }
//
//     buffer.writeln('\n');
//     for (var meth in visitor.methods) {
//       buffer.writeln(
//           '//${meth.returnType}-${meth.name} : ${meth.parameters.map((e) => '${e.key}:${e.value}').join(',')}');
//     }
//     buffer.writeln('\n');
//   }
// }
