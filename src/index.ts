import Fastify from "fastify";

const app = Fastify({ logger: true });

app.get("/", async (request, reply) => {
  return { message: "Hello Fastify + TypeScript!" };
});

const start = async () => {
  try {
    await app.listen({ port: 3000 });
    console.log("Server listening on http://localhost:3000");
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();
