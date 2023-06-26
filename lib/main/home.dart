import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
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
import '../handle_api/handle_api.dart';
import '../model/list_device_user/data_list_device_user_response.dart';
import '../model/list_device_user/list_device_user_response.dart';
import '../until/global.dart';
import '../until/show_loading_dialog.dart';

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
  List<String> listTimeOfVelocity = [];
  List<int> listVelocity = [];
  List<PricePoint> point = [];
  int idDevice = 0;
  bool isLoading = false;
  Set<Marker> markersConsumer = {};
  CameraPosition kLake =
      const CameraPosition(target: LatLng(10.9501542, 106.6707032), zoom: 16);

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kLake));
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
      items: List.generate(
        listDeviceUser.length,
            (index) {
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
            }
      ),
      elevation: 0,
    ).then((value) {
      if (value != null)
        {
          setState(() {
            idDevice = listDeviceUser[value].idDevice;
            debugPrint("iddevice: ${idDevice.toString()}");
            getListDataOfDevice();
            listVelocity = [];
            listTimeOfVelocity = [];
          });
          debugPrint("index: ${value.toString()}");
        }
    });
  }


  void connectAndListenSocket(){
    debugPrint('-------------Call function-----------------');
    socket = IO.io('http://192.168.1.7:3002',IO.OptionBuilder()
        .setTransports(['websocket']).build());

    socket.onConnect((_) {
      debugPrint('Connect successfully');
    });

    socket.on('connection', (_) {
      debugPrint('Connect server');
    });

    socket.on('mysql-event', (data) {
      debugPrint('Received message: $data');
      getListDeviceUSer();
      getListDataOfDevice();
        setState(() {
          if(listDataOfDevice.isNotEmpty){
            updateDataVelocity();
            updateDataTimeOfVelocity();
          }
        });
    });
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
          Uri.parse("http://192.168.1.7:3002/api/user/devices"),
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
    if(listDeviceUserResponse.code == 0){
      listDeviceUser = listDeviceUserResponse.listDataDeviceUser;
      Global.listDeviceUser = listDeviceUserResponse.listDataDeviceUser;
      debugPrint("Get list device successfully");
    }else{
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
          Uri.parse("http://192.168.1.7:3002/api/device?iddevice=$idDevice"),
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
    if(listDataOfDeviceResponse.code == 0){
     setState(() {
       listDataOfDevice = listDataOfDeviceResponse.listDataDevice;
       debugPrint("get list data of device successfully");
       debugPrint(listDataOfDeviceResponse.message);
     });
    }else{
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
          Uri.parse("http://192.168.1.7:3002/api/user"),
          RequestType.get,
          headers: null,
          body: null);
    } catch (error) {
      debugPrint("Fail to get account info $error");
      rethrow;
    }
    if (body == null) return AccountInfoResponse.buildDefault();
    //get data from api here
    accountInfoResponse = AccountInfoResponse.fromJson(body);
    if(accountInfoResponse.code == 0){
      Global.accountInfo = accountInfoResponse.accountInfo[0];
      debugPrint("Get Account Info successfully");
      debugPrint(Global.accountInfo.toString());

    }else{
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

  void updateDataVelocity(){
    setState(() {
      listVelocity.add((listDataOfDevice[0].velocity).toInt());
      if(listVelocity.length > 7){
        listVelocity.removeAt(0);
      }
    });
    debugPrint(listVelocity.toString());
  }

  void updateDataTimeOfVelocity(){
    setState(() {
      String time = "${listDataOfDevice[0].hour}:${listDataOfDevice[0].minute}";
      listTimeOfVelocity.add(time);
      if(listTimeOfVelocity.length > 5){
        listTimeOfVelocity.removeAt(0);
      }
    });
    debugPrint(listTimeOfVelocity.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Color(Global.primaryColor),
        centerTitle: true,
        leading: GestureDetector(
            onTap: (){
              showMemberMenu();
            },
            child: const Icon(Icons.menu,color: Colors.black)),
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
          padding: const EdgeInsets.fromLTRB(20,0,20,100),
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
                           listDataOfDevice.isNotEmpty ?listDataOfDevice[0].distance.toString():"0",
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
                              listDataOfDevice.isNotEmpty ?listDataOfDevice[0].velocity.toString():"0",
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
                        Image.asset(IconsAssets.icHeartRate,width: 30,height: 30),
                        Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(maxWidth: 150),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          child:  Text(
                            listDataOfDevice.isNotEmpty ?listDataOfDevice[0].heartRate.toString():"0",
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
                padding: const EdgeInsets.fromLTRB(25, 20, 30, 0),
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
                      'm/s',
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
                      child: LineChart(

                        LineChartData(
                            lineTouchData: LineTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: bottomTitleVelocityChart,
                                  interval: 1,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: leftTitleVelocityChart,
                                  reservedSize: 30,
                                  interval: 1,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                    color: Colors.black.withOpacity(0.4),
                                    strokeWidth: 1);
                              },
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            minX: 0,
                            maxX: 11,
                            minY: 0,
                            maxY: 5,
                            baselineX: 0,
                            baselineY: 0,
                            lineBarsData: [
                              LineChartBarData(
                               // spots: point.map((point) => FlSpot(point.x, point.y)).toList(),
                                spots: const [
                                  FlSpot(2, 1),
                                  FlSpot(4, 2),
                                  FlSpot(6, 3),
                                  FlSpot(8, 4),
                                  FlSpot(10, 5),
                                ],
                                isCurved: true,
                                color: Colors.black,
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: true,
                                ),
                                belowBarData: BarAreaData(
                                  show: false,
                                ),
                              ),
                            ]),
                        swapAnimationDuration:
                        const Duration(milliseconds: 120), // Optional
                        swapAnimationCurve: Curves.linear, // Optional
                      ),
                    ),
                  ],
                ),
              ),

              /// line chart heart rate
              Container(
                width: MediaQuery.of(context).size.width,
                height: 400,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                padding: const EdgeInsets.fromLTRB(25, 20, 30, 0),
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      margin: const EdgeInsets.only(top: 10),
                      child:
                      LineChart(
                        LineChartData(
                            lineTouchData: LineTouchData(enabled: false),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: bottomTitleHeartRateChart,
                                  interval: 1,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: leftTitleHeartRateChart,
                                  reservedSize: 30,
                                  interval: 1,
                                ),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: FlGridData(
                              show: true,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                    color: Colors.black.withOpacity(0.4),
                                    strokeWidth: 1);
                              },
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            minX: 0,
                            maxX: 11,
                            minY: 0,
                            maxY: 8,
                            baselineX: 0,
                            baselineY: 0,
                            lineBarsData: [
                              LineChartBarData(
                                spots: const [
                                  FlSpot(2, 5),
                                  FlSpot(2, 2),
                                  FlSpot(4, 3.44),
                                  FlSpot(6, 5),
                                  FlSpot(8, 4),
                                  FlSpot(9, 5.5),
                                  FlSpot(11, 7.5),
                                ],
                                isCurved: true,
                                color: Colors.black,
                                barWidth: 2,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                                belowBarData: BarAreaData(
                                  show: false,
                                ),
                              ),
                            ]),
                        swapAnimationDuration:
                        const Duration(milliseconds: 120), // Optional
                        swapAnimationCurve: Curves.linear, // Optional
                      ),
                    ),
                  ],
                ),
              ),

              /// map
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MapScreen.routeName,
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
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: GoogleMap(
                          onMapCreated: onMapCreate,
                          mapType: MapType.normal,
                          zoomControlsEnabled: false,
                          markers: {
                            const Marker(
                              markerId: MarkerId('Position'),
                              icon: BitmapDescriptor.defaultMarker,
                              position: LatLng(10.9501542, 106.6707032),
                            )
                          },
                          initialCameraPosition: kLake,
                          minMaxZoomPreference: const MinMaxZoomPreference(5, 26),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// clear data
              Padding(
                padding: const EdgeInsets.fromLTRB(30,40,30,0),
                child: ButtonNext(onTap: (){},textInside: "Xóa dữ liệu",color: Colors.orange,),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget bottomTitleVelocityChart(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    if(listTimeOfVelocity.isNotEmpty && listTimeOfVelocity.length==5 && listVelocity.length == 7){
      switch (value.toInt()) {
        case 2:
          text =  Text(listTimeOfVelocity[listTimeOfVelocity.length-1], style: style);
          break;
        case 4:
          text =  Text(listTimeOfVelocity[listTimeOfVelocity.length-2], style: style);
          break;
        case 6:
          text =  Text(listTimeOfVelocity[listTimeOfVelocity.length-3], style: style);
          break;
        case 8:
          text =  Text(listTimeOfVelocity[listTimeOfVelocity.length-4], style: style);
          break;
        case 10:
          text =  Text(listTimeOfVelocity[listTimeOfVelocity.length-5], style: style);
          break;
        default:
          text =  const Text('', style: style);
          break;
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    }else{
      switch (value.toInt()) {
        case 2:
          text = const Text('00:00', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    }



  }

  Widget leftTitleVelocityChart(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if(listVelocity.isNotEmpty && listVelocity.length == 7){
      switch (value.toInt()) {
        case 0:
          text = '0';
          break;
        case 1:
          text =  listVelocity[(listVelocity.length)-1].toString();
          break;
        case 2:
          text = listVelocity[(listVelocity.length)-2].toString();
          break;
        case 3:
          text = listVelocity[(listVelocity.length)-3].toString();
          break;
        case 4:
          text = listVelocity[(listVelocity.length)-4].toString();
          break;
        case 5:
          text = listVelocity[(listVelocity.length)-5].toString();
          break;
        // case 6:
        //   text = listVelocity[(listVelocity.length)-6].toString();
        //   break;
        // case 7:
        //   text =  listVelocity[(listVelocity.length)-7].toString();
        //   break;
        default:
          return Container();
      }
      debugPrint(value.toString());
      return Text(text, style: style, textAlign: TextAlign.center);
    }
    else{
      switch (value.toInt()) {
        case 0:
          text = '0';
          break;
        case 1:
          text =  '0';
          break;
        case 2:
          text = '0';
          break;
        case 3:
          text = '0';
          break;
        case 4:
          text = '0';
          break;
        case 5:
          text = '0';
          break;
        case 6:
          text = '0';
          break;
        case 7:
          text =  '0';
          break;
        default:
          return Container();
      }
      debugPrint(value.toString());
      return Text(text, style: style, textAlign: TextAlign.center);
    }


  }

  Widget bottomTitleHeartRateChart(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('2:30', style: style);
        break;
      case 4:
        text = const Text('3:40', style: style);
        break;
      case 6:
        text = const Text('4:00', style: style);
        break;
      case 8:
        text = const Text('5:05', style: style);
        break;
      case 10:
        text = const Text('6:00', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleHeartRateChart(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '20';
        break;
      case 2:
        text = '40';
        break;
      case 3:
        text = '60';
        break;
      case 4:
        text = '80';
        break;
      case 5:
        text = '120';
        break;
      case 6:
        text = '140';
        break;
      case 7:
        text = '160';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

}

class PricePoint {
  final double x;
  final double y;
  PricePoint({required this.x, required this.y});
}

