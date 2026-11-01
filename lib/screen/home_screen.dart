import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';

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

  // 위치 마커 선언
  static final Marker marker = Marker(
    markerId: MarkerId('place'),
    position: placeLatLng,
  );

  // 현재 위치 반경 표시
  static final Circle circle = Circle(
    circleId: CircleId('attendanceCheckCircle'),
    center: placeLatLng,   // 원의 중심이 되는 위치로 LatLng 값을 제공
    fillColor: Colors.blueAccent.withValues(alpha: 0.5),   // 원의 색상
    radius: 100,   // 원의 반지름 (미터 단위)
    strokeColor: Colors.blueAccent,   // 원의 테두리 색
    strokeWidth: 1,   // 원의 테두리 두께
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 로딩 상태
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // 위치 권한 허가 상태
          if (snapshot.data == 'Location permission has been granted.') {
            return Column(
              children: [
                // 공간의 2/3 만큼 차지
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: placeLatLng,
                      zoom: 18,   // 확대 정도 (높을수록 크게 보임)
                    ),
                    markers: Set.from([marker]),   // Set으로 Marker 제공
                    circles: Set.from([circle]),   // Set으로 Circle 제공
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
            );
          }
          // 위치 권한 없는 상태
          return Center(
            child: Text(
              snapshot.data.toString(),
            ),
          );
        }
      )
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

  // 위치 권한 사용 여부 확인 후, 사용할 수 없는 상태일 경우 권한을 재요청하는 함수
  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();   // 위치 서비스 활성화 여부 확인

    // 위치 서비스 활성화 안됨
    if (!isLocationEnabled) {
      return 'Please enable location services.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();   // 위치 권한 확인

    // 위치 권한이 허가되지 않은 경우 요청
    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return 'Please grant location permission.';
      }
    }

    // 위치 권한이 허가되지 않았고 앱에서 재요청이 불가한 경우 요청
    if (checkedPermission == LocationPermission.deniedForever) {
      return 'Please grant the app location permission in Settings.';
    }

    return 'Location permission has been granted.';   // 위 조건이 모두 만족되면 위치 권한 허가 완료
  }
}