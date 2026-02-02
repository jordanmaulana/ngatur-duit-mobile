import 'package:ngatur_duit_mobile/apps/profile/repo/profile_repo.dart';
import 'package:ngatur_duit_mobile/ui/components/toast.dart';
import 'package:get/get.dart';

class ChangePasswordController {
  final ProfileRepo _profileRepo = Get.find<ProfileRepo>();

  RxBool obscurePassword = true.obs;
  void toggleObscurePassword() => obscurePassword(!obscurePassword.value);

  RxBool obscureNewPassword = true.obs;
  void toggleObscureNewPassword() =>
      obscureNewPassword(!obscureNewPassword.value);

  RxBool obscureNewPasswordConfirmation = true.obs;
  void toggleObscurePasswordConfirmation() =>
      obscureNewPasswordConfirmation(!obscureNewPasswordConfirmation.value);

  void submit(Map<String, String> data) async {
    final result = await _profileRepo.changePassword(data);
    result.when(
      onSuccess: (data) {
        VToast.success('Password changed successfully!');
      },
      onFailure: (error) {
        VToast.error(error);
      },
    );
  }
}
