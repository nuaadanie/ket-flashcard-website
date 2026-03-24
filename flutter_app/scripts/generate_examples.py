#!/usr/bin/env python3
"""
Generate KET-level example sentences for all words in assets/words.json.

Uses an AI API (OpenAI-compatible) to produce simple, short example sentences
appropriate for KET learners. Only fills in empty example fields.

Usage:
    export OPENAI_API_KEY="sk-..."
    python3 scripts/generate_examples.py [--model gpt-4o-mini] [--batch-size 20]

The script reads/writes assets/words.json in-place.
"""

import argparse
import json
import os
import sys
import time

try:
    from openai import OpenAI
except ImportError:
    print("Please install openai: pip install openai", file=sys.stderr)
    sys.exit(1)

WORDS_PATH = os.path.join(os.path.dirname(__file__), "..", "assets", "words.json")

SIMPLE_PROMPT = (
    "You are a KET (Key English Test) English teacher. "
    "For each word given, produce ONE short example sentence (6-12 words) "
    "using only A1/A2 level vocabulary. "
    "The sentence should clearly illustrate the meaning of the word. "
    "Return ONLY a JSON array of strings, one sentence per word, in the same order. "
    "Do NOT include any other text."
)


def load_words():
    with open(WORDS_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def save_words(data):
    with open(WORDS_PATH, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def generate_batch(client, model, words_batch):
    """Generate example sentences for a batch of words."""
    word_list = [w["word"] for w in words_batch]
    prompt = (
        f"{SIMPLE_PROMPT}\n\n"
        f"Words: {json.dumps(word_list)}"
    )

    response = client.chat.completions.create(
        model=model,
        messages=[{"role": "user", "content": prompt}],
        temperature=0.7,
        max_tokens=1024,
    )

    text = response.choices[0].message.content.strip()

    # Try to parse JSON array from response
    if text.startswith("```"):
        text = text.split("\n", 1)[-1].rsplit("```", 1)[0].strip()

    try:
        sentences = json.loads(text)
    except json.JSONDecodeError:
        # Fallback: try to extract lines
        sentences = [line.strip().strip('"-,') for line in text.split("\n") if line.strip()]
        sentences = [s for s in sentences if len(s) > 3]

    return sentences


def validate_sentence(sentence, word):
    """Basic validation: length and no complex words."""
    if not sentence or len(sentence) > 120:
        return False
    if len(sentence.split()) > 18:
        return False
    return True


def main():
    parser = argparse.ArgumentParser(description="Generate example sentences for KET flashcards")
    parser.add_argument("--model", default="gpt-4o-mini", help="OpenAI model to use")
    parser.add_argument("--batch-size", type=int, default=20, help="Words per API call")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be done")
    args = parser.parse_args()

    data = load_words()
    words = data["words"]

    # Find words without examples
    empty = [i for i, w in enumerate(words) if not w.get("example")]
    print(f"Total words: {len(words)}")
    print(f"Words without examples: {len(empty)}")

    if not empty:
        print("All words already have examples. Nothing to do.")
        return

    if args.dry_run:
        print("Dry run - would generate examples for:")
        for i in empty[:10]:
            print(f"  {words[i]['word']}")
        if len(empty) > 10:
            print(f"  ... and {len(empty) - 10} more")
        return

    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        print("Error: OPENAI_API_KEY environment variable not set.", file=sys.stderr)
        sys.exit(1)

    client = OpenAI(api_key=api_key)

    # Process in batches
    for batch_start in range(0, len(empty), args.batch_size):
        batch_indices = empty[batch_start:batch_start + args.batch_size]
        batch_words = [words[i] for i in batch_indices]

        print(f"Generating examples for batch {batch_start // args.batch_size + 1} "
              f"({len(batch_words)} words)...")

        try:
            sentences = generate_batch(client, args.model, batch_words)
        except Exception as e:
            print(f"  Error: {e}", file=sys.stderr)
            print("  Skipping this batch. You can re-run to retry.")
            time.sleep(2)
            continue

        # Assign sentences
        for j, idx in enumerate(batch_indices):
            if j < len(sentences):
                sentence = sentences[j]
                if validate_sentence(sentence, words[idx]["word"]):
                    words[idx]["example"] = sentence
                else:
                    print(f"  Validation failed for '{words[idx]['word']}': {sentence}")
            else:
                print(f"  Missing sentence for '{words[idx]['word']}'")

        # Save after each batch
        save_words(data)
        remaining = len([i for i in empty if not words[i].get("example")])
        print(f"  Saved. {remaining} words remaining.")

        if batch_start + args.batch_size < len(empty):
            time.sleep(1)

    final_empty = [w for w in words if not w.get("example")]
    print(f"\nDone! {len(words) - len(final_empty)}/{len(words)} words have examples.")
    if final_empty:
        print(f"Still missing: {[w['word'] for w in final_empty[:10]]}")


if __name__ == "__main__":
    main()
