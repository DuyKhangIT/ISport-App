import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isport_app/assets/assets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:isport_app/main/map.dart';
import 'package:isport_app/model/account_info/account_info_response.dart';
import 'package:isport_app/model/list_data_of_device/data_list_data_of_device_response.dart';
import 'package:isport_app/model/list_data_of_device/list_data_of_device_response.dart';
import 'package:isport_app/widget/button_next.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../handle_api/handle_api.dart';
import '../model/list_device_user/data_list_device_user_response.dart';
import '../model/list_device_user/list_device_user_response.dart';
import '../until/global.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;
  late IO.Socket socket;
  final Completer<GoogleMapController> _controller = Completer();
  List<DataListDeviceUserResponse> listDeviceUser = [];
  List<DataListDataOfDeviceResponse> listDataOfDevice = [];

  Set<Marker> marker = {};
  ChartSeriesController? _chartSeriesController;

  /// list data velocity line chart
  List<_ChartDataVelocity> chartDataVelocity = [];

  /// list data heart rate line chart
  List<_ChartDataHeartRate> chartDataHeartRate = [];

  int idDevice = 0;
  bool isLoading = false;
  bool isUpdate = false;


  CameraPosition kLake =
       const CameraPosition(target: LatLng(10.9501542, 106.6707032), zoom: 16);

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(Global.latLngFromDB!));
      setState(() {
        _setMarker(Global.latLngFromDB!);
      });
  }

  void onMapCreate(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  void showMemberMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(20, 80, 100, 0),
      color: Colors.orange,
      items: List.generate(listDeviceUser.length, (index) {
        return PopupMenuItem(
          value: index,
          child: Text(
            listDeviceUser[index].name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito Sans',
            ),
          ),
        );
      }),
      elevation: 0,
    ).then((value) {
      if (value != null) {
        setState(() {
          idDevice = listDeviceUser[value].idDevice;
          debugPrint("iddevice: ${idDevice.toString()}");
          isUpdate = false;
          getListDataOfDevice();
        });
        debugPrint("index: ${value.toString()}");
      }
    });
  }

  void connectAndListenSocket() {
    debugPrint('-------------Call function-----------------');
    socket = IO.io('http://192.168.1.8:3002',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      debugPrint('Connect successfully');
    });

    socket.on('connection', (_) {
      debugPrint('Connect server');
    });

    socket.on('mysql-event', (data) {
      debugPrint('Received message: $data');
      getListDeviceUSer();
      setState(() {
        isUpdate = true;
        getListDataOfDevice();
      });
    });
  }

  void updateDataVelocityChart() {
    chartDataVelocity.add(_ChartDataVelocity(
        "${listDataOfDevice[0].hour}:${listDataOfDevice[0].minute}:${listDataOfDevice[0].second}",
        listDataOfDevice[0].velocity));
    if (chartDataVelocity.length == 6) {
      chartDataVelocity.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartDataVelocity.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartDataVelocity.length - 1],
      );
    }
  }

  void updateDataHeartRateChart() {
    chartDataHeartRate.add(_ChartDataHeartRate(
        "${listDataOfDevice[0].hour}:${listDataOfDevice[0].minute}:${listDataOfDevice[0].second}",
        listDataOfDevice[0].heartRate));
    if (chartDataHeartRate.length == 6) {
      chartDataHeartRate.removeAt(0);
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartDataHeartRate.length - 1],
        removedDataIndexes: <int>[0],
      );
    } else {
      _chartSeriesController?.updateDataSource(
        addedDataIndexes: <int>[chartDataHeartRate.length - 1],
      );
    }
  }

  @override
  void initState() {
    connectAndListenSocket();
    getListDeviceUSer();
    getAccountInfo();
    super.initState();
  }

  /// list device user
  Future<ListDeviceUserResponse> getListDeviceUSer() async {
    ListDeviceUserResponse listDeviceUserResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.8:3002/api/user/devices"),
          RequestType.get,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to list device user $error");
      rethrow;
    }
    if (body == null) return ListDeviceUserResponse.buildDefault();
    //get data from api here
    listDeviceUserResponse = ListDeviceUserResponse.fromJson(body);
    if (listDeviceUserResponse.code == 0) {
      listDeviceUser = listDeviceUserResponse.listDataDeviceUser;
      Global.listDeviceUser = listDeviceUserResponse.listDataDeviceUser;
      debugPrint("Get list device successfully");
    } else {
      Fluttertoast.showToast(
          msg: "Lỗi server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.black,
          fontSize: 16);
      debugPrint(listDeviceUserResponse.message);
    }
    return listDeviceUserResponse;
  }

  /// list data of device
  Future<ListDataOfDeviceResponse> getListDataOfDevice() async {
    ListDataOfDeviceResponse listDataOfDeviceResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.8:3002/api/device?iddevice=$idDevice"),
          RequestType.get,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to list data of device $error");
      rethrow;
    }
    if (body == null) return ListDataOfDeviceResponse.buildDefault();
    //get data from api here
    listDataOfDeviceResponse = ListDataOfDeviceResponse.fromJson(body);
    if (listDataOfDeviceResponse.code == 0) {
      setState(() {
        listDataOfDevice = listDataOfDeviceResponse.listDataDevice;
        debugPrint("get list data of device successfully");
        debugPrint(listDataOfDeviceResponse.message);
        if (listDataOfDevice.isNotEmpty) {
          if (isUpdate == false) {
            Global.latLngFromDB = LatLng(listDataOfDeviceResponse.listDataDevice[0].lat, listDataOfDeviceResponse.listDataDevice[0].lng);
            chartDataVelocity = <_ChartDataVelocity>[
              _ChartDataVelocity(
                  "${listDataOfDevice[0].hour}:${listDataOfDevice[0].minute}:${listDataOfDevice[0].second}",
                  listDataOfDevice[0].velocity),
            ];
            chartDataHeartRate = <_ChartDataHeartRate>[
              _ChartDataHeartRate(
                  "${listDataOfDevice[0].hour}:${listDataOfDevice[0].minute}:${listDataOfDevice[0].second}",
                  listDataOfDevice[0].heartRate),
            ];
            goToTheLake();
          } else {
            Global.latLngFromDB = LatLng(listDataOfDeviceResponse.listDataDevice[0].lat, listDataOfDeviceResponse.listDataDevice[0].lng);
            updateDataVelocityChart();
            updateDataHeartRateChart();
            goToTheLake();
          }
        }
      });
    } else {
      setState(() {
        Fluttertoast.showToast(
            msg: "Lỗi server",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.black,
            fontSize: 16);
        debugPrint(listDataOfDeviceResponse.message);
      });
    }
    return listDataOfDeviceResponse;
  }

  /// account info
  Future<AccountInfoResponse> getAccountInfo() async {
    AccountInfoResponse accountInfoResponse;
    Map<String, dynamic>? body;
    try {
      body = await HttpHelper.invokeHttp(
          Uri.parse("http://192.168.1.8:3002/api/user"), RequestType.get,
          headers: null, body: null);
    } catch (error) {
      debugPrint("Fail to get account info $error");
      rethrow;
    }
    if (body == null) return AccountInfoResponse.buildDefault();
    //get data from api here
    accountInfoResponse = AccountInfoResponse.fromJson(body);
    if (accountInfoResponse.code == 0) {
      Global.accountInfo = accountInfoResponse.accountInfo[0];
      debugPrint("Get Account Info successfully");
      debugPrint(Global.accountInfo.toString());
    } else {
      Fluttertoast.showToast(
          msg: "Lỗi server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.black,
          fontSize: 16);
      debugPrint(accountInfoResponse.message);
    }
    return accountInfoResponse;
  }

  void _setMarker(LatLng point){
      marker.add(Marker( markerId: MarkerId('MarkerMap: ${Global.latLngFromDB}'),
          icon: BitmapDescriptor.defaultMarker,
          position: point));
  }

  @override
  void dispose() {
    super.dispose();
    marker.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Global.primaryColor),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              showMemberMenu();
            },
            child: const Icon(Icons.menu, color: Colors.black)),
        title: const Text(
          'Trang chủ',
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          child: Column(
            children: [
              ///
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFCC99),
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chỉ số',
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(IconsAssets.icDistance),
                        Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(maxWidth: 150),
                          margin: const EdgeInsets.only(right: 15),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            listDataOfDevice.isNotEmpty
                                ? listDataOfDevice[0].distance.toString()
                                : "0",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const Text(
                          'm',
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(IconsAssets.icVelocity),
                        Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(maxWidth: 150),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            listDataOfDevice.isNotEmpty
                                ? listDataOfDevice[0].velocity.toString()
                                : "0",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const Text(
                          'm/s',
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(IconsAssets.icHeartRate,
                            width: 30, height: 30),
                        Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(maxWidth: 150),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            listDataOfDevice.isNotEmpty
                                ? listDataOfDevice[0].heartRate.toString()
                                : "0",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        const Text(
                          'm/s',
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              /// line chart velocity
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFCC99),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    const Text(
                      'Vận tốc',
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      '(m/s)',
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        margin: const EdgeInsets.only(top: 10),
                        child: velocityLineChart()),
                  ],
                ),
              ),

              /// line chart heart rate
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFCC99),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    const Text(
                      'Nhịp tim',
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const Text(
                      '(bpm)',
                      style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      margin: const EdgeInsets.only(top: 10),
                      child: heartRateLineChart(),
                    ),
                  ],
                ),
              ),

              /// map
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MapScreen(
                        )),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  color: Colors.transparent,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: GoogleMap(
                          onMapCreated: onMapCreate,
                          mapType: MapType.normal,
                          zoomControlsEnabled: false,
                          markers: marker,
                          initialCameraPosition: kLake,
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(16, 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// button clear data
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                child: ButtonNext(
                  onTap: () {
                    setState(() {
                      listDataOfDevice = [];
                      chartDataVelocity = [];
                      chartDataHeartRate = [];
                    });
                  },
                  textInside: "Xóa dữ liệu",
                  color: Colors.orange,
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  /// Returns the realtime velocity line chart.
  SfCartesianChart velocityLineChart() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
            axisLine: const AxisLine(color: Colors.black),
            majorTickLines: const MajorTickLines(size: 8, color: Colors.black)),
        primaryYAxis: NumericAxis(
            borderColor: Colors.black,
            axisLine: const AxisLine(width: 1, color: Colors.black),
            majorTickLines: const MajorTickLines(size: 4, color: Colors.black)),
        series: <LineSeries<_ChartDataVelocity, String>>[
          LineSeries<_ChartDataVelocity, String>(
            dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: Colors.black, fontSize: 8)),
            markerSettings: const MarkerSettings(
                isVisible: true,
                width: 2,
                height: 2,
                borderWidth: 2,
                borderColor: Colors.black),
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartDataVelocity,
            color: Colors.orange,
            xValueMapper: (_ChartDataVelocity sales, _) => sales.time,
            yValueMapper: (_ChartDataVelocity sales, _) => sales.velocity,
            animationDuration: 0,
          )
        ]);
  }

  /// Returns the realtime heart rate line chart.
  SfCartesianChart heartRateLineChart() {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
            axisLine: const AxisLine(color: Colors.black),
            majorTickLines: const MajorTickLines(size: 8, color: Colors.black)),
        primaryYAxis: NumericAxis(
            borderColor: Colors.black,
            axisLine: const AxisLine(width: 1, color: Colors.black),
            majorTickLines: const MajorTickLines(size: 4, color: Colors.black)),
        series: <LineSeries<_ChartDataHeartRate, String>>[
          LineSeries<_ChartDataHeartRate, String>(
            dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: Colors.black, fontSize: 8)),
            markerSettings: const MarkerSettings(
                isVisible: true,
                width: 2,
                height: 2,
                borderWidth: 2,
                borderColor: Colors.black),
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController = controller;
            },
            dataSource: chartDataHeartRate,
            color: Colors.orange,
            xValueMapper: (_ChartDataHeartRate sales, _) => sales.time,
            yValueMapper: (_ChartDataHeartRate sales, _) => sales.heartRate,
            animationDuration: 0,
          )
        ]);
  }
}

class _ChartDataVelocity {
  _ChartDataVelocity(this.time, this.velocity);
  final String time;
  final int velocity;
}

class _ChartDataHeartRate {
  _ChartDataHeartRate(this.time, this.heartRate);
  final String time;
  final int heartRate;
}
