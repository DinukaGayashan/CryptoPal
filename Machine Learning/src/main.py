import math
import datetime
import time
from statistics import mean

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

import pandas as pd
import numpy as np
from sklearn.metrics import mean_squared_error

from sklearn.preprocessing import MinMaxScaler

from tensorflow.python.keras.models import Sequential
from tensorflow.python.keras.layers import Dense, Dropout
from tensorflow.python.keras.layers import LSTM
from tensorflow.python.keras.callbacks import ModelCheckpoint, EarlyStopping

from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

cred = credentials.Certificate("src/serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["GET"],
    allow_headers=["*"],
)


@app.get("/")
def root(currency_type, current_date):
    s = time.perf_counter()
    run_ml(currency_type, current_date)
    elapsed = time.perf_counter() - s
    print(f'Execution time: {elapsed:0.2f} seconds.')
    return {"message": "completed"}


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

    scaler_train_df = MinMaxScaler(feature_range=(0, 1))
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

    rmse_lstm_train = math.sqrt(mean_squared_error(train_actual, predicted_train_data))

    train_x_last_look_back = train_x[train_x.shape[0] - look_back_period:]

    predicted_forcast_data = []
    for i in range(look_back_period):
        predicted_forcast_train_x = regressor.predict(train_x_last_look_back[i:i + 1])
        predicted_forcast_train_x = scaler_train_df.inverse_transform(predicted_forcast_train_x.reshape(-1, 1))
        predicted_forcast_data.append(predicted_forcast_train_x)

    predictions_array = np.array(predicted_forcast_data).flatten()
    for i, price in enumerate(predictions_array):
        day = (datetime.date.fromisoformat(date) + datetime.timedelta(days=i)).strftime('%Y-%m-%d')
        db.collection('mlPredictions').document('predictions').collection('predictionPrices').document(
            day + ' ' + currency).set({
            'date': day,
            'currency': currency,
            'closePrice': float(price)
        })

    db.collection('mlPredictions').document('predictions').collection('predictionErrors').document(currency).set({
        'rmse': float(rmse_lstm_train),
        'rmsePercentage': float((rmse_lstm_train / mean(predictions_array)) * 100)
    })

    print('ML completed for ' + currency)
