#!/bin/bash
# Generate KET example sentences using OpenAI API via curl
# Usage: OPENAI_API_KEY=sk-... bash scripts/gen_all_examples.sh

set -e

WORDS_FILE="assets/words.json"
API_KEY="${OPENAI_API_KEY}"

if [ -z "$API_KEY" ]; then
    echo "Set OPENAI_API_KEY" >&2
    exit 1
fi

# Extract words without examples
EMPTY_WORDS=$(python3 -c "
import json
with open('$WORDS_FILE', 'r') as f:
    data = json.load(f)
empty = [(i, w['word'], w['meaning']) for i, w in enumerate(data['words']) if not w.get('example')]
print(len(empty))
for idx, word, meaning in empty:
    print(f'{idx}|{word}|{meaning}')
")

TOTAL_EMPTY=$(echo "$EMPTY_WORDS" | head -1)
echo "Total words without examples: $TOTAL_EMPTY"

# Process in batches of 30
BATCH=30
OFFSET=0

while [ $OFFSET -lt $TOTAL_EMPTY ]; do
    # Build batch
    BATCH_WORDS=""
    BATCH_MEANINGS=""
    BATCH_INDICES=""
    COUNT=0

    while IFS='|' read -r idx word meaning; do
        [ -z "$idx" ] && continue
        [ "$idx" = "idx" ] && continue
        if [ $COUNT -ge $OFFSET ] && [ $COUNT -lt $((OFFSET + BATCH)) ]; then
            if [ -n "$BATCH_WORDS" ]; then
                BATCH_WORDS="$BATCH_WORDS, "
                BATCH_MEANINGS="$BATCH_MEANINGS, "
                BATCH_INDICES="$BATCH_INDICES "
            fi
            BATCH_WORDS="$BATCH_WORDS\"$word\""
            BATCH_MEANINGS="$BATCH_MEANINGS\"$meaning\""
            BATCH_INDICES="$BATCH_INDICES$idx"
        fi
        COUNT=$((COUNT + 1))
    done <<< "$(echo "$EMPTY_WORDS" | tail -n +2)"

    BATCH_NUM=$((OFFSET / BATCH + 1))
    echo "Batch $BATCH_NUM: processing words $OFFSET to $((OFFSET + BATCH - 1))..."

    # Build JSON payload
    PROMPT="You are a KET (Key English Test) English teacher. For each word given, produce ONE short example sentence (6-12 words) using only A1/A2 level vocabulary. The sentence should clearly illustrate the meaning of the word. Return ONLY a JSON array of strings, one sentence per word, in the same order. Do NOT include any other text.

Words: [$BATCH_WORDS]
Chinese meanings (for reference): [$BATCH_MEANINGS]"

    PAYLOAD=$(python3 -c "
import json, sys
msg = sys.argv[1]
print(json.dumps({
    'model': 'gpt-4o-mini',
    'messages': [{'role': 'user', 'content': msg}],
    'temperature': 0.7,
    'max_tokens': 2048
}))
" "$PROMPT")

    # Call API
    RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "$PAYLOAD" 2>&1)

    # Extract content
    CONTENT=$(python3 -c "
import json, sys
try:
    resp = json.loads(sys.argv[1])
    text = resp['choices'][0]['message']['content'].strip()
    if text.startswith('\`\`\`'):
        text = text.split('\n', 1)[-1].rsplit('\`\`\`', 1)[0].strip()
    print(text)
except Exception as e:
    print('ERROR: ' + str(e), file=sys.stderr)
    print('[]')
" "$RESPONSE")

    # Apply to words.json
    python3 -c "
import json, sys

indices_str = sys.argv[1]
sentences_str = sys.argv[2]

indices = [int(x) for x in indices_str.split()]
sentences = json.loads(sentences_str)

with open('$WORDS_FILE', 'r') as f:
    data = json.load(f)

assigned = 0
for j, idx in enumerate(indices):
    if j < len(sentences) and sentences[j] and len(str(sentences[j])) <= 120:
        data['words'][idx]['example'] = sentences[j]
        assigned += 1

with open('$WORDS_FILE', 'w') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

remaining = sum(1 for w in data['words'] if not w.get('example'))
print(f'  Assigned {assigned}/{len(indices)}, remaining: {remaining}')
" "$BATCH_INDICES" "$CONTENT"

    OFFSET=$((OFFSET + BATCH))
    sleep 1
done

# Final count
python3 -c "
import json
with open('$WORDS_FILE', 'r') as f:
    data = json.load(f)
with_ex = sum(1 for w in data['words'] if w.get('example'))
print(f'\nDone! {with_ex}/{len(data[\"words\"])} words have examples.')
"
