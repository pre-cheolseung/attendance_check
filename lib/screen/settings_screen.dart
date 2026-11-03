import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);   // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수

  @override
  // State<SettingsScreen> createState() => _SettingsScreenState();
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 텍스트 입력을 제어하기 위한 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _savedName = "No name has been registered.";
  String _savedEmail = "No e-mail has been registered.";

  @override
  void initState() {
    super.initState();
    _loadSavedData();   // 페이지가 시작될 때 저장된 이름 호출
  }

  // 저장된 이름을 불러오는 함수
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    // 상태 변경 시 setState() 함수 실행
    // 값 변경 시 build() 함수 재실행
    // Clean -> setState() -> Dirty -> build() -> Clean
    setState(() {
      // 'user_name' 키로 저장된 값을 호출 (없으면 null 반환하므로 기본값 설정)
      _savedName = prefs.getString('user_name') ?? "No name has been registered.";
      _savedEmail = prefs.getString('user_email') ?? "No e-mail has been registered.";
      _nameController.text = prefs.getString('user_name') ?? "";
      _emailController.text = prefs.getString('user_email') ?? "";
    });
  }

  // 입력한 이름을 저장하는 함수
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_email', _emailController.text);
    
    // 저장 후 화면 갱신
    _loadSavedData();
    
    // 저장 완료 알림창
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.deepPurpleAccent,
          content: Text(
            'Personal settings have been saved.',
            // style: TextStyle(
            //   color: Colors.white,
            // ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Personal Settings',
          style: TextStyle(
            color: Colors.deepPurpleAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 저장된 정보 표시 영역
            UserAccountsDrawerHeader(
              accountName: Text(_savedName),
              accountEmail: Text(_savedEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            // 이름 수정 입력창
            const Text(
              'Edit name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Please enter a name.',
              ),
            ),
            const SizedBox(height: 16),
            // 이메일 수정 입력창
            const Text(
              'Edit e-mail',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Please enter a e-mail.',
              ),
            ),
            Spacer(),   // 중간의 남은 공간을 모두 차지하여 아래 위젯을 가장 밑으로 배치
            // 저장 버튼
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // // 설정 상태값 변수들
  // bool _pushNotification = true;
  // bool _darkMode = false;
  // String _selectedLanguage = 'English';

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       title: const Text(
  //         'Personal Settings',
  //         style: TextStyle(
  //           color: Colors.deepPurpleAccent,
  //           fontWeight: FontWeight.w700,
  //         ),
  //       ),
  //       elevation: 0,
  //     ),
  //     body: ListView(
  //       children: [
  //         // 프로필 영역
  //         UserAccountsDrawerHeader(
  //           accountName: const Text('Cheolseung'),
  //           accountEmail: const Text('Pre.Cheolseung@Gmail.com'),
  //           currentAccountPicture: const CircleAvatar(
  //             backgroundColor: Colors.white,
  //             child: Icon(
  //               Icons.person,
  //               size: 40,
  //               color: Colors.grey,
  //             ),
  //           ),
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).primaryColor,
  //           ),
  //         ),
  //         // 알림 설정 섹션
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
  //           child: Text(
  //             'Notification',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ),
  //         SwitchListTile(
  //           secondary: const Icon(Icons.notifications_active),
  //           title: const Text('Receive push notifications'),
  //           value: _pushNotification,
  //           onChanged: (bool value) {
  //             setState(() {
  //               _pushNotification = value;
  //             });
  //           },
  //         ),
  //         const Divider(),
  //         // 화면 테마 섹션
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
  //           child: Text(
  //             'Screen and Display',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ),
  //         SwitchListTile(
  //           secondary: const Icon(Icons.dark_mode),
  //           title: const Text('Dark mode'),
  //           value: _darkMode,
  //           onChanged: (bool value) {
  //             setState(() {
  //               _darkMode = value;
  //             });
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.language),
  //           title: const Text('Language selection'),
  //           trailing: Text(_selectedLanguage),
  //           onTap: () {
  //             // 언어 변경 다이얼로그나 페이지 이동
  //           },
  //         ),
  //         const Divider(),
  //         // 계정 및 지원 섹션
  //         const Padding(
  //           padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
  //           child: Text(
  //             'Account',
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.lock),
  //           title: const Text('Change password'),
  //           onTap: () {
  //             // 비밀번호 변경 페이지로 이동
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(
  //             Icons.logout,
  //             color: Colors.red,
  //           ),
  //           title: const Text(
  //             'Sign out',
  //             style: TextStyle(color: Colors.red),
  //           ),
  //           onTap: () {
  //             // 로그아웃 처리
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}