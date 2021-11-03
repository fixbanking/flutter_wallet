import 'dart:async';
import 'package:flutter/services.dart';

class AddToWallet {
  static const MethodChannel _channel = const MethodChannel('flutter_wallet_handler');

  static final AddToWallet _instance = AddToWallet._internal();

  /// Associate each rendered Widget to its `onPressed` event handler
  static final Map<String, FutureOr<dynamic> Function(MethodCall)> _handlers = Map();

  static Future<void> addCardToGooglePay({dynamic args}) async {
    await _channel.invokeMethod('addCardToGooglePay', args);
  }

  // Returns whether this app can add payment passes or not on iOS.
  static Future<bool> canAddPaymentPass() async {
    return await _channel.invokeMethod('canAddPaymentPass');
  }

  static Future<String> getGooglePayWalletId() async => await _channel.invokeMethod('getGooglePayWalletId');

  factory AddToWallet() => _instance;

  AddToWallet._internal() {
    _initMethodCallHandler();
  }

  void _initMethodCallHandler() => _channel.setMethodCallHandler(_handleCalls);

  Future<dynamic> _handleCalls(MethodCall call) async {
    var handler = _handlers[call.arguments['key']];
    return handler != null ? await handler(call) : null;
  }

  Future<void> addHandler<T>(String key, FutureOr<T> Function(MethodCall) handler) async {
    _handlers[key] = handler;
  }

  invokeMethod(String method, dynamic args) {
    _channel.invokeMethod(method, args);
  }

  void removeHandler(String key) {
    _handlers.remove(key);
  }
}
