import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class RecentFile {
  final String icon;
  final String title;
  final String date;
  final String size;

  RecentFile({
    required this.icon,
    required this.title,
    required this.date,
    required this.size,
  });
}

List<RecentFile> generateRecentFiles() {
  return [
    _createRecentFile("XD File", "01-03-2021", "3.5mb", "xd_file.svg"),
    _createRecentFile("Figma File", "27-02-2021", "19.0mb", "Figma_file.svg"),
    _createRecentFile("Document", "23-02-2021", "32.5mb", "doc_file.svg"),
    _createRecentFile("Sound File", "21-02-2021", "3.5mb", "sound_file.svg"),
    _createRecentFile("Media File", "23-02-2021", "2.5gb", "media_file.svg"),
    _createRecentFile("Sales PDF", "25-02-2021", "3.5mb", "pdf_file.svg"),
    _createRecentFile("Excel File", "25-02-2021", "34.5mb", "excel_file.svg"),
  ];
}

RecentFile _createRecentFile(String title, String date, String size, String icon) {
  return RecentFile(
    icon: "assets/icons/$icon",
    title: title,
    date: date,
    size: size,
  );
}

void main() {
  List<RecentFile> demoRecentFiles = generateRecentFiles();

  // Utilisez demoRecentFiles comme vous le feriez normalement dans le reste de votre code.
}
