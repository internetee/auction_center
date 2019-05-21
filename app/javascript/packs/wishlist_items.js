function createListItem(string, document) {
    let listItem = document.createElement('li');
    listItem.innerHTML = string;
    return listItem;
};

function onlyUnique(value, index, self) {
    return self.indexOf(value) === index;
}

document.addEventListener("ajax:error", (event) => {
    let xhr, status, error;
    [xhr, status, error] = event.detail;

    let errorsBlock = document.getElementById('errors');
    let errorsList = document.getElementById('errors-list');

    let uniqueMessages = xhr.filter(onlyUnique);

    uniqueMessages.forEach(function(message) {
        let listItem = createListItem(message, document);
        errorsList.appendChild(listItem);
    });

    errorsBlock.classList.remove('hidden');
});

document.addEventListener("ajax:beforeSend", (event) => {
    let errorsBlock = document.getElementById('errors');
    let errorsList = document.getElementById('errors-list');

    errorsBlock.classList.add('hidden');
    let duplicate = errorsList.cloneNode();
    errorsList.replaceWith(duplicate);
});
