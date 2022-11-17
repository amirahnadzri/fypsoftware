// @dart=2.9
import 'package:flutter/material.dart';
import 'package:appmaindesign/model.dart';
import 'package:appmaindesign/HomePage.dart';

class EditableListTile extends StatefulWidget {
  final ListModel model;
  final Function(ListModel listModel) onChanged;
  EditableListTile({Key key, this.model, this.onChanged})
      : assert(model != null),
        super(key: key);

  @override
  _EditableListTileState createState() => _EditableListTileState();
}

class _EditableListTileState extends State<EditableListTile> {
  ListModel model;

  bool _isEditingMode;

  TextEditingController _titleEditingController;

  @override
  void initState() {
    super.initState();
    this.model = widget.model;
    this._isEditingMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: titleWidget,
      trailing: tralingButton,
    );
  }

  Widget get titleWidget {
    if (_isEditingMode) {
      _titleEditingController = TextEditingController(text: model.ingredient);
      return TextField(
        controller: _titleEditingController,
      );
    } else
      return Text(model.ingredient);
  }

  Widget get tralingButton {
    if (_isEditingMode) {
      return IconButton(
        icon: Icon(Icons.check),
        onPressed: saveChange,
      );
    } else
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: _toggleMode,
      );
  }

  void _toggleMode() {
    setState(() {
      _isEditingMode = !_isEditingMode;
    });
  }

  void saveChange() {
    this.model.ingredient = _titleEditingController.text;
    _toggleMode();
    if (widget.onChanged != null) {
      widget.onChanged(this.model);
    }
  }
}