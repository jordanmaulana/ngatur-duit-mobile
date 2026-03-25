import '../../../../base/export_view.dart';

import '../../controllers/profile_controller.dart';

class ProfileLogoutButton extends StatelessWidget {
  final ProfileController controller;
  const ProfileLogoutButton({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.logout(),
      child: Row(
        spacing: context.smPadding,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedLogout01,
            color: VColor.greyText,
          ),
          VText("Logout"),
        ],
      ),
    );
  }
}
