async function registerServiceWorker() {
  const oldRegistrations = await navigator.serviceWorker.getRegistrations();
  for (const registration of oldRegistrations) {
    if (registration.installing.state === "installing") {
      return;
    }
  }

  const workerUrl =
    import.meta.env.MODE === "production"
      ? "/rails.sw.js"
      : "/dev-sw.js?dev-sw";

  await navigator.serviceWorker.register(workerUrl, {
    scope: "/",
    type: "module",
  });
}

async function boot({ bootMessage, bootProgress, bootConsoleOutput }) {
  bootConsoleOutput.textContent += "Booting...\n";
  if (!("serviceWorker" in navigator)) {
    console.error("Service Worker is not supported in this browser.");
    bootConsoleOutput.textContent =
      "Service Worker is not available in this browser\n";
    bootProgress.remove();
    return;
  }

  if (
    (navigator.userAgent.includes("Safari") &&
      !navigator.userAgent.includes("Chrome")) ||
    navigator.userAgent.includes("iPhone")
  ) {
    console.error("Rails on Wasm doesn't work in this browser yet.");
    bootConsoleOutput.textContent =
      "Sorry, Safari is not supported by Rails on Wasm yet :(\n(NOTE: all browsers on iOS are Safari-driven).\n";
    bootProgress.remove();
    return;
  }

  if (!navigator.serviceWorker.controller) {
    await registerServiceWorker();

    bootConsoleOutput.textContent +=
      "Waiting for Service Worker to activate...\n";
  } else {
    console.log("Service Worker already active.");
    bootConsoleOutput.textContent += "Service Worker already active.\n";
  }

  navigator.serviceWorker.addEventListener("message", function (event) {
    switch (event.data.type) {
      case "progress": {
        // bootMessage.textContent = event.data.step;
        bootConsoleOutput.textContent += event.data.step + "\n";
        bootProgress.value = event.data.value;
        break;
      }
      case "console": {
        bootConsoleOutput.textContent += event.data.message + "\n";
        break;
      }
      default: {
        console.log("Unknown message type:", event.data.type);
      }
    }
  });

  return await navigator.serviceWorker.ready;
}

async function init() {
  const bootMessage = document.getElementById("boot-message");
  const bootProgress = document.getElementById("boot-progress");
  const bootConsoleOutput = document.getElementById("boot-console-output");
  const registration = await boot({
    bootMessage,
    bootProgress,
    bootConsoleOutput,
  });
  if (!registration) {
    return;
  }
  // bootMessage.textContent = "Service Worker Ready";
  // bootProgress.value = 100;

  const launchButton = document.getElementById("launch-button");
  launchButton.disabled = false;
  launchButton.addEventListener("click", async function () {
    // Open in a new window
    window.open("/", "_self");
  });

  const rebootButton = document.getElementById("reboot-button");
  rebootButton.disabled = false;
  rebootButton.addEventListener("click", async function () {
    await registration.unregister();
    window.location.reload();
  });

  const reloadButton = document.getElementById("reload-button");
  reloadButton.disabled = false;
  reloadButton.addEventListener("click", async function () {
    bootConsoleOutput.textContent = "Reloading Rails...\n";
    registration.active.postMessage({ type: "reload-rails" });
  });

  const reloadDebugButton = document.getElementById("reload-debug-button");
  reloadDebugButton.disabled = false;
  reloadDebugButton.addEventListener("click", async function () {
    bootConsoleOutput.textContent = "Reloading Rails (w/ debug log level)...\n";
    registration.active.postMessage({ type: "reload-rails", debug: true });
  });

  const avoButton = document.getElementById("avo-button");
  avoButton.disabled = false;
  avoButton.addEventListener("click", async function () {
    // Open in a new window
    window.open("/avo", "_blank");
  });
}

init();
