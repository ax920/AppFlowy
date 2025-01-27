import 'empty_test.dart' as preset_af_cloud_env_test;
import 'appflowy_cloud_auth_test.dart' as appflowy_cloud_auth_test;
import 'document_sync_test.dart' as document_sync_test;
import 'user_setting_sync_test.dart' as user_sync_test;
// import 'anon_user_continue_test.dart' as anon_user_continue_test;

Future<void> main() async {
  preset_af_cloud_env_test.main();

  appflowy_cloud_auth_test.main();

  document_sync_test.main();

  user_sync_test.main();

  // anon_user_continue_test.main();
}
