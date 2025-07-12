import 'package:class_management/colors.dart';
import 'package:flutter/material.dart';

class SectionButton extends StatelessWidget {
  const SectionButton({
    super.key,
    required this.section,
    this.onSectionSelect,
    required this.is180,
    required this.onIsSecSelected,
    required this.isSecSelected,
  });
  final bool is180;

  final void Function(String section)? onSectionSelect;
  final void Function(bool is180, String sectionName) onIsSecSelected;
  final bool isSecSelected;

  final String section;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          onSectionSelect != null
              ? () {
                onSectionSelect!(section);
                onIsSecSelected(is180, section);
              }
              : null,

      style: ElevatedButton.styleFrom(
        backgroundColor:
            onSectionSelect != null
                ? isSecSelected
                    ? mainC1
                    : bodyC1
                : null,
        fixedSize: Size(80, 80),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        section,
        style: TextStyle(
          fontFamily: 'font1',
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color:
              onSectionSelect != null
                  ? isSecSelected
                      ? Colors.white
                      : Colors.black
                  : null,
        ),
      ),
    );
  }
}
