import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradelinkedai/core/providers/auth.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final bool showLogoutIcon; // New parameter to control the display of the logout icon

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.centerTitle = false,
    this.showLogoutIcon = false, // Default value is false
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0); // Provide preferred size here
}

class _CustomAppBarState extends State<CustomAppBar> {
  void _onLogout() {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: Row(
        mainAxisAlignment: widget.centerTitle ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          if (widget.onBackPressed != null)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button icon
              onPressed: widget.onBackPressed, // Trigger the callback
            ),
          // Center the title if specified, otherwise space it with the back button
          Expanded(
            child: Text(
              widget.title,
              textAlign: widget.centerTitle ? TextAlign.center : TextAlign.start,
              style: const TextStyle(
                fontSize: 20.0, // Adjust font size
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          if (widget.showLogoutIcon) // Show logout icon if showLogoutIcon is true
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white), // Logout button icon
              onPressed: _onLogout, // Call logout method
            ),
        ],
      ),
    );
  }
}
