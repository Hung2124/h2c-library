// H2C LIBRARY – Main JavaScript

// Auto-dismiss alerts after 4 seconds
document.addEventListener('DOMContentLoaded', function () {
    const alerts = document.querySelectorAll('.alert.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            bsAlert.close();
        }, 4000);
    });

    // Star rating – clickable input
    document.querySelectorAll('.star-rating-input').forEach(function (container) {
        const hiddenInput = container.querySelector('input[type="hidden"][name="rating"]');
        const stars = container.querySelectorAll('i[data-value]');

        stars.forEach(function (star) {
            star.addEventListener('click', function () {
                const value = parseInt(this.getAttribute('data-value'), 10);
                hiddenInput.value = value;
                stars.forEach(function (s) {
                    const sVal = parseInt(s.getAttribute('data-value'), 10);
                    s.classList.toggle('filled', sVal <= value);
                });
            });

            star.addEventListener('mouseover', function () {
                const hoverVal = parseInt(this.getAttribute('data-value'), 10);
                stars.forEach(function (s) {
                    const sVal = parseInt(s.getAttribute('data-value'), 10);
                    if (!hiddenInput.value || sVal > parseInt(hiddenInput.value, 10)) {
                        s.classList.toggle('hovered', sVal <= hoverVal);
                    }
                });
            });

            star.addEventListener('mouseout', function () {
                stars.forEach(function (s) { s.classList.remove('hovered'); });
            });
        });
    });
});
