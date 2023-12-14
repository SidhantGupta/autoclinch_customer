import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithPadding extends StatelessWidget {
  final TextStyle style = TextStyle(fontSize: 14.0);
  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final String? prefixText;
  final String? labelText;
  final IconData? iconData;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffix;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  final String? initialValue;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool showDecimal;
  final FocusNode? focusNode;
  final bool whitespaceNotAllowed;
  final ValueChanged<String>? onFieldSubmitted;

  TextFieldWithPadding(
      {Key? key,
      this.onSaved,
      this.validator,
      this.hintText,
      this.labelText,
      this.iconData,
      this.prefixText,
      this.suffix,
      this.onTap,
      this.maxLength,
      this.controller,
      this.initialValue,
      this.minLines,
      this.onFieldSubmitted,
      this.focusNode,
      this.maxLines = 1,
      this.keyboardType = TextInputType.name,
      this.obscureText = false,
      this.showDecimal = false,
      this.readOnly = false,
      this.whitespaceNotAllowed = false,
      this.textInputAction = TextInputAction.next})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputFormatters = <TextInputFormatter>[];
    if (keyboardType == TextInputType.number && !showDecimal) {
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }
    if (whitespaceNotAllowed) {
      inputFormatters
          .add(FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5),
            child: Text(
              labelText ?? "",
              style: labelTextstyle,
            ),
          ),
          TextFormField(
            initialValue: initialValue,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            onSaved: (value) {
              if (onSaved != null) {
                onSaved!(value ?? "");
              }
            },
            onFieldSubmitted: onFieldSubmitted,
            focusNode: focusNode,
            onTap: onTap,
            controller: controller,
            style: style,
            validator: (value) {
              return validator != null ? validator!(value) : null;
            },
            keyboardType: keyboardType,
            readOnly: readOnly,
            minLines: minLines,
            maxLength: maxLength,
            maxLines: maxLines,
            textInputAction: textInputAction,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: InputBorder.none,
                hintText: hintText,
                // labelText: labelText,
                labelText: hintText,
                counterText: "",
                prefixText: prefixText,
                prefixIcon: Icon(
                  iconData,
                  color: Colors.grey,
                ),
                suffixIcon: suffix,
                suffixStyle: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}

class TextLabelWithPadding extends StatelessWidget {
  final TextStyle style = TextStyle(fontSize: 14.0);
  final TextStyle labelTextstyle = TextStyle(fontSize: 14.0);

  final String? prefixText;
  final String? labelText;
  final IconData? iconData;
  final Widget? suffix;
  final GestureTapCallback? onTap;
  final String? initialValue;

  TextLabelWithPadding({
    Key? key,
    this.labelText,
    this.iconData,
    this.prefixText,
    this.suffix,
    this.onTap,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText ?? "",
            style: labelTextstyle,
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(iconData),
              const SizedBox(width: 8),
              Text(prefixText ?? '', style: style),
              SizedBox(width: prefixText != null ? 5 : 0),
              Expanded(child: Text(initialValue ?? '', style: style)),
            ],
          )
        ],
      ),
    );
  }
}

final cardPadding = const EdgeInsets.fromLTRB(0, 7, 0, 7);

extension CardToWIdget on Widget {
  Widget get card => Card(
      color: Colors.white,
      child:
          Padding(padding: const EdgeInsets.fromLTRB(0, 7, 0, 7), child: this));
}
