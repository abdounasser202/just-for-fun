let openedURL = null;

chrome.runtime.onInstalled.addListener(() => {

    function handleWebRequest(details) {
        const requestedUrl = details.initiator;

        // Retrieve data from storage
        chrome.storage.local.get(null).then((result) => {
            if (result.urls) {
                const matchingPair = result.urls.find((pair) => pair.from === requestedUrl);
                if (matchingPair) {
                    const redirectUrl = matchingPair.to;

                    // Redirect the user to the specified URL
                    chrome.tabs.update(details.tabId, { url: redirectUrl }, () => {
                        openedURL = redirectUrl;

                        // Remove the listener to stop further redirections
                        if (openedURL) {
                            chrome.webRequest.onBeforeRequest.removeListener(handleWebRequest);
                        }
                    });
                }
            }
            
        });
    }

    // Add the web request listener
    chrome.webRequest.onBeforeRequest.addListener(handleWebRequest, { urls: ["<all_urls>"] });
});


//  Reactivate extension
chrome.tabs.onCreated.addListener((tab) => {
    if (tab.active) {
        openedURL = null
        chrome.runtime.reload()
    }
});

