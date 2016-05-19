import pandas as pd

#import data
rest = pd.read_csv('DOHMH_New_York_City_Restaurant_Inspection_Results.csv')

#remove duplicate rows
rest.drop_duplicates(subset='CAMIS', inplace=True)

#keep only some of columns
keepers = ['CAMIS', 'DBA', 'BORO', 'BUILDING', 'STREET', 'ZIPCODE', 'CUISINE DESCRIPTION']
rest = pd.DataFrame(rest, columns=keepers)
#drop 6 missing boro
rest = rest[rest['BORO'] != 'Missing']

#rename certain descriptions
rest['CUISINE DESCRIPTION'] = rest['CUISINE DESCRIPTION'].str.replace(pat='.*Coffee.*', repl='Coffee')
rest['CUISINE DESCRIPTION'] = rest['CUISINE DESCRIPTION'].str.replace(pat='Latin.*', repl='Latin')
#remove coffee places (starbux etc)
rest = rest[rest["CUISINE DESCRIPTION"] != "Coffee"]

#combine itailian and pizza places as italian
rest['CUISINE DESCRIPTION'] = rest['CUISINE DESCRIPTION'].str.replace(pat='Pizza\/', repl='')
rest['CUISINE DESCRIPTION'] = rest['CUISINE DESCRIPTION'].str.replace(pat='Pizza', repl='Italian')

#group by boro and type of food
rest_group = rest.groupby(['BORO', 'CUISINE DESCRIPTION']).size().reset_index()
rest_group.rename(index=str, columns={0:'Count'}, inplace=True)

#link to latest population data
pop = pd.read_csv('nyc_pop_raw.csv', usecols=['Geography', 'Year', 'Population'])
pop = pop.loc[pop['Year'] == 2014]
pop['BORO'] = ['BRONX','BROOKLYN','MANHATTAN','QUEENS','STATEN ISLAND']
rest_group = rest_group.merge(pop[['BORO', 'Population']], on='BORO', how='left')

#find the proportion of each type of restaraunt
totals = pd.DataFrame(rest.groupby('BORO').size()).reset_index()
totals.rename(index=str, columns={0:'Total'}, inplace=True)
rest_group = rest_group.merge(totals, on='BORO', how='left')
rest_group['Prop'] = rest_group['Count']/rest_group['Total']

#save a copy
rest_group.to_csv('rest_group.csv', index=False)

#what if we remove the american restaraunts
rest_wout = rest[rest['CUISINE DESCRIPTION'] != 'American']
rest_group_wout = rest_group[rest_group['CUISINE DESCRIPTION'] != 'American']
rest_group_wout = rest_group_wout.drop(labels=['Total', 'Prop'], axis=1)
totals = pd.DataFrame(rest_wout.groupby('BORO').size()).reset_index()
totals.rename(index=str, columns={0:'Total'}, inplace=True)
rest_group_wout = rest_group_wout.merge(totals, on='BORO', how='left')
rest_group_wout['Prop'] = rest_group_wout['Count']/rest_group_wout['Total']

#combine type and borough
rest_group_wout['Btype'] = rest_group_wout["CUISINE DESCRIPTION"] + " " + rest_group_wout.BORO

#save a copy
rest_group_wout.sort_values(by='Prop', ascending=False, inplace=True)
rest_group_wout.to_csv('rest_group_wout_american.csv', index=False)