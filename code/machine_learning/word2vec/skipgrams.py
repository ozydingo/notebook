import argparse
import collections
import numpy as np
import types

parser = argparse.ArgumentParser(description="Run an NLP model")

parser.add_argument("data", help="Text corpus data file.")
parser.add_argument("--vocab-size", default=10000, help="Vocab size")
parser.add_argument("--embedding-size", default=300, help="Embedding vector size")

args = parser.parse_args()
data = args.data
vocab_size = args.vocab_size
embedding_size = args.embedding_size

if not "production":
    data = "/Volumes/Data/3p/research/nlp/datasets/alpha_tango/alpha_tango-1000.txt"
    vocab_size = 1000
    embedding_size = 100

def word_generator(text_file):
    with open(text_file, 'r') as fp:
        for line in fp:
            words = line.split()
            for word in words:
                yield word

def build_dictionary(words, vocab_size = None):
    all_word_counts = collections.Counter(words)
    if vocab_size == None:
        vocab_size = len(all_word_counts) + 1

    in_vocab_counts = [("<unk>", 0)] + all_word_counts.most_common(vocab_size - 1)
    word_to_index = {word: ii for (ii, (word, _count)) in enumerate(in_vocab_counts)}
    return word_to_index

def generate_skipgrams(token_generator, skips_per_window, window_size):
    """Generate skipgram samples from integer-encoded word sequence
    
    Parameters
    
    token_generator: generator of tokens (words or encoded words)
    skips_per_window: number of skipgrams to generate for each window of words
    window_size: number of words before and after target word to include in each
        window
    
    Returns a generator of skipgrams: (target, context)
    """
    
    assert skips_per_window <= 2 * window_size, "Cannot have more skips than words available in window"
    
    # Force token_generator to be a generator
    if type(token_generator) != types.GeneratorType:
        token_generator = (item for item in token_generator)
    
    # Moving window of context words: window_size on each side of target.
    buffer_size = 2 * window_size + 1
    buffer = collections.deque(maxlen=buffer_size)
    # Target word index in the buffer == window_size
    target_index = window_size
    # Context indices are all indices in buffer except the target
    context_indexes = list(range(window_size)) + list(range(window_size + 1, window_size * 2 + 1))
    
    # Pre-fill the window
    for ii in range(buffer_size-1):
        buffer.append(next(token_generator))

    # Iterate words, sliding the window
    for next_word in token_generator:
        buffer.append(next_word)
        target_word = buffer[target_index]
        context_sample_indices = np.random.choice(context_indexes, skips_per_window, replace=False)
        for ii in context_sample_indices:
            yield (target_word, buffer[ii])
