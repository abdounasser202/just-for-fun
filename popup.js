/**
 * Normalize a user-entered URL to ensure it starts with "https://" and remove redundant prefixes.
 *
 * @param {string} userInput - The user-entered URL to be normalized.
 * @returns {string} The normalized URL with "https://" and without redundant prefixes.
 */
function normalizeURL(userInput) {
    // Remove any leading and trailing spaces
    userInput = userInput.trim();

    // Check if the input starts with "http://" or "https://"
    if (!/^https?:\/\//i.test(userInput)) {
        // If not, add "https://"
        userInput = "https://" + userInput;
    }

    // Remove "www." if it's at the beginning
    userInput = userInput.replace(/^https?:\/\/(www\.)?/i, "https://");

    return userInput;
}


function getInputURL(elementId) {
    const userURL = document.getElementById(elementId).value;
    return normalizeURL(userURL);
}

function updateMainContainer(text) {
    const mainMainContainer = document.getElementById('main');
    mainMainContainer.innerHTML = text;
}

function saveURLs() {
    let originURL = getInputURL("originURL");
    let redirectURL = getInputURL("redirectURL");

    // Retrieve existing data from storage
    chrome.storage.local.get({ urls: [] }, function (data) {
        // Create a new URL pair and add it to the existing array
        const urlPair = { from: originURL, to: redirectURL };
        data.urls.push(urlPair);

        // // Save the updated array back to storage
        chrome.storage.local.set({ urls: data.urls }, function () {
            updateMainContainer('<h3>URL Redirection saved successfully</h3>')
        });
    });
}

function getSavedURLs() {
    chrome.storage.local.get(null).then((result) => {
        console.log(result);
    });
}

function deleteURLs() {
    chrome.storage.local.clear()
    updateMainContainer('<h3>URLs deleted successfully</h3>')
}

document.getElementById('saveButton').addEventListener('click', saveURLs);
document.getElementById('getURLs').addEventListener('click', getSavedURLs);
document.getElementById('clearURLs').addEventListener('click', deleteURLs);
