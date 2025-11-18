document.addEventListener('DOMContentLoaded', function() {
  const fileInput = document.getElementById('cnab_file_file');
  const fileLabel = document.querySelector('.file-label');

  if (!fileInput || !fileLabel) return;
  
  const fileText = fileLabel.querySelector('.file-text');

  // Drag and drop
  fileLabel.addEventListener('dragover', function(e) {
    e.preventDefault();
    fileLabel.style.borderColor = '#667eea';
    fileLabel.style.background = '#e2e8f0';
  });

  fileLabel.addEventListener('dragleave', function(e) {
    e.preventDefault();
    fileLabel.style.borderColor = '#cbd5e0';
    fileLabel.style.background = '#f7fafc';
  });

  fileLabel.addEventListener('drop', function(e) {
    e.preventDefault();
    fileLabel.style.borderColor = '#cbd5e0';
    fileLabel.style.background = '#f7fafc';

    const files = e.dataTransfer.files;
    if (files.length > 0) {
      fileInput.files = files;
      updateFileLabel(files[0].name);
    }
  });

  // Quando seleciona arquivo via input
  fileInput.addEventListener('change', function(e) {
    if (e.target.files.length > 0) {
      updateFileLabel(e.target.files[0].name);
    }
  });

  function updateFileLabel(fileName) {
    fileText.textContent = `Arquivo selecionado: ${fileName}`;
    fileLabel.style.borderColor = '#48bb78';
    fileLabel.style.background = '#f0fff4';
  }
});

