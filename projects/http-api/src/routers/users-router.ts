import Router from "@koa/router";

export const usersRouter = new Router()
  .prefix("/users")
  .get("All users", "/", async (ctx) => {
    ctx.body = "Getting all users";
    ctx.status = 200;
  })
  .get("User by id", "/:user_id", async (ctx) => {
    const userId = ctx.params["user_id"];

    ctx.body = `Getting user '${userId}'`;
    ctx.status = 200;
  });
