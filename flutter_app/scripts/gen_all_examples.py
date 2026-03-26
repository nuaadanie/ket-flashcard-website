#!/usr/bin/env python3
"""Generate KET-level example sentences for all words missing examples."""

import json
import os
import sys
import time

try:
    from openai import OpenAI
except ImportError:
    print("pip install openai", file=sys.stderr)
    sys.exit(1)

WORDS_PATH = os.path.join(os.path.dirname(__file__), "..", "assets", "words.json")

PROMPT = (
    "You are a KET (Key English Test) English teacher. "
    "For each word given, produce ONE short example sentence (6-12 words) "
    "using only A1/A2 level vocabulary. "
    "The sentence should clearly illustrate the meaning of the word. "
    "Return ONLY a JSON array of strings, one sentence per word, in the same order. "
    "Do NOT include any other text."
)


def main():
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        print("Set OPENAI_API_KEY", file=sys.stderr)
        sys.exit(1)

    client = OpenAI(api_key=api_key)

    with open(WORDS_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)

    words = data["words"]
    empty = [i for i, w in enumerate(words) if not w.get("example")]
    print(f"Total: {len(words)}, missing: {len(empty)}")

    batch_size = 30
    for start in range(0, len(empty), batch_size):
        indices = empty[start : start + batch_size]
        batch = [words[i] for i in indices]
        word_list = [w["word"] for w in batch]
        meanings = [w["meaning"] for w in batch]

        prompt = (
            f"{PROMPT}\n\n"
            f"Words: {json.dumps(word_list)}\n"
            f"Chinese meanings (for reference): {json.dumps(meanings, ensure_ascii=False)}"
        )

        for attempt in range(3):
            try:
                resp = client.chat.completions.create(
                    model="gpt-4o-mini",
                    messages=[{"role": "user", "content": prompt}],
                    temperature=0.7,
                    max_tokens=2048,
                )
                text = resp.choices[0].message.content.strip()
                if text.startswith("```"):
                    text = text.split("\n", 1)[-1].rsplit("```", 1)[0].strip()
                sentences = json.loads(text)
                break
            except Exception as e:
                print(f"  Attempt {attempt+1} failed: {e}")
                if attempt < 2:
                    time.sleep(3)
                else:
                    sentences = []

        assigned = 0
        for j, idx in enumerate(indices):
            if j < len(sentences) and sentences[j] and len(sentences[j]) <= 120:
                words[idx]["example"] = sentences[j]
                assigned += 1

        # Save after each batch
        with open(WORDS_PATH, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        remaining = sum(1 for w in words if not w.get("example"))
        print(f"  Batch {start//batch_size + 1}: assigned {assigned}/{len(indices)}, remaining: {remaining}")

        if start + batch_size < len(empty):
            time.sleep(1)

    final = sum(1 for w in words if w.get("example"))
    print(f"\nDone! {final}/{len(words)} words have examples.")


if __name__ == "__main__":
    main()
