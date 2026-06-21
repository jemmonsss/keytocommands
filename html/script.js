window.addEventListener("message", (event) => {
    console.log("📩 NUI Message received:", event.data);

    if (event.data.action === "openKeybindMenu") {
        console.log("✅ Opening Menu with data:", event.data);

        setTimeout(() => {
            const menu = document.getElementById("menu");
            const title = document.getElementById("menuTitle");

            if (!menu) {
                console.error("❌ Menu element (`#menu`) not found!");
                return;
            }
            if (!title) {
                console.error("❌ Title element (`#menuTitle`) not found!");
                return;
            }

            // ✅ Show menu before updating UI to prevent missing elements
            menu.style.display = "block";
            menu.style.visibility = "visible";
            menu.style.opacity = "1";

            // ✅ Apply UI Customizations from Config.UI
            title.innerText = event.data.menuTitle;
            menu.style.background = event.data.backgroundColor;

            document.querySelectorAll("button").forEach(button => {
                button.style.backgroundColor = event.data.buttonColor;
                button.addEventListener("mouseover", () => {
                    button.style.backgroundColor = event.data.hoverColor;
                });
                button.addEventListener("mouseout", () => {
                    button.style.backgroundColor = event.data.buttonColor;
                });
            });

            // ✅ Fetch keybinds and apply remove button colors
            refreshKeybinds(
                event.data.buttonColor, 
                event.data.hoverColor, 
                event.data.removeButtonColor, 
                event.data.removeHoverColor
            );

            console.log("✅ Menu should now be visible!");
            setNuiFocus(true);
        }, 500);
    }

    if (event.data.action === "closeMenu") {
        closeMenu();
    }
});

/* ✅ Function to Refresh Keybinds */
function refreshKeybinds(buttonColor, hoverColor, removeButtonColor, removeHoverColor) {
    fetch(`https://${GetParentResourceName()}/getKeybinds`, {
        method: "POST",
        headers: { "Content-Type": "application/json" }
    })
    .then(response => response.json())
    .then(data => {
        updateKeybindList(data.keybinds, buttonColor, hoverColor, removeButtonColor, removeHoverColor);
        console.log("🔄 Keybinds refreshed:", data.keybinds);
    })
    .catch(err => console.error("❌ Failed to refresh keybinds:", err));
}

/* ✅ Function to Update the Keybind List */
function updateKeybindList(keybinds, buttonColor, hoverColor, removeButtonColor, removeHoverColor) {
    const keybindList = document.getElementById("keybindList");
    if (!keybindList) {
        console.error("❌ Keybind list element not found!");
        return;
    }

    keybindList.innerHTML = "";

    keybinds.forEach(kb => {
        const li = document.createElement("li");
        li.className = "keybind";
        li.innerHTML = `
            ${kb.key} → ${kb.command} 
            <button class="remove-btn" data-key="${kb.key}">Remove</button>
        `;
        keybindList.appendChild(li);
    });

    // ✅ Apply Dynamic Button Colors to Remove Buttons
    document.querySelectorAll(".remove-btn").forEach(button => {
        button.style.backgroundColor = removeButtonColor;
        button.addEventListener("mouseover", () => {
            button.style.backgroundColor = removeHoverColor;
        });
        button.addEventListener("mouseout", () => {
            button.style.backgroundColor = removeButtonColor;
        });

        // ✅ Set Remove Key Event
        button.addEventListener("click", function () {
            removeKey(this.getAttribute("data-key"));
        });
    });
}

/* ✅ Function to Bind a New Key */
function bindKey() {
    const keyInput = document.getElementById("keyInput");
    const commandInput = document.getElementById("commandInput");

    if (!keyInput || !commandInput) {
        console.error("❌ Key input or command input not found!");
        return;
    }

    const key = keyInput.value.toUpperCase();
    const command = commandInput.value;

    if (!key || !command) {
        console.error("❌ Invalid Key or Command");
        return;
    }

    fetch(`https://${GetParentResourceName()}/bindKey`, {
        method: "POST",
        body: JSON.stringify({ key, command }),
        headers: { "Content-Type": "application/json" }
    }).then(() => {
        console.log(`✅ Keybind ${key} added`);
        refreshKeybinds();
    });
}

/* ✅ Function to Remove a Keybind */
function removeKey(key) {
    fetch(`https://${GetParentResourceName()}/removeKeybind`, {
        method: "POST",
        body: JSON.stringify({ key }),
        headers: { "Content-Type": "application/json" }
    }).then(() => {
        console.log(`❌ Keybind ${key} removed`);
        refreshKeybinds();
    });
}

/* ✅ Function to Close the Menu */
function closeMenu() {
    console.log("❌ Closing menu...");

    const menu = document.getElementById("menu");
    if (!menu) {
        console.error("❌ Menu element not found when closing!");
        return;
    }

    menu.style.visibility = "hidden";
    menu.style.opacity = "0";

    setTimeout(() => {
        menu.style.display = "none";
    }, 300);

    // ✅ Ensure mouse is properly released
    setNuiFocus(false);
}

/* ✅ Function to Set NUI Focus */
function setNuiFocus(state) {
    fetch(`https://${GetParentResourceName()}/setNuiFocus`, {
        method: "POST",
        body: JSON.stringify({ focus: state }),
        headers: { "Content-Type": "application/json" }
    }).catch(err => console.error("❌ setNuiFocus Error:", err));
}
