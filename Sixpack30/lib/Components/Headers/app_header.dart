import 'package:flutter/material.dart';
import 'package:sixpack30/Colors/app_colors.dart';
import 'package:sixpack30/Text/font.dart';
import 'package:sixpack30/Text/height.dart';
import 'package:sixpack30/Text/size.dart';
import 'package:sixpack30/Text/width.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: AppFont.primary,
          fontSize: AppFontSize.body,
          height: AppTextHeight.normal,
          letterSpacing: AppTextWidth.normal,
          color: AppColors.textPrimary,
        ),
      ),
      actions: actions,
    );
  }
}

