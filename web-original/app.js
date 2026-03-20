// 全局变量
let words = [];
let currentMode = 'level'; // level / topic
let currentLevel = '黑1';
let currentTopic = '';
let currentIndex = 0;
let filteredWords = [];
let synth = window.speechSynthesis;

// 本地存储数据结构
let storage = {
    mastered: [],
    unknown: [],
    lastMode: 'level',
    levelProgress: {
        '黑1': { currentIndex: 0, total: 0 },
        '蓝2': { currentIndex: 0, total: 0 },
        '红3': { currentIndex: 0, total: 0 }
    },
    topicProgress: {},
    theme: 'forest'
};

// 初始化
document.addEventListener('DOMContentLoaded', async () => {
    // 加载词汇数据
    await loadWords();
    // 加载本地存储
    loadStorage();
    // 初始化UI
    initUI();
    // 加载第一个单词
    showCurrentWord();
    // 更新统计
    updateStats();
});

// 加载词汇数据
async function loadWords() {
    try {
        const res = await fetch('data/words.json');
        const data = await res.json();
        // 明确取words字段
        words = Array.isArray(data.words) ? data.words : [];
        console.log(`✅ 加载了${words.length}个单词`);
        // 初始化主题进度
        const topics = [...new Set(words.map(w => w.topic || '未分类'))];
        topics.forEach(topic => {
            if (!storage.topicProgress[topic]) {
                storage.topicProgress[topic] = { currentIndex: 0, total: 0 };
            }
        });
        saveStorage();
    } catch (e) {
        console.error('加载词汇失败:', e);
        // 加载失败时用测试数据
        words = [
            { id: 1, word: 'happy', phonetic: '/ˈhæpi/', meaning: 'adj. 开心的', level: '黑1', topic: '形容词' },
            { id: 2, word: 'sad', phonetic: '/sæd/', meaning: 'adj. 难过的', level: '黑1', topic: '形容词' }
        ];
    }
}

// 初始化UI
function initUI() {
    // 等待DOM完全加载
    setTimeout(() => {
        // 模式切换
        const modeBtns = document.querySelectorAll('.mode-btn');
        if (modeBtns.length > 0) {
            // 初始化按钮样式，确保未选中的是灰色
            modeBtns.forEach((btn, index) => {
                if (index === 0) {
                    btn.className = 'mode-btn px-4 py-2 rounded-lg bg-green-500 text-white font-medium';
                } else {
                    btn.className = 'mode-btn px-4 py-2 rounded-lg bg-gray-200 text-gray-700 font-medium hover:bg-gray-300';
                }
            });
            // 绑定点击事件
            modeBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    // 重置所有按钮样式
                    modeBtns.forEach(b => {
                        b.className = 'mode-btn px-4 py-2 rounded-lg bg-gray-200 text-gray-700 font-medium hover:bg-gray-300';
                    });
                    // 设置选中按钮样式
                    btn.className = 'mode-btn px-4 py-2 rounded-lg bg-green-500 text-white font-medium';
                    currentMode = btn.dataset.mode;
                    const levelSelector = document.getElementById('level-selector');
                    const topicSelector = document.getElementById('topic-selector');
                    if (levelSelector) levelSelector.classList.toggle('hidden', currentMode !== 'level');
                    if (topicSelector) topicSelector.classList.toggle('hidden', currentMode !== 'topic');
                    if (currentMode === 'level') {
                        filterWordsByLevel(currentLevel);
                    } else {
                        // 生成主题下拉框
                        renderTopicButtons();
                    }
                });
            });
        }

        // 级别选择
        const levelBtns = document.querySelectorAll('.level-btn');
        if (levelBtns.length > 0) {
            levelBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    levelBtns.forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');
                    currentLevel = btn.textContent.trim();
                    filterWordsByLevel(currentLevel);
                });
            });
        }

        // 操作按钮
        const unknownBtn = document.getElementById('unknown-btn');
        const masteredBtn = document.getElementById('mastered-btn');
        const playBtn = document.getElementById('play-btn');
        const playBtnLarge = document.getElementById('play-btn-large');
        
        if (unknownBtn) unknownBtn.addEventListener('click', markUnknown);
        if (masteredBtn) masteredBtn.addEventListener('click', markMastered);
        if (playBtn) playBtn.addEventListener('click', playWord);
        if (playBtnLarge) playBtnLarge.addEventListener('click', playWord);

        // 背景切换
        const themeBtn = document.getElementById('theme-btn');
        if (themeBtn) themeBtn.addEventListener('click', toggleTheme);

        // 单词本
        const vocabBtn = document.getElementById('vocab-btn');
        if (vocabBtn) vocabBtn.addEventListener('click', openVocabModal);

        // 导出PDF
        const exportBtn = document.getElementById('export-btn');
        if (exportBtn) exportBtn.addEventListener('click', exportPDF);

        // 初始化默认级别
        if (levelBtns.length > 0) {
            levelBtns[0].classList.add('active');
            filterWordsByLevel('黑1');
        }

        // 应用主题
        applyTheme();
    }, 100);
}

// 按级别过滤单词
function filterWordsByLevel(level) {
    filteredWords = words.filter(w => w.level === level);
    currentIndex = storage.levelProgress[level].currentIndex || 0;
    storage.levelProgress[level].total = filteredWords.length;
    saveStorage();
    showCurrentWord();
    updateStats();
}

// 渲染主题下拉框
function renderTopicButtons() {
    const dropdown = document.getElementById('topic-dropdown');
    if (!dropdown) return;
    const topics = [...new Set(words.map(w => w.topic || '未分类'))].sort();
    dropdown.innerHTML = `
        <option value="">请选择主题</option>
        ${topics.map(topic => `<option value="${topic}">${topic}</option>`).join('')}
    `;
    
    // 绑定事件
    dropdown.addEventListener('change', () => {
        currentTopic = dropdown.value;
        if (currentTopic) {
            filterWordsByTopic(currentTopic);
        }
    });
}

// 按主题过滤单词
function filterWordsByTopic(topic) {
    filteredWords = words.filter(w => w.topic === topic);
    currentIndex = storage.topicProgress[topic].currentIndex || 0;
    storage.topicProgress[topic].total = filteredWords.length;
    saveStorage();
    showCurrentWord();
    updateStats();
}

// 显示当前单词
function showCurrentWord() {
    if (filteredWords.length === 0) return;
    if (currentIndex >= filteredWords.length) currentIndex = 0;
    
    const word = filteredWords[currentIndex];
    document.getElementById('phonetic').textContent = word.phonetic || '';
    document.getElementById('word').textContent = word.word;
    document.getElementById('meaning').textContent = word.meaning;
    document.getElementById('level-tag').textContent = word.level;
    document.getElementById('topic-tag').textContent = word.topic;
    
    // 设置级别标签颜色
    const levelTag = document.getElementById('level-tag');
    if (word.level === '黑1') levelTag.className = 'px-3 py-1 rounded-full text-white text-sm font-medium bg-black';
    if (word.level === '蓝2') levelTag.className = 'px-3 py-1 rounded-full text-white text-sm font-medium bg-blue-500';
    if (word.level === '红3') levelTag.className = 'px-3 py-1 rounded-full text-white text-sm font-medium bg-red-500';
    
    // 添加入场动画
    const card = document.getElementById('flashcard');
    card.classList.add('flashcard-enter');
    setTimeout(() => card.classList.add('flashcard-enter-active'), 10);
    setTimeout(() => {
        card.classList.remove('flashcard-enter', 'flashcard-enter-active');
    }, 300);
}

// 播放单词发音
function playWord() {
    if (filteredWords.length === 0) return;
    const word = filteredWords[currentIndex];
    
    if (synth.speaking) synth.cancel();
    
    const utterance = new SpeechSynthesisUtterance(word.word);
    utterance.lang = 'en-US';
    utterance.rate = 0.8;
    synth.speak(utterance);
}

// 标记为不会
function markUnknown() {
    if (filteredWords.length === 0) return;
    const wordId = filteredWords[currentIndex].id;
    
    if (!storage.unknown.includes(wordId)) {
        storage.unknown.push(wordId);
    }
    // 从已会中移除
    storage.mastered = storage.mastered.filter(id => id !== wordId);
    
    saveProgress();
    nextWord();
}

// 标记为已会
function markMastered() {
    if (filteredWords.length === 0) return;
    const wordId = filteredWords[currentIndex].id;
    
    if (!storage.mastered.includes(wordId)) {
        storage.mastered.push(wordId);
    }
    // 从不会中移除
    storage.unknown = storage.unknown.filter(id => id !== wordId);
    
    saveProgress();
    nextWord();
}

// 下一个单词
function nextWord() {
    currentIndex++;
    if (currentIndex >= filteredWords.length) {
        currentIndex = 0;
        alert('恭喜你完成了当前分类的所有单词！🎉');
    }
    
    saveProgress();
    showCurrentWord();
    updateStats();
}

// 保存进度
function saveProgress() {
    if (currentMode === 'level') {
        storage.levelProgress[currentLevel].currentIndex = currentIndex;
    } else {
        storage.topicProgress[currentTopic].currentIndex = currentIndex;
    }
    storage.lastMode = currentMode;
    saveStorage();
}

// 更新统计
function updateStats() {
    document.getElementById('total-count').textContent = words.length;
    document.getElementById('mastered-count').textContent = storage.mastered.length;
    document.getElementById('unknown-count').textContent = storage.unknown.length;
    
    const progress = Math.round((storage.mastered.length / words.length) * 100);
    document.getElementById('progress-percent').textContent = `${progress}%`;
    document.getElementById('progress-bar').style.width = `${progress}%`;
}

// 切换主题
function toggleTheme() {
    const themes = ['forest', 'ocean', 'desert', 'eye-care-green', 'eye-care-blue', 'eye-care-yellow', 'eye-care-gray'];
    const currentIndex = themes.indexOf(storage.theme);
    const nextIndex = (currentIndex + 1) % themes.length;
    storage.theme = themes[nextIndex];
    applyTheme();
    saveStorage();
}

// 应用主题
function applyTheme() {
    document.body.className = '';
    document.body.classList.add(`theme-${storage.theme}`);
}

// 本地存储操作
function saveStorage() {
    try {
        localStorage.setItem('ket-flashcard', JSON.stringify(storage));
        console.log('✅ 数据已保存到本地存储');
    } catch (e) {
        console.error('❌ 保存存储失败:', e);
        // 降级方案：把数据存在URL hash里
        window.location.hash = btoa(JSON.stringify(storage));
    }
}

function loadStorage() {
    let saved = null;
    // 优先读localStorage
    try {
        saved = localStorage.getItem('ket-flashcard');
    } catch (e) {
        console.warn('⚠️ 无法读取localStorage，尝试从URL读取');
    }
    // 降级读URL hash
    if (!saved && window.location.hash.length > 1) {
        try {
            saved = atob(window.location.hash.slice(1));
        } catch (e) {
            console.error('❌ 读取URL失败:', e);
        }
    }
    if (saved) {
        try {
            const parsed = JSON.parse(saved);
            storage = { ...storage, ...parsed };
            console.log('✅ 已加载本地存储数据', storage);
        } catch (e) {
            console.error('❌ 解析存储失败:', e);
        }
    }
}

// 打开单词本模态框
function openVocabModal() {
    const modal = document.createElement('div');
    modal.className = 'vocab-modal';
    modal.innerHTML = `
        <div class="vocab-content">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">单词本</h2>
                <button id="close-vocab" class="text-gray-500 hover:text-gray-700 text-2xl">
                    <i class="fa fa-times"></i>
                </button>
            </div>
            
            <div class="flex gap-2 mb-6 border-b pb-4">
                <button class="vocab-tab px-4 py-2 rounded-lg bg-green-500 text-white font-medium" data-tab="all">全部单词</button>
                <button class="vocab-tab px-4 py-2 rounded-lg bg-gray-100 font-medium" data-tab="mastered">已会单词</button>
                <button class="vocab-tab px-4 py-2 rounded-lg bg-gray-100 font-medium" data-tab="unknown">不会单词</button>
            </div>
            
            <div class="flex gap-2 mb-4">
                <select id="vocab-level-filter" class="px-3 py-2 border rounded-lg">
                    <option value="">所有级别</option>
                    <option value="黑1">黑1</option>
                    <option value="蓝2">蓝2</option>
                    <option value="红3">红3</option>
                </select>
                <select id="vocab-topic-filter" class="px-3 py-2 border rounded-lg">
                    <option value="">所有主题</option>
                    ${[...new Set(words.map(w => w.topic))].sort().map(t => `<option value="${t}">${t}</option>`).join('')}
                </select>
            </div>
            
            <div id="vocab-list" class="max-h-[50vh] overflow-y-auto">
                <!-- 单词列表动态生成 -->
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // 绑定事件
    document.getElementById('close-vocab').addEventListener('click', () => modal.remove());
    modal.addEventListener('click', (e) => {
        if (e.target === modal) modal.remove();
    });
    
    // 标签切换
    modal.querySelectorAll('.vocab-tab').forEach(tab => {
        tab.addEventListener('click', () => {
            modal.querySelectorAll('.vocab-tab').forEach(t => {
                t.classList.remove('bg-green-500', 'text-white');
                t.classList.add('bg-gray-100');
            });
            tab.classList.remove('bg-gray-100');
            tab.classList.add('bg-green-500', 'text-white');
            renderVocabList(modal);
        });
    });
    
    // 筛选事件
    document.getElementById('vocab-level-filter').addEventListener('change', () => renderVocabList(modal));
    document.getElementById('vocab-topic-filter').addEventListener('change', () => renderVocabList(modal));
    
    // 渲染列表
    renderVocabList(modal);
}

// 渲染单词列表
function renderVocabList(modal) {
    const activeTab = modal.querySelector('.vocab-tab.bg-green-500').dataset.tab;
    const levelFilter = document.getElementById('vocab-level-filter').value;
    const topicFilter = document.getElementById('vocab-topic-filter').value;
    
    let filtered = [...words];
    
    // 按标签过滤
    if (activeTab === 'mastered') {
        filtered = filtered.filter(w => storage.mastered.includes(w.id));
    } else if (activeTab === 'unknown') {
        filtered = filtered.filter(w => storage.unknown.includes(w.id));
    }
    
    // 按级别过滤
    if (levelFilter) {
        filtered = filtered.filter(w => w.level === levelFilter);
    }
    
    // 按主题过滤
    if (topicFilter) {
        filtered = filtered.filter(w => w.topic === topicFilter);
    }
    
    const container = modal.querySelector('#vocab-list');
    if (filtered.length === 0) {
        container.innerHTML = '<p class="text-center text-gray-500 py-8">暂无单词</p>';
        return;
    }
    
    container.innerHTML = `
        <div class="grid grid-cols-1 gap-3">
            ${filtered.map(word => `
                <div class="flex items-center justify-between p-3 border rounded-lg hover:bg-gray-50">
                    <div>
                        <div class="flex items-center gap-2">
                            <span class="font-bold text-lg">${word.word}</span>
                            <span class="text-gray-500">${word.phonetic || ''}</span>
                            ${word.level === '黑1' ? '<span class="px-2 py-0.5 bg-black text-white text-xs rounded">黑1</span>' : ''}
                            ${word.level === '蓝2' ? '<span class="px-2 py-0.5 bg-blue-500 text-white text-xs rounded">蓝2</span>' : ''}
                            ${word.level === '红3' ? '<span class="px-2 py-0.5 bg-red-500 text-white text-xs rounded">红3</span>' : ''}
                            <span class="px-2 py-0.5 bg-green-500 text-white text-xs rounded">${word.topic}</span>
                        </div>
                        <div class="text-gray-600 mt-1">${word.meaning}</div>
                    </div>
                    <button class="play-word-btn p-2 text-blue-500 hover:text-blue-700" data-word="${word.word}">
                        <i class="fa fa-volume-up"></i>
                    </button>
                </div>
            `).join('')}
        </div>
    `;
    
    // 绑定发音按钮
    container.querySelectorAll('.play-word-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const word = btn.dataset.word;
            if (synth.speaking) synth.cancel();
            const utterance = new SpeechSynthesisUtterance(word);
            utterance.lang = 'en-US';
            utterance.rate = 0.8;
            synth.speak(utterance);
        });
    });
}

// 导出PDF功能
async function exportPDF() {
    // 动态加载jsPDF依赖
    if (!window.jspdf) {
        await loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');
        await loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
    }
    
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF();
    
    // 选择导出类型
    const type = prompt('导出类型：\n1 - 全部单词\n2 - 已会单词\n3 - 不会单词', '1');
    if (!type) return;
    
    let exportWords = [];
    let title = '';
    
    if (type === '1') {
        exportWords = words;
        title = 'KET核心词汇大全';
    } else if (type === '2') {
        exportWords = words.filter(w => storage.mastered.includes(w.id));
        title = '已会单词本';
    } else if (type === '3') {
        exportWords = words.filter(w => storage.unknown.includes(w.id));
        title = '不会单词本';
    }
    
    if (exportWords.length === 0) {
        alert('没有可导出的单词');
        return;
    }
    
    // 生成PDF
    doc.setFontSize(20);
    doc.text(title, 20, 20);
    doc.setFontSize(12);
    doc.text(`总词数: ${exportWords.length}`, 20, 30);
    
    let y = 40;
    const lineHeight = 8;
    const pageHeight = doc.internal.pageSize.height;
    
    exportWords.forEach((word, index) => {
        if (y > pageHeight - 20) {
            doc.addPage();
            y = 20;
        }
        
        doc.setFont('helvetica', 'bold');
        doc.text(`${index + 1}. ${word.word}`, 20, y);
        doc.setFont('helvetica', 'normal');
        doc.text(word.phonetic || '', 80, y);
        doc.text(word.meaning, 120, y);
        
        y += lineHeight;
    });
    
    doc.save(`${title}.pdf`);
}

// 动态加载脚本
function loadScript(src) {
    return new Promise((resolve, reject) => {
        const script = document.createElement('script');
        script.src = src;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
}
