# %%
"""
### Loading data from csv to database
"""

# %%
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import pyodbc
import os
pd.set_option('display.max_columns', None)

# %%
# conn = pyodbc.connect('Driver={SQL Server};'
#                       'Server=DESKTOP-QEE21EV;'
#                       'Database=Airbnb_db_test;'
#                       'Trusted_Connection=yes;')
# cursor = conn.cursor()

# %%
# cursor.execute('CREATE TABLE Listings_skrypt ( \
#                id int, \
#                listing_url nvarchar(MAX),  \
#                 scrape_id float, \
#                last_scraped  nvarchar(MAX), \
#                name nvarchar(MAX), \
#                description nvarchar(MAX), \
#                neighborhood_overview nvarchar(MAX),\
#                picture_url nvarchar(MAX), \
#                host_id int, \
#                host_url nvarchar(MAX), \
#                host_name nvarchar(MAX), \
#                host_since  nvarchar(MAX), \
#                host_location nvarchar(MAX), \
#                host_about nvarchar(MAX), \
#                host_response_time nvarchar(MAX), \
#                host_response_rate nvarchar(MAX), \
#                host_acceptance_rate nvarchar(MAX), \
#                host_is_superhost nvarchar(MAX), \
#                host_thumbnail_url nvarchar(MAX), \
#                host_picture_url nvarchar(MAX), \
#                host_neighbourhood nvarchar(MAX), \
#                host_listings_count  nvarchar(MAX), \
#                host_total_listings_count  nvarchar(MAX), \
#                host_verifications nvarchar(MAX), \
#                host_has_profile_pic nvarchar(MAX), \
#                host_identity_verified  nvarchar(MAX), \
#                neighbourhood nvarchar(MAX),\
#                neighbourhood_cleansed nvarchar(MAX), \
#                neighbourhood_group_cleansed nvarchar(MAX), \
#                latitude nvarchar(MAX), \
#                longitude nvarchar(MAX), \
#                property_type nvarchar(MAX), \
#                room_type  nvarchar(MAX), \
#                accommodates nvarchar(MAX) , \
#                bathrooms nvarchar(MAX), \
#                bathrooms_text nvarchar(MAX), \
#                bedrooms nvarchar(MAX), \
#                beds nvarchar(MAX), \
#                amenities nvarchar(MAX), \
#                price nvarchar(MAX), \
#                minimum_nights  nvarchar(MAX), \
#                maximum_nights int, \
#                minimum_minimum_nights nvarchar(MAX), \
#                maximum_minimum_nights nvarchar(MAX), \
#                minimum_maximum_nights int , \
#                maximum_maximum_nights int, \
#                minimum_nights_avg_ntm nvarchar(MAX), \
#                maximum_nights_avg_ntm nvarchar(MAX), \
#                calendar_updated nvarchar(MAX), \
#                has_availability  nvarchar(MAX), \
#                availability_30  nvarchar(MAX) , \
#                availability_60  nvarchar(MAX), \
#                availability_90  nvarchar(MAX), \
#                availability_365  nvarchar(MAX), \
#                calendar_last_scraped  nvarchar(MAX), \
#                number_of_reviews  nvarchar(MAX), \
#                number_of_reviews_ltm  nvarchar(MAX), \
#                number_of_reviews_l30d  nvarchar(MAX), \
#                first_review  nvarchar(MAX), \
#                last_review  nvarchar(MAX), \
#                review_scores_rating  nvarchar(MAX), \
#                review_scores_accuracy   nvarchar(MAX), \
#                review_scores_cleanliness   nvarchar(MAX), \
#                review_scores_checkin   nvarchar(MAX), \
#                review_scores_communication  nvarchar(MAX), \
#                review_scores_location  nvarchar(MAX), \
#                review_scores_value  nvarchar(MAX), \
#                license nvarchar(MAX), \
#                instant_bookable  nvarchar(MAX), \
#                calculated_host_listings_count  nvarchar(MAX) , \
#                calculated_host_listings_count_entire_homes  nvarchar(MAX), \
#                calculated_host_listings_count_private_rooms  nvarchar(MAX), \
#                calculated_host_listings_count_shared_rooms nvarchar(MAX), \
#                reviews_per_month nvarchar(MAX))')

# %%
# conn.commit()

# %%
data = pd.read_csv (f'airbnb_csv/Barcelona, Catalonia, Spain.csv')
city_df = pd.DataFrame(data)
df=pd.DataFrame(columns=city_df.columns)

# %%
for file in os.listdir('airbnb_csv'):
    string=file.split(".")[0]
    string_split=string.split(", ")  

    data = pd.read_csv(f'airbnb_csv/{file}')
    city_df = pd.DataFrame(data)
    city_df['city']=string_split[0]
    city_df['region']=string_split[1]
    city_df['country']=string_split[2]
    df=pd.concat([df, city_df], axis=0)


# %%
df_copy=df.copy()

# %%
#df=df_copy.copy()

# %%
"""
### INSERT DATA
"""

# %%
# for row in df.itertuples():
#     cursor.execute('''
#                 INSERT INTO Listings_skrypt
#                 VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, \
#                 ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
#                 ''',
#                  row.id, row.listing_url, row.scrape_id, row.last_scraped,
#                  row.name, row.description, row.neighborhood_overview,
#                  row.picture_url, row.host_id, row.host_url,
#                  row.host_name, row.host_since, row.host_location, row.host_about,
#                  row.host_response_time, row.host_response_rate, row.host_acceptance_rate,
#                  row.host_is_superhost, row.host_thumbnail_url, row.host_picture_url,
#                  row.host_neighbourhood, row.host_listings_count,
#                  row.host_total_listings_count, row.host_verifications,
#                  row.host_has_profile_pic, row.host_identity_verified, row.neighbourhood,
#                  row.neighbourhood_cleansed, row.neighbourhood_group_cleansed, row.latitude,
#                  row.longitude, row.property_type, row.room_type, row.accommodates, row.bathrooms,
#                  row.bathrooms_text, row.bedrooms, row.beds, row.amenities, row.price,
#                  row.minimum_nights, row.maximum_nights, row.minimum_minimum_nights,
#                  row.maximum_minimum_nights, row.minimum_maximum_nights,
#                  row.maximum_maximum_nights, row.minimum_nights_avg_ntm,
#                  row.maximum_nights_avg_ntm, row.calendar_updated, row.has_availability,
#                  row.availability_30, row.availability_60, row.availability_90,
#                  row.availability_365, row.calendar_last_scraped, row.number_of_reviews,
#                  row.number_of_reviews_ltm, row.number_of_reviews_l30d, row.first_review,
#                  row.last_review, row.review_scores_rating, row.review_scores_accuracy,
#                  row.review_scores_cleanliness, row.review_scores_checkin,
#                  row.review_scores_communication, row.review_scores_location,
#                  row.review_scores_value, row.license, row.instant_bookable,
#                  row.calculated_host_listings_count,
#                  row.calculated_host_listings_count_entire_homes,
#                  row.calculated_host_listings_count_private_rooms,
#                  row.calculated_host_listings_count_shared_rooms, row.reviews_per_month
#                 )
# conn.commit()

# %%
df = df.loc[:,['id','scrape_id','last_scraped','name',
'host_id','host_name','host_since','host_response_time','host_response_rate','host_acceptance_rate','host_is_superhost',
'host_listings_count','host_has_profile_pic','host_identity_verified','latitude','longitude','property_type','room_type','accommodates',
'bathrooms_text','bedrooms','beds','amenities','price','minimum_nights','maximum_nights',
'availability_365','number_of_reviews','first_review','last_review',
        'review_scores_rating', 'review_scores_accuracy',
       'review_scores_cleanliness', 'review_scores_checkin',
       'review_scores_communication', 'review_scores_location',
       'review_scores_value',
'instant_bookable','reviews_per_month', 'city', 'region', 'country']]

# %%
df.shape

# %%
#host = df.loc[:,['host_id','host_name','host_since','host_is_superhost','host_has_profile_pic',
#                 'host_identity_verified','host_response_time','host_response_rate','host_acceptance_rate',]]

# %%
#host.shape[1]

# %%
#host.duplicated().value_counts()

# %%
# listing = df.loc[:,['id','last_scraped', 'host_id','name','latitude','longitude','property_type','room_type',
#                     'instant_bookable','first_review','last_review','accommodates','bathrooms','bathrooms_text',
#                     'bedrooms','beds','amenities','price','minimum_nights','maximum_nights','availability_365',
#                     'number_of_reviews','reviews_per_month','review_scores_rating','review_scores_cleanliness',
#                     'review_scores_checkin','review_scores_communication','review_scores_location','host_listings_count']]

# %%
# listing.shape[1]

# %%
# amenity = df['amenities']

# %%
total = df.isna().sum().sort_values(ascending=False) # how many missings in each column
percent = (df.isna().sum()/df.isna().count()).round(4).sort_values(ascending=False) # in %
missing_df = pd.concat([total, percent], axis=1, keys=['Total', 'Percent'])
missing_df.query("Total > 0")

# %%
#plt.figure(figsize=(15,9))
sns.heatmap(df[missing_df.query('Total > 0').index].isna()); # selecting only those variables which contain any missings
plt.title('Visualization of NAs in dataset (white - missing values)\n');

# %%
cols_missing=['review_scores_rating', 'review_scores_accuracy',
       'review_scores_cleanliness', 'review_scores_checkin',
       'review_scores_communication', 'review_scores_location',
       'review_scores_value','bedrooms', 'beds','bathrooms_text', 'host_listings_count', 'name', 'first_review', 'last_review']
df = df.dropna(subset=cols_missing).reset_index(drop=True)

# %%
# usuniecie $ i konwersja price na typ numeryczny
df['price'] = df['price'].apply(lambda x: x[1:].replace(',','')).astype(float)

# %%
# usuniecie ; z nazwy
df['name'] = df['name'].apply(lambda x: x.replace(';',':'))

# %%
%%time
# bathrooms
df['bathrooms_type'] = 'private'
df['bathrooms'] = 0.0
for i, val in df.iterrows():
    if ('shared' in df.iat[i,19]) or ('Shared' in df.iat[i,19]):
        df.iat[i,42] = 'shared'
    if ('half-bath' in df.iat[i,19]) or ('Half-bath' in df.iat[i,19]):
        df.iat[i,43] = 0.5
    first_word = df.iat[i,19].split(' ', 1)[0]
    if len(first_word) <= 4:
        df.iat[i,43] = float(first_word)
df['bathrooms_text'] = df['bathrooms_type']

# %%
df = df.drop('bathrooms_type', axis=1).rename(columns={'bathrooms_text':'bathrooms_type'})

# %%
# beds
df['bedrooms'] = df.bedrooms.astype(int)
df['beds'] = df.beds.astype(int)

# %%
df.info()

# %%
"""
## Conversion
"""

# %%
date_cols=['last_scraped', 'first_review','last_review', 'host_since']
for col in date_cols:
    df[col]=pd.to_datetime(df[col])

# %%
int_cols=['id', 'host_id', 'review_scores_rating', 'review_scores_accuracy', 'review_scores_cleanliness', 'review_scores_checkin',
          'review_scores_communication', 'review_scores_location', 'review_scores_value', 'host_listings_count',
         'minimum_nights', 'maximum_nights', 'accommodates', 'availability_365', 'number_of_reviews', ]

# %%
for col in int_cols:
    df[col]=df[col].astype(int)

# %%
df.info()

# %%
df.shape

# %%
df.to_csv('airbnb_data.csv', sep=';', index=False)

# %%
#df.to_csv('airbnb_data_coma.csv', sep=',', index=False)

# %%
