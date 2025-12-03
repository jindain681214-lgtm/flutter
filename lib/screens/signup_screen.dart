import 'package:flutter/material.dart';
import '../theme/constants.dart'; // kLgRed, kTextDark 사용

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // 입력값을 관리하는 컨트롤러들
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  // 회원가입 버튼 눌렀을 때 실행되는 함수
  void _handleSignUp() {
    String id = _idController.text;
    String pw = _pwController.text;
    String pwConfirm = _pwConfirmController.text;
    String name = _nameController.text;

    // 1. 간단한 유효성 검사
    if (id.isEmpty || pw.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("모든 정보를 입력해주세요.")),
      );
      return;
    }

    if (pw != pwConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
      );
      return;
    }

    // 2. 가입 성공 시 처리 (백엔드가 없으니 성공했다고 가정)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("환영합니다!"),
        content: Text("$name님, 회원가입이 완료되었습니다.\n로그인 해주세요."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 회원가입 화면 닫기 (로그인 화면으로 돌아감)
            },
            child: const Text("확인", style: TextStyle(color: kLgRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextDark),
          onPressed: () => Navigator.pop(context), // 뒤로가기
        ),
        title: const Text("회원가입", style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "LG ThinQ와 함께\n스마트한 일상을 시작하세요.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 40),

            _buildInputField("이름", _nameController, false),
            const SizedBox(height: 20),
            _buildInputField("아이디 (이메일)", _idController, false),
            const SizedBox(height: 20),
            _buildInputField("비밀번호", _pwController, true),
            const SizedBox(height: 20),
            _buildInputField("비밀번호 확인", _pwConfirmController, true),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kLgRed, // LG Red 컬러
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: _handleSignUp,
                child: const Text("가입하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 입력창 디자인 위젯
  Widget _buildInputField(String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: "$label을(를) 입력하세요",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kTextDark, width: 2)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            isDense: true,
          ),
        ),
      ],
    );
  }
}