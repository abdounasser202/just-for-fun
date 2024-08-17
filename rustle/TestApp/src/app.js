
const { invoke } = window.__TAURI__.tauri;

const { getTauriVersion, getVersion } = window.__TAURI__.app;


let greetInputEl;
let greetMsgEl;

async function greet() {
    // Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
    greetMsgEl.textContent = await invoke("greet", { name: greetInputEl.value });
}

window.addEventListener("DOMContentLoaded", () => {
    greetInputEl = document.querySelector("#greet-input");
    greetMsgEl = document.querySelector("#greet-msg");
    document.querySelector("#greet-form").addEventListener("submit", (e) => {
        e.preventDefault();
        greet();
    });
});



async function initDB() {

    try {
        await invoke('create_db');
        console.log('DB created successfully');
    } catch (error) {
        console.error('Error creating user:', error);
    }

}

const buttonInit = document.getElementById('init');
buttonInit.onclick = () => {
    initDB()
};


async function queryUsers() {

    try {
        const users = await invoke('query_users');
        users.then(result => {
            console.log(result);
        })
    } catch (error) {
        console.error('Error creating user:', error);
    }

}


const buttonQuery = document.getElementById('query');
buttonQuery.onclick = () => {
    console.log('queryUsers!');
    queryUsers()
};


async function getAppInfos() {
    console.log("owl version: ", owl.__info__.version);
    console.log("water.css version: ", "2.1.1");

    getTauriVersion().then(tauriVersion => {
        console.log("tauri version: ", tauriVersion);
    })

    getVersion().then(version => {
        console.log("TestApp version: ", version);
    })

}

const buttonHelp = document.getElementById('help');
buttonHelp.onclick = () => {
    getAppInfos()
};



