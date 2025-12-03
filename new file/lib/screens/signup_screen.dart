import 'package:firebase_auth/firebase_auth.dart'; // 1. Firebase Auth 패키지 import
import 'package:flutter/material.dart';
import '../theme/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController(); // ID -> email로 명확하게 변경
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false; // 2. 로딩 상태 변수 추가

  // 3. Firebase 회원가입 함수로 수정
  Future<void> _handleSignUp() async {
    // 위젯이 마운트되지 않았다면 함수를 실행하지 않음
    if (!mounted) return;

    String email = _emailController.text.trim();
    String pw = _pwController.text.trim();
    String pwConfirm = _pwConfirmController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || pw.isEmpty || name.isEmpty) {
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

    // 로딩 시작
    setState(() {
      _isLoading = true;
    });

    try {
      // Firebase Auth로 새로운 사용자 생성
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pw,
      );
      
      // 사용자 이름(DisplayName) 업데이트
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload(); // 최신 사용자 정보 가져오기

      if (mounted) {
        // 성공 다이얼로그 표시
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("환영합니다!"),
            content: Text("$name님, 회원가입이 완료되었습니다.\n로그인 해주세요."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  Navigator.pop(context); // 회원가입 화면 닫기
                },
                child: const Text("확인", style: TextStyle(color: kLgRed)),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Firebase 에러 처리
      String errorMessage = "회원가입에 실패했습니다. 다시 시도해주세요.";
      if (e.code == 'weak-password') {
        errorMessage = '비밀번호는 6자리 이상이어야 합니다.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = '이미 사용 중인 이메일입니다.';
      } else if (e.code == 'invalid-email') {
        errorMessage = '유효하지 않은 이메일 형식입니다.';
      }
       if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
       }
    } catch (e) {
      // 기타 에러 처리
       if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("알 수 없는 오류가 발생했습니다: $e")),
          );
       }
    } finally {
      // 로딩 종료
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _pwConfirmController.dispose();
    _nameController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
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
            // ID -> email 컨트롤러로 변경
            _buildInputField("아이디 (이메일)", _emailController, false),
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
                  backgroundColor: kLgRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[400], // 비활성화 색상
                ),
                // 4. 로딩 중일 때 버튼 비활성화, _handleSignUp 함수 연결
                onPressed: _isLoading ? null : _handleSignUp,
                // 5. 로딩 인디케이터 또는 텍스트 표시
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("가입하기", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
