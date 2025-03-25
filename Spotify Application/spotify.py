import pandas as pd
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import streamlit as st

# Spotify API credentials. Insert your own API keys here
client_id = ''
client_secret = ''

# Authenticating with Spotify using Client Credentials Flow
spotify = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=client_id, client_secret=client_secret))
st.title('Spotify Artist Metrics')

# Search for artists. Allows the user to input the artist names separated by commas
artist_names = st.text_input('Enter the names of the artists you would like to search for (separated by commas):')

# Added a button to search for the artists
search_button = st.button('Search')

if not search_button:
    st.stop()

# Split the input into individual artist names and limited it to 5 artists
artist_names_list = [name.strip() for name in artist_names.split(',')][:5]

#Added spotify logo to top left
logo = 'https://storage.googleapis.com/pr-newsroom-wp/1/2023/05/Spotify_Primary_Logo_RGB_Green.png'
st.logo(image=logo)

st.write("")

#Added cache
@st.cache_data
def get_artist_data(artist_name):
    return spotify.search(q='artist:' + artist_name, type='artist')

@st.cache_data
def get_top_tracks(artist_id):
    return spotify.artist_top_tracks(artist_id)['tracks']

for artist_name in artist_names_list:
    results = get_artist_data(artist_name)
    if not results['artists']['items']:
        st.write(f"No results found for {artist_name}")
        continue

    # Chooses the first artist from the search results
    artist = results['artists']['items'][0]

    icon = artist['images'][0]['url']
    st.image(image=icon, width=200)
    name = artist['name']
    st.markdown(f"### [{name}]({artist['external_urls']['spotify']})")

    col1, col2, col3 = st.columns(3)
    col1.metric("Followers", value=f"{artist['followers']['total']:,}")
    col2.metric("Popularity", value=artist['popularity'])
    if len(artist['genres']) == 0:
        col3.metric("Genre(s)", value="N/A")
    else:
        col3.metric("Genre(s)", value=', '.join(artist['genres']))

    # Displays the artist's top tracks
    st.subheader('Top Tracks')
    top_tracks = get_top_tracks(artist['id'])

    # Creates a DataFrame to display the top tracks in a table
    top_tracks_data = {
        'Rank': list(range(1, len(top_tracks) + 1)),
        'Track Name': [track['name'] for track in top_tracks],
        'Artists': [', '.join([artist['name'] for artist in track['artists']]) for track in top_tracks]
    }

    top_tracks_df = pd.DataFrame(top_tracks_data)
    st.table(top_tracks_df.head(10).set_index('Rank'))

    with st.expander("Extra Information"):
        st.write(f"Spotify URL: {artist['external_urls']['spotify']}")
        st.write(f"Spotify ID: {artist['id']}")

    # Adds a gap after each artist
    st.write("---")

# Compares the popularity of the artists using the popularity metric and a bar chart
if len(artist_names_list) > 1:
    popularity_data = {
        'Artist': [str(artist_name) for artist_name in artist_names_list],
        'Popularity': [float(get_artist_data(artist_name)['artists']['items'][0]['popularity']) for artist_name in artist_names_list]
    }
    popularity_df = pd.DataFrame(popularity_data)

    followers_data = {
        'Artist': [str(artist_name) for artist_name in artist_names_list],
        'Followers': [float(get_artist_data(artist_name)['artists']['items'][0]['followers']['total']) for artist_name in artist_names_list]
    }
    followers_df = pd.DataFrame(followers_data)

    col1, col2 = st.columns(2)
    col1.subheader('Popularity Comparison')
    col1.bar_chart(popularity_df.set_index('Artist'), use_container_width=True, color='#008000')
    col2.subheader('Followers Comparison' + (' (in millions)' if followers_df['Followers'].max() >= 1_000_000 else ''))
    followers_df['Followers'] = followers_df['Followers'].apply(lambda x: x / 1_000_000 if x >= 1_000_000 else x)
    col2.bar_chart(followers_df.set_index('Artist'), use_container_width=True)

st.write("Thank you for using the Spotify Artist Metrics app!")
