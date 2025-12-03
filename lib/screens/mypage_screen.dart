import 'package:flutter/material.dart';
import '../theme/constants.dart';
import 'sub_page_screen.dart'; // [중요] 서브 페이지 import

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text("마이페이지", style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. 프로필 섹션
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text("사용자", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextDark)),
                        SizedBox(width: 5),
                        Icon(Icons.edit, size: 16, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // [연동 1] 내 정보 수정 버튼
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubPageScreen(title: "내 정보 수정", content: "회원 정보를 수정하는 화면입니다.")));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("내 정보 수정", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. 멤버십 카드
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

            // 3. 메뉴 리스트 (클릭 기능 추가됨)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.shopping_bag_outlined, "구매 내역", "최근 구매한 제품 내역이 없습니다."),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
                  _buildMenuItem(context, Icons.devices_other, "보유 제품 관리", "등록된 제품 목록을 관리합니다."),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
                  _buildMenuItem(context, Icons.support_agent, "1:1 문의 내역", "작성하신 문의 내역이 없습니다."),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
                  _buildMenuItem(context, Icons.settings_outlined, "앱 설정", "알림 및 버전 정보를 설정합니다."),
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

  // [연동 2] 메뉴 아이템 빌더 수정 (클릭 시 이동 기능 추가)
  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String dummyContent) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // 클릭하면 SubPageScreen으로 이동하면서 제목과 내용을 전달함
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubPageScreen(title: title, content: dummyContent),
          ),
        );
      },
    );
  }
}