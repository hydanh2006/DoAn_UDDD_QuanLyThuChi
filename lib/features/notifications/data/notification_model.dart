import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String content;
  final String time;
  final IconData icon;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.content,
    required this.time,
    required this.icon,
    this.isRead = false,
  });
}
