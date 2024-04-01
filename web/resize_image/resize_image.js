function resizeImage(arrayBuffer, targetWidth, targetHeight) {
  return new Promise((resolve, reject) => {
      // convert ArrayBuffer to Blob
      const blob = new Blob([arrayBuffer]);
      const url = URL.createObjectURL(blob);

      // create Image and load Blob
      const img = new Image();
      img.onload = () => {
          // create Canvas for image resize
          const canvas = document.createElement('canvas');
          const ctx = canvas.getContext('2d');
          canvas.width = targetWidth;
          canvas.height = targetHeight;

          // draw resized image on Canvas 
          ctx.drawImage(img, 0, 0, targetWidth, targetHeight);

          // release Blob URL resource
          URL.revokeObjectURL(url);

          // convert Canvas content to Blob，then convert to ArrayBuffer
          canvas.toBlob((resizedBlob) => {
              const reader = new FileReader();
              reader.onloadend = () => {
                  resolve(reader.result); // return ArrayBuffer
              };
              reader.onerror = reject;
              reader.readAsArrayBuffer(resizedBlob);
          }, 'image/png');
      };
      img.onerror = () => {
          reject(new Error('Image loading error'));
          URL.revokeObjectURL(url);
      };

      img.src = url;
  });
}