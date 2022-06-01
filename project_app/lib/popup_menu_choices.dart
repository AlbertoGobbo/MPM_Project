import 'package:flutter/material.dart';

class PopupMenuChoices {
  const PopupMenuChoices({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

const List<PopupMenuChoices> choices = <PopupMenuChoices>[
  PopupMenuChoices(title: 'Help', icon: Icons.help),
  PopupMenuChoices(title: 'Logout', icon: Icons.logout),
];
