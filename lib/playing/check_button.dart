import 'package:flutter/material.dart';

const double defaultBorderRadius = 3.0;

class StretchableButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double borderRadius;
  final double buttonPadding;
  final Color buttonColor, splashColor;
  final Color buttonBorderColor;
  final List<Widget> children;
  final bool centered;

  StretchableButton({
    @required this.buttonColor,
    @required this.borderRadius,
    @required this.children,
    this.splashColor,
    this.buttonBorderColor,
    this.onPressed,
    this.buttonPadding,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var contents = List<Widget>.from(children);

        if (constraints.minWidth == 0) {
          contents.add(SizedBox.shrink());
        } else {
          if (centered) {
            contents.insert(0, Spacer());
          }
          contents.add(Spacer());
        }

        BorderSide bs;
        if (buttonBorderColor != null) {
          bs = BorderSide(
            color: buttonBorderColor,
          );
        } else {
          bs = BorderSide.none;
        }

        return ButtonTheme(
          height: 40.0,
          padding: EdgeInsets.all(buttonPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: bs,
          ),
          child: RaisedButton(
            onPressed: onPressed,
            color: buttonColor,
            splashColor: splashColor,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: contents,
            ),
          ),
        );
      },
    );
  }
}

enum NiceButtonStyle { white, whiteOutline, black }

/// A sign in button that matches Apple's design guidelines.
class NiceButton extends StatelessWidget {
  final String text;
  final NiceButtonStyle style;
  final double borderRadius;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  final Color splashColor;
  final bool centered;

  /// Creates a new button. Set [darkMode] to `true` to use the dark
  /// black background variant with white text, otherwise an all-white background
  /// with dark text is used.
  NiceButton(
      {this.onPressed,
      // 'Continue with Apple' is also an available variant depdening on App's sign-in experience.
      this.text = 'I won!',
      this.textStyle,
      this.splashColor,
      this.style = NiceButtonStyle.white,
      // Apple doesn't specify a border radius, but this looks about right.
      this.borderRadius = defaultBorderRadius,
      this.centered = false,
      Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      buttonColor: style == NiceButtonStyle.black ? Colors.black : Colors.white,
      borderRadius: borderRadius,
      splashColor: splashColor,
      buttonBorderColor:
          style == NiceButtonStyle.whiteOutline ? Colors.black : null,
      onPressed: onPressed,
      buttonPadding: 0.0,
      centered: centered,
      children: <Widget>[
        Center(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 22.0, bottom: 3.0),
                child: Container(
                  height: 38.0,
                  width: 32.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(this.borderRadius),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.verified,
                      size: 17,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 32.0, 8.0),
                child: Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: style == NiceButtonStyle.black
                              ? Colors.white
                              : Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
