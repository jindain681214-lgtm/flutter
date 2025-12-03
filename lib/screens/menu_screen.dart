import 'package:flutter/material.dart';
import '../theme/constants.dart';
import 'login_screen.dart';
import 'mypage_screen.dart';
import 'sub_page_screen.dart'; // [수정] 따옴표 오류 수정완료

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9), // 전체 배경색
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7F9),
        elevation: 0,
        title: const Text(
          "LG ThinQ",
          style: TextStyle(fontWeight: FontWeight.bold, color: kTextDark),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign, color: Colors.grey), // 확성기 아이콘
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey), // 설정 아이콘
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 상단 탭 (마이페이지 | 고객 지원)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // [1] 마이페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyPageScreen()),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("마이페이지", style: TextStyle(color: kTextDark, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    VerticalDivider(color: Colors.grey[300], thickness: 1, width: 1, indent: 10, endIndent: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // [2] 고객 지원 페이지로 이동 (서브 페이지 활용)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SubPageScreen(
                                    title: "고객 지원",
                                    content: "서비스 예약 및 상담 센터입니다."
                                )
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text("고객 지원", style: TextStyle(color: kTextDark, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 2. 쿠폰 배너
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE), // 연한 빨강 배경
                      borderRadius: BorderRadius.circular(22.5),
                    ),
                    child: const Icon(Icons.confirmation_number_outlined, color: kLgRed),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("시크릿 쿠폰 프로모션", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(height: 4),
                      Text("ThinQ 회원 최대 12% 할인", style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Text("~ 2025. 11. 28.", style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. 섹션 타이틀
            const Text("제품 사용과 관리", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),

            // 4. 리스트 메뉴 (위치 변경)
            GestureDetector(
              onTap: () {
                // [3] 이 버튼을 누르면 시나리오(위치) 설정 Drawer가 열립니다.
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: kLgRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.map, size: 18, color: Colors.white), // 지도 아이콘
                    ),
                    const SizedBox(width: 15),
                    const Text("위치 변경", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: kTextDark)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),

            // 5. 하단 푸터 링크
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("LGE.COM", style: TextStyle(color: Colors.grey, fontSize: 12)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("|", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
                Text("LG전자 멤버십", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 30),

            // 6. 로그아웃 버튼
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // [4] 로그아웃 -> 로그인 페이지로 이동
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false, // 뒤로가기 방지 (모든 스택 제거)
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[300]!),
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("로그아웃", style: TextStyle(color: kLgRed, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}