const fs = require('fs');

// 读取原始 HTML 文件
const originalHTML = fs.readFileSync('standalone.html', 'utf8');

// 读取单词数据
const wordData = fs.readFileSync('data/words.json', 'utf8');

// 简单的搜索模式 - 只搜索包含 "const wordData" 的行
const searchPattern = /const wordData = \{[^}]*\};?/;

// 将单词数据嵌入到 HTML 文件中
const updatedHTML = originalHTML.replace(searchPattern, `const wordData = ${wordData};`);

// 保存更新后的 HTML 文件
fs.writeFileSync('standalone.html', updatedHTML, 'utf8');

console.log('✅ 单词数据已成功嵌入到 standalone.html 文件中');
console.log('现在可以直接在本地打开 standalone.html 文件进行测试');
