import 'package:flx_core_flutter/flx_core_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({
    required this.title,
    required this.subtitle,
    required this.onLogout,
    required this.onChangePassword,
    super.key,
    this.padding,
  });

  final double? padding;
  final String title;
  final String subtitle;
  final void Function() onLogout;
  final void Function(BuildContext context) onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 8),
      child: GestureDetector(
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (context) => _PopUpDialogProfile(
              title,
              subtitle,
              onLogout,
              onChangePassword,
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'asset/image/avatar.png',
          ),
        ),
      ),
    );
  }
}

class AvatarNameEmail extends StatelessWidget {
  const AvatarNameEmail({
    required this.title,
    required this.subtitle,
    required this.onLogout,
    required this.onChangePassword,
    required this.isOnPop,
    this.avatarWidth = 70,
    super.key,
  });

  final double avatarWidth;
  final String title;
  final String subtitle;
  final void Function() onLogout;
  final void Function(BuildContext context) onChangePassword;
  final bool isOnPop;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: isOnPop
              ? null
              : () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => _PopUpDialogProfile(
                      title,
                      subtitle,
                      onLogout,
                      onChangePassword,
                    ),
                  );
                },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(avatarWidth / 2),
            child: SizedBox(
              width: avatarWidth,
              child: Image.asset('asset/image/avatar.png'),
            ),
          ),
        ),
        const Gap(24),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PopUpDialogProfile extends StatelessWidget {
  const _PopUpDialogProfile(
    this.title,
    this.subtitle,
    this.onLogout,
    this.onChangePassword,
  );

  final String title;
  final String subtitle;
  final void Function() onLogout;
  final void Function(BuildContext context) onChangePassword;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusPopup),
      ),
      contentPadding: EdgeInsets.zero,
      children: [
        const Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: paddingHorizontalPage,
            vertical: 12,
          ),
          child: AvatarNameEmail(
            isOnPop: true,
            onLogout: onLogout,
            onChangePassword: onChangePassword,
            title: title,
            subtitle: subtitle,
          ),
        ),
        const Gap(12),
        const Divider(height: 0),
        _ListMenu(
          color: Colors.orange,
          icon: const Icon(Icons.account_box),
          label: 'Profile',
          onTap: () {},
        ),
        const Divider(height: 0),
        _ListMenu(
          color: Colors.green,
          icon: const Icon(Icons.key),
          label: 'Change Password',
          onTap: () => onChangePassword(context),
        ),
        const Divider(height: 0),
        _ListMenu(
          color: Colors.red,
          icon: const Icon(Icons.exit_to_app),
          label: 'Log out',
          onTap: () async {
            final logout = await showDialogLogout(context: context);
            if (logout ?? false) {
              onLogout();
              Navigator.pop(context);
            }
          },
        ),
        const Gap(12),
      ],
    );
  }
}

class _ListMenu extends StatelessWidget {
  const _ListMenu({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final String label;
  final Icon icon;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: paddingHorizontalPage,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.lighten(.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: IconTheme(
                data: const IconThemeData(
                  color: Colors.white,
                ),
                child: icon,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }
}
