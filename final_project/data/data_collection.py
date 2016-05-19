import pandas as pd

#import data
pop = pd.read_csv('Annual_Population_Estimates_for_New_York_State_and_Counties__Beginning_1970.csv')
#keep data after 1990
pop = pop.loc[pop['Year'] >= 1990]
#remove duplicate population estimates
pop = pop.loc[pop['Program Type'] != 'Census Base Population']

#import data
crime = pd.read_csv('Index_Crimes_by_County_and_Agency__Beginning_1990.csv')
#only keep county totals
crime = crime.loc[crime['Agency'] == 'County Total']

#rename columns so both dfs match
crime.rename(index=str, columns={'County':'Geography'}, inplace=True)
#add the word county so the county names match for the 2 dfs
crime['Geography'] = crime['Geography'] + ' County'

#function to create keys
def create_key(row):
    return str(row['Year']) + row['Geography']

#apply function
pop['key'] = pop.apply(lambda row: create_key(row), axis=1)
crime['key'] = crime.apply(lambda row: create_key(row), axis=1)

#remove any duplicate keys
countpop = pop.groupby('key').count()
pop = pop.loc[pop['key'].isin(countpop[countpop['Geography'] < 2].index)]
countcrime = crime.groupby('key').count()
crime = crime.loc[crime['key'].isin(countcrime[countcrime['Geography'] < 2].index)]

#join dfs but dont duplicate any columns
pop_keep = ['Population', 'key']
crime_rates = pd.merge(crime, pop[pop_keep], on=['key'])

#function to find all crime rates
def get_crime_rates(row, column):
    return 100000 * row[column]/row['Population']

#get columns where rates are appropriate
column_names = list(crime_rates)[4:14]
#create a rate column for each
for each in column_names:
    new_column = each + ' Rate'
    crime_rates[new_column] = crime_rates.apply(lambda row: get_crime_rates(row, each), axis=1).round(2)

#save as a csv file
crime_rates.to_csv('crime_rates.csv', index=False)

#just violent nyc crimes for chart
nyc_counties = ['Bronx County', 'Kings County', 'New York County', 'Queens County', 'Richmond County']
nyc_crime_rates = crime_rates.loc[crime_rates['Geography'].isin(nyc_counties)]
#columns to keep
keepers = ['Geography', 'Year', 'Population', 'Violent Total Rate',
           'Murder Rate','Robbery Rate', 'Aggravated Assault Rate']
nyc_crime_rates = pd.DataFrame(nyc_crime_rates, columns=keepers)

#rename counties as boroughs
nyc_crime_rates['Geography'] = nyc_crime_rates['Geography'].str.replace(pat='Bronx County', repl='Bronx')
nyc_crime_rates['Geography'] = nyc_crime_rates['Geography'].str.replace(pat='Kings County', repl='Brooklyn')
nyc_crime_rates['Geography'] = nyc_crime_rates['Geography'].str.replace(pat='New York County', repl='Manhattan')
nyc_crime_rates['Geography'] = nyc_crime_rates['Geography'].str.replace(pat='Queens County', repl='Queens')
nyc_crime_rates['Geography'] = nyc_crime_rates['Geography'].str.replace(pat='Richmond County', repl='Staten Island')

#create wide data to use with google charts
v = nyc_crime_rates.pivot(index='Year', columns='Geography', values='Violent Total Rate')
v['Type'] = 'All Violent Crimes'
m = nyc_crime_rates.pivot(index='Year', columns='Geography', values='Murder Rate')
m['Type'] = 'Murder'
r = nyc_crime_rates.pivot(index='Year', columns='Geography', values='Robbery Rate')
r['Type'] = 'Robbery'
a = nyc_crime_rates.pivot(index='Year', columns='Geography', values='Aggravated Assault Rate')
a['Type'] = 'Aggravated Assault'
nyc_crime_rates = v.append(m.append(r.append(a)))

#save it
nyc_crime_rates.to_csv('nyc_crime_rate.csv')

