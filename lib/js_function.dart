@JS()
library my_lib; //Not avoid the library annotation

import 'dart:js_util' as js_util;
import 'dart:typed_data';

import 'package:js/js.dart';

@JS()
external resizeImage(Uint8List imageData, int width, int height);

resizeImageFunction(imageData, width, height) async {
  var promise = resizeImage(imageData, width, height);
  var qs = await js_util.promiseToFuture(promise);
  return qs;
}
