document.addEventListener('DOMContentLoaded', () => {
    console.log('Lex | Next Level Development loaded.');

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });

    // Optional: Add dynamic glitch effect trigger here if needed

    // Login Logic
    const lotrTrigger = document.getElementById('LOTR');
    const adminModal = document.getElementById('adminModal');
    const closeModal = document.querySelector('.close-modal');
    const adminForm = document.getElementById('adminForm');

    if (lotrTrigger && adminModal) {
        // Open modal on trigger click
        lotrTrigger.addEventListener('click', () => {
            adminModal.classList.add('visible');
            document.getElementById('username').focus();
        });

        // Close modal on close button click
        closeModal.addEventListener('click', () => {
            adminModal.classList.remove('visible');
        });

        // Close modal on outside click
        window.addEventListener('click', (e) => {
            if (e.target === adminModal) {
                adminModal.classList.remove('visible');
            }
        });

        // Handle form submission
        adminForm.addEventListener('submit', (e) => {
            e.preventDefault();
            // Simple Client-Side "Auth" (Security through Obscurity per user request)
            const user = document.getElementById('username').value;
            const pass = document.getElementById('password').value;

            if (user === 'Gandalf' && pass === 'Mellon') {
                window.location.href = 'http://files.real-x-dreams.com';
            } else {
                alert('Access Denied');
            }
        });
    }
});