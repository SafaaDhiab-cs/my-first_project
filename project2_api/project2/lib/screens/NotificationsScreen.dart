// ignore_for_file: file_names, use_super_parameters, library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/core/services/api_service.dart';
import 'package:project1/models/StudentNotification_model.dart';
import 'package:project1/widgets/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  final int studentId;

  const NotificationsScreen({Key? key, required this.studentId})
      : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<StudentNotification>> futureNotifications;
  final ApiService apiService = ApiService('http://192.168.0.250/api_inst/');
  List<StudentNotification>? notifications;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _markAllAsRead();
  }

  void _loadNotifications() {
    setState(() {
      futureNotifications =
          apiService.fetchStudentNotifications(widget.studentId);
    });
    futureNotifications.then((value) {
      if (mounted) {
        setState(() {
          notifications = value;
        });
      }
    });
  }

  Future<void> _markAllAsRead() async {
    try {
      await apiService.markNotificationsAsRead(widget.studentId);
      _loadNotifications();
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }

  Future<void> _markNotificationAsRead(int notificationId) async {
    try {
      await apiService.markNotificationAsRead(notificationId);
      _loadNotifications();
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(title: 'الاشعارات'),
      ),
      body: FutureBuilder<List<StudentNotification>>(
        future: futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد إشعارات'));
          }

          final unreadCount = snapshot.data!
              .where((notification) => notification.state == 'unread')
              .length;

          return Column(
            children: [
              if (unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.withOpacity(0.2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'لديك $unreadCount إشعارات جديدة',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final notification = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      color: notification.state == 'unread'
                          ? Colors.grey[100]
                          : Colors.white,
                      child: InkWell(
                        onTap: () {
                          if (notification.state == 'unread') {
                            _markNotificationAsRead(notification.id);
                          }
                        },
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: notification.state == 'unread'
                                  ? Colors.orange
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: notification.state == 'unread'
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                          title: Text(
                            'إشعار رقم ${notification.id}',
                            style: TextStyle(
                              fontWeight: notification.state == 'unread'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(notification.note),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(notification.date),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              if (notification.state == 'unread')
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'جديد',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
