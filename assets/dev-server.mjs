import { spawn } from "node:child_process";
import net from "node:net";
import path from "node:path";
import { fileURLToPath } from "node:url";

const host = process.env.VITE_HOST || "127.0.0.1";
const port = Number(process.env.VITE_PORT || 5173);
const cwd = path.dirname(fileURLToPath(import.meta.url));

function isPortOpen(hostname, portNumber) {
  return new Promise((resolve) => {
    const socket = net.connect({ host: hostname, port: portNumber }, () => {
      socket.end();
      resolve(true);
    });

    socket.on("error", () => resolve(false));
  });
}

const alreadyRunning = await isPortOpen(host, port);

if (alreadyRunning) {
  process.stdout.write(`Vite dev server already running at http://${host}:${port}\n`);
  setInterval(() => {}, 1 << 30);
} else {
  const child = spawn(
    process.platform === "win32" ? "npm.cmd" : "npm",
    ["run", "dev", "--", "--host", host, "--port", String(port)],
    {
      cwd,
      stdio: "inherit",
      env: process.env,
    }
  );

  child.on("exit", (code, signal) => {
    if (signal) {
      process.kill(process.pid, signal);
    } else {
      process.exit(code ?? 0);
    }
  });
}
