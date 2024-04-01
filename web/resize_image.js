self.onmessage = async function(event) {
    const { arrayBuffer, targetWidth, targetHeight } = event.data;
    const result = await resizeImage(arrayBuffer, targetWidth, targetHeight);
    self.postMessage(result);
};

async function resizeImage(arrayBuffer, targetWidth, targetHeight) {
  try {
    console.log(arrayBuffer.byteLength, 'bytes');
    console.log(targetWidth, 'width');
    console.log(targetHeight, 'height');
    const blob = new Blob([arrayBuffer]);
    const bitmap = await createImageBitmap(blob);
    const offscreenCanvas = new OffscreenCanvas(targetWidth, targetHeight);
    const ctx = offscreenCanvas.getContext('2d');
    ctx.drawImage(bitmap, 0, 0, targetWidth, targetHeight);
    const resizedBlob = await offscreenCanvas.convertToBlob();

    // use Promise to wait for FileReader result
    const resultArrayBuffer = await new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onloadend = () => resolve(reader.result); // success to get result
      reader.onerror = () => reject(reader.error); 
      reader.readAsArrayBuffer(resizedBlob); // start to read blob as ArrayBuffer
    });
    console.log(resultArrayBuffer.byteLength, 'bytes');
    return new Uint8Array(resultArrayBuffer); // convert ArrayBuffer to Uint8Array for Uint8List in dart
  } catch (error) {
    throw error; 
  }
}