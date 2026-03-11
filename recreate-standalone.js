const fs = require('fs');

// 读取原始 HTML 文件
const originalHTML = fs.readFileSync('index.html', 'utf8');

// 读取单词数据
const wordData = fs.readFileSync('data/words.json', 'utf8');

// 读取 CSS 和 JavaScript 文件
const cssContent = fs.readFileSync('css/style.css', 'utf8');
const appJSContent = fs.readFileSync('js/app.js', 'utf8');

// 修改 JavaScript 代码，使用直接嵌入的数据而非 fetch 请求
let modifiedJSContent = appJSContent.replace(
    `async function loadWords() {
    try {
        const res = await fetch('data/words.json');
        const data = await res.json();
        // 明确取words字段
        words = Array.isArray(data.words) ? data.words : [];
        console.log(\`✅ 加载了\${words.length}个单词\`);
        // 初始化主题进度
        const topics = [...new Set(words.map(w => w.topic || '未分类'))];
        topics.forEach(topic => {
            if (!storage.topicProgress[topic]) {
                storage.topicProgress[topic] = { currentIndex: 0, total: 0 };
            }
        });
        // 不要在这里调用saveStorage，避免覆盖刚刚加载的本地存储数据
        // saveStorage();
    } catch (e) {
        console.error('加载词汇失败:', e);
        // 加载失败时用测试数据
        words = [
            { id: 1, word: 'happy', phonetic: '/ˈhæpi/', meaning: 'adj. 开心的', level: '黑1', topic: '形容词' },
            { id: 2, word: 'sad', phonetic: '/sæd/', meaning: 'adj. 难过的', level: '黑1', topic: '形容词' }
        ];
    }
}`,
    `function loadWords() {
    try {
        // 直接从嵌入的数据中获取
        words = Array.isArray(wordData.words) ? wordData.words : [];
        console.log(\`✅ 加载了\${words.length}个单词\`);
        // 初始化主题进度
        const topics = [...new Set(words.map(w => w.topic || '未分类'))];
        topics.forEach(topic => {
            if (!storage.topicProgress[topic]) {
                storage.topicProgress[topic] = { currentIndex: 0, total: 0 };
            }
        });
        // 不要在这里调用saveStorage，避免覆盖刚刚加载的本地存储数据
        // saveStorage();
    } catch (e) {
        console.error('加载词汇失败:', e);
        // 加载失败时用测试数据
        words = [
            { id: 1, word: 'happy', phonetic: '/ˈhæpi/', meaning: 'adj. 开心的', level: '黑1', topic: '形容词' },
            { id: 2, word: 'sad', phonetic: '/sæd/', meaning: 'adj. 难过的', level: '黑1', topic: '形容词' }
        ];
    }
}`
);

// 创建完整的独立 HTML 文件
const standaloneHTML = `<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KET单词闪卡</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <style>
        ${cssContent}
    </style>
</head>
<body class="bg-gradient-to-br from-green-100 to-green-200 min-h-screen transition-colors duration-500">
    ${originalHTML.replace(/<link rel="stylesheet" href="[^"]+">|<script src="[^"]+"><\/script>/g, '')}

    <script>
        // 单词数据 - 直接嵌入到HTML中
        const wordData = ${wordData};

        // 应用程序JavaScript代码
        ${modifiedJSContent}
    </script>
</body>
</html>`;

// 保存独立的HTML文件
fs.writeFileSync('standalone.html', standaloneHTML, 'utf8');

console.log('✅ 独立HTML文件已成功重建');
console.log('现在可以直接在本地打开 standalone.html 文件进行测试');
