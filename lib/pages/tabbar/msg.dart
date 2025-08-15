import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  static const chatData = [
    {
      'name': '小明',
      'message': '你好啊，最近怎么样？',
      'time': '12:30',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 2,
    },
    {
      'name': '系统客服',
      'message': '您的订单已发货。',
      'time': '昨天',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 0,
    },
    {
      'name': '群聊：Flutter技术群',
      'message': '[图片]',
      'time': '周一',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 8,
    },
    {
      'name': '小明',
      'message': '你好啊，最近怎么样？',
      'time': '12:30',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 2,
    },
    {
      'name': '系统客服',
      'message': '您的订单已发货。',
      'time': '昨天',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 0,
    },
    {
      'name': '群聊：Flutter技术群',
      'message': '[图片]',
      'time': '周一',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 8,
    },
    {
      'name': '小明',
      'message': '你好啊，最近怎么样？',
      'time': '12:30',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 2,
    },
    {
      'name': '系统客服',
      'message': '您的订单已发货。',
      'time': '昨天',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 0,
    },
    {
      'name': '群聊：Flutter技术群',
      'message': '[图片]',
      'time': '周一',
      'avatar': 'https://cdn-www.huorong.cn/Public/Uploads/uploadfile/images/20240301/comlogo.png',
      'unread': 8,
    },
  ];

  List<Map<String, dynamic>> filteredData = List.from(chatData);

  void _onSearchChanged(String keyword) {
    setState(() {
      filteredData = filterMessages(keyword, chatData);
    });
  }

  List<Map<String, dynamic>> filterMessages(
      String keyword, List<Map<String, dynamic>> messages) {
    if (keyword.isEmpty) return messages;

    final query = keyword.toLowerCase();
    return messages.where((msg) {
      final name = msg['name']?.toString().toLowerCase() ?? '';
      final message = msg['message']?.toString().toLowerCase() ?? '';
      return name.contains(query) || message.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('消息')),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSystemNotificationCard(),
          Expanded(child: _buildChatList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: '搜索消息',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildSystemNotificationCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_active, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text('您有新的系统通知，点击查看详情。', style: TextStyle(fontSize: 14)),
          ),
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final item = filteredData[index];
        return _buildChatItem(item);
      },
    );
  }

  Widget _buildChatItem(Map<String, dynamic> item) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(item['avatar']),
            radius: 24,
          ),
          if (item['unread'] > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${item['unread']}',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
          Text(item['time'], style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      subtitle: Text(
        item['message'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {},
    );
  }
}
