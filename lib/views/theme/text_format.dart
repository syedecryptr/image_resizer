import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:image_resizer/views/theme/colors.dart';

class styles{

  // style 1
  // static final parameters_headings = GoogleFonts.raleway(color: ThemeColors.white_main, fontSize: 15 ,fontWeight: FontWeight.w400, letterSpacing: 0.3);
  static final parameters_headings = TextStyle(fontFamily:"raleway", color: ThemeColors.white_main, fontSize: 14 ,fontWeight: FontWeight.w700, letterSpacing: 0.3);

  // static final small_information = GoogleFonts.robotoMono(color: ThemeColors.white_dull, fontSize: 12);
  static final small_information = TextStyle(fontFamily: "roboto_mono", color: ThemeColors.white_dull, fontSize: 10);

  // static final place_holder = GoogleFonts.ptSerif(color: ThemeColors.white_dull, fontSize: 14 ,fontWeight: FontWeight.w400, letterSpacing: 0.3);
  static final place_holder = TextStyle(fontFamily:"pt_serif", color: ThemeColors.white_dull, fontSize: 14 ,fontWeight: FontWeight.w400, letterSpacing: 0.3);

  // static final input_value = GoogleFonts.ptSerif(color: ThemeColors.white_main, fontSize: 14 ,fontWeight: FontWeight.w400, letterSpacing: 0.3);
  static final input_value = TextStyle(fontFamily: "pt_serif", color: ThemeColors.white_main, fontSize: 14 ,fontWeight: FontWeight.w400, letterSpacing: 0.3);

  // static final secondary_title = GoogleFonts.robotoMono(color: ThemeColors.white_main, fontSize: 18 ,fontWeight: FontWeight.w400, letterSpacing: 0.5);
  static final secondary_title = TextStyle(fontFamily: "roboto_mono", color: ThemeColors.white_main, fontSize: 16 ,fontWeight: FontWeight.w400, letterSpacing: 0.9);

  static final primary_title = TextStyle(fontFamily: "roboto", color: ThemeColors.white_main, fontSize: 17 ,fontWeight: FontWeight.w400, letterSpacing: 0.9);

}