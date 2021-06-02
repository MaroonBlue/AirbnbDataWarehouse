# %%
import csv
import requests
import os
import gzip
import shutil
from urllib.request import urlopen
from bs4 import BeautifulSoup

# %%
countries= ["Spain","Italy", "Portugal"]

# %%
url="http://insideairbnb.com/get-the-data.html"
html=urlopen(url)
soup=BeautifulSoup(html, "html.parser")    

# %%
"""
## Check city names to download
"""

# %%
for item in soup.find_all('h2'):
    string=item.get_text()
    split_string=string.split(", ")
    country=split_string[-1]
    if country in countries:
        print(string)

# %%
"""
## Download .csv.gz files to airbnb_gz
"""

# %%
if not (os.path.isdir('airbnb_gz')): os.mkdir('airbnb_gz')

# %%
for item in soup.find_all('h2'):
    string=item.get_text()
    if string=='Trentino, Trentino-Alto Adige/Südtirol, Italy':
        string='Trentino, Trentino, Italy'
    if string=='Euskadi, Euskadi, Spain':
        string='Basque Country, Basque Country, Spain'
    if string=='Milan, Lombardy, Italy':
        string='Milan, Lombardia, Italy'
    split_string=string.split(', ')
    country=split_string[-1]
    if country in countries:
        table=item.nextSibling.nextSibling.nextSibling.nextSibling
        #print(table.get('class', []))
        #print(type(table))
        listing_url=table.contents[3].contents[1].contents[5].contents[0]['href']
        filename=f'airbnb_gz\{string}.csv.gz'

        with open(filename, "wb") as f:
            r = requests.get(listing_url)
            f.write(r.content)

# %%
"""
## Unpack .gz to .csv in airbnb_csv
"""

# %%
if not(os.path.isdir('airbnb_csv')): os.mkdir('airbnb_csv')

# %%
for filename in os.listdir('airbnb_gz'):
    with gzip.open(f'airbnb_gz\{filename}', 'rb') as f_in:
        new_filename=f'airbnb_csv\{filename[0:-3]}'
        with open(new_filename, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

# %%
