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
  },
  {
    _id: "USR004",
    name: "Dmitry Volkov",
    plan: "basic",
    favoriteGenres: ["Sci-Fi", "Action"],
    country: "RU"
  },
  {
    _id: "USR005",
    name: "Elena Orlova",
    plan: "premium",
    favoriteGenres: ["Drama", "Romance"],
    country: "BY"
  },
  {
    _id: "USR006",
    name: "Nikita Egorov",
    plan: "standard",
    favoriteGenres: ["Crime", "Thriller"],
    country: "RU"
  },
  {
    _id: "USR007",
    name: "Sofia Melnik",
    plan: "premium",
    favoriteGenres: ["Biography", "Drama"],
    country: "KZ"
  },
  {
    _id: "USR008",
    name: "Artem Lebedev",
    plan: "basic",
    favoriteGenres: ["Adventure", "Action"],
    country: "RU"
  },
  {
    _id: "USR009",
    name: "Olga Romanova",
    plan: "standard",
    favoriteGenres: ["Sci-Fi", "Mystery"],
    country: "RU"
  },
  {
    _id: "USR010",
    name: "Kirill Fedorov",
    plan: "premium",
    favoriteGenres: ["Crime", "Drama"],
    country: "AM"
  },
  {
    _id: "USR011",
    name: "Polina Morozova",
    plan: "standard",
    favoriteGenres: ["Romance", "Drama"],
    country: "RU"
  },
  {
    _id: "USR012",
    name: "Ilya Zaitsev",
    plan: "basic",
    favoriteGenres: ["Action", "Sci-Fi"],
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
  },
  {
    _id: "MOV007",
    title: "Oppenheimer",
    year: 2023,
    genres: ["Biography", "Drama"],
    director: "Christopher Nolan",
    actors: ["Cillian Murphy", "Emily Blunt"]
  },
  {
    _id: "MOV008",
    title: "The Wolf of Wall Street",
    year: 2013,
    genres: ["Biography", "Crime"],
    director: "Martin Scorsese",
    actors: ["Leonardo DiCaprio", "Margot Robbie"]
  },
  {
    _id: "MOV009",
    title: "The Departed",
    year: 2006,
    genres: ["Crime", "Thriller"],
    director: "Martin Scorsese",
    actors: ["Leonardo DiCaprio", "Matt Damon"]
  },
  {
    _id: "MOV010",
    title: "Vanilla Sky",
    year: 2001,
    genres: ["Drama", "Mystery"],
    director: "Cameron Crowe",
    actors: ["Tom Cruise", "Penelope Cruz"]
  },
  {
    _id: "MOV011",
    title: "Almost Famous",
    year: 2000,
    genres: ["Drama", "Comedy"],
    director: "Cameron Crowe",
    actors: ["Billy Crudup", "Kate Hudson"]
  },
  {
    _id: "MOV012",
    title: "Mystic River",
    year: 2003,
    genres: ["Crime", "Drama"],
    director: "Clint Eastwood",
    actors: ["Sean Penn", "Tim Robbins"]
  },
  {
    _id: "MOV013",
    title: "The Dark Knight",
    year: 2008,
    genres: ["Action", "Crime"],
    director: "Christopher Nolan",
    actors: ["Christian Bale", "Heath Ledger"]
  },
  {
    _id: "MOV014",
    title: "Shutter Island",
    year: 2010,
    genres: ["Thriller", "Mystery"],
    director: "Martin Scorsese",
    actors: ["Leonardo DiCaprio", "Mark Ruffalo"]
  },
  {
    _id: "MOV015",
    title: "Avatar",
    year: 2009,
    genres: ["Sci-Fi", "Adventure"],
    director: "James Cameron",
    actors: ["Sam Worthington", "Zoe Saldana"]
  }
]);
