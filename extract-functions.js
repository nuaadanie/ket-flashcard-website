const fs = require('fs');
const appContent = fs.readFileSync('/home/admin/.openclaw/workspace-codingagent/projects/ket-flashcard-website/js/app.js', 'utf8');

console.log('===== app.js 初始化过程代码 ====');

// 提取 loadStorage 函数
const loadStoragePattern = /function loadStorage\(\)\s*\{([\s\S]*?)\}\s*(?:\/\*|\nfunction|\n$)/;
const loadStorageMatch = appContent.match(loadStoragePattern);

if (loadStorageMatch) {
    console.log('\\n=== loadStorage ===');
    console.log(loadStorageMatch[1].trim());
}

// 提取 DOMContentLoaded 事件监听器
const domLoadedPattern = /document\.addEventListener\('DOMContentLoaded', async \(.*?\)\s*\{([\s\S]*?)\}\);/;
const domLoadedMatch = appContent.match(domLoadedPattern);

if (domLoadedMatch) {
    console.log('\\n=== DOMContentLoaded ===');
    console.log(domLoadedMatch[1].trim());
}
