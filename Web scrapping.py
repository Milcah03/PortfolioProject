#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# Web scrapping


# In[ ]:


from bs4 import BeautifulSoup
import requests


# In[81]:


url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
page = requests.get(url)

soup = BeautifulSoup(page.text, 'html')


# In[82]:


print(soup)


# In[93]:


soup.find_all('table')

soup.find("table", class_ = "wikitable sortable")


# In[107]:


soup.find("table", class_ = "wikitable sortable")

table = soup.find_all("table")[1]

print(table)


# In[108]:


world_titles = table.find_all('th')


# In[109]:


world_table_titles = [title.text.strip() for title in world_titles]
print(world_table_titles)


# In[110]:


import pandas as pd


# In[113]:


df = pd.DataFrame(columns = world_table_titles)

df


# In[120]:


column_data = table.find_all('tr')

for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
       
    length = len(df)
    df.loc[length] =  individual_row_data 
    


# In[121]:


df


# In[133]:


df.to_csv(r'C:\Users\Administrator\Desktop\data analyst\companies.csv', index = False)

