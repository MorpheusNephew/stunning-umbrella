import Router from "@koa/router";

export const postsRouter = new Router()
  .prefix("/posts")
  .get("All posts", "/", async (ctx) => {
    ctx.body = "Getting all posts";
    ctx.status = 200;
  })
  .get("Post by id", "/:post_id", async (ctx) => {
    const postId = ctx.params["post_id"];

    ctx.body = `Getting post '${postId}'`;
    ctx.status = 200;
  });
