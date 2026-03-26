#!/usr/bin/env python3
"""Generate word_visuals.dart from words.json with semantic visual mappings."""
import json
import hashlib
import os

os.chdir('/home/admin/.openclaw/workspace/projects/ket-flashcard-website/flutter_app')

with open('assets/words.json') as f:
    data = json.load(f)

verbs = [w for w in data['words'] if w['topic'].startswith('Verbs')]
adjs = [w for w in data['words'] if w['topic'].startswith('Adjectives')]

# Animation types for verbs vs adjectives
VERB_ANIMS = ['bounce', 'slide', 'wave', 'rotate', 'expand', 'flow']
ADJ_ANIMS = ['pulse', 'breathe', 'sparkle', 'morph', 'pulse', 'breathe']

# Semantic meaning → visual config overrides
# Format: word -> (palette_hex, shape_types, anim_type, motif)
SEMANTIC = {
    # === VERBS ===
    'add': (['4CAF50', '81C784'], ['circle', 'circle', 'cross'], 'expand', 'two circles merging with +'),
    'clap': (['FF9800', 'FFB74D'], ['circle', 'star'], 'shake', 'hand shapes clapping'),
    'clean': (['00BCD4', '80DEEA'], ['circle', 'dot'], 'sparkle', 'water drops shimmering'),
    'complete': (['4CAF50', 'C8E6C9'], ['circle', 'star'], 'pulse', 'checkmark circle'),
    'count': (['3F51B5', '7986CB'], ['dot', 'dot', 'dot'], 'slide', 'numbers sliding'),
    'like': (['E91E63', 'F48FB1'], ['heart'], 'pulse', 'heart beating'),
    'look at': (['9C27B0', 'CE93D8'], ['circle', 'dot'], 'pulse', 'eye with pupil'),
    'love': (['E91E63', 'FF5252'], ['heart'], 'breathe', 'heart breathing'),
    'paint': (['FF5722', 'FFC107', '4CAF50', '2196F3'], ['circle', 'circle', 'circle'], 'flow', 'paint palette'),
    'pick up': (['795548', 'A1887F'], ['arrow', 'circle'], 'bounce', 'hand picking up'),
    'point': (['607D8B', '90A4AE'], ['arrow'], 'slide', 'finger pointing'),
    'show': (['FF9800', 'FFC107'], ['star', 'circle'], 'expand', 'spotlight reveal'),
    'start': (['4CAF50', '8BC34A'], ['triangle', 'circle'], 'slide', 'play button'),
    'stop': (['F44336', 'E57373'], ['circle', 'rect'], 'pulse', 'stop sign'),
    'talk': (['2196F3', '64B5F6'], ['circle', 'dot', 'dot'], 'wave', 'speech bubbles'),
    'try': (['FF9800', 'FFE082'], ['circle', 'arrow'], 'bounce', 'effort bouncing'),
    'want': (['9C27B0', 'E1BEE7'], ['star', 'ring'], 'breathe', 'wish shimmer'),
    'wave': (['03A9F4', '81D4FA'], ['wave'], 'wave', 'waving hand'),
    'call': (['009688', '80CBC4'], ['circle', 'dot', 'dot'], 'shake', 'phone ringing'),
    'carry': (['795548', 'BCAAA4'], ['roundedRect', 'arrow'], 'bounce', 'lifting weight'),
    'change': (['FF5722', 'FF9800'], ['circle', 'circle'], 'morph', 'two shapes morphing'),
    'climb': (['4CAF50', '8D6E63'], ['triangle', 'dot'], 'bounce', 'figure climbing up'),
    'dress up': (['E91E63', 'FCE4EC'], ['roundedRect', 'star'], 'sparkle', 'fancy outfit'),
    'drop': (['2196F3', '90CAF9'], ['circle'], 'bounce', 'ball dropping'),
    'dry': (['FFC107', 'FFF9C4'], ['circle', 'dot'], 'sparkle', 'sun drying'),
    'fix': (['607D8B', 'B0BEC5'], ['cross', 'circle'], 'rotate', 'wrench turning'),
    'help': (['4CAF50', 'E91E63'], ['heart', 'circle'], 'pulse', 'hands together'),
    'invite': (['9C27B0', 'E1BEE7'], ['star', 'ring'], 'expand', 'invitation card'),
    'laugh': (['FFC107', 'FFF176'], ['circle', 'dot', 'dot'], 'bounce', 'happy face'),
    'look for': (['3F51B5', '9FA8DA'], ['circle', 'dot'], 'slide', 'searching eye'),
    'move': (['FF5722', 'FF8A65'], ['arrow', 'circle'], 'slide', 'moving arrow'),
    'need': (['F44336', 'EF9A9A'], ['exclamation'], 'pulse', 'urgent need'),
    'practise': (['3F51B5', '7986CB'], ['circle', 'arrow'], 'rotate', 'repeating motion'),
    'shop': (['E91E63', 'F48FB1'], ['roundedRect', 'dot'], 'bounce', 'shopping bag'),
    'shout': (['F44336', 'FF5252'], ['star', 'dot'], 'shake', 'loud exclamation'),
    'travel': (['2196F3', '81D4FA'], ['circle', 'dot'], 'slide', 'moving around globe'),
    'wait': (['9E9E9E', 'BDBDBD'], ['circle', 'dot'], 'breathe', 'clock waiting'),
    'water': (['2196F3', '4FC3F7'], ['circle', 'dot'], 'bounce', 'water drops'),
    'act': (['9C27B0', 'CE93D8'], ['star', 'circle'], 'sparkle', 'stage performance'),
    'agree': (['4CAF50', 'A5D6A7'], ['circle', 'circle'], 'pulse', 'two checkmarks'),
    'appear': (['FFC107', 'FFE082'], ['circle', 'star'], 'expand', 'materializing'),
    'arrive': (['4CAF50', '81C784'], ['circle', 'dot'], 'slide', 'arriving at destination'),
    'believe': (['9C27B0', 'E1BEE7'], ['star', 'ring'], 'breathe', 'faith star'),
    'borrow': (['FF9800', 'FFCC80'], ['arrow', 'circle'], 'slide', 'arrow exchange'),
    'camp': (['4CAF50', '8D6E63'], ['triangle', 'circle'], 'breathe', 'tent under stars'),
    'chat': (['2196F3', '64B5F6'], ['roundedRect', 'dot', 'dot'], 'wave', 'chat bubbles'),
    'cycle': (['607D8B', '90A4AE'], ['circle', 'circle'], 'rotate', 'bicycle wheels'),
    'decide': (['673AB7', 'B39DDB'], ['diamond', 'circle'], 'pulse', 'decision point'),
    'design': (['FF5722', 'FF8A65'], ['star', 'circle'], 'rotate', 'creative design'),
    'disappear': (['9E9E9E', 'CFD8DC'], ['circle'], 'breathe', 'fading away'),
    'enter': (['4CAF50', '81C784'], ['rect', 'arrow'], 'slide', 'entering door'),
    'win a competition': (['FFC107', 'FFD54F'], ['star', 'circle'], 'sparkle', 'trophy star'),
    'explain': (['2196F3', '90CAF9'], ['circle', 'dot', 'dot'], 'wave', 'explaining waves'),
    'explore': (['00BCD4', '4DD0E1'], ['circle', 'arrow'], 'slide', 'compass exploring'),
    'fetch': (['795548', 'A1887F'], ['arrow', 'circle'], 'slide', 'going and returning'),
    'finish': (['4CAF50', 'C8E6C9'], ['circle', 'star'], 'expand', 'completion star'),
    'follow': (['607D8B', 'B0BEC5'], ['dot', 'dot', 'dot'], 'slide', 'dots following'),
    'guess': (['9C27B0', 'CE93D8'], ['circle', 'dot'], 'pulse', 'question mark'),
    'happen': (['FF9800', 'FFE082'], ['star', 'circle'], 'expand', 'event occurring'),
    'hate': (['F44336', 'EF5350'], ['circle', 'cross'], 'shake', 'anger shaking'),
    'hope': (['4CAF50', 'FFC107'], ['star', 'ring'], 'breathe', 'hopeful star'),
    'hurry': (['F44336', 'FF8A65'], ['arrow', 'dot'], 'shake', 'fast running'),
    'improve': (['4CAF50', '81C784'], ['arrow', 'circle'], 'bounce', 'upward growth'),
    'invent': (['FFC107', 'FFD54F'], ['star', 'ring'], 'sparkle', 'lightbulb moment'),
    'lift': (['795548', 'BCAAA4'], ['arrow', 'roundedRect'], 'bounce', 'lifting up'),
    'look after': (['4CAF50', '81C784'], ['heart', 'circle'], 'breathe', 'caring heart'),
    'look like': (['9C27B0', 'CE93D8'], ['circle', 'circle'], 'morph', 'two similar shapes'),
    'mind': (['3F51B5', '9FA8DA'], ['circle', 'dot'], 'pulse', 'thinking brain'),
    'mix': (['FF5722', '2196F3', 'FFC107'], ['circle', 'circle'], 'flow', 'colors mixing'),
    'post': (['795548', 'D7CCC8'], ['roundedRect', 'arrow'], 'slide', 'sending letter'),
    'prefer': (['9C27B0', 'CE93D8'], ['star', 'circle'], 'pulse', 'preference star'),
    'prepare': (['FF9800', 'FFCC80'], ['rect', 'circle'], 'expand', 'getting ready'),
    'pull': (['607D8B', '90A4AE'], ['arrow'], 'slide', 'pulling arrow'),
    'push': (['607D8B', '90A4AE'], ['arrow'], 'slide', 'pushing arrow'),
    'remember': (['3F51B5', '7986CB'], ['star', 'ring'], 'breathe', 'memory star'),
    'repair': (['607D8B', 'B0BEC5'], ['cross', 'circle'], 'rotate', 'repairing tools'),
    'repeat': (['3F51B5', '9FA8DA'], ['circle', 'circle', 'circle'], 'orbit', 'circles repeating'),
    'save': (['4CAF50', 'A5D6A7'], ['heart', 'circle'], 'pulse', 'saving heart'),
    'sound': (['9C27B0', 'E1BEE7'], ['circle', 'ring', 'ring'], 'wave', 'sound waves'),
    'stay': (['607D8B', 'B0BEC5'], ['circle'], 'breathe', 'staying still'),
    'thank': (['E91E63', 'F48FB1'], ['heart', 'star'], 'sparkle', 'grateful heart'),
    'tidy': (['00BCD4', '80DEEA'], ['roundedRect', 'dot'], 'sparkle', 'clean sparkle'),
    'touch': (['FF9800', 'FFCC80'], ['circle', 'dot'], 'pulse', 'touching point'),
    'turn': (['607D8B', '90A4AE'], ['arrow'], 'rotate', 'turning arrow'),
    'turn off': (['9E9E9E', 'BDBDBD'], ['circle', 'dot'], 'breathe', 'power off'),
    'turn on': (['4CAF50', '81C784'], ['circle', 'dot'], 'pulse', 'power on'),
    'use': (['FF9800', 'FFCC80'], ['circle', 'arrow'], 'slide', 'using tool'),
    'visit': (['2196F3', '90CAF9'], ['circle', 'star'], 'bounce', 'visiting place'),
    'whisper': (['9E9E9E', 'CFD8DC'], ['circle', 'dot'], 'breathe', 'quiet whisper'),
    'whistle': (['03A9F4', '81D4FA'], ['circle', 'dot'], 'wave', 'whistle sound'),
    'wish': (['FFC107', 'FFF176'], ['star'], 'sparkle', 'wish upon star'),
    'be': (['9E9E9E', 'CFD8DC'], ['circle'], 'breathe', 'being existing'),
    'can': (['4CAF50', '81C784'], ['star', 'circle'], 'pulse', 'ability star'),
    'choose': (['673AB7', 'B39DDB'], ['diamond', 'diamond'], 'pulse', 'choosing between'),
    'come': (['2196F3', '64B5F6'], ['arrow', 'dot'], 'slide', 'coming toward'),
    'do': (['FF9800', 'FFE082'], ['circle', 'arrow'], 'bounce', 'doing action'),
    'get': (['4CAF50', '81C784'], ['circle', 'arrow'], 'expand', 'getting item'),
    'give': (['E91E63', 'F48FB1'], ['heart', 'arrow'], 'slide', 'giving heart'),
    'go to bed': (['3F51B5', '7986CB'], ['roundedRect', 'star'], 'breathe', 'moon and bed'),
    'go to sleep': (['3F51B5', '7986CB'], ['circle', 'star', 'star'], 'breathe', 'sleeping moon'),
    'have': (['FF9800', 'FFCC80'], ['circle', 'star'], 'pulse', 'having star'),
    'have got': (['4CAF50', 'A5D6A7'], ['circle', 'star'], 'pulse', 'got it star'),
    'hold': (['795548', 'BCAAA4'], ['circle', 'roundedRect'], 'breathe', 'holding tight'),
    "let's": (['4CAF50', '81C784'], ['arrow', 'arrow'], 'bounce', 'let us go'),
    'make': (['FF5722', 'FF8A65'], ['star', 'circle'], 'expand', 'making creation'),
    'put': (['607D8B', 'B0BEC5'], ['rect', 'arrow'], 'slide', 'putting down'),
    'say': (['2196F3', '64B5F6'], ['roundedRect', 'dot'], 'wave', 'saying words'),
    'see': (['9C27B0', 'CE93D8'], ['circle', 'dot'], 'pulse', 'seeing eye'),
    'would like': (['E91E63', 'F48FB1'], ['heart', 'ring'], 'breathe', 'desiring heart'),
    'be called': (['009688', '80CBC4'], ['roundedRect', 'dot'], 'wave', 'name tag'),
    'bring': (['795548', 'A1887F'], ['arrow', 'circle'], 'slide', 'bringing item'),
    'build': (['FF9800', 'FFCC80'], ['rect', 'rect', 'triangle'], 'bounce', 'building blocks'),
    'buy': (['4CAF50', '81C784'], ['roundedRect', 'dot'], 'bounce', 'shopping buy'),
    'catch': (['FF9800', 'FFE082'], ['circle', 'circle'], 'expand', 'catching ball'),
    'catch (a bus)': (['2196F3', '64B5F6'], ['roundedRect', 'dot'], 'slide', 'catching bus'),
    'feed': (['4CAF50', 'A5D6A7'], ['circle', 'dot', 'dot'], 'bounce', 'feeding'),
    'get dressed': (['E91E63', 'F48FB1'], ['roundedRect', 'star'], 'expand', 'getting dressed'),
    'get off': (['2196F3', '90CAF9'], ['arrow', 'rect'], 'slide', 'getting off'),
    'get on': (['2196F3', '90CAF9'], ['arrow', 'rect'], 'slide', 'getting on'),
    'get undressed': (['9E9E9E', 'CFD8DC'], ['roundedRect'], 'breathe', 'undressing'),
    'get up': (['FFC107', 'FFF176'], ['circle', 'arrow'], 'bounce', 'waking up'),
    'grow': (['4CAF50', '81C784'], ['circle'], 'expand', 'growing circle'),
    'have': (['F44336', 'EF9A9A'], ['circle', 'arrow'], 'pulse', 'must do'),
    'hide': (['9E9E9E', 'CFD8DC'], ['circle'], 'breathe', 'hiding away'),
    'lose': (['9E9E9E', 'BDBDBD'], ['circle', 'dot'], 'breathe', 'losing'),
    'mean': (['3F51B5', '9FA8DA'], ['equals'], 'pulse', 'meaning equals'),
    'must': (['F44336', 'E57373'], ['exclamation', 'circle'], 'pulse', 'must do'),
    'put on': (['E91E63', 'F48FB1'], ['roundedRect', 'arrow'], 'bounce', 'putting on'),
    'send': (['2196F3', '64B5F6'], ['arrow', 'roundedRect'], 'slide', 'sending message'),
    'take': (['795548', 'BCAAA4'], ['arrow', 'circle'], 'slide', 'taking item'),
    'take off': (['03A9F4', '81D4FA'], ['arrow', 'circle'], 'bounce', 'taking off'),
    'teach': (['3F51B5', '7986CB'], ['rect', 'star'], 'expand', 'teaching'),
    'think': (['9C27B0', 'CE93D8'], ['circle', 'dot', 'dot'], 'breathe', 'thinking'),
    'wake': (['FFC107', 'FFF176'], ['circle', 'star'], 'pulse', 'waking up'),
    'begin': (['4CAF50', '81C784'], ['triangle', 'circle'], 'expand', 'beginning'),
    'break': (['F44336', 'EF5350'], ['rect', 'rect'], 'shake', 'breaking apart'),
    'burn': (['FF5722', 'FF9800'], ['triangle', 'triangle'], 'wave', 'fire burning'),
    'feel': (['E91E63', 'F48FB1'], ['heart', 'circle'], 'breathe', 'feeling heart'),
    'find out': (['FFC107', 'FFD54F'], ['star', 'circle'], 'sparkle', 'discovery'),
    'forget': (['9E9E9E', 'CFD8DC'], ['circle', 'dot'], 'breathe', 'fading memory'),
    'go out': (['3F51B5', '9FA8DA'], ['arrow', 'rect'], 'slide', 'going outside'),
    'hear': (['9C27B0', 'E1BEE7'], ['circle', 'ring', 'ring'], 'wave', 'hearing sound'),
    'keep': (['795548', 'A1887F'], ['roundedRect', 'circle'], 'breathe', 'keeping safe'),
    'leave': (['607D8B', '90A4AE'], ['arrow', 'circle'], 'slide', 'leaving'),
    'let': (['4CAF50', 'A5D6A7'], ['circle', 'arrow'], 'expand', 'letting go'),
    'lie': (['3F51B5', '7986CB'], ['oval'], 'breathe', 'lying down'),
    'make sure': (['4CAF50', 'C8E6C9'], ['circle', 'star'], 'pulse', 'check mark'),
    'sell': (['FF9800', 'FFCC80'], ['roundedRect', 'arrow'], 'slide', 'selling'),
    'speak': (['2196F3', '64B5F6'], ['circle', 'dot', 'dot'], 'wave', 'speaking'),
    'spend': (['4CAF50', '81C784'], ['circle', 'arrow'], 'slide', 'spending'),

    # === ADJECTIVES ===
    'angry': (['F44336', 'D32F2F'], ['triangle', 'triangle'], 'shake', 'angry sharp'),
    'beautiful': (['E91E63', 'F48FB1', 'FFC107'], ['star', 'heart'], 'sparkle', 'beautiful sparkles'),
    'big': (['E65100', 'FF8A65'], ['circle'], 'pulse', 'big circle'),
    'black': (['212121', '424242'], ['circle'], 'breathe', 'dark circle'),
    'blue': (['2196F3', '64B5F6'], ['circle', 'oval'], 'breathe', 'blue shapes'),
    'brown': (['795548', 'A1887F'], ['circle', 'oval'], 'breathe', 'brown shapes'),
    'clean': (['00BCD4', 'E0F7FA'], ['circle', 'star'], 'sparkle', 'clean sparkle'),
    'closed': (['607D8B', '90A4AE'], ['rect', 'rect'], 'breathe', 'closed door'),
    'cool': (['00BCD4', '80DEEA'], ['circle', 'ring'], 'breathe', 'cool breeze'),
    'correct': (['4CAF50', 'C8E6C9'], ['circle', 'dot'], 'pulse', 'correct check'),
    'dirty': (['795548', '8D6E63'], ['circle', 'dot', 'dot'], 'breathe', 'dirty spots'),
    'double': (['3F51B5', '7986CB'], ['circle', 'circle'], 'pulse', 'double circles'),
    'English': (['F44336', '1565C0'], ['circle', 'rect'], 'breathe', 'english flag'),
    'fantastic': (['FFC107', 'FFD54F', 'FF5722'], ['star', 'star'], 'sparkle', 'fantastic stars'),
    'favourite': (['E91E63', 'F48FB1'], ['heart', 'star'], 'pulse', 'favourite heart'),
    'fun': (['FFC107', 'FFF176'], ['star', 'circle'], 'bounce', 'fun bouncing'),
    'funny': (['FFC107', 'FF9800'], ['circle', 'dot', 'dot'], 'bounce', 'funny face'),
    'good': (['4CAF50', '81C784'], ['circle', 'star'], 'pulse', 'good star'),
    'gray': (['9E9E9E', 'BDBDBD'], ['circle', 'oval'], 'breathe', 'gray shapes'),
    'great': (['4CAF50', 'A5D6A7', 'FFC107'], ['star'], 'sparkle', 'great star'),
    'happy': (['FFC107', 'FFF176'], ['circle', 'dot', 'dot'], 'bounce', 'happy face'),
    'long': (['3F51B5', '9FA8DA'], ['oval'], 'expand', 'long shape'),
    'new': (['4CAF50', 'C8E6C9'], ['star', 'circle'], 'sparkle', 'new sparkle'),
    'nice': (['E91E63', 'F48FB1'], ['heart', 'circle'], 'breathe', 'nice heart'),
    'old': (['795548', 'BCAAA4'], ['circle', 'ring'], 'breathe', 'old ring'),
    'open': (['4CAF50', '81C784'], ['rect', 'arrow'], 'expand', 'open door'),
    'orange': (['FF9800', 'FFB74D'], ['circle'], 'pulse', 'orange circle'),
    'pink': (['E91E63', 'F48FB1'], ['circle', 'heart'], 'breathe', 'pink shapes'),
    'purple': (['9C27B0', 'CE93D8'], ['circle', 'star'], 'breathe', 'purple shapes'),
    'red': (['F44336', 'E57373'], ['circle'], 'pulse', 'red circle'),
    'right': (['4CAF50', 'A5D6A7'], ['circle', 'dot'], 'pulse', 'right mark'),
    'sad': (['5C6BC0', '9FA8DA'], ['circle', 'dot', 'dot'], 'breathe', 'sad face'),
    'scary': (['9C27B0', '4A148C'], ['triangle', 'dot'], 'shake', 'scary spikes'),
    'short': (['FF9800', 'FFCC80'], ['circle'], 'pulse', 'short circle'),
    'small': (['03A9F4', '81D4FA'], ['circle'], 'breathe', 'small circle'),
    'sorry': (['5C6BC0', '9FA8DA'], ['heart', 'circle'], 'breathe', 'sorry heart'),
    'ugly': (['795548', '8D6E63'], ['circle', 'cross'], 'shake', 'ugly shapes'),
    'white': (['ECEFF1', 'CFD8DC'], ['circle', 'oval'], 'breathe', 'white shapes'),
    'yellow': (['FFC107', 'FFF176'], ['circle'], 'pulse', 'yellow circle'),
    'young': (['4CAF50', '81C784'], ['circle', 'star'], 'bounce', 'young bounce'),
    'afraid': (['9C27B0', '7B1FA2'], ['circle', 'dot'], 'shake', 'afraid shaking'),
    'all': (['3F51B5', '7986CB'], ['circle', 'circle', 'circle'], 'orbit', 'all circles'),
    'all right': (['4CAF50', '81C784'], ['circle', 'star'], 'pulse', 'all right'),
    'asleep': (['3F51B5', '5C6BC0'], ['circle', 'star', 'star'], 'breathe', 'sleeping stars'),
    'awake': (['FFC107', 'FFF176'], ['circle', 'star'], 'pulse', 'awake sun'),
    'back': (['607D8B', '90A4AE'], ['arrow'], 'slide', 'back arrow'),
    'bad': (['F44336', 'EF5350'], ['circle', 'cross'], 'shake', 'bad mark'),
    'best': (['FFC107', 'FFD54F'], ['star', 'star'], 'sparkle', 'best stars'),
    'better': (['4CAF50', '81C784'], ['arrow', 'circle'], 'bounce', 'better up'),
    'blond(e)': (['FFC107', 'FFF9C4'], ['oval', 'dot'], 'breathe', 'blonde hair'),
    'boring': (['9E9E9E', 'BDBDBD'], ['rect'], 'breathe', 'boring flat'),
    'bottom': (['607D8B', '90A4AE'], ['rect', 'arrow'], 'breathe', 'bottom down'),
    'brave': (['F44336', 'FF5722'], ['star', 'shield'], 'pulse', 'brave star'),
    'brilliant': (['FFC107', 'FFF176', 'FF5722'], ['star', 'star'], 'sparkle', 'brilliant sparkle'),
    'busy': (['FF5722', 'FF8A65'], ['circle', 'dot', 'dot'], 'shake', 'busy buzzing'),
    'careful': (['FF9800', 'FFCC80'], ['exclamation', 'circle'], 'pulse', 'careful warning'),
    'clever': (['9C27B0', 'CE93D8'], ['star', 'circle'], 'sparkle', 'clever brain'),
    'cloudy': (['90A4AE', 'CFD8DC'], ['oval', 'oval'], 'wave', 'clouds floating'),
    'cold': (['2196F3', 'B3E5FC'], ['circle', 'dot', 'dot'], 'breathe', 'cold ice'),
    'curly': (['FF9800', 'FFCC80'], ['ring', 'ring'], 'wave', 'curly waves'),
    'dangerous': (['F44336', 'FF5722'], ['triangle', 'exclamation'], 'shake', 'danger warning'),
    'different': (['673AB7', 'E91E63', '4CAF50'], ['circle', 'triangle', 'diamond'], 'morph', 'different shapes'),
    'difficult': (['F44336', 'E57373'], ['star', 'cross'], 'shake', 'difficult cross'),
    'dry': (['FFC107', 'FFF9C4'], ['circle', 'dot'], 'sparkle', 'dry sun'),
    'easy': (['4CAF50', 'C8E6C9'], ['circle', 'star'], 'pulse', 'easy check'),
    'exciting': (['FF5722', 'FF9800', 'FFC107'], ['star', 'star'], 'sparkle', 'exciting fireworks'),
    'fair': (['FFC107', 'FFF176'], ['circle', 'star'], 'breathe', 'fair balanced'),
    'famous': (['FFC107', 'FFD54F'], ['star', 'star', 'star'], 'sparkle', 'famous stars'),
    'fat': (['FF9800', 'FFCC80'], ['oval'], 'pulse', 'fat oval'),
    'fine': (['4CAF50', '81C784'], ['circle', 'dot'], 'breathe', 'fine circle'),
    'first': (['FFC107', 'FFD54F'], ['star', 'circle'], 'pulse', 'number one'),
    'frightened': (['9C27B0', '7B1FA2'], ['circle', 'dot'], 'shake', 'frightened shaking'),
    'hot': (['F44336', 'FF5722'], ['triangle', 'triangle'], 'wave', 'hot fire'),
    'huge': (['E65100', 'FF6D00'], ['circle'], 'pulse', 'huge circle'),
    'hungry': (['FF9800', 'FFCC80'], ['circle', 'dot'], 'breathe', 'hungry stomach'),
    'ill': (['9E9E9E', 'BDBDBD'], ['circle', 'dot'], 'breathe', 'ill face'),
    'last': (['607D8B', '90A4AE'], ['circle', 'dot'], 'breathe', 'last one'),
    'little': (['03A9F4', '81D4FA'], ['circle'], 'breathe', 'little dot'),
    'loud': (['F44336', 'FF5252'], ['circle', 'ring', 'ring'], 'wave', 'loud waves'),
    'naughty': (['FF5722', 'FF8A65'], ['star', 'dot'], 'shake', 'naughty mischief'),
    'pretty': (['E91E63', 'F48FB1'], ['heart', 'star'], 'sparkle', 'pretty sparkles'),
    'quick': (['FF5722', 'FF8A65'], ['arrow', 'dot'], 'slide', 'quick arrow'),
    'quiet': (['9E9E9E', 'CFD8DC'], ['circle', 'dot'], 'breathe', 'quiet whisper'),
    'round': (['FF9800', 'FFCC80'], ['circle'], 'rotate', 'round spinning'),
    'safe': (['4CAF50', 'A5D6A7'], ['circle', 'shield'], 'breathe', 'safe shield'),
    'second': (['3F51B5', '9FA8DA'], ['circle', 'circle'], 'pulse', 'second place'),
    'sick': (['9E9E9E', 'BDBDBD'], ['circle', 'dot'], 'breathe', 'sick face'),
    'slow': (['9E9E9E', 'CFD8DC'], ['circle', 'dot'], 'breathe', 'slow moving'),
    'square': (['FF9800', 'FFCC80'], ['rect'], 'pulse', 'square shape'),
    'straight': (['607D8B', '90A4AE'], ['rect'], 'breathe', 'straight line'),
    'strong': (['F44336', 'E57373'], ['circle', 'star'], 'pulse', 'strong power'),
    'sunny': (['FFC107', 'FFF176'], ['circle', 'dot', 'dot', 'dot'], 'rotate', 'sun rays'),
    'surprised': (['FFC107', 'FF5722'], ['circle', 'dot'], 'expand', 'surprised face'),
    'sweet': (['E91E63', 'F48FB1'], ['heart', 'circle'], 'breathe', 'sweet candy'),
    'tall': (['4CAF50', '81C784'], ['oval'], 'expand', 'tall shape'),
    'terrible': (['F44336', 'B71C1C'], ['triangle', 'cross'], 'shake', 'terrible danger'),
    'thin': (['90A4AE', 'B0BEC5'], ['oval'], 'breathe', 'thin shape'),
    'third': (['795548', 'A1887F'], ['circle', 'circle', 'circle'], 'pulse', 'third place'),
    'thirsty': (['2196F3', '64B5F6'], ['circle', 'dot'], 'breathe', 'thirsty water'),
    'tired': (['9E9E9E', 'BDBDBD'], ['circle', 'dot', 'dot'], 'breathe', 'tired face'),
    'weak': (['9E9E9E', 'CFD8DC'], ['circle'], 'breathe', 'weak circle'),
    'well': (['4CAF50', 'A5D6A7'], ['circle', 'star'], 'pulse', 'well star'),
    'wet': (['2196F3', '4FC3F7'], ['circle', 'dot'], 'bounce', 'wet drops'),
    'windy': (['03A9F4', '81D4FA'], ['wave', 'dot'], 'wave', 'wind blowing'),
    'worse': (['F44336', 'EF5350'], ['circle', 'arrow'], 'shake', 'worse down'),
    'worst': (['B71C1C', 'F44336'], ['circle', 'cross'], 'shake', 'worst mark'),
    'wrong': (['F44336', 'E57373'], ['circle', 'cross'], 'shake', 'wrong cross'),
    'alone': (['9E9E9E', 'CFD8DC'], ['circle'], 'breathe', 'alone single'),
    'amazing': (['FFC107', 'FF5722', '9C27B0'], ['star', 'star'], 'sparkle', 'amazing stars'),
    'bored': (['9E9E9E', 'BDBDBD'], ['circle', 'dot', 'dot'], 'breathe', 'bored face'),
    'broken': (['F44336', 'EF5350'], ['rect', 'rect'], 'shake', 'broken pieces'),
    'cheap': (['4CAF50', '81C784'], ['circle', 'dot'], 'pulse', 'cheap price'),
    'dark': (['212121', '424242'], ['circle', 'star'], 'breathe', 'dark night'),
    'dear': (['E91E63', 'F48FB1'], ['heart', 'circle'], 'breathe', 'dear heart'),
    'deep': (['1565C0', '0D47A1'], ['circle', 'oval'], 'breathe', 'deep ocean'),
    'delicious': (['E91E63', 'FF5722', 'FFC107'], ['star', 'heart'], 'sparkle', 'delicious food'),
    'early': (['FFC107', 'FFF176'], ['circle', 'dot'], 'breathe', 'early morning'),
    'empty': (['CFD8DC', 'ECEFF1'], ['ring'], 'breathe', 'empty ring'),
    'enormous': (['E65100', 'FF6D00'], ['circle'], 'pulse', 'enormous circle'),
    'excellent': (['FFC107', 'FFD54F'], ['star', 'star'], 'sparkle', 'excellent stars'),
    'excited': (['FF5722', 'FF9800'], ['star', 'dot'], 'bounce', 'excited bouncing'),
    'expensive': (['FFC107', 'FFD54F'], ['star', 'circle'], 'sparkle', 'expensive gold'),
    'extinct': (['9E9E9E', 'BDBDBD'], ['circle', 'dot'], 'breathe', 'extinct fading'),
    'far': (['2196F3', '90CAF9'], ['circle', 'dot'], 'breathe', 'far distance'),
    'fast': (['FF5722', 'FF8A65'], ['arrow', 'dot'], 'slide', 'fast speed'),
    'foggy': (['90A4AE', 'B0BEC5'], ['oval', 'oval', 'oval'], 'wave', 'foggy mist'),
    'friendly': (['4CAF50', '81C784'], ['heart', 'circle'], 'pulse', 'friendly heart'),
    'frightening': (['9C27B0', '4A148C'], ['triangle', 'dot'], 'shake', 'frightening'),
    'front': (['607D8B', '90A4AE'], ['arrow', 'rect'], 'pulse', 'front arrow'),
    'full': (['FF9800', 'FFB74D'], ['circle'], 'pulse', 'full circle'),
    'furry': (['795548', 'A1887F'], ['circle', 'dot', 'dot', 'dot'], 'breathe', 'furry texture'),
    'glass': (['B3E5FC', 'E1F5FE'], ['rect', 'ring'], 'sparkle', 'glass shine'),
    'gold': (['FFC107', 'FFD54F'], ['circle', 'star'], 'sparkle', 'gold shine'),
    'half': (['3F51B5', '9FA8DA'], ['circle'], 'breathe', 'half circle'),
    'hard': (['607D8B', '455A64'], ['rect', 'rect'], 'pulse', 'hard blocks'),
    'heavy': (['5D4037', '795548'], ['circle'], 'bounce', 'heavy weight'),
    'high': (['2196F3', '64B5F6'], ['arrow', 'circle'], 'bounce', 'high up'),
    'horrible': (['B71C1C', 'F44336'], ['triangle', 'cross'], 'shake', 'horrible'),
    'important': (['FFC107', 'FFD54F'], ['star', 'exclamation'], 'pulse', 'important'),
    'interested': (['9C27B0', 'CE93D8'], ['circle', 'dot'], 'pulse', 'interested eye'),
    'interesting': (['9C27B0', 'E1BEE7'], ['star', 'circle'], 'sparkle', 'interesting'),
    'kind': (['E91E63', 'F48FB1'], ['heart', 'circle'], 'breathe', 'kind heart'),
    'large': (['E65100', 'FF8A65'], ['circle'], 'pulse', 'large circle'),
    'late': (['3F51B5', '5C6BC0'], ['circle', 'dot'], 'breathe', 'late night'),
    'lazy': (['9E9E9E', 'BDBDBD'], ['oval'], 'breathe', 'lazy lying'),
    'left': (['607D8B', '90A4AE'], ['arrow'], 'slide', 'left arrow'),
    'light': (['FFF9C4', 'FFF176'], ['circle', 'ring'], 'sparkle', 'light shining'),
    'lovely': (['E91E63', 'F48FB1', 'FFC107'], ['heart', 'star'], 'sparkle', 'lovely'),
    'low': (['607D8B', '90A4AE'], ['arrow', 'circle'], 'breathe', 'low down'),
    'lucky': (['4CAF50', 'FFC107'], ['star', 'dot'], 'sparkle', 'lucky clover'),
    'married': (['E91E63', 'F48FB1'], ['heart', 'ring'], 'breathe', 'married rings'),
    'metal': (['90A4AE', 'B0BEC5'], ['rect', 'rect'], 'pulse', 'metal blocks'),
    'missing': (['9E9E9E', 'CFD8DC'], ['ring', 'dot'], 'breathe', 'missing empty'),
    'next': (['2196F3', '64B5F6'], ['arrow', 'circle'], 'slide', 'next arrow'),
    'noisy': (['FF5722', 'FF8A65'], ['circle', 'ring', 'ring'], 'wave', 'noisy waves'),
    'online': (['4CAF50', '81C784'], ['circle', 'dot', 'ring'], 'pulse', 'online signal'),
    'plastic': (['2196F3', '90CAF9'], ['roundedRect'], 'breathe', 'plastic shape'),
    'pleased': (['FFC107', 'FFF176'], ['circle', 'dot', 'dot'], 'bounce', 'pleased face'),
    'poor': (['9E9E9E', 'BDBDBD'], ['circle'], 'breathe', 'poor simple'),
    'popular': (['E91E63', 'FF5722'], ['star', 'star', 'star'], 'sparkle', 'popular stars'),
    'racing': (['F44336', 'FF5722'], ['arrow', 'dot'], 'slide', 'racing speed'),
    'ready': (['4CAF50', '81C784'], ['circle', 'star'], 'pulse', 'ready check'),
    'rich': (['FFC107', 'FFD54F'], ['star', 'circle', 'star'], 'sparkle', 'rich gold'),
    'right': (['4CAF50', 'A5D6A7'], ['arrow'], 'pulse', 'right arrow'),
    'same': (['3F51B5', '7986CB'], ['circle', 'circle'], 'pulse', 'same circles'),
    'several': (['673AB7', 'B39DDB'], ['dot', 'dot', 'dot'], 'breathe', 'several dots'),
    'silver': (['B0BEC5', 'CFD8DC'], ['circle', 'star'], 'sparkle', 'silver shine'),
    'soft': (['E1BEE7', 'F3E5F5'], ['circle', 'oval'], 'breathe', 'soft shapes'),
    'sore': (['F44336', 'EF9A9A'], ['circle', 'dot'], 'pulse', 'sore pain'),
    'special': (['FFC107', '9C27B0'], ['star', 'circle'], 'sparkle', 'special star'),
    'spotted': (['FF9800', 'FFCC80'], ['circle', 'dot', 'dot', 'dot'], 'breathe', 'spotted pattern'),
    'strange': (['9C27B0', 'CE93D8'], ['diamond', 'dot'], 'morph', 'strange shape'),
    'striped': (['607D8B', '90A4AE'], ['rect', 'rect', 'rect'], 'breathe', 'striped pattern'),
    'sure': (['4CAF50', '81C784'], ['circle', 'star'], 'pulse', 'sure check'),
    'tidy': (['00BCD4', '80DEEA'], ['roundedRect', 'dot'], 'sparkle', 'tidy clean'),
    'unfriendly': (['9E9E9E', '78909C'], ['circle', 'cross'], 'breathe', 'unfriendly'),
    'unhappy': (['5C6BC0', '7986CB'], ['circle', 'dot', 'dot'], 'breathe', 'unhappy face'),
    'unkind': (['F44336', 'EF5350'], ['heart', 'cross'], 'shake', 'unkind'),
    'untidy': (['795548', '8D6E63'], ['circle', 'dot', 'dot'], 'shake', 'untidy mess'),
    'unusual': (['673AB7', 'B39DDB'], ['diamond', 'star'], 'morph', 'unusual shape'),
    'warm': (['FF9800', 'FFCC80'], ['circle', 'ring'], 'breathe', 'warm glow'),
    'wild': (['4CAF50', '8BC34A'], ['triangle', 'dot'], 'shake', 'wild nature'),
    'wonderful': (['FFC107', 'FF5722', '9C27B0'], ['star', 'star'], 'sparkle', 'wonderful'),
    'worried': (['FF9800', 'FFCC80'], ['circle', 'dot', 'dot'], 'shake', 'worried face'),
}

# Default palettes by word hash for fallback
DEFAULT_PALETTES = [
    ['2196F3', '64B5F6'],
    ['4CAF50', '81C784'],
    ['9C27B0', 'CE93D8'],
    ['FF5722', 'FF8A65'],
    ['00BCD4', '80DEEA'],
    ['FF9800', 'FFCC80'],
    ['E91E63', 'F48FB1'],
    ['3F51B5', '7986CB'],
    ['009688', '80CBC4'],
    ['FFC107', 'FFD54F'],
    ['795548', 'BCAAA4'],
    ['607D8B', '90A4AE'],
]

def hex_to_dart(h):
    return f"Color(0xFF{h})"

def gen_config(word, meaning, is_verb):
    w = word.lower().strip()
    if w in SEMANTIC:
        palette, shapes, anim, _ = SEMANTIC[w]
        return palette, shapes, anim

    # Hash-based fallback
    h = int(hashlib.md5(w.encode()).hexdigest()[:8], 16)
    palette = DEFAULT_PALETTES[h % len(DEFAULT_PALETTES)]
    anim_list = VERB_ANIMS if is_verb else ADJ_ANIMS
    anim = anim_list[h % len(anim_list)]

    # Shape based on word length
    shape_options = ['circle', 'roundedRect', 'oval', 'diamond', 'star']
    main_shape = shape_options[h % len(shape_options)]
    shapes = [main_shape]
    if h % 3 == 0:
        shapes.append('dot')

    return palette, shapes, anim

def gen_dart_shapes(shape_names, palette_hex):
    """Generate Dart VisualShape constructors."""
    parts = []
    positions = [
        (0.5, 0.45, 0.45, 0.45),
        (0.35, 0.6, 0.15, 0.15),
        (0.65, 0.6, 0.15, 0.15),
        (0.5, 0.3, 0.12, 0.12),
    ]
    for i, name in enumerate(shape_names):
        x, y, w, h = positions[i % len(positions)]
        color = hex_to_dart(palette_hex[i % len(palette_hex)])
        if name == 'star':
            x, y, w, h = 0.5, 0.45, 0.5, 0.5
        elif name == 'heart':
            x, y, w, h = 0.5, 0.45, 0.45, 0.45
        elif name == 'arrow':
            x, y, w, h = 0.5, 0.45, 0.25, 0.4
        elif name == 'ring':
            x, y, w, h = 0.5, 0.45, 0.5, 0.5
        elif name == 'triangle':
            x, y, w, h = 0.5, 0.45, 0.45, 0.45
        elif name == 'diamond':
            x, y, w, h = 0.5, 0.45, 0.35, 0.35
        elif name == 'wave':
            x, y, w, h = 0.5, 0.5, 0.6, 0.15
        elif name == 'cross':
            x, y, w, h = 0.5, 0.45, 0.3, 0.3
        elif name == 'dot':
            x, y, w, h = 0.5, 0.5, 0.15, 0.15
        elif name == 'equals':
            x, y, w, h = 0.5, 0.45, 0.3, 0.2
        elif name == 'exclamation':
            x, y, w, h = 0.5, 0.45, 0.12, 0.35
        elif name == 'shield':
            x, y, w, h = 0.5, 0.45, 0.35, 0.4

        shape_type = f"ShapeType.{name}" if name != 'equals' else "ShapeType.cross"
        parts.append(
            f"VisualShape(type: {shape_type}, x: {x}, y: {y}, w: {w}, h: {h}, color: {color})"
        )
    return ",\n        ".join(parts)

# Build Dart file
lines = []
lines.append("import 'package:flutter/material.dart';")
lines.append("import '../models/word_visual.dart';")
lines.append("")
lines.append("/// 今日一词插画配置：为每个动词和形容词定义视觉效果。")
lines.append("final Map<String, WordVisual> wordVisuals = {")

# Process verbs first, then adjectives
all_words = [(w, True) for w in verbs] + [(w, False) for w in adjs]

for wdata, is_verb in all_words:
    word = wdata['word']
    meaning = wdata['meaning']
    palette, shapes, anim = gen_config(word, meaning, is_verb)

    palette_dart = ", ".join(hex_to_dart(h) for h in palette)
    shapes_dart = gen_dart_shapes(shapes, palette)

    lines.append(f"  '{word}': WordVisual(")
    lines.append(f"    palette: [{palette_dart}],")
    lines.append(f"    shapes: [")
    lines.append(f"        {shapes_dart},")
    lines.append(f"    ],")
    lines.append(f"    animType: AnimType.{anim},")
    speed = "1.2" if is_verb else "0.8"
    lines.append(f"    animSpeed: {speed},")
    lines.append(f"  ),")

lines.append("};")

output = "\n".join(lines)
with open("lib/data/word_visuals.dart", "w") as f:
    f.write(output)

print(f"Generated {len(all_words)} word visual configs")
print(f"Output: lib/data/word_visuals.dart ({len(output)} bytes)")
