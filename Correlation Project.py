#!/usr/bin/env python
# coding: utf-8

# In[3]:


#Importing libraries
import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None

# read the data from csv file

df = pd.read_csv(r'C:\Users\Admin\Downloads\movies.csv')


# In[5]:


# view the dataset

df.head(5)


# In[14]:


# Look for missing data

for col in df.columns:
    missing_data = np.mean(df[col].isnull())
    print('{} - {}%'.format(col,round(missing_data*100)))


# In[10]:


# Looking for datatypes of columns

df.dtypes


# In[25]:


# Changing datatype
# df['budget'] = df['budget'].astype('int64')
# df['gross'] = df['gross'].astype('int64')

# create a year column from released column
df['year'] = df['released'].astype('str').str[8:]


# In[26]:


df.head(10)


# In[60]:


# Sorting data according to gross revenue

df.sort_values(by= ['gross'],inplace = False, ascending = False)


# In[30]:


pd.set_option('display.max_rows',None)


# In[34]:


# drop duplicates = df.drop_duplicates()
# Unique or distinct values = df['company'].sort_values(ascending = False)
df['company'].drop_duplicates()


# In[36]:


# correlation between budget and gross revenue ,company and gross revenue

#scatterplot with budget vs gross revenue
plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget Vs Gross revenue')
plt.xlabel('Budget of the movie')
plt.ylabel('Gross Revenue of the movie')
plt.show()


# In[42]:


#regression plot using seaborne(sns)
#plot budget Vs gross

sns.regplot(x = df['budget'],y=df['gross'],data = df,scatter_kws={"color":"Red"},line_kws = {"color":"Blue"})


# In[46]:


# correlation in df 
#correlation works only on numerical datatypes not on strings

df.corr(method ='pearson') #pearson, kendall,spearman correlation methods. By default we use pearson correlation


# In[48]:


# high correlation b/w budget and revenue
corr_matrix = df.corr(method ='pearson')
sns.heatmap(corr_matrix, annot = True)
plt.title("Correlation among Movie attributes")
plt.xlabel("Movie attributes")
plt.ylabel("Movie attributes")
plt.show()


# In[51]:


# company Vs gross

df_numerized = df
for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype =='object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes

df_numerized


# In[52]:


#correlation among all movie attributes

corr_matrix_1 = df.corr(method ='pearson')
sns.heatmap(corr_matrix_1, annot = True)
plt.title("Correlation among Movie attributes")
plt.xlabel("Movie attributes")
plt.ylabel("Movie attributes")
plt.show()


# In[54]:


df_numerized.corr()


# In[55]:


correlation_matrix = df_numerized.corr()
corr_pairs = correlation_matrix.unstack()
corr_pairs


# In[57]:


sorted_pairs = corr_pairs.sort_values(ascending=False)
sorted_pairs


# In[59]:


high_correlation = sorted_pairs[(sorted_pairs)>0.5]
high_correlation


# In[ ]:


# Here Budget and votes have highest correlation with gross among all other movie attributes.
# company has very little correlation

