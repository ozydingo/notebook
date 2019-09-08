import numpy as np
import sys

datafile = sys.argv[1]

data = open(datafile, 'r').read()
chars = list(set(data))
data_size = len(data)
vocab_size = len(chars)

print('data has %d characters, %d unique.' % (data_size, vocab_size))

char_to_ix = {ch: ii for (ii, ch) in enumerate(chars)}
ix_to_char = {ii: ch for (ii, ch) in enumerate(chars)}

# hyperparams
hidden_size = 100
seq_length = 25
learning_rate = 1e-1
rand_ampl = 0.01

Wxh = np.random.randn(hidden_size, vocab_size) * rand_ampl
Whh = np.random.randn(hidden_size, hidden_size) * rand_ampl
Why = np.random.randn(vocab_size, hidden_size) * rand_ampl
bh = np.zeros((hidden_size, 1))
by = np.zeros((vocab_size, 1))

def lossFn(inputs, targets, hprev):
  """
  inputs,targets are both list of integers each corresponding to a char
  hprev is Hx1 array of initial hidden state
  returns the loss, gradients on model parameters, and last hidden state
  """
  xs, hs, ys, ps = {}, {}, {}, {}
  hs[-1] = np.copy(hprev)
  loss = 0
  for t in range(len(inputs)):
    xs[t] = np.zeros((vocab_size, 1))
    xs[t][inputs[t]] = 1
    hs[t] = np.tanh(np.dot(Wxh, xs[t]) + np.dot(Whh, hs[t-1]) + bh)
    # unnormalized scores for each char
    ys[t] = np.dot(Why, hs[t]) + by
    # softmax -> probs
    ps[t] = np.exp(ys[t]) / np.sum(np.exp(ys[t]))
    # ?
    loss += -np.log(ps[t][targets[t], 0])
  dWxh = np.zeros(Wxh.shape)
  dWhh = np.zeros(Whh.shape)
  dWhy = np.zeros(Why.shape)
  dbh = np.zeros(bh.shape)
  dby = np.zeros(by.shape)
  dhnext = np.zeros(hs[0].shape)

  for t in reversed(range(len(inputs))):
    dy = np.copy(ps[t])
    dy[targets[t]] -= 1
    dWhy += np.dot(dy, hs[t].T)
    dby += dy
    dh = np.dot(Why.T, dy) + dhnext
    dhraw = (1 - hs[t] * hs[t]) * dh
    dbh + dhraw
    dWxh += np.dot(dhraw, xs[t].T)
    dWhh += np.dot(dhraw, hs[t-1].T)
    dhnext = np.dot(Whh.T, dhraw)

  for dparam in [dWxh, dWhh, dWhy, dby, dbh]:
    np.clip(dparam, -5, 5, out=dparam)

  return loss, dWxh, dWhh, dWhy, dbh, dby, hs[len(inputs) - 1]

def sample(h, seed_ix, n):
  """
  sample a sequence of integers from the model
  h is memory state, seed_ix is seed letter for first time step
  """
  x = np.zeros((vocab_size, 1))
  x[seed_ix] = 1
  ixes = []
  for t in range(n):
    h = np.tanh(np.dot(Wxh, x) + np.dot(Whh, h) + bh)
    y = np.dot(Why, h) + by
    p = np.exp(y) / np.sum(np.exp(y))
    ix = np.random.choice(range(vocab_size), p=p.ravel())
    x = np.zeros((vocab_size, 1))
    x[ix] = 1
    ixes.append(ix)
  return ixes

mWxh = np.zeros(Wxh.shape)
mWhh = np.zeros(Whh.shape)
mWhy = np.zeros(Why.shape)
mby = np.zeros(by.shape)
mbh = np.zeros(bh.shape)

smooth_loss = -np.log(1.0/vocab_size) * seq_length

n = 0
hprev = np.zeros((hidden_size, 1))
# current sequence-start
p = 0

while True:
  if p + seq_length + 1 >= len(data):
    hprev = np.zeros((hidden_size, 1))
    p = 0

  inputs = [char_to_ix[ch] for ch in data[p:p + seq_length]]
  targets = [char_to_ix[ch] for ch in data[p + 1:p + 1 + seq_length]]

  # sample from the model now and then
  if n%100 == 0:
    sample_ix = sample(hprev, inputs[0], 200)
    txt = ''.join(ix_to_char[ix] for ix in sample_ix)
    print('----\n %s \n----' % (txt, ))

  # forward seq_length characters through the net and fetch gradient
  loss, dWxh, dWhh, dWhy, dbh, dby, hprev = lossFn(inputs, targets, hprev)
  smooth_loss = smooth_loss * 0.999 + loss * 0.001
  if n % 100 == 0: print('iter %d, loss: %f' % (n, smooth_loss)) # print progress

  # perform parameter update with Adagrad
  for param, dparam, mem in zip(
    [Wxh, Whh, Why, bh, by],
    [dWxh, dWhh, dWhy, dbh, dby],
    [mWxh, mWhh, mWhy, mbh, mby]
  ):
    mem += dparam * dparam
    param += -learning_rate * dparam / np.sqrt(mem + 1e-8)

    p += seq_length
    n+=1
