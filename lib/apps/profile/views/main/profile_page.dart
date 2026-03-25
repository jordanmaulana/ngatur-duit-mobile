import '../../../../base/export_view.dart';

import '../../controllers/profile_controller.dart';
import 'profile_logout_button.dart';
import 'profile_name_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.find();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(height: 120.0, color: VColor.primary),
                Expanded(child: Container(color: VColor.white)),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(context.lgPadding),
              child: Column(
                spacing: context.lgPadding,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VText(
                    "My Profile",
                    fontSize: 24,
                    color: VColor.white,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: VStyle.boxShadow(),
                    padding: EdgeInsets.all(context.mdPadding),
                    child: GetBuilder<ProfileController>(
                      builder: (_) {
                        return Column(
                          spacing: context.mdPadding,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileNameSection(controller: controller),
                            Divider(),
                            ProfileLogoutButton(controller: controller),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
