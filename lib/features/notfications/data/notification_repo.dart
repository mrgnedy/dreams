import 'package:dreams/const/urls.dart';
import 'package:dreams/features/notfications/data/notification_model.dart';
import 'package:dreams/utils/network_client.dart';

class NotificationRepo {
  final client = NetworkClient();

  Future<NotificationModel> getNotifications() async {
    const url = URLs.GET_NOTIFICATION;
    final req = await client.getRequest(url);
    return NotificationModel.fromMap(req);
  }

  Future<NotificationModel> deleteNotifications(int id) async {
    final url = URLs.DELETE_NOTIFICATION + "$id";
    final req = await client.getRequest(url);
    return NotificationModel.fromMap(req);
  }
}
