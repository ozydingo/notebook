import numpy as np
import keras
from keras.datasets import mnist
from keras.models import Sequential, Model
from keras.layers import Dense, Input
from keras import optimizers
from keras.optimizers import Adam

sequence_length = 512
bottleck_length = 16

autoencoder = Sequential()
autoencoder.add(Dense(256,  activation='elu', input_shape=(sequence_length,)))
autoencoder.add(Dense(64,  activation='elu'))
autoencoder.add(Dense(bottleck_length,    activation='linear', name="bottleneck"))
autoencoder.add(Dense(64,  activation='elu'))
autoencoder.add(Dense(256,  activation='elu'))
autoencoder.add(Dense(sequence_length,  activation='tanh'))
autoencoder.compile(loss='mean_squared_error', optimizer = Adam())

def generate_target(freq, length = 512):
    nn = np.arange(length)
    signal = np.cos(2 * np.pi * freq * nn)
    return signal

def generate_anomaly(freq, length = 512):
    nn = np.arange(length)
    signal = np.sin(2 * np.pi * freq * nn)
    return signal

num_train = 20000
num_validate = 1000
data_train = np.array([generate_target(x, sequence_length) for x in 0.3 * np.random.rand(num_train)])
data_validate = np.array([generate_target(x, sequence_length) for x in 0.3 * np.random.rand(num_train)])

trained_model = autoencoder.fit(
    data_train, data_train,
    batch_size=1024,
    epochs=25,
    verbose=1,
    validation_data=(data_validate, data_validate))

num_test = 250
targets = np.array([generate_target(x, sequence_length) for x in 0.3 * np.random.rand(num_test)])
anomalies = np.array([generate_anomaly(x, sequence_length) for x in 0.3 * np.random.rand(num_test)])

target_score = autoencoder.evaluate(targets, targets)
anomaly_score = autoencoder.evaluate(anomalies, anomalies)

target_reencoded = autoencoder.predict(targets)
anomaly_reencoded = autoencoder.predict(anomalies)

plt.scatter(anomalies[0:10, :], anomaly_reencoded[0:10, :], c='r', marker='x')
plt.scatter(targets[0:10, :], target_reencoded[0:10, :], c='b', marker='.')

target_scores = np.mean((target_reencoded - targets)**2, axis=-1)
anomaly_scores = np.mean((anomaly_reencoded - anomalies)**2, axis=-1)
