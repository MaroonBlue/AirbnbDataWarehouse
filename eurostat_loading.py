# %%
"""
## Eurostat data
"""

# %%
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import pyodbc
import pycountry
pd.set_option('display.max_columns', None)

# %%
"""
### Arrivals
"""

# %%
df_arrivals = pd.read_excel('./eurostat/TOUR_OCC_ARN2$DEFAULTVIEW1621782256780.xlsx', 'Sheet 5', skiprows=9, nrows=494)

# %%
df_arrivals.drop(0, axis=0, inplace=True)
cols = [c for c in df_arrivals.columns if c[:7] == 'Unnamed']
df_arrivals.drop(cols, axis=1, inplace=True)

# %%
df_arrivals = df_arrivals.rename(columns = {'TIME' : 'Region'})

# %%
df_arrivals.head()

# %%
"""
### Establishments
"""

# %%
df_establishments = pd.read_excel('./eurostat/TOUR_CAP_NUTS2$DEFAULTVIEW1622395990444.xlsx', 'Sheet 1', skiprows=9, nrows=499) # unit of measure - number

# %%
df_establishments.drop(0, axis=0, inplace=True)
cols = [c for c in df_establishments.columns if c[:7] == 'Unnamed']
df_establishments.drop(cols, axis=1, inplace=True)
df_establishments.drop('2020', axis=1, inplace=True)

# %%
df_establishments = df_establishments.rename(columns = {'TIME' : 'Region'})

# %%
df_establishments.head()

# %%
"""
### Air transport
"""

# %%
df_airtransport = pd.read_excel('./eurostat/TRAN_R_AVPA_NM$DEFAULTVIEW1622396128371.xlsx', 'Sheet 1', skiprows=8, nrows=353) # unit of measure - thousand

# %%
df_airtransport.drop(0, axis=0, inplace=True)
cols = [c for c in df_airtransport.columns if c[:7] == 'Unnamed']
df_airtransport.drop(cols, axis=1, inplace=True)

# %%
df_airtransport = df_airtransport.rename(columns = {'TIME' : 'Code', 'TIME.1' : 'Region'})

# %%
df_airtransport.head()

# %%
"""
### Population
"""

# %%
df_population = pd.read_excel('./eurostat/DEMO_R_D2JAN$DEFAULTVIEW1622396054950.xlsx', 'Sheet 1', skiprows=9, nrows=507) # unit of measure - number

# %%
df_population.drop(0, axis=0, inplace=True)
cols = [c for c in df_population.columns if c[:7] == 'Unnamed']
df_population.drop(cols, axis=1, inplace=True)

# %%
df_population = df_population.rename(columns = {'TIME' : 'Code', 'TIME.1' : 'Region'})

# %%
df_population.head()

# %%
"""
### Final df
"""

# %%
regions = ["País Vasco",
"Comunidad de Madrid", 
"Cataluña",
"Comunitat Valenciana", 
"Illes Balears", 
"Andalucía", 
"Lombardia",
"Provincia Autonoma di Bolzano/Bozen",
"Provincia Autonoma di Trento",
"Veneto",
"Emilia-Romagna",
"Toscana",
"Lazio",
"Campania",
"Puglia",
"Sicilia",
"Norte", 
"Área Metropolitana de Lisboa" ]

# %%
# tylko potrzebne dane (2019) + usunięcie duplikatów
df_arrivals = df_arrivals.loc[df_arrivals.Region.isin(regions), ['Region', '2019']].drop_duplicates()
df_establishments = df_establishments.loc[df_establishments.Region.isin(regions), ['Region', '2019']].drop_duplicates()
df_airtransport = df_airtransport.loc[df_airtransport.Region.isin(regions), ['Code', 'Region', '2019']].drop_duplicates()
df_population = df_population.loc[df_population.Region.isin(regions), ['Code', 'Region', '2019']].drop_duplicates()

# %%
# łączenie wszystkich ramek
df_1 = pd.merge(df_arrivals, df_establishments, how='inner', on='Region', suffixes=('_arr', '_est'))
df_2 = pd.merge(df_airtransport, df_population, how='right', on=['Code', 'Region'], suffixes=('_air', '_pop'))
df_final = pd.merge(df_1, df_2, how='left', on='Region')

# %%
df_final = df_final.loc[:,['Code', 'Region', '2019_arr', '2019_est', '2019_air', '2019_pop']]
df_final = df_final.query('Code != "ES3"').reset_index(drop=True)

# %%
df_final.info()

# %%
# zsumowanie danych dla regionu Trentino
df_final.iloc[df_final.Code == 'ITH2', 2:6] = df_final.values[7:9, 2:6].sum(axis=0)
df_final = df_final.drop(7, axis=0).reset_index(drop=True)

# %%
# zmiana typów zmiennych
cols = df_final.columns[2:]
for col in cols:
    if col != '2019_air':
        df_final[col] = df_final[col].astype(int)
    if col == '2019_air':
        df_final[col] = df_final[col].astype(float)


# %%
# uwzględnienie jednostki w AirTransport
df_final['2019_air'] = df_final['2019_air']*1000

# %%
# zmiana nazw kolumn
df_final = df_final.rename(columns = {'Code' : 'RegionCode', '2019_arr' : 'TouristArrivals',
                                        '2019_est' : 'TouristEstablishments', '2019_air' :                                                      'AirPassengers', '2019_pop' : 'Population'})

# %%
# dodanie kolumny countrycode i country
df_final['CountryCode'] = df_final.RegionCode.str.slice(0,2)
for i, val in df_final.iterrows():
    country = pycountry.countries.get(alpha_2=df_final.loc[i, 'CountryCode'])
    df_final.loc[i, 'Country'] = country.name

# %%
# zmiana na odpowiednie nazwy regionów
df_final.loc[:5, 'Region'] = pd.Series(['Basque Country', 'Comunidad de Madrid', 'Catalonia', 'Valencia', 'Islas Baleares', 'Andalucía'])
df_final.loc[7, 'Region'] = 'Trentino'
df_final.loc[16, 'Region'] = 'Lisbon'

# %%
# odpowiednia kolejnosc kolumn
df_final = df_final[['Country', 'CountryCode', 'Region', 'RegionCode', 'TouristArrivals', 'TouristEstablishments', 'AirPassengers', 'Population']]

# %%
# zmiana NaN na 0 (tymczasowo w celu odpowiedniego wczytania do bazy)
df_final.loc[df_final.AirPassengers.isna(), 'AirPassengers'] = 0

# %%
df_final

# %%
"""
### Loading to database
"""

# %%
#conn = pyodbc.connect('Driver={SQL Server};'
#                      'Server=DESKTOP-QEE21EV;'
#                      'Database=Airbnb_eurostat;'
#                      'Trusted_Connection=yes;')
#cursor = conn.cursor()

# %%
conn = pyodbc.connect('Driver={SQL Server}; Server=LAPTOP-4QT1T3CT; Database=Airbnb_eurostat; Trusted_Connection=yes;')
cursor = conn.cursor()

# %%
cursor.execute('CREATE TABLE RegionalStatistics ( \
               Country varchar(50),\
               CountryCode varchar(2),\
               Region varchar(100),\
               RegionCode varchar(4),\
               TouristArrivals int,\
               TouristEstablishments int,\
               AirPassengers int,\
               Population int)')
conn.commit()

# %%
for row in df_final.itertuples():
    cursor.execute('''
                INSERT INTO RegionalStatistics
                VALUES (?,?,?,?,?,?,?,?)
                ''',
                 row.Country, row.CountryCode, 
                 row.Region, row.RegionCode, 
                 row.TouristArrivals, row.TouristEstablishments, 
                 row.AirPassengers, row.Population)
conn.commit()

# %%
# zmiana 0 na własciwa wartość (NULL)
cursor.execute('''
               UPDATE Airbnb_eurostat.dbo.RegionalStatistics
               SET AirPassengers = NULL
               WHERE RegionCode = 'ITH2'
               ''')
conn.commit()

# %%
df_final.to_csv('eurostat_data.csv', index=False, header=True)

# %%
