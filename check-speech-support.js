const https = require('https');

function fetchCanIUseData(feature) {
  return new Promise((resolve, reject) => {
    https.get(`https://caniuse.com/feat=${feature}`, (res) => {
      let data = '';
      res.on('data', (chunk) => {
        data += chunk;
      });
      res.on('end', () => {
        resolve(data);
      });
    }).on('error', (err) => {
      reject(err);
    });
  });
}

// 获取 speech-synthesis 和 speech-recognition 的支持情况
Promise.all([
  fetchCanIUseData('speech-synthesis'),
  fetchCanIUseData('speech-recognition')
]).then(([synthesisData, recognitionData]) => {
  console.log('=== 语音合成支持情况 ===');
  if (synthesisData.includes('Safari on iOS')) {
    const iOSSupport = synthesisData.match(/Safari on iOS ([\d.]+)\+?/);
    console.log('iOS Safari:', iOSSupport ? iOSSupport[1] + '+' : '❌');
  }
  if (synthesisData.includes('Chrome on Android')) {
    const androidSupport = synthesisData.match(/Chrome on Android ([\d.]+)\+?/);
    console.log('Android Chrome:', androidSupport ? androidSupport[1] + '+' : '❌');
  }

  console.log('');
  console.log('=== 语音识别支持情况 ===');
  if (recognitionData.includes('Safari on iOS')) {
    const iOSSupport = recognitionData.match(/Safari on iOS ([\d.]+)\+?/);
    console.log('iOS Safari:', iOSSupport ? iOSSupport[1] + '+' : '❌');
  }
  if (recognitionData.includes('Chrome on Android')) {
    const androidSupport = recognitionData.match(/Chrome on Android ([\d.]+)\+?/);
    console.log('Android Chrome:', androidSupport ? androidSupport[1] + '+' : '❌');
  }
}).catch((err) => {
  console.error('Error fetching data:', err);
});
