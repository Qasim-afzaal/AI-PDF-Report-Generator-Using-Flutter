import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:tradelinkedai/core/extensions/build_context_extension.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText(
      {super.key, this.text, this.highlightedText, this.fontSize, this.onTap});
  final String? text, highlightedText;
  final double? fontSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: context.bodyLarge
            ?.copyWith( fontSize: fontSize),
        children: <TextSpan>[
          if (highlightedText != null)
            TextSpan(
              text: " ${highlightedText ?? ''} ",

              style: context.bodyLarge?.copyWith(
                color: context.primary,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                // decoration: TextDecoration.underline,
                decorationColor: context.primary
              ),
              recognizer: onTap == null
                  ? null
                  : (TapGestureRecognizer()..onTap = () => onTap!()),
            ),
        ],
      ),
    );
  }
}
