import 'package:dreams/const/urls.dart';
import 'package:dreams/features/account/data/models/packages_model.dart';
import 'package:dreams/utils/network_client.dart';

class AccountRepo {
  final client = NetworkClient();

  Future<PackagesModel> getPackages() async {
    const url = URLs.GET_PACKAGES;
    final req = await client.getRequest(url);
    return PackagesModel.fromMap(await req);
  }

  Future subscripe(int pkgId) async {
    const url = URLs.SUBSCRIBE;
    final body = {"package_id": pkgId};
    final req = await client.postRequest(url, body);
    return PackagesModel.fromMap(await req);
  }

  Future contactUs(String name, String mail, String message) async {
    const url = URLs.CONTACT_US;
    final body = {"name": name, "email": mail, "message": message};
    final req = client.postRequest(url, body);
    return await req;
  }
}
