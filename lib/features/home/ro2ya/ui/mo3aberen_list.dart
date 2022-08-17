import 'dart:developer';

import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/ro2ya/state/roya_request_cubit.dart';
import 'package:dreams/helperWidgets/app_error_widget.dart';
import 'package:dreams/helperWidgets/app_loader.dart';
import 'package:dreams/helperWidgets/dialogs.dart';
import 'package:dreams/main.dart';
import 'package:dreams/utils/base_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/colors.dart';
import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/features/home/ro2ya/data/models/mo3aberen_list_model.dart';
import 'package:dreams/features/home/ro2ya/state/mo3beren_cubit.dart';
import 'package:dreams/features/home/ro2ya/ui/ta3beer_request.dart';
import 'package:dreams/helperWidgets/buttons.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';

import 'commonWidgets/moaber_sepcs.dart';

class MoaberenListScreen extends StatelessWidget {
  final MoaberenCubit moaberenCubit;
  const MoaberenListScreen({Key? key, required this.moaberenCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        title: LocaleKeys.mo3aberenList.tr(),
        body: BlocBuilder<MoaberenCubit, MoaberenData>(
          bloc: moaberenCubit,
          builder: (context, state) {
            log('${state.data.length}');
            if (state.state is ErrorResult) {
              return AppErrorWidget(
                error: state.state.getErrorMessage(),
                onError: moaberenCubit.getMoaberenList,
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.data.length,
                    // itemExtent: 190.h,
                    itemBuilder: (context, index) => Mo3aberCard(
                      moaberData: state.data[index],
                    ),
                  ),
                ),
                if (state.state is LoadingResult)
                  const Expanded(child: AppLoader())
              ],
            );
          },
        ));
  }
}

class Mo3aberCard extends StatelessWidget {
  final MoaberData moaberData;
  const Mo3aberCard({
    Key? key,
    required this.moaberData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0).copyWith(top: 0),
      child: Container(
        // height: 190.h,
        width: 350.w,
        decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Column(
                children: [
                  MoaberDetailsCard(
                    moaberData: moaberData,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GradientButton(
                        onTap: () {
                          if ((di<AuthCubit>().state.remaining_dreams ?? 0) <=
                              0) {
                            return SuccessDialog.show(
                                context, 'قد نفذت كمية الطلبات المتاحة لديك',
                                isSuccess: false);
                          }
                          final requestCubit = RoyaRequestCubit()
                            ..getQuestions()
                            ..updateInterId(moaberData.id);
                          BlocProvider.value(
                            value: requestCubit,
                            child: TaabeerRequest(moaberData: moaberData),
                          ).push(context);
                        },
                        title: LocaleKeys.dreamRequest.tr()),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class MoaberDetailsCard extends StatelessWidget {
  final MoaberData moaberData;
  MoaberDetailsCard({
    Key? key,
    required this.moaberData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: moaberData.image.isEmpty
                ? Image.asset(
                    R.ASSETS_IMAGES_PROFILE_NAV_AT_3X_PNG,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcATop,
                  )
                : Image.network(moaberData.image)),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                moaberData.name,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
              ),
              MoaberSpecs(
                moaberData: moaberData,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.0.h),
                child: Text(
                  moaberData.note,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
