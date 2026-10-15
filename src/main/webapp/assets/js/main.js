/**
 * Jobify Client-Side Interactive Logic
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Auto-dismiss flash alerts after 6 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (alert) {
        const closeBtn = alert.querySelector('.alert-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function () {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 250);
            });
        }
        setTimeout(function () {
            if (document.body.contains(alert)) {
                alert.style.transition = 'opacity 0.4s ease';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 400);
            }
        }, 6000);
    });

    // Mobile Navigation Toggle
    const navToggle = document.getElementById('nav-mobile-toggle');
    const navLinks = document.getElementById('nav-links-menu');
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', function () {
            navLinks.classList.toggle('mobile-open');
        });
    }

    // 2. Modal Helper Functions
    window.openModal = function (modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
    };

    window.closeModal = function (modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('active');
            document.body.style.overflow = '';
        }
    };

    // Close modal on click outside
    document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                overlay.classList.remove('active');
                document.body.style.overflow = '';
            }
        });
    });

    // 3. Client-Side Form Validation for Registration
    const registerForm = document.querySelector('form[action*="/register"]');
    if (registerForm) {
        registerForm.addEventListener('submit', function (e) {
            const pwd = registerForm.querySelector('input[name="password"]');
            const confirm = registerForm.querySelector('input[name="confirmPassword"]');
            if (pwd && confirm && pwd.value !== confirm.value) {
                e.preventDefault();
                alert('Passwords do not match. Please verify your password confirmation.');
                confirm.focus();
            }
        });
    }

    // 4. Job Posting Form: Validate Salary Range
    const jobForm = document.querySelector('form.job-form');
    if (jobForm) {
        jobForm.addEventListener('submit', function (e) {
            const minInput = jobForm.querySelector('input[name="salaryMin"]');
            const maxInput = jobForm.querySelector('input[name="salaryMax"]');
            if (minInput && maxInput) {
                const min = parseFloat(minInput.value) || 0;
                const max = parseFloat(maxInput.value) || 0;
                if (max > 0 && min > max) {
                    e.preventDefault();
                    alert('Maximum salary must be greater than or equal to minimum salary.');
                    maxInput.focus();
                }
            }
        });
    }
});
