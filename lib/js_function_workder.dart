import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

Stream<Uint8List> webWorkerResult(
    Uint8List imageData, int width, int height) async* {
  StreamController<Uint8List> controller = StreamController<Uint8List>();

  // check is Web Worker support
  if (Worker.supported) {
    // create Web Worker
    final worker = Worker('resize_image.js');

    // send required data to Worker
    worker.postMessage({
      'arrayBuffer': imageData,
      'targetWidth': width,
      'targetHeight': height
    });

    // listen Worker result
    worker.onMessage.listen((event) {
      // handle Worker result here
      final result = event.data;
      if (result != null) {
        Uint8List uint8List = Uint8List.fromList(result);
        controller.add(uint8List);
      }
      worker.terminate(); // end Worker
      controller.close(); // end Stream
    });
  } else {
    print('Web Workers are not supported in this environment.');
    controller.close(); // end Stream
  }

  yield* controller.stream;
}
