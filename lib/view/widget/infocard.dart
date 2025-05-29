
import 'package:flutter/material.dart';

Widget infoTile(IconData icon, String title, dynamic value) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(vertical: 4),
    leading: Icon(icon, color: Colors.lightBlueAccent),
    title: Text(
      title,
      style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.bold),
    ),
    subtitle: Text(
      value ?? "غير متوفر",
      style: TextStyle(color: Colors.white),
    ),
  );
}
