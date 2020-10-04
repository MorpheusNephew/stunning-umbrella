import Router from "@koa/router";

import { postsRouter } from "./posts-router";
import { usersRouter } from "./users-router";

export const router = new Router();

router.use(postsRouter.routes());
router.use(usersRouter.routes());
