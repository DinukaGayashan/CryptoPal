import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.preprocessing import MinMaxScaler
from tensorflow.python.keras.models import Sequential
from tensorflow.python.keras.layers import Dense, Dropout
from tensorflow.python.keras.layers import LSTM
from tensorflow.python.keras.callbacks import ModelCheckpoint, EarlyStopping

cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)
db = firestore.client()


def dataset_generator_lstm(dataset, look_back=5):
    dataX, dataY = [], []
    for i in range(len(dataset) - look_back):
        window_size_x = dataset[i:(i + look_back), 0]
        dataX.append(window_size_x)
        dataY.append(dataset[i + look_back, 0])
    return np.array(dataX), np.array(dataY)


# for a currency
currency = 'BTC-USD'
# date = '2022-06-08'

testingLimit = 100
lookbackPeriod =10
# dataSet = db.collection('realPrices').where('currency', '==', currency).limit(2000).get()
dataSet = db.collection('realPrices').where('currency', '==', currency).get()

data = [dic._data for dic in dataSet]
df = pd.DataFrame(data)

df = df.astype({'date': 'datetime64'})
df = df[['date', 'closePrice']]
df = df.set_index('date')

trainDf = df[:len(df) - testingLimit].values.reshape(-1, 1)
testDf = df[len(df) - testingLimit:].values.reshape(-1, 1)

scalerTrainDf = MinMaxScaler(feature_range=(0, 1))
scaledTrainDf = scalerTrainDf.fit_transform(trainDf)
scalerTestDf = MinMaxScaler(feature_range=(0, 1))
scaledTestDf = scalerTestDf.fit_transform(testDf)

trainX, trainY = dataset_generator_lstm(scaledTrainDf)
testX, testY = dataset_generator_lstm(scaledTestDf)

trainX = np.reshape(trainX, (trainX.shape[0], trainX.shape[1], 1))
testX = np.reshape(testX, (testX.shape[0], testX.shape[1], 1))

regressor = Sequential()
regressor.add(LSTM(units=128, activation='relu', return_sequences=True, input_shape=(trainX.shape[1], trainX.shape[2])))
regressor.add(Dropout(0.2))
regressor.add(LSTM(units=64, input_shape=(trainX.shape[1], trainX.shape[2])))
regressor.add(Dropout(0.2))
regressor.add(Dense(units=1))

regressor.compile(optimizer='adam', loss='mean_squared_error')
checkpointPath = 'best_model_for_' + currency + '.hdf5'
checkpoint = ModelCheckpoint(filepath=checkpointPath, monitor='val_loss', verbose=1, save_best_only=True, mode='min')
earlyStopping = EarlyStopping(monitor='val_loss', patience=10, restore_best_weights=True)
callbacks = [checkpoint, earlyStopping]
history = regressor.fit(trainX, trainY, batch_size=32, epochs=300, verbose=1, shuffle=False, validation_data=())

predictedTestData = regressor.predict(testX)
predictedTestData = scalerTestDf.inverse_transform(predictedTestData.reshape(-1, 1))
testActual = scalerTestDf.inverse_transform(testY.reshape(-1, 1))
#
# predictedTrainData=regressor.predict(trainX)
# predictedTrainData=scalerTrainDf.inverse_transform(predictedTrainData.reshape(-1,1))
# trainActual=scalerTrainDf.inverse_transform(trainY.reshape(-1,1))

# rmseLtsmTest=math.sqrt(mean_squared_error(testActual,predictedTestData))
# print(rmseLtsmTest)
# rmseLtsmTrain=math.sqrt(mean_squared_error(trainActual,predictedTrainData))
# print(rmseLtsmTrain)

testXLastLookback = testX[testX.shape[0] - lookbackPeriod:]

predictedForcastData = []
for i in range(lookbackPeriod):
    predictedForcastTestX = regressor.predict(testXLastLookback[i:i + 1])
    predictedForcastTestX = scalerTestDf.inverse_transform(predictedForcastTestX.reshape(-1, 1))
    predictedForcastData.append(predictedForcastTestX)

# print("Forecast for the next 5 Days Beyond the actual trading days ", np.array(predictedForcastData))


predicted_5_days_forecast_price_test_x = np.array(predictedForcastData)
predicted_5_days_forecast_price_test_x = predicted_5_days_forecast_price_test_x.flatten()
predicted_btc_price_test_data = predictedTestData.flatten()
predicted_btc_test_concatenated = np.concatenate(
    (predicted_btc_price_test_data, predicted_5_days_forecast_price_test_x))
plt.figure(figsize=(16, 7))
plt.plot(predicted_btc_test_concatenated, 'r', marker='.', label='Predicted Test')
plt.plot(testActual, marker='.', label='Actual Test')
plt.legend()
plt.show()

# db.collection('mlPredictions').document(name).set({},merge=True)
