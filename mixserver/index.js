const dotenv = require('dotenv');
var SpotifyWebApi = require('spotify-web-api-node');
const express = require('express')
const app = express()
const port = 8000

dotenv.config();



const env = process.env;

var scopes = ['user-read-private', 'user-read-email','ugc-image-upload','user-read-playback-state',
'user-modify-playback-state', 'user-follow-modify','user-follow-read', 'user-library-modify','user-library-read',
'streaming', 'user-read-playback-position', 'playlist-modify-private', 'playlist-read-collaborative', 'app-remote-control',
'playlist-read-private', 'user-top-read', 'playlist-modify-public', 'user-read-currently-playing', 'user-read-recently-played']


var spotifyApi = new SpotifyWebApi({
    clientId: env.SPOTIFY_ID,
    clientSecret: env.SPOTIFY_SECRET,
    redirectUri: 'http://localhost:8000/home'

});



app.get('/', async (req, res) => {

  var authorizeURL = spotifyApi.createAuthorizeURL(scopes, 'some-state-of-my-choice',false);
  res.redirect(authorizeURL);

})


app.get('/home', async (req, res) => {

  code = req.query['code']
  
  spotifyApi.authorizationCodeGrant(code).then(
    function(data) {
      console.log(data.body['access_token'])
      console.log(data.body['refresh_token']);
      spotifyApi.setAccessToken(data.body['access_token']);
      spotifyApi.setRefreshToken(data.body['refresh_token']);
      res.redirect("http://localhost:8000/aboutme");
    },
    function(err) {
      console.log('Something went wrong!', err);
    }
  );

})

app.get('/aboutme', async (req, res) => {

  spotifyApi.getMe()
      .then(function(data) {
        res.send(JSON.stringify(data.body['images'][0]['url']));
      }, function(err) {
        console.log('Something went wrong!', err);
      });

})


app.get('/logout', async (req,res)=>{
  spotifyApi.resetAccessToken()
  spotifyApi.resetRefreshToken()

  // request("https://www.spotify.com/fr/logout", function (error, response, body) {
  //   console.log('error:', error); // Print the error if one occurred
  //   console.log('statusCode:', response && response.statusCode); // Print the response status code if a response was received
  //   console.log('body:', body); // Print the HTML for the Google homepage.
  // });

  res.redirect('/')
})


app.listen(port, () => {
  console.log(`Mixserver at http://localhost:${port}`)
})