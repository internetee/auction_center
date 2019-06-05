function createListItem(string, document) {
    const listItem = document.createElement('li');
    listItem.innerHTML = string;
    return listItem;
};

function onlyUnique(value, index, self) {
    return self.indexOf(value) === index;
}

document.addEventListener('ajax:error', (event) => {
    const xhr = event.detail[0];

    const errorsBlock = document.getElementById('errors');
    const errorsList = document.getElementById('errors-list');

    const uniqueMessages = xhr.filter(onlyUnique);

    uniqueMessages.forEach(function(message) {
        const listItem = createListItem(message, document);
        errorsList.appendChild(listItem);
    });

    errorsBlock.classList.remove('hidden');
});

document.addEventListener('ajax:beforeSend', (event) => {
    const errorsBlock = document.getElementById('errors');
    const errorsList = document.getElementById('errors-list');

    errorsBlock.classList.add('hidden');
    const duplicate = errorsList.cloneNode();
    errorsList.replaceWith(duplicate);
});
