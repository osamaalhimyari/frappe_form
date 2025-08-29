import 'package:flutter/cupertino.dart';
import 'package:frappe_form/frappe_form.dart';

class DocFieldDependsOnController {
  DocFieldDependsOnBundle? requiredDependsOn;
  DocFieldDependsOnBundle? readOnlyDependsOn;
  DocFieldDependsOnBundle? visibilityDependsOn;
  ValueChanged<bool>? _onRequiredDependsOnChanged;
  ValueChanged<bool>? _onReadOnlyDependsOnChanged;
  ValueChanged<bool>? _onVisibilityDependsOnChanged;

  DocFieldDependsOnController({
    this.requiredDependsOn,
    this.readOnlyDependsOn,
    this.visibilityDependsOn,
  });

  bool listenOnRequiredDependsOnChangesAndCheck(ValueChanged<bool>? listener) {
    _onRequiredDependsOnChanged = listener;
    requiredDependsOn?.addListener(checkIfRequired);
    return checkIfRequired();
  }

  bool listenOnReadOnlyDependsOnChangesAndCheck(ValueChanged<bool>? listener) {
    _onReadOnlyDependsOnChanged = listener;
    readOnlyDependsOn?.addListener(checkIfReadOnly);
    return checkIfReadOnly();
  }

  bool listenOnVisibilityDependsOnChangesAndCheck(
    ValueChanged<bool>? listener,
  ) {
    _onVisibilityDependsOnChanged = listener;
    visibilityDependsOn?.addListener(checkIfVisible);
    return checkIfVisible();
  }

  bool checkIfRequired({bool notify = true}) {
    bool result = requiredDependsOn?.check() ?? false;
    if (notify) {
      _onRequiredDependsOnChanged?.call(result);
    }
    return result;
  }

  bool checkIfReadOnly({bool notify = true}) {
    bool result = readOnlyDependsOn?.check() ?? false;
    if (notify) {
      _onReadOnlyDependsOnChanged?.call(result);
    }
    return result;
  }

  bool checkIfVisible({bool notify = true}) {
    bool result = visibilityDependsOn?.check() ?? true;
    if (notify) {
      _onVisibilityDependsOnChanged?.call(result);
    }
    return result;
  }

  void _removeListeners() {
    requiredDependsOn?.removeListener(checkIfRequired);
    readOnlyDependsOn?.removeListener(checkIfReadOnly);
    visibilityDependsOn?.removeListener(checkIfVisible);
  }

  void dispose() {
    _onRequiredDependsOnChanged = null;
    _onReadOnlyDependsOnChanged = null;
    _onVisibilityDependsOnChanged = null;
    _removeListeners();
  }
}
