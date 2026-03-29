use("streaming_lab");

db.users.drop();
db.content.drop();

db.users.insertMany([
  {
    _id: "USR001",
    name: "Anna Petrova",
    plan: "premium",
    favoriteGenres: ["Sci-Fi", "Drama"],
    country: "RU"
  },
  {
    _id: "USR002",
    name: "Ivan Smirnov",
    plan: "standard",
    favoriteGenres: ["Thriller", "Action"],
    country: "RU"
  },
  {
    _id: "USR003",
    name: "Maria Sokolova",
    plan: "premium",
    favoriteGenres: ["Biography", "Adventure"],
    country: "KZ"
  }
]);

db.content.insertMany([
  {
    _id: "MOV001",
    title: "Inception",
    year: 2010,
    genres: ["Sci-Fi", "Thriller"],
    director: "Christopher Nolan",
    actors: ["Leonardo DiCaprio", "Joseph Gordon-Levitt"]
  },
  {
    _id: "MOV004",
    title: "Interstellar",
    year: 2014,
    genres: ["Sci-Fi", "Drama"],
    director: "Christopher Nolan",
    actors: ["Matthew McConaughey", "Anne Hathaway"]
  },
  {
    _id: "MOV006",
    title: "Titanic",
    year: 1997,
    genres: ["Drama", "Romance"],
    director: "James Cameron",
    actors: ["Leonardo DiCaprio", "Kate Winslet"]
  }
]);
