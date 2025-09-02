import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:calories/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../auth/screens/login_screen.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return AppBar(
      title: Text(
        'Calories',
        style: GoogleFonts.dynaPuff(
          textStyle: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        if (ModalRoute.of(context)?.settings.name != ChatScreen.routeName)
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(),
                    settings: RouteSettings(name: ChatScreen.routeName),
                  ),
                ),
            icon: Icon(LucideIcons.messageCircleMore, color: Colors.white),
          ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (ctx) => AlertDialog(
                    title: Center(child: Text("Logout")),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await authProvider.logout();
                          if (!context.mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => LoginScreen()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Logout"),
                      ),
                    ],
                  ),
            );
          },
          icon: Icon(Icons.logout, color: Colors.white),
        ),
      ],
      backgroundColor: Colors.orangeAccent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
