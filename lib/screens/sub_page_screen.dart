import 'package:flutter/material.dart';
import '../theme/constants.dart';

class SubPageScreen extends StatelessWidget {
  final String title; // 페이지 제목 (예: 구매 내역)
  final String content; // 페이지 내용 (예: 구매 내역이 없습니다.)

  const SubPageScreen({
    super.key,
    required this.title,
    this.content = "준비 중인 서비스입니다.", // 기본 내용
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 60, color: Colors.grey[300]), // 공사중 아이콘
            const SizedBox(height: 20),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}