import time
import math
with open('AviationData.txt', "r") as file:
    aviation_data = list(file.readlines())

aviation_list = []
for line in aviation_data:
    columns = line.split(' | ')
    aviation_list.append(columns)

def timeit(method):
    def timed(*args, **kw):
        ts = time.time()
        result = method(*args, **kw)
        te = time.time()
        if 'log_time' in kw:
            name = kw.get('log_name', method.__name__.upper())
            kw['log_time'][name] = int((te - ts) * 1000)
        return result
    return timed    
    
lax_code = []
logtime_data = {}

ts = time.time()
for l in aviation_list:
    for ll in l:
        if ll == 'LAX94LA336':
            lax_code.append(l)
elapse = time.time() - ts
# print("quadratic: ",  elapse)


"""
The problem with this approach, the elapse time could be as long as the lenth of the whole list. 
If the data is at the end, it could take long to return the value if the value is at the end of the list 
or doesn't exist at all. 
"""

"""
Linear Time Algorithm
Instead of searching through the columns that we know that the 'LAX94LA336' isn't in, we can separate the column and 
only search in the column. Later on we are going to use binary search to see which is more efficient to find the data we
want to find. For that, we are going to sort the data in the alphabetical order by Accident Number.
"""
def take_accident_number(elem):
    return elem[2]
# decorator to time

header = aviation_list[0]
aviation_list = aviation_list[1:]

aviation_list.sort(key=take_accident_number)
aviation_list.insert(0, header)


for l in aviation_list:
    if l[2] == 'LAX94LA336':
        lax_code.append(l)
elapse = time.time() - ts
# print("Linear Time Algorithm: ",  elapse)

"""
Logarithm Time Algorithm
"""
ts = time.time()
for l in aviation_list:
    upper_bound = len(aviation_list) -1
    lower_bound = 0
    index = math.floor((upper_bound+lower_bound) / 2)
    if l[2] < 'LAX94LA336':
        upper_bound = index - 1
    elif l[2] > 'LAX94LA336':
        lower_bound = index + 1
    else:
        lax_code.append(l)
elapse = time.time() - ts
# print("Logarithm Time Algorithm: ",  elapse)
# print(lax_code)

"""
Change the data structure to dictionary
"""
with open('AviationData.txt', "r") as file:
    aviation_data = list(file.readlines())

aviation_list = []
for line in aviation_data:
    columns = line.split(' | ')
    aviation_list.append(columns)

aviation_dict_list = []
header = aviation_list[0]
# print(header)
for l in aviation_list[1:]:
    current_row = {}
    for i in range(0,len(header)):
        current_row[header[i]] = l[i]
    aviation_dict_list.append(current_row)

lax_dict = []

for l in aviation_dict_list:
    if l['Accident Number'] == 'LAX94LA336':
        lax_dict.append(l)
        print(lax_dict)
"""
Counting accidents by state
"""
        
state_accidents = {}
for l in aviation_dict_list[1:]:
    location = l['Location'].split(', ')
    country = l['Country']
    if len(location) == 2 and country == 'United States':
        if location[1] in state_accidents:
            state_accidents[location[1]] += 1
        else:
            state_accidents[location[1]] = 1

# print(state_accidents)

"""
Counting fatalities and serious injuries during each unique month and year
"""
        
monthly_injuries = {}
for l in aviation_dict_list[1:]:
    event_date = l['Event Date'].split('/')
    
    if l['Total Fatal Injuries'] == '':
        fatal_injury = 0
    else:
        fatal_injury = l['Total Fatal Injuries']
        
    if l['Total Serious Injuries'] == '':
        serious_injury = 0
    else:
        serious_injury = l['Total Serious Injuries']  
    total_injuries = int(fatal_injury) + int(serious_injury)
    
    if len(event_date) == 3:
        year_month = event_date[2] + '/'+ event_date[0]
        if year_month in state_accidents:
            monthly_injuries[year_month] += total_injuries
        else:
            monthly_injuries[year_month] = total_injuries

print(monthly_injuries)