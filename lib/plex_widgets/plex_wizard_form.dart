import 'package:flutter/material.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widget.dart';
import 'package:plex/plex_widgets/plex_form.dart';
import 'package:plex/plex_l10n/plex_localization.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

/// A single step in a [PlexWizardForm].
class PlexWizardStep {
  const PlexWizardStep({
    required this.title,
    required this.fields,
  });

  final String title;
  final List<PlexFormField> fields;
}

/// A multi-step wizard form with Back / Next / Submit buttons.
class PlexWizardForm extends StatefulWidget {
  const PlexWizardForm({
    super.key,
    required this.steps,
    required this.onComplete,
    this.onCancel,
  });

  final List<PlexWizardStep> steps;
  final VoidCallback onComplete;
  final VoidCallback? onCancel;

  @override
  State<PlexWizardForm> createState() => _PlexWizardFormState();
}

class _PlexWizardFormState extends State<PlexWizardForm> {
  int _currentStep = 0;

  void _onStepContinue() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      widget.onComplete();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      widget.onCancel?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _currentStep,
      onStepContinue: _onStepContinue,
      onStepCancel: _currentStep > 0 ? _onStepCancel : null,
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.only(top: PlexDim.medium),
          child: Row(
            children: [
              if (_currentStep > 0)
                OutlinedButton(
                  onPressed: details.onStepCancel,
                  child: Text(context.plexStrings.wizardBack),
                ),
              if (_currentStep > 0) const SizedBox(width: PlexDim.small),
              FilledButton(
                onPressed: details.onStepContinue,
                child: Text(
                  _currentStep < widget.steps.length - 1 ? context.plexStrings.wizardNext : context.plexStrings.wizardSubmit,
                ),
              ),
              if (widget.onCancel != null && _currentStep == 0) ...[
                const SizedBox(width: PlexDim.small),
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(context.plexStrings.dialogCancel),
                ),
              ],
            ],
          ),
        );
      },
      steps: [
        for (var i = 0; i < widget.steps.length; i++)
          Step(
            title: Text(widget.steps[i].title),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildFieldsForStep(widget.steps[i]),
            ),
            isActive: i == _currentStep,
            state: i < _currentStep
                ? StepState.complete
                : i == _currentStep
                    ? StepState.indexed
                    : StepState.indexed,
          ),
      ],
    );
  }

  List<Widget> _buildFieldsForStep(PlexWizardStep step) {
    final formState = <String, dynamic>{'step': _currentStep};
    return [
      for (var value in step.fields)
        if (value.showWhen != null && !value.showWhen!(formState))
          const SizedBox.shrink()
        else
          _buildField(value),
    ];
  }

  Widget _buildField(PlexFormField value) {
    if (value.fieldType == PlexFormField.TYPE_INPUT) {
      if (value.type == String) {
        return PlexFormFieldInput(
          properties: PlexFormFieldGeneric(
            title: value.title.toUpperCase(),
            enabled: value.editable,
          ),
          isPassword: value.isPassword,
          inputKeyboardType: value.inputType ?? TextInputType.text,
          inputAction: value.inputAction,
          inputController: TextEditingController(
            text: value.initialValue?.toString(),
          ),
          inputOnChange: (v) => value.onChange(v.toString()),
        );
      }
      if (value.type == int) {
        return PlexFormFieldInput(
          properties: PlexFormFieldGeneric(
            title: value.title.toUpperCase(),
            enabled: value.editable,
          ),
          inputKeyboardType: const TextInputType.numberWithOptions(
            decimal: false,
            signed: false,
          ),
          inputOnChange: (v) => value.onChange(int.tryParse(v)),
          inputController: TextEditingController(
            text: value.initialValue?.toString(),
          ),
        );
      }
      if (value.type == double) {
        return PlexFormFieldInput(
          properties: PlexFormFieldGeneric(
            title: value.title.toUpperCase(),
            enabled: value.editable,
          ),
          inputKeyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputOnChange: (v) => value.onChange(v),
          inputController: TextEditingController(
            text: value.initialValue?.toString(),
          ),
        );
      }
      if (value.type == bool) {
        return PlexFormFieldDropdown<bool>(
          properties: PlexFormFieldGeneric(
            title: value.title.toUpperCase(),
            enabled: value.editable,
          ),
          dropdownSelectionController: PlexWidgetController(data: value.initialValue),
          dropdownItems: const [true, false],
          dropdownItemAsString: (v) => v ? 'True' : 'False',
          dropdownItemOnSelect: (v) => value.onChange(v),
        );
      }
      if (value.type == DateTime) {
        return PlexFormFieldDate(
          properties: PlexFormFieldGeneric(
            title: value.title.toUpperCase(),
            enabled: value.editable,
          ),
          type: PlexFormFieldDateType.typeDateTime,
          selectionController: PlexWidgetController(data: value.initialValue),
          onSelect: (v) => value.onChange(v),
        );
      }
    }
    if (value.fieldType == PlexFormField.TYPE_DROPDOWN) {
      return PlexFormFieldDropdown(
        properties: PlexFormFieldGeneric(
          title: value.title.toUpperCase(),
          enabled: value.editable,
        ),
        dropdownSelectionController: PlexWidgetController(data: value.initialValue),
        dropdownItemOnSelect: (p) => value.onChange(p),
        dropdownItemAsString: (p) => value.itemAsString!(p),
        dropdownItems: value.items,
        dropdownAsyncItems: value.itemsAsync,
        dropdownOnSearch: value.onSearch,
        dropdownItemWidget: value.dropdownWidget,
        dropDownLeadingIcon: value.dropdownLeadingWidget,
      );
    }
    if (value.fieldType == PlexFormField.TYPE_MULTISELECT) {
      return PlexFormFieldMultiSelect<dynamic>(
        properties: PlexFormFieldGeneric(
          title: value.title.toUpperCase(),
          enabled: value.editable,
        ),
        multiSelectionController: PlexWidgetController(data: value.initialValue),
        dropdownItemOnSelect: (p) => value.onChange(p),
        dropdownItemAsString: (p) => value.itemAsString!(p),
        dropdownItems: value.items,
        dropdownAsyncItems: value.itemsAsync,
        dropdownOnSearch: value.onSearch,
        dropdownItemWidget: value.dropdownWidget,
        dropDownLeadingIcon: value.dropdownLeadingWidget,
        multiInitialSelection: value.initialSelection,
      );
    }
    if (value.fieldType == PlexFormField.TYPE_DATETIME) {
      return PlexFormFieldDate(
        properties: PlexFormFieldGeneric(
          title: value.title.toUpperCase(),
          enabled: value.editable,
        ),
        type: PlexFormFieldDateType.typeDateTime,
        selectionController: PlexWidgetController(data: value.initialValue),
        onSelect: (p) => value.onChange(p),
      );
    }
    return const SizedBox.shrink();
  }
}
