class UserInfo {
  UserInfo._internal();   // 생성을 위한 프라이빗 생성자

  static final UserInfo _instance = UserInfo._internal();   // 단 하나의 인스턴스를 유지할 static 변수

  factory UserInfo() => _instance;   // 외부에서 접근할 팩토리 생성자

  // 저장할 사용자 정보 변수들
  String? userName;
  String? userEmail;

  // 데이터를 한 번에 업데이트할 메서드
  void updateUserInfo({required String name, required String email}) {
    this.userName = name;
    this.userEmail = email;
  }

  // 로그아웃 등을 위한 초기화 메서드
  // void clear() {
  //   userName = null;
  //   userEmail = null;
  // }

  // 콘솔 출력을 위한 현재 사용자 정보 toString() 변환
  // @override
  // String toString() {
  //   return 'UserInfo : Name = $userName, Email = $userEmail';
  // }

  // void checkUser() {
  //   print(UserInfo);
  // }
}