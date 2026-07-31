import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// Profile & Settings screen — matches the Figma frame with
// Notifications / Security / Language / Support rows and logout.
//
// userProgram/userLocation from the original Figma frame were dropped:
// UserEntity has no program or location field, so there was nothing real
// to show there. userBio (which does exist on UserEntity) takes their
// place as the header's subtitle.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.userName,
    required this.onLogout,
    this.userBio,
    this.onNotificationsTap,
    this.onSecurityTap,
    this.onLanguageTap,
    this.onSupportTap,
    this.profileImageUrl,
  });

  final String userName;
  final String? userBio;
  final VoidCallback onLogout;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSecurityTap;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onSupportTap;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'EduBridge',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _ProfileHeader(
              name: userName,
              bio: userBio,
              imageUrl: profileImageUrl,
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              onNotificationsTap: onNotificationsTap,
              onSecurityTap: onSecurityTap,
              onLanguageTap: onLanguageTap,
              onSupportTap: onSupportTap,
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: onLogout,
                child: const Text(
                  'Logout Account',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    this.bio,
    this.imageUrl,
  });

  final String name;
  final String? bio;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.infoBg,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? const Icon(Icons.person, color: AppColors.primaryBlue, size: 32)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.deepNavy,
            ),
          ),
          if (bio != null && bio!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              bio!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    this.onNotificationsTap,
    this.onSecurityTap,
    this.onLanguageTap,
    this.onSupportTap,
  });

  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSecurityTap;
  final VoidCallback? onLanguageTap;
  final VoidCallback? onSupportTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ACCOUNT SETTINGS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          _SettingsRow(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Alerts, Email, Application Updates',
            onTap: onNotificationsTap,
          ),
          const Divider(height: 1, color: AppColors.border),
          _SettingsRow(
            icon: Icons.shield_outlined,
            title: 'Security',
            subtitle: 'Password, Two-factor Auth, Biometrics',
            onTap: onSecurityTap,
          ),
          const Divider(height: 1, color: AppColors.border),
          _SettingsRow(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: onLanguageTap,
          ),
          const Divider(height: 1, color: AppColors.border),
          _SettingsRow(
            icon: Icons.help_outline,
            title: 'Support',
            subtitle: 'Help Center, FAQ, Contact Us',
            onTap: onSupportTap,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.infoBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
    );
  }
}