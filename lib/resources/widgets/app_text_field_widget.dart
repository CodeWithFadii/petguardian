import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Color? hintColor;
  final double? hintSize;
  final FontWeight? hintWeight;
  final EdgeInsets? padding;
  final bool? filled;
  final Color? fillColor;
  final Color? borderColor;
  final int? maxLength;
  final double? borderRadius;
  final bool enabled;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.hintColor,
    this.hintSize,
    this.hintWeight,
    this.padding,
    this.filled = true,
    this.fillColor,
    this.borderRadius,
    this.borderColor,
    this.enabled = true,
    this.maxLength,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        onTapOutside: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        maxLength: widget.maxLength,
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        minLines: widget.minLines,
        readOnly: widget.readOnly,
        obscuringCharacter: '*',
        style: TextStyle(color: Colors.black),
        cursorColor: AppColors.black,
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintColor ?? Colors.grey,
            fontSize: widget.hintSize ?? 14,
            fontWeight: widget.hintWeight ?? FontWeight.w400,
          ),
          prefixIcon: widget.prefixIcon,
          filled: widget.filled ?? true,
          fillColor: widget.fillColor ?? AppColors.white,
          enabled: widget.enabled,
          suffixIcon:
              widget.suffixIcon ??
              (widget.obscureText
                  ? IconButton(
                    icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                  : null),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? 8.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
            borderSide: BorderSide(color: AppColors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
            borderSide: BorderSide(color: widget.borderColor ?? AppColors.white),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.white),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 6),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.red),
          ),
          errorStyle: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
