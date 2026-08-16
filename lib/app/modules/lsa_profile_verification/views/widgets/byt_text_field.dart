import 'package:flutter/material.dart';


class BytTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final bool required;

  const BytTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.focusNode,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator ??
          (required
              ? (String? value) => (value == null || value.trim().isEmpty)
                  ? '$label is required'
                  : null
              : null),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
      ),
    );
  }
}
