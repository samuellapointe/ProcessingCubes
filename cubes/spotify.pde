import http.requests.*; // Library for HTTP requests: https://github.com/runemadsen/HTTP-Requests-for-Processing

String data;
String newToken;

// Keys to authorize the app through Spotify
String authorizationKey;
String refreshToken;

String requestSong = "https://api.spotify.com/v1/audio-features/";
JSONObject json;
JSONObject jsonSong;

// Variables we're interested in saving from the JSON
float tempo;
float energy;
int musicKey;
float loudness;
int mode;
float valence;
float danceability;

void setupSpotify() {
  String keys[] = loadStrings("data/KeyToken.txt");
  authorizationKey=keys[0];
  refreshToken=keys[1];

  // First, request a new refreshed token
  PostRequest postToken = new PostRequest("https://accounts.spotify.com/api/token");

  // adding all required data and headers
  postToken.addHeader("Authorization", "Basic " + authorizationKey);
  postToken.addData("grant_type", "refresh_token");
  postToken.addData("refresh_token", refreshToken);

  postToken.send();

//  println("Response Content Refresh Token: " + postToken.getContent());

  // Save new token for song request
  json = parseJSONObject(postToken.getContent());
  if (json == null) {
    println("JSONObject could not be parsed");
  } else {
    newToken = json.getString("access_token");
  }
}

void getSpotifyData(String songID) {
  
  // POST request
  GetRequest getSongData = new GetRequest(requestSong + songID);
  getSongData.addHeader("Authorization", "Bearer " + newToken);
  getSongData.send();
//  println("Response Content: " + getSongData.getContent());

  // save whatever data we want from the JSON
  jsonSong= parseJSONObject(getSongData.getContent());
  if (jsonSong == null) {
    println("JSONObject could not be parsed");
  } else {
    tempo = jsonSong.getFloat("tempo");
    energy = jsonSong.getFloat("energy");
    musicKey = jsonSong.getInt("key");
    loudness = jsonSong.getFloat("loudness");
    mode = jsonSong.getInt("mode");
    valence = jsonSong.getFloat("valence");
    danceability = jsonSong.getFloat("danceability");
  }
}