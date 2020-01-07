import math
import random
import os

MODULE_PATH = os.path.dirname(__file__)

_corpus = None

def corpus():
    global _corpus
    if not _corpus: _corpus = _load_corpus()
    return _corpus

def generate():
    """Generate random sentences such as "a quick turtle asked the brown snake"
    """

    corpus = _load_corpus()

    while True:
        (art0, art1) = random.sample(corpus["articles"], 2)
        (adj0, adj1) = random.sample(corpus["adjectives"], 2)
        (noun0, noun1) = random.sample(corpus["nouns"], 2)
        (verb,) = random.sample(corpus["verbs"], 1)

        yield f"{art0} {adj0} {noun0} {verb} {art1} {adj1} {noun1}"

def generate_correlated():
    """Generate sentences where adjectives are perfectly correlated to the nouns
    they modify
    """

    corpus = _load_corpus()

    while True:
        (art0, art1) = random.sample(corpus["articles"], 2)
        (ii0, ii1) = random.sample(range(len(corpus["adjectives"])), 2)
        (adj0, adj1) = (corpus["adjectives"][ii0], corpus["adjectives"][ii1])
        (noun0, noun1) = (corpus["nouns"][ii0], corpus["nouns"][ii1])
        (verb,) = random.sample(corpus["verbs"], 1)

        yield f"{art0} {adj0} {noun0} {verb} {art1} {adj1} {noun1}"

def generate_corrections():
    """Generate sentence pairs of (incorrect, correct) where correct is defined
    via the `generate_correlated` grammar rules. The incorrect word is the first
    noun of each sentence.
    """

    corpus = _load_corpus()

    while True:
        (art0, art1) = random.sample(corpus["articles"], 2)
        (ii0, ii1) = random.sample(range(len(corpus["adjectives"])), 2)
        (adj0, adj1) = (corpus["adjectives"][ii0], corpus["adjectives"][ii1])
        (noun0, noun1) = (corpus["nouns"][ii0], corpus["nouns"][ii1])
        (verb,) = random.sample(corpus["verbs"], 1)

        mistake = corpus["nouns"][(ii0 + 1) % len(corpus["nouns"])]
        incorrect = f"{art0} {adj0} {mistake} {verb} {art1} {adj1} {noun1}"
        correct = f"{art0} {adj0} {noun0} {verb} {art1} {adj1} {noun1}"

        yield (incorrect, correct)

def _load_corpus():
    corpus = {}

    corpus["articles"] = _read(os.path.join(MODULE_PATH, 'data', 'articles.txt'))
    corpus["nouns"] = _read(os.path.join(MODULE_PATH, 'data', 'nouns.txt'))
    corpus["adjectives"] = _read(os.path.join(MODULE_PATH, 'data', 'adjectives.txt'))
    corpus["verbs"] = _read(os.path.join(MODULE_PATH, 'data', 'verbs.txt'))
    return corpus

def _read(file):
    with open(file, 'r') as f:
        return f.read().splitlines()
