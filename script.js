const select = document.getElementById('tab-select');
const sections = document.querySelectorAll('main section');
select.addEventListener('change', () => {
  const selected = select.value;
  sections.forEach(section => {
    section.classList.toggle('active', section.id === selected);
  });
});

const fileInput = document.getElementById('product-image');
const previewContainer = document.getElementById('image-preview');
const previewImage = document.getElementById('preview-img');
if (fileInput) {
  fileInput.addEventListener('change', () => {
    const file = fileInput.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = e => {
        previewImage.src = e.target.result;
        previewContainer.style.display = 'block';
      };
      reader.readAsDataURL(file);
    } else {
      previewImage.src = '';
      previewContainer.style.display = 'none';
    }
  });
}

const sellForm = document.getElementById('sell-form');
if (sellForm) {
  sellForm.addEventListener('submit', e => {
    e.preventDefault();
    const productName = document.getElementById('product-name').value.trim();
    const productPrice = document.getElementById('product-price').value.trim();
    const productImageFile = fileInput.files[0];

    if (!productName || !productPrice || !productImageFile) {
      alert('Please fill all required fields and select an image.');
      return;
    }

    console.log('Product Name:', productName);
    console.log('Price:', productPrice);
    console.log('Image File:', productImageFile);

    alert('Product listed successfully! (Demo only)');

    e.target.reset();
    previewImage.src = '';
    previewContainer.style.display = 'none';
  });
}

document.querySelectorAll('.product-card .btn').forEach(btn => {
  btn.addEventListener('click', function() {
    const card = btn.closest('.product-card');
    const name = card.querySelector('.product-title').textContent.trim();
    const priceText = card.querySelector('.product-price').textContent.trim();
    const price = priceText.replace(/[R,\s]/g, '');

    select.value = 'payments';
    select.dispatchEvent(new Event('change'));

    document.getElementById('pf-item-name').value = name;
    document.getElementById('pf-amount').value = price;
    document.getElementById('ozow-reference').value = name;
    document.getElementById('ozow-amount').value = price;

    setTimeout(() => {
      document.getElementById('payments').scrollIntoView({behavior: 'smooth'});
    }, 200);
  });
});

const payfastContainer = document.getElementById('payfast-container');
const ozowContainer = document.getElementById('ozow-container');
document.querySelectorAll('input[name="payment-method"]').forEach(radio => {
  radio.addEventListener('change', function() {
    if (this.value === 'payfast') {
      payfastContainer.style.display = '';
      ozowContainer.style.display = 'none';
    } else {
      payfastContainer.style.display = 'none';
      ozowContainer.style.display = '';
    }
  });
});

function addDeliveryValidation(formId, hiddenInputId) {
  const form = document.getElementById(formId);
  if (!form) return;
  form.addEventListener('submit', function(e) {
    const delivery = document.getElementById('delivery-option').value;
    if (!delivery) {
      alert('Please select a delivery option before proceeding.');
      e.preventDefault();
      document.getElementById('delivery-option').focus();
    } else {
      document.getElementById(hiddenInputId).value = delivery;
    }
  });
}
addDeliveryValidation('payfast-form', 'payfast-delivery');
addDeliveryValidation('ozow-form', 'ozow-delivery');