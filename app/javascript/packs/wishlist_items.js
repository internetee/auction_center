document.addEventListener("ajax:error", function(event) {
    [xhr, status, error] = event.detail;

    let errorsBlock = document.getElementById('errors');
    let errorsList = document.getElementById('errors-list');

    xhr.forEach(function(element) {
        let listItem = document.createElement('li');
        listItem.innerHTML = element;
        errorsList.appendChild(listItem);
    });

    errorsBlock.classList.remove('hidden');
});

document.addEventListener("ajax:beforeSend", function(event) {
    let errorsBlock = document.getElementById('errors');
    let errorsList = document.getElementById('errors-list');

    errorsBlock.classList.add('hidden');

    while (errorsList.hasChildNodes()) {
        errorsList.removeChild(errorsList.firstChild);
    }
});
