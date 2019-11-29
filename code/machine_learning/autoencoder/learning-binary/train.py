import numpy as np
import keras
from keras.models import Sequential, Model
from keras.layers import Dense, Input
from keras import optimizers
from keras.optimizers import Adam
import matplotlib.pyplot as plt

def int2bin(num,length):
    return np.array([(np.array(num)>>k) & 1 for k in range(length)][-1::-1]).transpose()

def bin2int(bin):
    vals = [x << len(bin) - k - 1 for (k, x) in enumerate(bin)]
    return sum(vals)

input_length = 4
encode_length = 2

q_train = np.random.randint(input_length, size=(10000,))
x_train = keras.utils.to_categorical(q_train, num_classes = input_length)

q_test = np.random.randint(input_length, size=(1000,))
x_test = keras.utils.to_categorical(q_test, num_classes = input_length)

# q_train = np.array([0, 1, 2, 3])
# x_train = keras.utils.to_categorical(q_train, num_classes = input_length)
#
# q_train = np.array([0, 1, 2, 3])
# x_test = keras.utils.to_categorical(q_test, num_classes = input_length)

autoencoder = Sequential()
autoencoder.add(Dense(4, activation='elu', input_shape=(input_length,)))
autoencoder.add(Dense(encode_length, activation='tanh', name="bottleneck", input_shape=(input_length,)))
autoencoder.add(Dense(4, activation='elu'))
autoencoder.add(Dense(input_length, activation='sigmoid'))
# autoencoder.compile(loss='mean_squared_error', optimizer = Adam())
autoencoder.compile(loss='binary_crossentropy', optimizer = Adam())
# trained_model = autoencoder.fit(x_train, x_train, batch_size=1024, epochs=100, verbose=1, validation_data=(x_test, x_test))
trained_model = autoencoder.fit(x_train, x_train, epochs=30, verbose=1, validation_data=(x_test, x_test))

encoder = Model(autoencoder.input, autoencoder.get_layer('bottleneck').output)
encoded_data = encoder.predict(x_train)

plt.scatter(q_train, encoded_data[:, 0], c = 'b', marker = '2')
plt.scatter(q_train, encoded_data[:, 1], c = 'r', marker = '1')

decoded_output = autoencoder.predict(x_train)
estimate = (decoded_output > 0.5).astype(int)

# return the decoder
encoded_input = Input(shape=(encoding_dim,))
decoder = autoencoder.layers[-3](encoded_input)
decoder = autoencoder.layers[-2](decoder)
decoder = autoencoder.layers[-1](decoder)
decoder = Model(encoded_input, decoder)
