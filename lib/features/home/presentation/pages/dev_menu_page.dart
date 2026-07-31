import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/pages/auth_flow_page.dart';
import '../../../scholarship/presentation/pages/scholarship_browse_page.dart';
import '../../../mentorship/presentation/pages/ai_mentor_chat_page.dart';
import '../../../career/presentation/pages/career_pathways_page.dart';
import '../../../cv_builder/presentation/pages/cv_builder_page.dart';
import '../../../essay_assistant/presentation/pages/essay_assistant_page.dart';
import '../../../deadline_tracker/presentation/pages/deadline_tracker_page.dart';
import '../../../community/presentation/pages/community_forum_page.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../settings/presentation/pages/settings_page.dart';

/// Temporary navigation hub until the real Home Dashboard (Person 1) is
/// pushed. Swap MyHomePage's usage in main.dart for this in the meantime.
class DevMenuPage extends StatelessWidget {
  const DevMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, WidgetBuilder)>[
      ('Auth (Login / Sign Up / Reset)', (_) => const AuthFlowPage()),
      ('Scholarships', (_) => const ScholarshipBrowsePage()),
      ('AI Mentor', (_) => const AiMentorChatPage()),
      ('Career Pathways', (_) => const CareerPathwaysPage()),
      ('CV Builder', (_) => const CvBuilderPage()),
      ('Essay Assistant', (_) => const EssayAssistantPage()),
      ('Deadline Tracker', (_) => const DeadlineTrackerPage()),
      ('Community Forum', (_) => const CommunityForumPage()),
      ('Settings', (_) => const SettingsPage()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('EduBridge AI')),
      body: ListView(
        children: [
          ...items.map((item) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item.$1),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: item.$2),
                  ),
                ),
              )),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: const Text('Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openProfile(context),
            ),
          ),
        ],
      ),
    );
  }

  void _openProfile(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in first — use "Auth" above.'),
        ),
      );
      return;
    }

    final user = authState.user;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          userName: user.fullName,
          userBio: user.bio,
          profileImageUrl:
              user.profilePictureUrl.isNotEmpty ? user.profilePictureUrl : null,
          onLogout: () {
            context.read<AuthBloc>().add(const SignOutRequested());
            Navigator.pop(context);
          },
          onNotificationsTap: () => _openSettings(context),
          onSecurityTap: () => _openSettings(context),
          onLanguageTap: () => _openSettings(context),
        ),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }
}