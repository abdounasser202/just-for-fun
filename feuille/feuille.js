const feuille = document.getElementById('feuille')

function parseHTML(html) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    return doc.body.innerHTML;
}

function makeToBold() {
    const div = document.createElement("div")
    div.contentEditable = true;
    div.id = "divBold";
    div.style = "border: 0.5px solid grey"
    feuille.appendChild(div);

    const bold = document.createElement("b");
    div.appendChild(bold);
    bold.focus();

    
}

// function getSelectedText() {
//     const textarea = document.getElementById('feuille')
//     let selectedText = {};
//     let result = {};

//     console.log(textarea.selectionStart);

//     if (textarea.selectionStart !== undefined) {
//         const startPosition = textarea.selectionStart;
//         const endPosition = textarea.selectionEnd

//         selectedText.value = textarea.value.substring(startPosition, endPosition)

//         selectedText.start = startPosition;
//         selectedText.end = endPosition

//         result.text = selectedText;
//         result.element = textarea

//     };

//     return result

// }

// const feuille = document.getElementById('feuille')

// function makeToBold(value) {
//     let newValue = `<b>${value}</b>`
//     return parseHTML(newValue)
// }

// function getSelectedText() {
    
//     const selection = window.getSelection()
//     let  selectedText;

//     if (feuille.contains(selection.anchorNode) && feuille.contains(selection.focusNode)) {
//         selectedText = makeToBold(selection.toString());
//     }

//     console.log(selectedText);
    
//     // makeToBold(selectedText)
//     return selectedText

// }




// function makeToBold() {
//     let selectedText = getSelectedText()
//     console.log(selectedText);
//     let newValue = `<b>${selectedText.text.value}</b>`
//     const originalText = selectedText.element.value
//     const newText = `${originalText.substring(0, selectedText.text.start)} ${newValue} ${originalText.substring(selectedText.text.end)}`
//     content = document.getElementById('feuille')
//     content.innerHTML = parseHTML(newText)
//     selectedText.element.value = parseHTML(newText)
// }
