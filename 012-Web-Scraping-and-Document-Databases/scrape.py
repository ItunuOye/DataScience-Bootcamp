import os
import pandas as pd
from splinter import Browser
from bs4 import BeautifulSoup
import requests


def init_browser():
    # Replace the path with your actual path to the chromedriver
    executable_path = {"executable_path": "C:\\Users\\keg827\\ChromeDriver\\chromedriver.exe"}
    return Browser("chrome", **executable_path, headless=False)

###### VARIABLES #######
news_title = []
news_teaser = []
image_feature = []
tweets = []
thumbs = []
titles = []
news = {}


###### SCRAPE FUNCTION #######

def scrape():

    #### SCRAPE NEWS TITLE #####
    # URL of page to be scraped
    news_title_url = 'https://mars.nasa.gov/news'
    # Retrieve page with the requests module
    news_title_response = requests.get(news_title_url)
    
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(news_title_response.text, 'html.parser')
    
    for div in soup.findAll('div', {'class': 'content_title'}):
        a = div.findAll('a')
        for link in a:
            href = link.get('href')
            headline_base = link.get_text()
            headline_strip_front = headline_base.lstrip()
            headline_strip_back = headline_strip_front.rstrip()
            #print(href)
            #print(headline)
            news_title.append(headline_strip_back)
     
    news["news_title"] = news_title[0]
    
    ####### SCRAPE NEWS TEASER #########

    # URL of page to be scraped
    news_teaser_url = 'https://mars.nasa.gov/news'
    # Retrieve page with the requests module
    news_teaser_response = requests.get(news_teaser_url)
    
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(news_teaser_response.text, 'html.parser')
    #print(soup.prettify())
           
    for div in soup.findAll('div', {'class': 'rollover_description_inner'}):
        
        teaser_base = div.get_text()
        teaser_front = teaser_base.lstrip()
        teaser_back = teaser_front.rstrip()
        #print(teaser)
        news_teaser.append(teaser_back)
       
    news["news_teaser"] = news_teaser[0]
    #return(news)

    ######### SCRAPE MARS FEATURE IMAGE ##########

    browser = init_browser()
    image_url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    browser.visit(image_url)
    
    html = browser.html
    soup = BeautifulSoup(html, "html.parser")
    browser.click_link_by_partial_text('FULL IMAGE')
            
    for image in soup.findAll('img'):
        src = image['src']
        full_link = 'https://www.jpl.nasa.gov' + src
        image_feature.append(full_link)
        #print(full_link)
        
    news["image"] = image_feature[3]
    
    ######## SCRAPE WEATHER TWEET #########

    # URL of page to be scraped
    weather_url = 'https://twitter.com/marswxreport?lang=en'
    # Retrieve page with the requests module
    weather_response = requests.get(weather_url)
    
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(weather_response.text, 'html.parser')
    #print(soup.prettify())
    
    for p in soup.findAll('p', class_="tweet-text"):
        tweet = p.get_text()
        #print(tweet)
        tweets.append(tweet)
    
    news["tweet"] = tweets[0]
    
    #print(news)
    #return(news)

    ######### SCRAPE FACTS TABLE #############

     # URL of page to be scraped
    facts_url = 'https://space-facts.com/mars/'
    # Retrieve page with the requests module
    facts_response = requests.get(facts_url)
    
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(facts_response.text, 'html.parser')
    #print(soup.prettify())
    
    table = soup.find('table', attrs={'id':'tablepress-mars'})
    table_rows = table.find_all('tr')

    res = []
    for tr in table_rows:
        td = tr.find_all('td')
        row = [tr.text.strip() for tr in td if tr.text.strip()]
        if row:
            res.append(row)

    df = pd.DataFrame(res, columns=["Fact", "Value"])
    #print(df)
   # for fact in df["Fact"]:
        #print(fact)
    
    df["Fact"] =  df["Fact"].str.replace(' ', '_')
    df['Fact'] = df['Fact'].str.rstrip(':')
    news[df["Fact"][0]] = df["Value"][0]
    news[df["Fact"][1]] = df["Value"][1]
    news[df["Fact"][2]] = df["Value"][2]
    news[df["Fact"][3]] = df["Value"][3]
    news[df["Fact"][4]] = df["Value"][4]
    news[df["Fact"][5]] = df["Value"][5]
    news[df["Fact"][6]] = df["Value"][6]
    news[df["Fact"][7]] = df["Value"][7]
    news[df["Fact"][8]] = df["Value"][8]
    
    #print(news)
    #return(new)  
    
    ######### SCRAPE HEMISPHERE IMAGES #########
    # URL of page to be scraped
    hemisphere_image_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    # Retrieve page with the requests module
    hemisphere_image_response = requests.get(hemisphere_image_url)
    
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(hemisphere_image_response.text, 'html.parser')
     #print(soup.prettify())
        
    for image in soup.findAll('img', class_="thumb"):
        src = image['src']
        full_link = 'https://astrogeology.usgs.gov' + src
        thumbs.append(full_link)
    #print(thumbs)
    #return(thumbs)
    
    ######### SCRAPE HEMISPHERE TITLES #########
     # URL of page to be scraped
    hemisphere_title_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    # Retrieve page with the requests module
    hemisphere_title_response = requests.get(hemisphere_title_url)
    
    # Create BeautifulSoup object; parse with 'html.parser'
    soup = BeautifulSoup(hemisphere_title_response.text, 'html.parser')
    #print(soup.prettify())
    
     
    for div in soup.findAll('div', class_="description"):
        image_titles = div.findAll("h3")
        #print(image_titles)
        for image_title in image_titles:
            title = image_title.get_text()
            titles.append(title)
    
    #print(titles)
    #return(titles)


    hemisphere_images = pd.DataFrame({
    'title': titles,
    'image_url': thumbs
    })

    hemisphere_images["title"] =  hemisphere_images["title"].str.replace(' ', '_')

    news[hemisphere_images["title"][0]] = hemisphere_images["image_url"][0]
    news[hemisphere_images["title"][1]] = hemisphere_images["image_url"][1]
    news[hemisphere_images["title"][2]] = hemisphere_images["image_url"][2]
    news[hemisphere_images["title"][3]] = hemisphere_images["image_url"][3]

    ######### RETURN NEWS DICTIONARY ###########
    return(news)  
    

scrape()