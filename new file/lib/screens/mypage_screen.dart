import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/constants.dart';
import 'login_screen.dart';
import 'sub_page_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _currentUser?.displayName ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showEditNameDialog() async {
    // 다이얼로그가 열릴 때 현재 이름으로 컨트롤러 값을 다시 설정합니다.
    _nameController.text = _currentUser?.displayName ?? "";
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이름 수정'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "새로운 이름을 입력하세요"),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('저장', style: TextStyle(color: kLgRed)),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  await _currentUser?.updateDisplayName(_nameController.text);
                  await _currentUser?.reload(); // 최신 사용자 정보를 가져옵니다.
                  // 사용자 정보가 업데이트되었으므로 화면을 다시 빌드하여 최신 정보를 표시합니다.
                  if (mounted) {
                    setState(() {});
                  }
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("마이페이지", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        // 1. 여기에 뒤로가기 버튼을 명시적으로 다시 추가합니다.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_currentUser?.displayName ?? "이름 없음", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextDark), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 5),
                      Text(_currentUser?.email ?? "이메일 정보 없음", style: const TextStyle(fontSize: 14, color: Colors.grey), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _showEditNameDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("내 정보 수정", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.edit, size: 14, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
             const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMembershipItem("멤버십 포인트", "1,250 P"),
                  Container(width: 1, height: 40, color: Colors.grey[200]),
                  _buildMembershipItem("보유 쿠폰", "2 장"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Column(
                 children: [
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextDark)),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
