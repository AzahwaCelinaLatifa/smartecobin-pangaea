import type { Express } from "express";
import { storage } from "./storage";
import { sensorRouter } from "./routes/sensor";
import { notificationsRouter } from "./routes/notifications";
import { authRouter } from "./routes/auth";
import { binsRouter } from "./routes/bins";
import { actionsRouter } from "./routes/actions";
import { healthRouter } from "./routes/health";

export function registerRoutes(app: Express): void {
  // Smart Trash Bin Routes
  app.use("/api/sensor", sensorRouter);
  app.use("/api/notifications", notificationsRouter);
  app.use("/api/auth", authRouter);
  app.use("/api/bins", binsRouter);
  app.use("/api/actions", actionsRouter);
  app.use("/api/health", healthRouter);

  // In serverless, we don't create or return a Node http server here.
  // The caller can create a server in non-serverless environments.
}
