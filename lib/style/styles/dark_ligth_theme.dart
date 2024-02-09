import 'package:flutter/material.dart';
import '../../utils/shared_preferences/s_p_settings.dart';
import 'palette_style.dart';

class darkLightTheme {
  bool themeDark = SharedPrerencesSettins().onDarkTheme;

  Color getPrimaryColor() {
    return themeDark ? Palette.purpleDark : Palette.purpleLigth;
  }

  Color getBackGround() {
    return themeDark ? Palette.bgpageDark : Palette.bgpageLight;
  }

  Color getBackGroundFullFocus() {
    return themeDark ? Palette.bgpageDarkFullFocus : Palette.bgpageLight;
  }

  Color greyContainer() {
    return themeDark
        ? const Color.fromARGB(255, 48, 50, 53)
        : Palette.greyContainerLight;
  }

  Color greyDetail() {
    return themeDark ? Palette.greyDetailDark : Palette.greyDetailLight;
  }

  Color textSecundary() {
    return themeDark ? Palette.textSecundaryDark : Palette.textSecundaryDark;
  }

  Color textPrimary() {
    return themeDark ? Palette.textPrimarydark : Palette.textPrimaryLigth;
  }

  Color green() {
    return themeDark ? Palette.greenDark : Palette.greenLigth;
  }

  Color red() {
    return themeDark ? Palette.redLigth : Palette.redLigth;
  }

  Color blue() {
    return themeDark ? Palette.blueDark : Palette.blueLigth;
  }

  Color orange() {
    return themeDark ? Palette.orangeDark : Palette.orangeLigth;
  }

  Color getOscureLigth() =>
      !themeDark ? Color(0xff252525) : Color.fromARGB(255, 240, 240, 240);
}
