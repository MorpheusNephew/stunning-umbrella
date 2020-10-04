import Router from "@koa/router";

import { postsRouter } from "./posts-router";
import { usersRouter } from "./users-router";

export const router = new Router()
  .prefix("/api/v1")
  .use(postsRouter.routes())
  .use(usersRouter.routes());
