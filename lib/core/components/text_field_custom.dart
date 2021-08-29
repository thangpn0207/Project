import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldCustom extends StatefulWidget {
  final double? width;
  final double? height;
  final String? hintText;
  final String? errorText;
  final int? maxLength;
  final bool validate;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool? isEdit;
  final int? maxLines;
  final VoidCallback? onDoneCheck;
  const TextFieldCustom(
      {Key? key,
        this.width,
        this.height,
        this.hintText,
        this.inputType,
        this.controller,
        this.prefixIcon,
        this.isEdit,
        this.maxLines,
        this.errorText,
        this.maxLength,
        this.validate = false,
        this.onDoneCheck,
        })
      : super(key: key);

  @override
  _TextFieldCustomState createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: widget.width,
            height: widget.maxLines == null ? widget.height ?? 40.h : null,
            child: TextField(
              autofocus: false,
              textCapitalization: TextCapitalization.sentences,
              maxLength: widget.maxLength,
              keyboardType: widget.inputType,
              controller: widget.controller,
              enabled: widget.isEdit ?? true,
              maxLines: widget.maxLines,
              decoration: InputDecoration(
                hintText: widget.hintText,
                errorText: widget.validate ? '' : null,
                errorStyle: TextStyle(height: 0, fontSize: 0),
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Container(
                  child: widget.prefixIcon,
                )
                    : null,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Maven-Medium',
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          widget.validate
              ? Align(
            alignment: Alignment.bottomRight,
            child: Text(
              widget.errorText ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
              ),
            ),
          )
              : Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          )
        ],
      ),
    );
  }

}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}