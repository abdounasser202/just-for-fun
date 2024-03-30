// Validation to prevent negative values
document.querySelectorAll('input[type="number"]').forEach(function (input) {
    input.addEventListener('input', function () {
        if (this.value < 0) {
            this.value = 0;
        }
    });
});
