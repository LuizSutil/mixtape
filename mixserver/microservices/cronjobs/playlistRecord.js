
var SpotifyWebApi = require('spotify-web-api-node');
const { MongoClient } = require('mongodb');
const cron = require('node-cron');
const dotenv = require('dotenv');
dotenv.config();

const uri = process.env.MONGO_URL;

const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

var spotifyApi = new SpotifyWebApi({
  clientId: process.env.SPOTIFY_ID,
  clientSecret: process.env.SPOTIFY_SECRET,
  redirectUri: 'http://localhost:8000/home'
});



const playlists= ["37i9dQZEVXcH6AFQukMvE2","37i9dQZEVXcN4YprUuCkfa","37i9dQZEVXcOXxPocvn8Ox",
"37i9dQZEVXcFKUTzCkj8Xv","37i9dQZEVXcXidnZSJQZWi","37i9dQZEVXcRv92PXTzgoD","37i9dQZEVXcXargOEr4Dxd"]


const refreshTokenHelper = async ()=> {
  spotifyApi.setRefreshToken(process.env.USER_REFRESH);

  // Gets access token to make api calls to spotify
  await spotifyApi.refreshAccessToken().then(
    function(data) {
      spotifyApi.setAccessToken(data.body['access_token']);
      return
    },
    function(err) {
      return
    }
  );

}

console.log("Cronjob initiated") 
cron.schedule('15 7 * * 1', async () => {
  //cron.schedule('* * * * *', async () => {
  //Logs the date that cronjob began
  console.log(new Date())
  const database = client.db("MixDB");
  const users = database.collection("users");
  let _date = new String

  //Shoud refresh every 30 min, as if cron job takes > 1 hour it will timeout
  await refreshTokenHelper()

  await spotifyApi.getPlaylistTracks(playlists[0])
    .then(function(data) {
        _date = data.body.items[0].added_at
    }, function(err) {
      console.log(err);
    });


  for (let i = 0;i < playlists.length;i++) {
    let songHistory = new Object()
    let _playlistCode = playlists[i]

    await spotifyApi.getPlaylistTracks(_playlistCode)
    .then(function(data) {
      console.log("got playlists")
      const songData = data.body.items

      for(song in songData){
        let _songName = songData[song].track.name
        let _songId = songData[song].track.id
        songHistory[_songId] = _songName
      }
      }, function(err) {
        console.log(err);
    });

    console.log("Sending playlist")
    let stringAddress = `cronMix.${_playlistCode}.${_date}`
    await client.connect();
    await database.collection("users").findOneAndUpdate({name:"Luiz"},{$set:{[stringAddress]:songHistory}});
    console.log("playlist added!")
    client.close()  
  }  
  console.log(new Date())  
});


