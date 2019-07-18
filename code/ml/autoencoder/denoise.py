from keras.layers import Conv2D, MaxPooling2D, UpSampling2D

input_img = Input(shape=(28, 28, 1))

nn = Conv2D(32, (3, 3), activation='relu', padding='same')(input_img)
nn = MaxPooling2D((2, 2), padding='same')(nn)
nn = Conv2D(32, (3, 3), activation='relu', padding='same')(nn)
encoded = MaxPooling2D((2, 2), padding='same')(nn)

nn = Conv2D(32, (3, 3), activation='relu', padding='same')(encoded)
nn = UpSampling2D((2, 2))(nn)
nn = Conv2D(32, (3, 3), activation='relu', padding='same')(nn)
nn = UpSampling2D((2, 2))(nn)
decoded = Conv2D(1, (3, 3), activation='sigmoid', padding='same')(nn)

autoencoder = Model(input_img, decoded)
autoencoder.compile(optimizer='adadelta',loss='binary_crossentropy')
autoencoder.fit(x_train_noisy[:,:,:,None], x_train[:,:,:,None],
                epochs=50,
                batch_size=256,
                validation_data=(x_test_noisy[:,:,:,None], x_test[:,:,:,None]))

denoised = autoencoder.predict(x_test_noisy[:,:,:,None])

ii = np.random.randint(len(x_test_noisy))
plt.imshow(x_test_noisy[ii])
plt.figure()
plt.imshow(denoised[ii][:,:,0])
