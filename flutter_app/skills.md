# 📘 Impeccable Design Skill: KET Flashcard (Flutter)

这是针对 KET 单词闪卡应用的 UI/UX 进阶规范。AI 在编写 Flutter 代码时必须严格遵守以下审美约束。

---

## 🎨 1. 核心设计令牌 (Design Tokens)

### 颜色系统 (`/colorize`)
* **拒绝纯色**: 严禁使用 `Colors.black` (#000000) 或 `Colors.white` (#FFFFFF)。
* **背景色**: 
  - 浅色模式: `Color(0xFFF8F9FD)` (陶瓷白，带 2% 蓝调)。
  - 深色模式: `Color(0xFF0F1115)` (曜石黑，带 3% 深蓝调)。
* **语义色**:
  - `Know (会了)`: 背景 `Color(0xFFE8F5E9)`，文字 `Color(0xFF2E7D32)`。
  - `Unknown (不会)`: 背景 `Color(0xFFFFEBEE)`，文字 `Color(0xFFC62828)`。
  - `Accent (品牌色)`: 使用柔和的靛蓝色 `Color(0xFF5C6BC0)`。

### 形状与间距 (`/arrange`)
* **大圆角 (Radius)**: 全局容器、卡片、按钮统一使用 `28.0` 的圆角。
* **呼吸间距**: 遵循 `8dp` 步进系统。组件间距优先使用 `24.0` 或 `32.0` 以保持视觉轻松感。
* **微边框**: 放弃重度阴影，使用 `Border.all(color: Colors.black.withOpacity(0.04), width: 0.8)`。

---

## 🔤 2. 单词闪卡规范 (`/typeset` & `/polish`)

### 视觉层级
* **单词文本 (Word)**: 
  - `fontSize: 44.0`, `fontWeight: FontWeight.w900` (Black)。
  - `letterSpacing: -1.2` (紧凑有力)。
* **音标 (Phonetic)**: 
  - 使用 `FontFamily: 'RobotoMono'` 或等宽字体。
  - 颜色使用中性灰 `Colors.grey[500]`。
* **隐藏机制**: 中文释义默认使用 `ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10))`，点击后通过 `AnimatedOpacity` 切换。

### 操作按钮
* **物理反馈**: 所有按钮必须包裹在 `GestureDetector` 中，并实现点击时的缩放动画：按下 `scale(0.94)`，抬起 `Spring` 弹回。
* **布局**: 四个按钮（上一个、不会、发音、会了）应采用非对称高度或明显的视觉权重区分。

---

## 📖 3. 阅读列表：Bento Grid 风格 (`/distill`)

* **网格布局**: 每行 2 列，使用 `StaggeredGridView` 以实现错落感。
* **卡片内容**: 
  - 移除发布日期、阅读量等干扰信息。
  - 结构：[顶部 65% 图片] + [底部标题 (Max 2 lines, w800)] + [底部左侧难度 Capsule 标签]。
* **详情页**: 正文 `fontSize: 18.0`, `height: 1.7` (大行间距)，段落间距 `20.0`。

---

## ⚡ 4. 动效准则 (`/animate`)

* **曲线**: 统一使用 `Curves.easeOutQuart`。
* **卡片切换**: 
  - “会了”：卡片向右上方抛出 (`SlideTransition` + `RotationTransition`)。
  - “不会”：卡片原地轻微左右抖动 (`Shake`)。
* **触感**: 调用 `HapticFeedback.lightImpact()`。

---

## 🛠️ AI 专用指令 (Slash Commands)

* **`/audit`**: 扫描代码，指出任何不符合 `28.0` 圆角、使用了纯黑/纯白或间距过窄的地方。
* **`/polish-ui`**: 为当前的 Widget 添加 `BoxDecoration` 微边框、自定义阴影以及 `Spring` 缩放反馈。
* **`/apply-impeccable`**: 将普通的 Material 组件（如 `ElevatedButton`）替换为符合本规范的自定义容器。

---
