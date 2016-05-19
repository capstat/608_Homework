import pandas as pd

#import data
pop = pd.read_csv('Annual_Population_Estimates_for_New_York_State_and_Counties__Beginning_1970.csv')

#just nyc
nyc_counties = ['Bronx County', 'Kings County', 'New York County', 'Queens County', 'Richmond County']
nyc_pop = pop.loc[pop['Geography'].isin(nyc_counties)]

#remove duplicate population estimates
nyc_pop = nyc_pop.loc[pop['Program Type'] != 'Census Base Population']

#keep only the columns we need
nyc_pop = nyc_pop[['Geography','Year','Population']]

#insert 1960 population
pop_60 = pd.DataFrame({
    'Geography': nyc_counties,
    'Year': 1960,
    'Population': [1424815, 2627319, 1698281, 1809578, 221991]
})

nyc_pop = nyc_pop.append(pop_60)

#create csv file
nyc_pop.to_csv('nyc_pop_raw.csv')

#create wide data to use with d3
nyc_pop = nyc_pop.pivot(index='Year', columns='Geography', values='Population')

#find the % change of population year over year
for each in nyc_counties:
    nyc_pop[each] = nyc_pop.apply(lambda x: ((nyc_pop[each] - nyc_pop.iloc[0][each])/nyc_pop.iloc[0][each]))
nyc_pop.fillna(value=0, inplace=True)

#create csv file
nyc_pop.to_csv('nyc_pop.csv')
