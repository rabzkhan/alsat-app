import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebView extends StatefulWidget {
  final String url;
  final String title;

  const AppWebView({super.key, required this.url, required this.title});

  @override
  State<AppWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<AppWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    Logger().d(widget.url.toString());
    // Initialize the WebView controller with the passed URL
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.contains('/success')) {
            //   Get.find<BookingController>().uponCompletingPaayment();
            // } else if (request.url.contains('/failed')) {
            //   Get.find<BookingController>().uponFailedPaayment();
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // Use the passed URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          elevation: 0,
        ),
        body: WebViewWidget(controller: controller));
  }
}
