import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler

from tensorflow.python.keras.models import Sequential
from tensorflow.python.keras.layers import Dense, Dropout
from tensorflow.python.keras.layers import LSTM
from tensorflow.python.keras.callbacks import ModelCheckpoint, EarlyStopping

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()


def dataset_generator_lstm(dataset, look_back=10):
    data_x, data_y = [], []
    for i in range(len(dataset) - look_back):
        window_size_x = dataset[i:(i + look_back), 0]
        data_x.append(window_size_x)
        data_y.append(dataset[i + look_back, 0])
    return np.array(data_x), np.array(data_y)


def run_ml(currency, date):
    print('ML started for ' + currency)

    look_back_period = 10
    data_set = db.collection('realPrices').where('currency', '==', currency).get()

    data = [dic._data for dic in data_set]
    df = pd.DataFrame(data)

    df = df.astype({'date': 'datetime64'})
    df = df[['date', 'closePrice']]
    df = df.set_index('date')

    train_df = df

    scaler_train_df = StandardScaler()
    scaled_train_df = scaler_train_df.fit_transform(train_df)

    train_x, train_y = dataset_generator_lstm(scaled_train_df)

    train_x = np.reshape(train_x, (train_x.shape[0], train_x.shape[1], 1))

    regressor = Sequential()
    regressor.add(
        LSTM(units=128, activation='relu', return_sequences=True, input_shape=(train_x.shape[1], train_x.shape[2])))
    regressor.add(Dropout(0.2))
    regressor.add(LSTM(units=64, input_shape=(train_x.shape[1], train_x.shape[2])))
    regressor.add(Dropout(0.2))
    regressor.add(Dense(units=1))

    regressor.compile(optimizer='adam', loss='mean_squared_error')
    checkpoint_path = 'best_model_for_' + currency + '.hdf5'
    checkpoint = ModelCheckpoint(filepath=checkpoint_path, monitor='val_loss', verbose=1, save_best_only=True,
                                 mode='min')
    early_stopping = EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)
    callbacks = [checkpoint, early_stopping]
    history = regressor.fit(train_x, train_y, batch_size=32, epochs=300, verbose=0, shuffle=False, validation_data=())

    predicted_train_data = regressor.predict(train_x)
    predicted_train_data = scaler_train_df.inverse_transform(predicted_train_data.reshape(-1, 1))
    train_actual = scaler_train_df.inverse_transform(train_y.reshape(-1, 1))

    regressor.save('final_model_for_'+currency)

    print('ML completed for ' + currency)


if __name__ == '__main__':
    cryptocurrencies = ['BTC', 'ETH', 'LTC', 'XRP', 'DOGE']
    for cryptocurrency in cryptocurrencies:
        run_ml(cryptocurrency+'-USD', '2022-10-03')
