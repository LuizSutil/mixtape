
var SpotifyWebApi = require('spotify-web-api-node');
const { MongoClient } = require('mongodb');
const cron = require('node-cron');
const dotenv = require('dotenv');
dotenv.config();

const uri = "mongodb+srv://admin:kNW18xUrfhKhtLm1@mixtape.qbeuh.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";

const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

var spotifyApi = new SpotifyWebApi({
    clientId: "7c323b27e1164b42a07da44759a13995",
    clientSecret: "64355de210924c28b6111798502dcc07",
    redirectUri: 'http://localhost:8000/home'

});


const playlists= ["37i9dQZEVXcH6AFQukMvE2","37i9dQZEVXcN4YprUuCkfa","37i9dQZEVXcOXxPocvn8Ox",
"37i9dQZEVXcFKUTzCkj8Xv","37i9dQZEVXcXidnZSJQZWi","37i9dQZEVXcRv92PXTzgoD","37i9dQZEVXcXargOEr4Dxd"]


const refreshTokenHelper = async ()=> {
  spotifyApi.setRefreshToken("AQC_kRBDmFBe_M2zVyx6kLaPvHtW4fvCZcTo09thzyaAax7-TMCdEiTobYdnrA02dorS6035actouKRClWLTOMuakZGA6fBt6B6F0tC9k65ylaQfu2jZYD1BXjnDFOWalUs");

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

// cron.schedule('0 03 1 */1 *', async () => {
  cron.schedule('* * * * *', async () => {
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


