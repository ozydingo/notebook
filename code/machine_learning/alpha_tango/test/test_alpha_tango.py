from alpha_tango import alpha_tango

def test_generate_sentences():
    generator = alpha_tango.generate()
    for ii in range(5):
        sentence = next(generator)
        assert len(sentence) > 0

def test_generate_correlated_sentences():
    generator = alpha_tango.generate_correlated()
    for ii in range(5):
        sentence = next(generator)
        assert len(sentence) > 0

def test_generate_corrections():
    generator = alpha_tango.generate_corrections()
    for ii in range(5):
        (input, output) = next(generator)
        assert len(input) > 0
        assert len(output) > 0
        assert (input != output)
