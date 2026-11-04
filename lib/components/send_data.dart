import 'dart:convert';

import 'package:attendance_check/components/user_info.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// 사용자 정보를 받아와서 현재 날짜 및 시간과 함께 서버로 저장하는 클래스
class SendData {
  final userInfo = UserInfo();   // 저장된 사용자 정보 싱글톤 클래스에서 데이터를 바로 꺼내서 사용

  Future<void> sendDataToServer() async {
    // 현재 날짜와 시간 (ISO 8601 Format : YYYY-MM-DDTHH:mm:ss.sssZ)
    // String currentTime = DateTime.now().toIso8601String();
    DateTime now = DateTime.now(); 
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);   // DateFormat을 사용해 형식 변환

    print(formattedDate);   // 콘솔에서 저장 결과 확인

    // 서버로 보낼 데이터 구조 만들기
    Map<String, dynamic> requestBody = {
      'createdAt': formattedDate,   // 형식 변환한 현재 날짜 및 시간
      'name': userInfo.userName,
      'email': userInfo.userEmail,
    };

    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/');   // 서버 전송 (실제 서버 URL로 변경 필요)
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',   // JSON 형태로 전송 명시
        },
        body: jsonEncode(requestBody),   // Map을 JSON 문자열로 변환
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Save successful : ${response.body}');
      } else {
        print('Save failure (status code) : ${response.statusCode}');
      }
    } catch (e) {
      print('Network error : $e');
    }
  }
}