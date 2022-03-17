const dotenv = require("dotenv");
var SpotifyWebApi = require("spotify-web-api-node");
const express = require("express");
const app = express();
const bcrypt = require("bcrypt");
const passport = require("passport");
const flash = require("express-flash");
const session = require("express-session");
const methodOverride = require("method-override");
const { MongoClient } = require("mongodb");

dotenv.config();
const env = process.env;

const uri = process.env.MONGO_URL;
const client = new MongoClient(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

const port = 8000;

const initializePassport = require("./passport-config");
const e = require("express");
initializePassport(
  passport,
  (email) => users.find((user) => user.email === email),
  (id) => users.find((user) => user.id === id)
);

let users = [];

app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(flash());
app.use(
  session({
    secret: env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false },
  })
);
app.use(passport.initialize());
app.use(passport.session());
app.use(methodOverride("_method"));

function checkAuthenticated(req, res, next) {
  if (req.isAuthenticated()) {
    return next();
  }
  res.redirect("/login");
}

function checkNotAuthenticated(req, res, next) {
  if (req.isAuthenticated()) {
    return res.redirect("/");
  }
  next();
}

app.post(
  "/login",
  checkNotAuthenticated,
  passport.authenticate("local", {
    successRedirect: "/",
    failureRedirect: "/login",
  })
);

app.post("/register", checkNotAuthenticated, async (req, res) => {
  try {
    const hashedPassword = await bcrypt.hash(req.body.password, 10);
    users.push({
      id: Date.now().toString(),
      name: req.body.name,
      email: req.body.email,
      password: hashedPassword,
    });

    const database = client.db("MixDB");
    // const users = database.collection("users");
    await client.connect();

    await database.collection("users").insertOne({
      id: Date.now().toString(),
      name: req.body.name,
      email: req.body.email,
      password: hashedPassword,
    });

    res.sendStatus(201);
  } catch (error) {
    console.log(error);
    res.send("not cool");
  }
});

var scopes = [
  "user-read-private",
  "user-read-email",
  "ugc-image-upload",
  "user-read-playback-state",
  "user-modify-playback-state",
  "user-follow-modify",
  "user-follow-read",
  "user-library-modify",
  "user-library-read",
  "streaming",
  "user-read-playback-position",
  "playlist-modify-private",
  "playlist-read-collaborative",
  "app-remote-control",
  "playlist-read-private",
  "user-top-read",
  "playlist-modify-public",
  "user-read-currently-playing",
  "user-read-recently-played",
];

var spotifyApi = new SpotifyWebApi({
  clientId: env.SPOTIFY_ID,
  clientSecret: env.SPOTIFY_SECRET,
  redirectUri: "http://localhost:8000/home",
});

app.get("/", async (req, res) => {
  var authorizeURL = spotifyApi.createAuthorizeURL(
    scopes,
    "some-state-of-my-choice",
    false
  );
  res.redirect(authorizeURL);
});

app.get("/home", async (req, res) => {
  code = req.query["code"];

  spotifyApi.authorizationCodeGrant(code).then(
    function (data) {
      console.log(data.body["access_token"]);
      console.log(data.body);
      spotifyApi.setAccessToken(data.body["access_token"]);
      spotifyApi.setRefreshToken(data.body["refresh_token"]);
      res.redirect("http://localhost:8000/aboutme");
    },
    function (err) {
      console.log("Something went wrong!", err);
    }
  );
});

app.get("/aboutme", async (req, res) => {
  const database = client.db("MixDB");
  // const users = database.collection("users");
  await client.connect();

  spotifyApi
    .getMe()
    .then(
      async (data) => {
        spotify_account_email = data.body["email"];
        _x = await database
          .collection("users")
          .findOne({ email: spotify_account_email });
        if (_x == null) {
          res.send(
            JSON.stringify({
              email: data.body.email,
              display_name: data.body.display_name,
              profile_image: data.body.images[0].url,
            })
          );
        } else {
          res.sendStatus(400);
        }
      },
      function (err) {
        console.log(err);
      }
    )
    .catch((err) => console.log(err));
});

app.get("/logout", async (req, res) => {
  // REMOVE SESSION
  spotifyApi.resetAccessToken();
  spotifyApi.resetRefreshToken();
  res.redirect("/");
});

app.listen(port, () => {
  // MAKE INTO HTTPS
  console.log(`Mixserver at http://localhost:${port}`);
});
