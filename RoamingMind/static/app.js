document.addEventListener('DOMContentLoaded', () => {
  const form = document.querySelector('form');
  const resultsContainer = document.querySelector('#results');

  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const formData = new FormData(form);
    const requestData = JSON.stringify(Object.fromEntries(formData.entries()));

    // Ajouter la classe "skeleton-loading" à resultsContainer
    resultsContainer.classList.add('skeleton-loading');

    fetch('/recommend', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': requestData.csrf_token
      },
      body: requestData
    })
      .then(response => response.json())
      .then(data => {
        // Supprimer la classe "skeleton-loading" de resultsContainer
        resultsContainer.classList.remove('skeleton-loading');

        const results = data;
        console.log(results)
        resultsContainer.innerHTML = '';
        results.forEach(result => {
          const p = document.createElement('p');
          p.textContent = result;
          resultsContainer.appendChild(p);
        });
      })
      .catch(error => console.error(error));
  });
});




//const feedbackBtn = document.querySelector('#feedback-btn');
//feedbackBtn.addEventListener('click', (event) => {
//  event.preventDefault();
//  const feedback = prompt('Entrez votre feedback:');
//  fetch('/feedback', {
//    method: 'POST',
//    headers: {
//      'Content-Type': 'application/json',
//    },
//    body: JSON.stringify({ feedback })
//  })
//    .then(response => {
//      if (response.ok) {
//        alert('Feedback envoyé avec succès!');
//      } else {
//        alert('Une erreur est survenue lors de l\'envoi du feedback.');
//      }
//    })
//    .catch(error => console.error(error));
//});

