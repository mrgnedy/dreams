import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/colors.dart';
import '../const/resource.dart';

class AppDropdownButton<T> extends StatefulWidget {
  final List<T?>? items;
  final String icon;
  final T? value;
  final void Function(T?)? onChanged;
  final String hint;

  final String? Function(T?)? validator;
  const AppDropdownButton({
    Key? key,
    required this.items,
    required this.icon,
    required this.hint,
    required this.value,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppDropdownButton> createState() => _AppTextFormFieldState<T>();
}

class _AppTextFormFieldState<T> extends State<AppDropdownButton<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("${widget.value}");
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0.h),
        child: Container(
          // margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField(
                  validator: widget.validator,
                  builder: (FormFieldState<dynamic> field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<T>(
                          itemHeight:
                              42.h.clamp(kMinInteractiveDimension, double.infinity),
                          underline: Container(),
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(widget.icon),
                              ),
                              Text(
                                widget.hint,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                          icon: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                            child: Image.asset(R.ASSETS_IMAGES_ARROW_DOWN_PNG),
                          ),
                          selectedItemBuilder: (context) => widget.items == null
                              ? []
                              : widget.items!
                                  .map(
                                    (e) => Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(widget.icon),
                                        ),
                                        Text(
                                          (e as dynamic).name,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList()
                                  .cast<Widget>(),
                          value: widget.value,
                          items: widget.items
                              ?.map(
                                (e) => DropdownMenuItem<T>(
                                  child: Text((e as dynamic).name),
                                  value: e,
                                ),
                              )
                              .toList(),
                          onChanged: widget.onChanged,
                        ),
                        if(field.hasError) Text('${field.errorText}', textAlign: TextAlign.start,style: TextStyle(color: Colors.red[700], fontSize: 13),)
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
