import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);   // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수

  // 지도 초기화 위치
  static final LatLng placeLatLng = LatLng(
    // 서울특별시 송파구 중대로 24
    // 37.488479633317546,   // 위도
    // 127.11751596993496,   // 경도
    // 서울특별시 강동구 진황도로 14
    37.539591186964124,   // 위도
    127.12844715860939,   // 경도
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: Column(
        children: [
          // 공간의 2/3 만큼 차지
          Expanded(
            flex: 2,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: placeLatLng,
                zoom: 18,   // 확대 정도 (높을수록 크게 보임)
              ),
            ),
          ),
          // 공간의 1/3 만큼 차지
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 시계 아이콘
                Icon(
                  Icons.timelapse_outlined,
                  color: Colors.blueAccent,
                  size: 50.0,
                ),
                const SizedBox(height: 20.0),
                // [Attendance!] 버튼
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Attendance!'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // AppBar를 구현하는 함수
  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Attendance Check',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}