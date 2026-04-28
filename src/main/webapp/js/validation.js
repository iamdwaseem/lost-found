document.addEventListener('DOMContentLoaded', () => {
  // Utility function to show error
  const showError = (inputElement, message) => {
    const formGroup = inputElement.closest('.form-group') || inputElement.closest('.file-upload-wrapper').parentElement;
    let errorElement = formGroup.querySelector('.error-message');
    
    if (!errorElement) {
      errorElement = document.createElement('div');
      errorElement.className = 'error-message';
      formGroup.appendChild(errorElement);
    }
    
    errorElement.textContent = message;
    errorElement.style.display = 'block';
    inputElement.classList.add('is-invalid');
  };

  // Utility function to clear error
  const clearError = (inputElement) => {
    const formGroup = inputElement.closest('.form-group') || inputElement.closest('.file-upload-wrapper').parentElement;
    const errorElement = formGroup.querySelector('.error-message');
    
    if (errorElement) {
      errorElement.style.display = 'none';
    }
    inputElement.classList.remove('is-invalid');
  };

  // Clear error on input change
  const inputs = document.querySelectorAll('input, select, textarea');
  inputs.forEach(input => {
    input.addEventListener('input', () => clearError(input));
    input.addEventListener('change', () => clearError(input));
  });

  // Login Form Validation
  const loginForm = document.getElementById('loginForm');
  if (loginForm) {
    loginForm.addEventListener('submit', (e) => {
      let isValid = true;
      const email = document.getElementById('email');
      const password = document.getElementById('password');

      if (!email.value.trim() || !/^\S+@\S+\.\S+$/.test(email.value)) {
        showError(email, 'Please enter a valid email address.');
        isValid = false;
      }

      if (!password.value.trim()) {
        showError(password, 'Password is required.');
        isValid = false;
      }

      if (!isValid) e.preventDefault();
    });
  }

  // Registration Form Validation
  const registerForm = document.getElementById('registerForm');
  if (registerForm) {
    registerForm.addEventListener('submit', (e) => {
      let isValid = true;
      const name = document.getElementById('name');
      const email = document.getElementById('email');
      const password = document.getElementById('password');
      const confirmPassword = document.getElementById('confirmPassword');

      if (!name.value.trim()) {
        showError(name, 'Full name is required.');
        isValid = false;
      }

      if (!email.value.trim() || !/^\S+@\S+\.\S+$/.test(email.value)) {
        showError(email, 'Please enter a valid email address.');
        isValid = false;
      }

      if (password.value.length < 6) {
        showError(password, 'Password must be at least 6 characters.');
        isValid = false;
      }

      if (password.value !== confirmPassword.value) {
        showError(confirmPassword, 'Passwords do not match.');
        isValid = false;
      }

      if (!isValid) e.preventDefault();
    });
  }

  // Submission Form Validation
  const submitForm = document.getElementById('submitForm');
  if (submitForm) {
    const fileInput = document.getElementById('imageFile');
    const fileNameDisplay = document.getElementById('fileName');

    // Update file name display when file is selected
    if (fileInput) {
      fileInput.addEventListener('change', function() {
        if (this.files && this.files.length > 0) {
          fileNameDisplay.textContent = `Selected: ${this.files[0].name}`;
        } else {
          fileNameDisplay.textContent = '';
        }
      });
    }

    submitForm.addEventListener('submit', (e) => {
      let isValid = true;
      
      const itemName = document.getElementById('itemName');
      const type = document.getElementById('type');
      const date = document.getElementById('date');
      const location = document.getElementById('location');
      const description = document.getElementById('description');

      if (!itemName.value.trim()) {
        showError(itemName, 'Item name is required.');
        isValid = false;
      }

      if (!type.value) {
        showError(type, 'Please select Lost or Found.');
        isValid = false;
      }

      if (!date.value) {
        showError(date, 'Please select a date.');
        isValid = false;
      }

      if (!location.value.trim()) {
        showError(location, 'Location is required.');
        isValid = false;
      }

      if (!description.value.trim()) {
        showError(description, 'Description is required.');
        isValid = false;
      }

      // File validation
      if (fileInput.files.length === 0) {
        showError(fileInput, 'Please upload an image.');
        isValid = false;
      } else {
        const file = fileInput.files[0];
        const validTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/gif'];
        if (!validTypes.includes(file.type)) {
          showError(fileInput, 'Only image files (JPEG, PNG, GIF) are allowed.');
          isValid = false;
        }
      }

      if (!isValid) e.preventDefault();
    });
  }
});
