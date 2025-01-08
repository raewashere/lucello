import 'dart:async';
import 'dart:typed_data';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';

class BluetoothClassicService {
  BluetoothClassicService._privateConstructor();
  static final BluetoothClassicService _instance =
      BluetoothClassicService._privateConstructor();
  factory BluetoothClassicService() => _instance;

  final BluetoothClassic _bluetoothClassicPlugin = BluetoothClassic();

  late Stream<Device> onDeviceDiscovered;
  late Stream<int> onDeviceStatusChanged;
  late Stream<Uint8List> onDeviceDataReceived;

  Future<void> initialize() async {
    onDeviceDiscovered =
        _bluetoothClassicPlugin.onDeviceDiscovered().asBroadcastStream();
    onDeviceStatusChanged =
        _bluetoothClassicPlugin.onDeviceStatusChanged().asBroadcastStream();
    onDeviceDataReceived =
        _bluetoothClassicPlugin.onDeviceDataReceived().asBroadcastStream();
  }

  Future<String?> getPlatformVersion() =>
      _bluetoothClassicPlugin.getPlatformVersion();

  Future<void> initPermissions() => _bluetoothClassicPlugin.initPermissions();
  Future<void> startScan() => _bluetoothClassicPlugin.startScan();
  Future<void> stopScan() => _bluetoothClassicPlugin.stopScan();
  Future<void> connect(String address, String uuid) =>
      _bluetoothClassicPlugin.connect(address, uuid);
  Future<void> disconnect() => _bluetoothClassicPlugin.disconnect();
  Future<void> write(String message) => _bluetoothClassicPlugin.write(message);
  Future<List<Device>> getPairedDevices() =>
      _bluetoothClassicPlugin.getPairedDevices();

  bool _isListening = false;

  bool get isListening => _isListening;

  set escuchando(bool valor) {
    _isListening = valor;
  }
}
