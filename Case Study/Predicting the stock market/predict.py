import pandas as pd
import numpy as np
from datetime import datetime
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error
data = pd.read_csv('sphist.csv')
data['Date'] = pd.to_datetime(data['Date'])

data.sort_values('Date', ascending = False, inplace = True)


## Generate 5 day rolling adjusted close
## (The daily closing price, adjusted retroactively to include any corporate actions.)
for row in data.iterrows():
    past_five_days = data.loc[row[0]+1:row[0]+5,'Adj Close']
    if len(past_five_days) == 5:
        avg = np.average(past_five_days)
    else:
        avg = 0
    data.loc[row[0], 'day_5'] = avg

for row in data.iterrows():
    past_five_days = data.loc[row[0]+1:row[0]+,'Adj Close']
    if len(past_five_days) == 5:
        avg = np.average(past_five_days)
    else:
        avg = 0
    data.loc[row[0], 'day_5'] = avg    
    
## Generate 30 day rolling standard deviation trade volume
    
for row in data.iterrows():
    past_thirty_days = data.loc[row[0]+1:row[0]+30,'Volume']
    if len(past_thirty_days) == 30:
        sd = np.std(past_thirty_days)
    else:
        sd = 0
    data.loc[row[0], 'volume_30'] = sd    

## Generate 365 days rolling average for the high price
for row in data.iterrows():
    past_year = data.loc[row[0]+1:row[0]+365,'High']
    if len(past_year) == 365:
        avg = np.average(past_year)
    else:
        avg = 0
    data.loc[row[0], 'high_365'] = avg    
    
## dropping the data before 1951-01-03, 
## because there aren't enough data to generate rolling average for a year
data = data[data["Date"] > datetime(year=1951, month=1, day=2)]
data.dropna(axis = 0)

train = data[data["Date"] < datetime(year=2013, month=1, day=1)]
test = data[data["Date"] >= datetime(year=2013, month=1, day=1)]

features = ['day_5','volume_30','high_365']
target = 'Close'

lr = LinearRegression()
lr.fit(train[features],train[target])
predictions = lr.predict(test[features])
mae = mean_absolute_error(test['Close'],predictions)
print(mae)
