// cupertino and material are two different design languages used in Flutter. Cupertino is used for iOS apps, while Material is used for Android apps.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// google_fonts is a package that allows to use Google Fonts in Flutter applications.
import 'package:google_fonts/google_fonts.dart';


/// ============================================================================
/// File: app_theme.dart
/// ============================================================================
///
/// Application Theme System
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Defines light and dark themes.
/// • Provides Material 3 design system.
/// • Centralizes typography.
/// • Centralizes component styling.
/// • Maintains consistent enterprise UI.
///
/// Architecture
/// ----------------------------------------------------------------------------
///
/// UI
/// ↓
/// AppTheme
/// ↓
/// ThemeData
///
/// ============================================================================


final class AppTheme {

  // Private constructor to prevent instantiation of the class.
  const AppTheme._();



  // ===========================================================================
  // Brand
  // ===========================================================================


  static const Color _seedColor =
      Color(0xFF2563EB);



  static const double _radiusSmall = 8;

  static const double _radiusMedium = 12;

  static const double _radiusLarge = 20;





  // ===========================================================================
  // Public Themes
  // ===========================================================================


  static ThemeData get lightTheme {

    return _buildTheme(
      Brightness.light,
    );

  }




  static ThemeData get darkTheme {

    return _buildTheme(
      Brightness.dark,
    );

  }







  // ===========================================================================
  // Theme Builder
  // ===========================================================================


  static ThemeData _buildTheme(
    Brightness brightness,
  ) {


    final ColorScheme scheme =
        ColorScheme.fromSeed(

      seedColor: _seedColor,

      brightness: brightness,

    );



    final TextTheme textTheme =
        GoogleFonts.interTextTheme(
          brightness == Brightness.dark
              ? ThemeData.dark().textTheme
              : ThemeData.light().textTheme,
        );



    return ThemeData(

      useMaterial3: true,

      brightness: brightness,


      colorScheme: scheme,


      scaffoldBackgroundColor:
          scheme.surface,



      visualDensity:
          VisualDensity.adaptivePlatformDensity,



      textTheme:
          _textTheme(textTheme),



      splashFactory:
          InkSparkle.splashFactory,



      appBarTheme:
          _appBarTheme(scheme),



      cardTheme:
          _cardTheme(scheme),



      inputDecorationTheme:
          _inputDecorationTheme(scheme),



      filledButtonTheme:
          _filledButtonTheme(),



      outlinedButtonTheme:
          _outlinedButtonTheme(),



      elevatedButtonTheme:
          _elevatedButtonTheme(),



      snackBarTheme:
          _snackBarTheme(),



      dividerTheme:
          DividerThemeData(

        color:
            scheme.outlineVariant,

        thickness: 1,

      ),



      progressIndicatorTheme:
          ProgressIndicatorThemeData(

        color:
            scheme.primary,

      ),



      iconTheme:
          IconThemeData(

        color:
            scheme.onSurfaceVariant,

        size: 24,

      ),

            iconButtonTheme:
          IconButtonThemeData(

        style:
            IconButton.styleFrom(

          foregroundColor:
              scheme.primary,

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
                  _radiusSmall,
                ),

          ),

        ),

      ),




      floatingActionButtonTheme:
          FloatingActionButtonThemeData(

        backgroundColor:
            scheme.primary,


        foregroundColor:
            scheme.onPrimary,


        elevation: 2,


        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                _radiusMedium,
              ),

        ),

      ),





      checkboxTheme:
          CheckboxThemeData(

        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                4,
              ),

        ),


        side:
            BorderSide(

          color:
              scheme.outline,

        ),

      ),





      radioTheme:
          RadioThemeData(

        fillColor:
            WidgetStatePropertyAll(
              scheme.primary,
            ),

      ),





      switchTheme:
          SwitchThemeData(

        thumbColor:
            WidgetStateProperty.resolveWith(
              (
                states,
              ) {

                if (states.contains(
                  WidgetState.selected,
                )) {

                  return scheme.primary;

                }


                return scheme.outline;

              },
            ),

      ),





      chipTheme:
          ChipThemeData(

        padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),


        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                _radiusMedium,
              ),

        ),


        side:
            BorderSide.none,


      ),






      listTileTheme:
          ListTileThemeData(

        contentPadding:
            const EdgeInsets.symmetric(
              horizontal: 16,
            ),


        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                _radiusMedium,
              ),

        ),


        iconColor:
            scheme.primary,


        minVerticalPadding:
            12,


      ),






      navigationBarTheme:
          NavigationBarThemeData(

        backgroundColor:
            scheme.surface,


        indicatorColor:
            scheme.primaryContainer,


        labelTextStyle:
            WidgetStatePropertyAll(

              GoogleFonts.inter(

                fontWeight:
                    FontWeight.w600,

              ),

            ),

      ),






      tooltipTheme:
          TooltipThemeData(

        padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),


        decoration:
            BoxDecoration(

          color:
              scheme.inverseSurface,


          borderRadius:
              BorderRadius.circular(
                _radiusSmall,
              ),

        ),


        textStyle:
            TextStyle(

          color:
              scheme.onInverseSurface,


        ),

      ),






      dialogTheme:
          DialogThemeData(

        backgroundColor:
            scheme.surface,


        surfaceTintColor:
            Colors.transparent,


        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                _radiusLarge,
              ),

        ),

      ),






      bottomSheetTheme:
          BottomSheetThemeData(

        showDragHandle:
            true,


        backgroundColor:
            scheme.surface,


        surfaceTintColor:
            Colors.transparent,


        shape:
            const RoundedRectangleBorder(

          borderRadius:
              BorderRadius.vertical(

            top:
                Radius.circular(
                  24,
                ),

          ),

        ),

      ),





      pageTransitionsTheme:
          const PageTransitionsTheme(

        builders: {

          TargetPlatform.android:
              FadeForwardsPageTransitionsBuilder(),


          TargetPlatform.iOS:
              CupertinoPageTransitionsBuilder(),

        },

      ),

    );

  }

  




  // ===========================================================================
  // Typography
  // ===========================================================================


  static TextTheme _textTheme(
    TextTheme base,
  ) {

    return base.copyWith(


      displayLarge:
          base.displayLarge?.copyWith(

        fontWeight:
            FontWeight.w700,

        letterSpacing:
            -1.5,

      ),



      displayMedium:
          base.displayMedium?.copyWith(

        fontWeight:
            FontWeight.w700,

      ),



      headlineLarge:
          base.headlineLarge?.copyWith(

        fontWeight:
            FontWeight.w700,

      ),



      headlineMedium:
          base.headlineMedium?.copyWith(

        fontWeight:
            FontWeight.w700,

      ),



      titleLarge:
          base.titleLarge?.copyWith(

        fontWeight:
            FontWeight.w600,

      ),



      titleMedium:
          base.titleMedium?.copyWith(

        fontWeight:
            FontWeight.w600,

      ),



      bodyLarge:
          base.bodyLarge?.copyWith(

        height:
            1.5,

      ),



      bodyMedium:
          base.bodyMedium?.copyWith(

        height:
            1.45,

      ),



      labelLarge:
          base.labelLarge?.copyWith(

        fontWeight:
            FontWeight.w600,

      ),


    );

  }








  // ===========================================================================
  // App Bar
  // ===========================================================================


  static AppBarTheme _appBarTheme(
    ColorScheme scheme,
  ) {


    return AppBarTheme(

      centerTitle:
          false,


      elevation:
          0,


      scrolledUnderElevation:
          0,


      backgroundColor:
          scheme.surface,


      foregroundColor:
          scheme.onSurface,


      surfaceTintColor:
          Colors.transparent,


      titleTextStyle:
          GoogleFonts.inter(

        fontSize:
            20,


        fontWeight:
            FontWeight.w700,


        color:
            scheme.onSurface,


      ),

    );

  }








  // ===========================================================================
  // Card Theme
  // ===========================================================================


  static CardThemeData _cardTheme(
    ColorScheme scheme,
  ) {


    return CardThemeData(

      elevation:
          0,


      margin:
          EdgeInsets.zero,


      color:
          scheme.surfaceContainer,


      surfaceTintColor:
          Colors.transparent,


      shadowColor:
          scheme.shadow.withValues(
            alpha: 0.12,
          ),


      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(
              _radiusLarge,
            ),

      ),

    );

  }








  // ===========================================================================
  // Input Fields
  // ===========================================================================


  static InputDecorationTheme _inputDecorationTheme(
    ColorScheme scheme,
  ) {


    OutlineInputBorder border(
      Color color,
      [
        double width = 1,
      ]
    ) {

      return OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
              _radiusMedium,
            ),


        borderSide:
            BorderSide(

          color:
              color,


          width:
              width,


        ),

      );

    }





    return InputDecorationTheme(


      filled:
          true,


      fillColor:
          scheme.surfaceContainerHighest,



      contentPadding:
          const EdgeInsets.symmetric(

        horizontal:
            16,


        vertical:
            18,


      ),




      border:
          border(
            scheme.outlineVariant,
          ),



      enabledBorder:
          border(
            scheme.outlineVariant,
          ),




      focusedBorder:
          border(
            scheme.primary,
            2,
          ),




      errorBorder:
          border(
            scheme.error,
          ),




      focusedErrorBorder:
          border(
            scheme.error,
            2,
          ),




      labelStyle:
          GoogleFonts.inter(

        fontWeight:
            FontWeight.w500,

      ),



      hintStyle:
          GoogleFonts.inter(

        color:
            scheme.onSurfaceVariant,

      ),


    );

  }

  



  // ===========================================================================
  // Button Themes
  // ===========================================================================


  static FilledButtonThemeData _filledButtonTheme() {


    return FilledButtonThemeData(

      style:
          FilledButton.styleFrom(

        minimumSize:
            const Size(
              double.infinity,
              52,
            ),


        padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
            ),


        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                _radiusMedium,
              ),

        ),



        textStyle:
            GoogleFonts.inter(

          fontWeight:
              FontWeight.w600,

        ),

      ),

    );

  }






  static ElevatedButtonThemeData _elevatedButtonTheme() {


    return ElevatedButtonThemeData(

      style:
          ElevatedButton.styleFrom(

        minimumSize:
            const Size(
              double.infinity,
              52,
            ),



        elevation:
            1,



        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                _radiusMedium,
              ),

        ),



        textStyle:
            GoogleFonts.inter(

          fontWeight:
              FontWeight.w600,

        ),

      ),

    );

  }







  static OutlinedButtonThemeData _outlinedButtonTheme() {


    return OutlinedButtonThemeData(

      style:
          OutlinedButton.styleFrom(

        minimumSize:
            const Size(
              double.infinity,
              52,
            ),



        side:
            const BorderSide(

          width:
              1,

        ),



        shape:
            RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(
                _radiusMedium,
              ),

        ),



        textStyle:
            GoogleFonts.inter(

          fontWeight:
              FontWeight.w600,

        ),

      ),

    );

  }








  // ===========================================================================
  // Snackbar
  // ===========================================================================


  static SnackBarThemeData _snackBarTheme() {


    return SnackBarThemeData(

      behavior:
          SnackBarBehavior.floating,



      elevation:
          4,



      shape:
          RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(
              _radiusMedium,
            ),

      ),



      contentTextStyle:
          GoogleFonts.inter(

        fontWeight:
            FontWeight.w500,

      ),

    );

  }

}