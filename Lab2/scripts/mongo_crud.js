use("streaming_lab");

db.content.find({ director: "Christopher Nolan" });

db.users.updateOne(
  { _id: "USR002" },
  { $set: { plan: "premium" } }
);

db.users.find({ plan: "premium" });

db.content.find(
  { actors: "Leonardo DiCaprio" },
  { _id: 1, title: 1, director: 1 }
);
