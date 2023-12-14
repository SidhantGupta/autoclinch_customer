import 'package:flutter/material.dart';
import '/widgets/user/textfield.dart';

class PasswordField extends StatefulWidget {
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final String? prefixText;
  final String? labelText;
  final TextEditingController? controller;
  final IconData? iconData;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  PasswordField(
      {Key? key,
      this.onSaved,
      this.validator,
      this.hintText,
      this.labelText,
      this.iconData,
      this.prefixText,
      this.controller,
      this.onFieldSubmitted,
      this.focusNode,
      this.obscureText = true,
      this.textInputAction = TextInputAction.next})
      : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHidden = true;
  @override
  void initState() {
    super.initState();
    _isHidden = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWithPadding(
      onSaved: widget.onSaved,
      validator: widget.validator,
      hintText: widget.hintText,
      labelText: widget.labelText,
      iconData: widget.iconData,
      controller: widget.controller,
      focusNode: widget.focusNode,
      prefixText: widget.prefixText,
      keyboardType: TextInputType.name,
      obscureText: _isHidden,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      suffix: InkWell(
        onTap: _togglePasswordView,
        child: Icon(
            _isHidden
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
