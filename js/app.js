// 应用配置
const APP_CONFIG = {
    DEFAULT_LEVEL: '黑1',
    DEFAULT_MODE: 'level',
    DEFAULT_THEME: 'forest',
    LEVEL_COLORS: {
        '黑1': 'bg-black',
        '蓝2': 'bg-blue-500',
        '红3': 'bg-red-500'
    },
    THEMES: ['forest', 'ocean', 'desert', 'eye-care-green', 'eye-care-blue', 'eye-care-yellow', 'eye-care-gray'],
    // 语音合成配置
    SPEECH: {
        DEFAULT_LANGUAGE: 'en',
        DEFAULT_RATE: 1,
        DEFAULT_PITCH: 1
    }
};

// 类型定义
class AppState {
    constructor() {
        this.words = [];
        this.currentMode = APP_CONFIG.DEFAULT_MODE;
        this.currentLevel = APP_CONFIG.DEFAULT_LEVEL;
        this.currentTopic = '';
        this.currentIndex = 0;
        this.filteredWords = [];
        this.isPlaying = false;
        this.storage = this.initializeStorage();
    }

    initializeStorage() {
        return {
            mastered: [],
            unknown: [],
            lastMode: APP_CONFIG.DEFAULT_MODE,
            levelProgress: {
                '黑1': { currentIndex: 0, total: 0 },
                '蓝2': { currentIndex: 0, total: 0 },
                '红3': { currentIndex: 0, total: 0 }
            },
            topicProgress: {},
            theme: APP_CONFIG.DEFAULT_THEME
        };
    }
}

// 全局应用状态
const appState = new AppState();

// DOM工具函数
const DOM = {
    get: (selector) => document.querySelector(selector),
    getAll: (selector) => document.querySelectorAll(selector),
    id: (id) => document.getElementById(id),
    create: (tag, className) => {
        const el = document.createElement(tag);
        if (className) el.className = className;
        return el;
    },
    setText: (element, text) => {
        if (element) element.textContent = text;
    },
    setHtml: (element, html) => {
        if (element) element.innerHTML = html;
    },
    showToast: (message, type = 'info') => {
        const toast = DOM.create('div', `fixed bottom-4 left-4 p-3 rounded-lg z-50 ${
            type === 'error' ? 'bg-red-500 text-white' :
            type === 'success' ? 'bg-green-500 text-white' :
            'bg-blue-500 text-white'
        }`);
        toast.textContent = message;
        document.body.appendChild(toast);
        setTimeout(() => toast.remove(), 3000);
    }
};

// 存储管理
const StorageManager = {
    KEY: 'ket-flashcard',

    save() {
        try {
            localStorage.setItem(this.KEY, JSON.stringify(appState.storage));
        } catch (error) {
            console.error('保存数据失败:', error);
        }
    },

    load() {
        try {
            const saved = localStorage.getItem(this.KEY);
            if (saved) {
                const loadedData = JSON.parse(saved);
                appState.storage = { ...appState.storage, ...loadedData };
                this.ensureStorageIntegrity();
                this.restoreFromStorage();
            }
        } catch (error) {
            console.error('加载数据失败:', error);
            appState.storage = appState.initializeStorage();
        }
    },

    ensureStorageIntegrity() {
        const storage = appState.storage;
        if (!storage.mastered) storage.mastered = [];
        if (!storage.unknown) storage.unknown = [];
        if (!storage.levelProgress) {
            storage.levelProgress = {
                '黑1': { currentIndex: 0, total: 0 },
                '蓝2': { currentIndex: 0, total: 0 },
                '红3': { currentIndex: 0, total: 0 }
            };
        }
        if (!storage.topicProgress) storage.topicProgress = {};
        if (!storage.theme) storage.theme = APP_CONFIG.DEFAULT_THEME;
        if (!storage.lastMode) storage.lastMode = APP_CONFIG.DEFAULT_MODE;
    },

    restoreFromStorage() {
        const storage = appState.storage;
        if (storage.levelProgress) {
            appState.currentLevel = Object.keys(storage.levelProgress)[0] || APP_CONFIG.DEFAULT_LEVEL;
        }
        if (storage.lastMode) {
            appState.currentMode = storage.lastMode;
        }
    },

    saveProgress() {
        if (appState.currentMode === 'level') {
            appState.storage.levelProgress[appState.currentLevel].currentIndex = appState.currentIndex;
        } else {
            appState.storage.topicProgress[appState.currentTopic].currentIndex = appState.currentIndex;
        }
        appState.storage.lastMode = appState.currentMode;
        this.save();
    }
};

// 词汇数据管理
const WordManager = {
    async load() {
        try {
            const res = await fetch('data/words.json');
            const data = await res.json();
            appState.words = Array.isArray(data.words) ? data.words : [];
            console.log(`✅ 加载了${appState.words.length}个单词`);
            this.initializeTopicProgress();
        } catch (e) {
            console.error('加载词汇失败:', e);
            appState.words = [
                { id: 1, word: 'happy', phonetic: '/ˈhæpi/', meaning: 'adj. 开心的', level: '黑1', topic: '形容词' },
                { id: 2, word: 'sad', phonetic: '/sæd/', meaning: 'adj. 难过的', level: '黑1', topic: '形容词' }
            ];
        }
    },

    initializeTopicProgress() {
        const topics = [...new Set(appState.words.map(w => w.topic || '未分类'))];
        topics.forEach(topic => {
            if (!appState.storage.topicProgress[topic]) {
                appState.storage.topicProgress[topic] = { currentIndex: 0, total: 0 };
            }
        });
    },

    getTopics() {
        return [...new Set(appState.words.map(w => w.topic || '未分类'))].sort();
    },

    filterByLevel(level) {
        appState.filteredWords = appState.words.filter(w => w.level === level);
        appState.currentIndex = appState.storage.levelProgress[level].currentIndex || 0;
        appState.storage.levelProgress[level].total = appState.filteredWords.length;
        StorageManager.save();
    },

    filterByTopic(topic) {
        appState.filteredWords = appState.words.filter(w => w.topic === topic);
        if (!appState.storage.topicProgress[topic]) {
            appState.storage.topicProgress[topic] = { currentIndex: 0, total: appState.filteredWords.length };
        } else {
            appState.storage.topicProgress[topic].total = appState.filteredWords.length;
        }
        appState.currentIndex = appState.storage.topicProgress[topic].currentIndex || 0;
        StorageManager.save();
    },

    filterByStatus(status) {
        switch (status) {
            case 'mastered':
                return appState.words.filter(w => appState.storage.mastered.includes(w.id));
            case 'unknown':
                return appState.words.filter(w => appState.storage.unknown.includes(w.id));
            default:
                return appState.words;
        }
    },

    getWordByStatus(wordId) {
        return {
            isMastered: appState.storage.mastered.includes(wordId),
            isUnknown: appState.storage.unknown.includes(wordId)
        };
    },

    markAsMastered(wordId) {
        if (!appState.storage.mastered.includes(wordId)) {
            appState.storage.mastered.push(wordId);
        }
        appState.storage.unknown = appState.storage.unknown.filter(id => id !== wordId);
    },

    markAsUnknown(wordId) {
        if (!appState.storage.unknown.includes(wordId)) {
            appState.storage.unknown.push(wordId);
        }
        appState.storage.mastered = appState.storage.mastered.filter(id => id !== wordId);
    }
};

// 设备检测工具
const DeviceDetector = {
    isMobile() {
        if (typeof this._isMobile === 'undefined') {
            this._isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
        }
        return this._isMobile;
    }
};

// 语音合成服务
const SpeechService = {
    // 检查浏览器支持
    isSupported() {
        return 'speechSynthesis' in window;
    },

    // 获取支持的语言列表
    getSupportedLanguages() {
        // 注意：speechSynthesis.getVoices() 可能异步返回
        const voices = window.speechSynthesis.getVoices();
        const languages = new Set();
        voices.forEach(voice => {
            if (voice.lang) languages.add(voice.lang);
        });
        return Array.from(languages).sort();
    },

    speak(text, options = {}, onStart = null, onEnd = null, onError = null) {
        return new Promise((resolve, reject) => {
            // 检查浏览器支持
            if (!this.isSupported()) {
                const error = new Error('您的浏览器不支持语音合成功能');
                this.handleError(error, onError);
                return reject(error);
            }

            // 取消当前发音
            this.cancel();

            try {
                // 处理 options 为 null 的情况
                const opts = options || {};
                const {
                    language = APP_CONFIG.SPEECH.DEFAULT_LANGUAGE,
                    rate = APP_CONFIG.SPEECH.DEFAULT_RATE,
                    pitch = APP_CONFIG.SPEECH.DEFAULT_PITCH,
                    volume = 1
                } = opts;

                const utterance = new SpeechSynthesisUtterance(text);
                utterance.lang = language;
                utterance.rate = rate;
                utterance.pitch = pitch;
                utterance.volume = volume;

                utterance.onstart = () => {
                    if (onStart) onStart();
                };

                utterance.onend = () => {
                    if (onEnd) onEnd();
                    resolve();
                };

                utterance.onerror = (event) => {
                    console.error('Speech synthesis error:', event);
                    const error = new Error('无法播放发音，请检查浏览器设置');
                    this.handleError(error, onError);
                    reject(error);
                };

                // 处理可能的发音队列问题
                utterance.onpause = () => {
                    console.warn('Speech synthesis paused');
                };

                utterance.onresume = () => {
                    console.log('Speech synthesis resumed');
                };

                window.speechSynthesis.speak(utterance);

            } catch (error) {
                console.error('Speech service error:', error);
                this.handleError(error, onError);
                reject(error);
            }
        });
    },

    cancel() {
        if (window.speechSynthesis.speaking) {
            window.speechSynthesis.cancel();
        }
    },

    // 检查是否正在发音
    isSpeaking() {
        return window.speechSynthesis.speaking;
    },

    // 检查是否有发音在队列中
    isPending() {
        return window.speechSynthesis.pending;
    },

    clearCache() {
        // Web Speech API不需要缓存
    },

    handleError(error, onError) {
        console.warn('Speech service error:', error);
        DOM.showToast(error.message, 'error');
        if (onError) onError(error);
    }
};

// UI组件管理器
const UI = {
    initialize() {
        this.initializeModeSwitching();
        this.initializeLevelSelection();
        this.initializeActionButtons();
        this.initializeThemeSwitching();
        this.initializeVocabBook();
        this.initializeExport();
        this.applyTheme();
    },

    initializeModeSwitching() {
        const modeBtns = DOM.getAll('.mode-btn');
        modeBtns.forEach(btn => {
            btn.addEventListener('click', () => this.switchMode(btn.dataset.mode));
        });
    },

    initializeLevelSelection() {
        const levelBtns = DOM.getAll('.level-btn');
        levelBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                levelBtns.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                appState.currentLevel = btn.textContent.trim();
                WordManager.filterByLevel(appState.currentLevel);
                this.showCurrentWord();
                this.updateStats();
            });
        });
    },

    initializeActionButtons() {
        const unknownBtn = DOM.id('unknown-btn');
        const masteredBtn = DOM.id('mastered-btn');
        const playBtn = DOM.id('play-btn');
        const playBtnLarge = DOM.id('play-btn-large');

        if (unknownBtn) unknownBtn.addEventListener('click', () => this.markAsUnknown());
        if (masteredBtn) masteredBtn.addEventListener('click', () => this.markAsMastered());
        if (playBtn) playBtn.addEventListener('click', () => this.playWord());
        if (playBtnLarge) playBtnLarge.addEventListener('click', () => this.playWord());
    },

    initializeThemeSwitching() {
        const themeBtn = DOM.id('theme-btn');
        if (themeBtn) themeBtn.addEventListener('click', () => this.toggleTheme());
    },

    initializeVocabBook() {
        const vocabBtn = DOM.id('vocab-btn');
        if (vocabBtn) vocabBtn.addEventListener('click', () => this.openVocabModal());
    },

    initializeExport() {
        const exportBtn = DOM.id('export-btn');
        if (exportBtn) exportBtn.addEventListener('click', () => this.exportPDF());
    },

    switchMode(mode) {
        appState.currentMode = mode;
        const modeBtns = DOM.getAll('.mode-btn');
        modeBtns.forEach(b => {
            b.classList.remove('bg-green-500', 'text-white');
            b.classList.add('bg-gray-100', 'text-gray-700');
        });
        modeBtns.forEach(btn => {
            if (btn.dataset.mode === mode) {
                btn.classList.remove('bg-gray-100', 'text-gray-700');
                btn.classList.add('bg-green-500', 'text-white');
            }
        });

        DOM.id('level-selector').classList.toggle('hidden', mode !== 'level');
        DOM.id('topic-selector').classList.toggle('hidden', mode !== 'topic');

        if (mode === 'level') {
            WordManager.filterByLevel(appState.currentLevel);
        } else {
            this.renderTopicButtons();
        }
    },

    renderTopicButtons() {
        const dropdown = DOM.id('topic-dropdown');
        if (!dropdown) return;

        const topics = WordManager.getTopics();
        dropdown.innerHTML = '<option value="">请选择主题</option>';
        topics.forEach(topic => {
            const option = DOM.create('option');
            option.value = topic;
            option.textContent = topic;
            dropdown.appendChild(option);
        });

        if (!dropdown.hasAttribute('data-listener-bound')) {
            dropdown.addEventListener('change', () => {
                const selectedTopic = dropdown.value;
                if (selectedTopic) {
                    appState.currentTopic = selectedTopic;
                    WordManager.filterByTopic(selectedTopic);
                    this.showCurrentWord();
                    this.updateStats();
                }
            });
            dropdown.setAttribute('data-listener-bound', 'true');
        }

        if (topics.length > 0 && appState.currentTopic === '') {
            appState.currentTopic = topics[0];
            dropdown.value = appState.currentTopic;
            WordManager.filterByTopic(appState.currentTopic);
        }

        this.updateStats();
    },

    showCurrentWord() {
        if (appState.filteredWords.length === 0) return;
        if (appState.currentIndex >= appState.filteredWords.length) {
            appState.currentIndex = 0;
        }

        const card = DOM.id('flashcard');
        card.classList.add('flashcard-exit');
        setTimeout(() => card.classList.add('flashcard-exit-active'), 10);

        setTimeout(() => {
            const word = appState.filteredWords[appState.currentIndex];
            DOM.setText(DOM.id('phonetic'), word.phonetic || '');
            DOM.setText(DOM.id('word'), word.word);
            DOM.setText(DOM.id('meaning'), word.meaning);
            DOM.setText(DOM.id('level-tag'), word.level);
            DOM.setText(DOM.id('topic-tag'), word.topic);

            const levelTag = DOM.id('level-tag');
            levelTag.className = 'px-3 py-1 rounded-full text-white text-sm font-medium ' +
                                APP_CONFIG.LEVEL_COLORS[word.level] || 'bg-gray-500';

            card.classList.remove('flashcard-exit', 'flashcard-exit-active');
            card.classList.add('flashcard-enter');
            setTimeout(() => card.classList.add('flashcard-enter-active'), 10);
            setTimeout(() => {
                card.classList.remove('flashcard-enter', 'flashcard-enter-active');
            }, 300);
        }, 300);
    },

    setPlayButtonState(disabled) {
        const playBtn = DOM.id('play-btn');
        const playBtnLarge = DOM.id('play-btn-large');

        [playBtn, playBtnLarge].forEach(btn => {
            if (btn) {
                if (disabled) {
                    btn.classList.add('animate-pulse');
                    btn.style.transform = 'scale(0.95)';
                    btn.disabled = true;
                    btn.style.opacity = '0.5';
                } else {
                    btn.classList.remove('animate-pulse');
                    btn.style.transform = '';
                    btn.disabled = false;
                    btn.style.opacity = '1';
                }
            }
        });
    },

    playWord() {
        if (appState.filteredWords.length === 0 || appState.isPlaying) return;
        appState.isPlaying = true;
        const word = appState.filteredWords[appState.currentIndex];

        this.setPlayButtonState(true);

        SpeechService.speak(word.word, null,
            null,  // onStart
            () => {  // onEnd
                this.setPlayButtonState(false);
                appState.isPlaying = false;
            },
            (error) => {  // onError
                this.setPlayButtonState(false);
                appState.isPlaying = false;
            }
        );
    },

    markAsUnknown() {
        if (appState.filteredWords.length === 0) return;
        const wordId = appState.filteredWords[appState.currentIndex].id;
        WordManager.markAsUnknown(wordId);
        StorageManager.saveProgress();
        this.nextWord();
    },

    markAsMastered() {
        if (appState.filteredWords.length === 0) return;
        const wordId = appState.filteredWords[appState.currentIndex].id;
        WordManager.markAsMastered(wordId);
        StorageManager.saveProgress();
        this.nextWord();
    },

    nextWord() {
        appState.currentIndex++;
        if (appState.currentIndex >= appState.filteredWords.length) {
            appState.currentIndex = 0;
            DOM.showToast('恭喜你完成了当前分类的所有单词！🎉', 'success');
        }

        StorageManager.saveProgress();
        this.showCurrentWord();
        this.updateStats();
    },

    updateStats() {
        DOM.setText(DOM.id('total-count'), appState.words.length);
        DOM.setText(DOM.id('mastered-count'), appState.storage.mastered.length);
        DOM.setText(DOM.id('unknown-count'), appState.storage.unknown.length);

        const progress = Math.round((appState.storage.mastered.length / appState.words.length) * 100);
        DOM.setText(DOM.id('progress-percent'), `${progress}%`);
        DOM.id('progress-bar').style.width = `${progress}%`;
    },

    toggleTheme() {
        const themes = APP_CONFIG.THEMES;
        const currentIndex = themes.indexOf(appState.storage.theme);
        const nextIndex = (currentIndex + 1) % themes.length;
        appState.storage.theme = themes[nextIndex];
        this.applyTheme();
        StorageManager.save();
    },

    applyTheme() {
        document.body.className = '';
        document.body.classList.add(`theme-${appState.storage.theme}`);
    },

    openVocabModal() {
        const modal = DOM.create('div', 'vocab-modal');
        modal.innerHTML = `
            <div class="vocab-content">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold">单词本</h2>
                    <button id="close-vocab" class="text-gray-500 hover:text-gray-700 text-2xl">
                        <i class="fa fa-times"></i>
                    </button>
                </div>

                <div class="flex gap-2 mb-6 border-b pb-4">
                    <button class="vocab-tab px-4 py-2 rounded-lg bg-green-500 text-white font-medium" data-tab="unknown">不会单词</button>
                    <button class="vocab-tab px-4 py-2 rounded-lg bg-gray-100 font-medium" data-tab="mastered">已会单词</button>
                    <button class="vocab-tab px-4 py-2 rounded-lg bg-gray-100 font-medium" data-tab="all">全部单词</button>
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
                        ${WordManager.getTopics().map(t => `<option value="${t}">${t}</option>`).join('')}
                    </select>
                </div>

                <div id="vocab-list" class="max-h-[50vh] overflow-y-auto">
                </div>
            </div>
        `;

        document.body.appendChild(modal);

        DOM.id('close-vocab').addEventListener('click', () => modal.remove());
        modal.addEventListener('click', (e) => {
            if (e.target === modal) modal.remove();
        });

        modal.querySelectorAll('.vocab-tab').forEach(tab => {
            tab.addEventListener('click', () => {
                modal.querySelectorAll('.vocab-tab').forEach(t => {
                    t.classList.remove('bg-green-500', 'text-white');
                    t.classList.add('bg-gray-100');
                });
                tab.classList.remove('bg-gray-100');
                tab.classList.add('bg-green-500', 'text-white');
                this.renderVocabList(modal);
            });
        });

        DOM.id('vocab-level-filter').addEventListener('change', () => this.renderVocabList(modal));
        DOM.id('vocab-topic-filter').addEventListener('change', () => this.renderVocabList(modal));

        this.renderVocabList(modal);
    },

    renderVocabList(modal) {
        const activeTab = modal.querySelector('.vocab-tab.bg-green-500').dataset.tab;
        const levelFilter = DOM.id('vocab-level-filter').value;
        const topicFilter = DOM.id('vocab-topic-filter').value;

        let filtered = WordManager.filterByStatus(activeTab);

        if (levelFilter) {
            filtered = filtered.filter(w => w.level === levelFilter);
        }

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
                                <span class="px-2 py-0.5 text-white text-xs rounded ${APP_CONFIG.LEVEL_COLORS[word.level]}">${word.level}</span>
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

        container.querySelectorAll('.play-word-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const word = btn.dataset.word;
                SpeechService.speak(word, null, null);
            });
        });
    },

    async exportPDF() {
        if (!window.jspdf) {
            await this.loadScript('https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js');
            await this.loadScript('https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js');
        }

        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        const type = prompt('导出类型：\n1 - 全部单词\n2 - 已会单词\n3 - 不会单词', '1');
        if (!type) return;

        let exportWords = [];
        let title = '';

        if (type === '1') {
            exportWords = appState.words;
            title = 'KET核心词汇大全';
        } else if (type === '2') {
            exportWords = WordManager.filterByStatus('mastered');
            title = '已会单词本';
        } else if (type === '3') {
            exportWords = WordManager.filterByStatus('unknown');
            title = '不会单词本';
        }

        if (exportWords.length === 0) {
            DOM.showToast('没有可导出的单词', 'error');
            return;
        }

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
    },

    loadScript(src) {
        return new Promise((resolve, reject) => {
            const script = DOM.create('script');
            script.src = src;
            script.onload = resolve;
            script.onerror = reject;
            document.head.appendChild(script);
        });
    }
};

// 初始化应用
document.addEventListener('DOMContentLoaded', async () => {
    await WordManager.load();
    StorageManager.load();
    UI.initialize();

    if (appState.storage.lastMode) {
        UI.switchMode(appState.storage.lastMode);
        if (appState.currentMode === 'level') {
            WordManager.filterByLevel(appState.currentLevel);
        } else {
            UI.renderTopicButtons();
        }
    } else {
        const levelBtns = DOM.getAll('.level-btn');
        if (levelBtns.length > 0) {
            levelBtns[0].classList.add('active');
            WordManager.filterByLevel('黑1');
        }
        UI.showCurrentWord();
    }

    setTimeout(() => {
        UI.updateStats();
        console.log('页面加载完成，更新统计数据');
    }, 100);
});
