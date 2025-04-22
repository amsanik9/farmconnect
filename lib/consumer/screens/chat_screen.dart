import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chat';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildChatList(context),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    // Mock chat data
    final chats = [
      {
        'name': 'Green Valley Farm',
        'avatar': 'G',
        'lastMessage': 'Your offer for Fresh Tomatoes has been accepted!',
        'time': '2 hours ago',
        'unread': true,
        'productName': 'Fresh Tomatoes',
      },
      {
        'name': 'Orchard Hills',
        'avatar': 'O',
        'lastMessage': 'We\'ll have fresh apples available next week as well.',
        'time': '1 day ago',
        'unread': false,
        'productName': 'Organic Apples',
      },
      {
        'name': 'Meadow Dairy',
        'avatar': 'M',
        'lastMessage': 'Thank you for your order. We hope you enjoyed our milk!',
        'time': '3 days ago',
        'unread': false,
        'productName': 'Fresh Milk',
      },
    ];

    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When you communicate with farmers, you\'ll see messages here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (ctx, i) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Text(
            chats[i]['avatar'] as String,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ),
        title: Text(
          chats[i]['name'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          chats[i]['lastMessage'] as String,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              chats[i]['time'] as String,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            if (chats[i]['unread'] as bool)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () {
          // Navigate to conversation using named route
          Navigator.of(context).pushNamed(
            ChatDetailScreen.routeName,
            arguments: {
              'farmerName': chats[i]['name'] as String,
              'productName': chats[i]['productName'] as String,
            },
          );
        },
      ),
    );
  }
} 