import '../../../../base/export_view.dart';

import '../../controllers/profile_controller.dart';

class ProfileNameSection extends StatelessWidget {
  final ProfileController controller;
  const ProfileNameSection({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final name =
        '${controller.profile?.firstname ?? ''} ${controller.profile?.lastname ?? ''}'
            .trim();
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: VColor.primary,
          child: HugeIcon(
            icon: HugeIcons.strokeRoundedUser,
            color: VColor.white,
          ),
        ),
        SizedBox(width: context.mdPadding),
        VText(
          name.isEmpty ? '-' : name,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ],
    );
  }
}
