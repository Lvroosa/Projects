# Tweaked the Gemini prompt to get more accurate results.
#Also, for some reason, gemini-1.0-pro is no longer available. Changed to gemini-1.5-pro-latest


import os
import streamlit as st
import requests
from google import genai
import pandas as pd
import re
import datetime




# Store API keys securely (Replace with your actual API keys)
NEWS_API_KEY = "6cc5852e38fb4036b3b99afa53edcfb6"
GEMINI_API_KEY = "AIzaSyCfor02YqYrYMsL016A9-PHXm6Whof3iGM"



# Configure Gemini API
client = genai.Client(api_key=GEMINI_API_KEY)
# Streamlit UI
st.title("Tulane University: Sentiment Analysis from News")




# Make it so someone can type in their own keywords to customize the search
search = st.text_input("Enter a keyword to search for. Separate multiple values with commas", "Tulane")
# Separate the search terms with a plus sign
start_date = st.date_input("Start Date", value= datetime.date.today() - datetime.timedelta(days = 7))
end_date = st.date_input("End Date", value=datetime.date.today())




if st.button('Search'):
    search = search.replace(", ", "+")




    #create a sidebar filter for the date range
   
    # Fetch News API articles
    news_url = (
        f"https://newsapi.org/v2/everything?q={search}&"
        f"from={start_date}&to={end_date}&sortBy=popularity&apiKey={NEWS_API_KEY}"
    )




    response = requests.get(news_url)
    if response.status_code == 200:
        news_data = response.json()
        articles = news_data.get("articles", [])
        for article in articles:
            title = article['title']
            url = article['url']
        if not articles:
            st.write("No articles found.")
        else:
            # Extract text from articles
            text_to_analyze = "\n\n".join(
                [f"Title: {article['title']}\nDescription: {article['description']}\nContent: {article['content']}\nURL:{article['url']}" for article in articles]
            )




            # Google Gemini Sentiment Analysis
            sentiment_prompt = (
            "Analyze the sentiment of the following news articles in relation to the keywords: "
            f"'{search}'.\n"  # Use f-string to include the search keywords
            "Assume all articles affect Tulane's reputation positively, neutrally, or negatively. \n"
            "Then, consider how the keywords also get discussed or portrayed in the article.\n"
            "Provide an overall sentiment score (-1 to 1, where -1 is very negative, 0 is neutral, and 1 is very positive(This is a continuous range)) \n"
            "Provide a summary of the sentiment and key reasons why the sentiment is positive, neutral, or negative, "
            "specifically in relation to the keywords.\n"
            "Make sure that you include the score from -1 to 1 in a continuous range (with decimal places) and include the title, "
            "sentiment score, summary, and a statement explaining how the article relates to the keywords.\n"
            "Separate article info by double newlines and always include 'Title:' before the headline and 'Sentiment:' before the score.\n"
            "Only judge the sentiment for each article in terms of how it mentions the keywords. Max amount of titles should be 100.\n\n"
            "If the article merely mentions a quote from a Tulane student, faculty, or staff, mention that on the.\n"
            f"{text_to_analyze}"
            )




            gemini_response = client.models.generate_content(model="gemini-1.5-pro-latest", contents=[sentiment_prompt])




            if gemini_response and gemini_response.text:
                sections = gemini_response.text.split("\n\n")  # Split by double newline
                for section in sections:
                    title_match = re.search(r'Title:\s*(.*)', section)
                    sentiment_match = re.search(r'Sentiment:\s*(-?\d+\.?\d*)', section)
                    summary_match = re.search(r'Summary:\s*(.*)', section)




                   




                    if title_match and sentiment_match and summary_match:
                        title = title_match.group(1)
                        sentiment = sentiment_match.group(1)
                        summary = summary_match.group(1)
                        for article in articles:
                            if article['title'] == title:
                                url = article['url']




                    # Format the output
                        st.markdown(f"###  **[{title}]({url})**")
                        st.markdown(f"🔹 **Sentiment Score:** `{sentiment}`")
                        st.markdown(f" **Summary:** {summary}")
                        st.write("---")  # Separator line for readability




            def text_to_dataframe(text):
                    """
                    Converts a text string with title and sentiment information into a Pandas DataFrame.
                    Ignores bold formatting.
               
                    Args:
                        text (str): The input text string.
               
                    Returns:
                        pandas.DataFrame: A DataFrame with "Title" and "Sentiment" columns.
                    """
               
                    titles = []
                    scores = []
               
                    # Split the text into sections based on "Title: "
                    sections = re.split(r'Title: ', text)[1:]
               
                    for section in sections:
                        # Extract title (ignoring bold formatting)
                        title_match = re.match(r'(.*?)\nSentiment:', section, re.DOTALL)
                        if title_match:
                            titles.append(title_match.group(1).strip())
                        else:
                            titles.append(None)
               
                        # Extract sentiment score (ignoring bold formatting)
                        score_match = re.search(r'Sentiment:\s*(-?\d+\.?\d*)', section, re.DOTALL)
                        if score_match:
                            scores.append(float(score_match.group(1)))
                        else:
                            scores.append(None)
               
                    df = pd.DataFrame({'Title': titles, 'Sentiment': scores})
                    return df
               
            df = text_to_dataframe(gemini_response.text)
   
            st.dataframe(df)
   
            #group the data by the sentiment score and count the number of articles in each sentiment category
            sentiment_counts = df['Sentiment'].value_counts()




            #make a histogram of the sentiment scores
            st.bar_chart(sentiment_counts)




                #make a metric showing the average sentiment score. round it. Also add a metric for amount of news stories covered
            st.metric("Average Sentiment Score", round(df['Sentiment'].mean(), 2))
            if df['Sentiment'].mean() >= 0.1:
                st.write("Overall sentiment is positive.")
                st.metric("Number of News Stories", len(df))
            elif df['Sentiment'].mean() <= -0.1:
                st.write("Overall sentiment is negative.")
                st.metric("Number of News Stories", len(df))
            else:
                st.write("Overall sentiment is neutral.")
                st.metric("Number of News Stories", len(df))
