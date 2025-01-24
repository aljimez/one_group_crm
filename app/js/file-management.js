document.addEventListener('DOMContentLoaded', function() {
    // Referencias DOM
    const filesList = document.querySelector('.files-list');
    const fileModal = document.getElementById('fileModal');
    const uploadButton = document.getElementById('uploadFileButton');
    const fileForm = document.getElementById('fileForm');
    
    // Obtener ID del lead de la URL
    const urlParams = new URLSearchParams(window.location.search);
    const leadId = urlParams.get('id');

    // Inicialización
    loadFiles();

    // Event Listeners
    if (uploadButton) {
        uploadButton.addEventListener('click', openFileModal);
    }

    // Event listener para cerrar el modal al hacer clic fuera
    window.addEventListener('click', function(event) {
        if (event.target === fileModal) {
            closeFileModal();
        }
    });

    // Manejar envío del formulario de archivo
    if (fileForm) {
        fileForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const fileInput = this.querySelector('input[type="file"]');
            
            if (!fileInput.files.length) {
                showNotification('Por favor selecciona un archivo', 'error');
                return;
            }

            formData.append('leadId', leadId);

            try {
                showLoader();
                const response = await fetch('php/upload_file.php', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();

                if (data.success) {
                    showNotification('Archivo subido correctamente', 'success');
                    closeFileModal();
                    this.reset();
                    await loadFiles();
                } else {
                    throw new Error(data.error || 'Error al subir el archivo');
                }
            } catch (error) {
                console.error('Error:', error);
                showNotification(error.message, 'error');
            } finally {
                hideLoader();
            }
        });
    }

    // Cargar lista de archivos
    async function loadFiles() {
        try {
            showLoader();
            const response = await fetch(`php/get_lead_files.php?leadId=${leadId}`);
            const data = await response.json();

            if (data.success && filesList) {
                filesList.innerHTML = '';
                if (data.files.length === 0) {
                    filesList.innerHTML = '<p class="text-gray-500 text-center py-4">No hay archivos subidos</p>';
                } else {
                    data.files.forEach(file => {
                        const fileElement = createFileElement(file);
                        filesList.appendChild(fileElement);
                    });
                }
            }
        } catch (error) {
            console.error('Error al cargar archivos:', error);
            showNotification('Error al cargar los archivos', 'error');
        } finally {
            hideLoader();
        }
    }

    // Crear elemento de archivo
    function createFileElement(file) {
        const div = document.createElement('div');
        div.className = 'flex items-center justify-between p-4 bg-white rounded-lg shadow mb-2';
        
        let fileIcon = 'fa-file';
        if (file.file_type?.includes('image')) fileIcon = 'fa-file-image';
        else if (file.file_type?.includes('pdf')) fileIcon = 'fa-file-pdf';
        else if (file.file_type?.includes('word')) fileIcon = 'fa-file-word';
        else if (file.file_type?.includes('excel')) fileIcon = 'fa-file-excel';

        const uploadDate = new Date(file.upload_date).toLocaleDateString('es-ES', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
        
        div.innerHTML = `
            <div class="flex items-center flex-1">
                <i class="fas ${fileIcon} text-gray-500 text-xl mr-3"></i>
                <div class="flex-1">
                    <a href="${file.file_path}" target="_blank" class="text-blue-600 hover:text-blue-800 font-medium">
                        ${file.original_name}
                    </a>
                    <p class="text-sm text-gray-500">
                        Subido por ${file.uploaded_by_name || 'Usuario'} el ${uploadDate}
                    </p>
                </div>
            </div>
            <div class="flex items-center space-x-2">
                <button onclick="downloadFile('${file.file_path}', '${file.original_name}')" 
                        class="text-gray-600 hover:text-gray-800 p-2"
                        title="Descargar">
                    <i class="fas fa-download"></i>
                </button>
                <button onclick="deleteFile(${file.id})" 
                        class="text-red-600 hover:text-red-800 p-2"
                        title="Eliminar">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;

        return div;
    }
});

// Funciones globales
window.openFileModal = function() {
    const fileModal = document.getElementById('fileModal');
    if (fileModal) {
        fileModal.style.display = 'block';
    }
};

window.closeFileModal = function() {
    const fileModal = document.getElementById('fileModal');
    if (fileModal) {
        fileModal.style.display = 'none';
        const form = fileModal.querySelector('form');
        if (form) form.reset();
    }
};

window.downloadFile = function(filePath, originalName) {
    const link = document.createElement('a');
    link.href = filePath;
    link.download = originalName;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
};

window.deleteFile = async function(fileId) {
    if (!confirm('¿Está seguro de que desea eliminar este archivo?')) {
        return;
    }

    try {
        showLoader();
        const response = await fetch('php/delete_file.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ fileId })
        });

        const data = await response.json();

        if (data.success) {
            showNotification('Archivo eliminado correctamente', 'success');
            const filesList = document.querySelector('.files-list');
            if (filesList) {
                const fileElement = document.querySelector(`[data-file-id="${fileId}"]`);
                if (fileElement) {
                    fileElement.remove();
                }
                // Si no quedan archivos, mostrar mensaje
                if (filesList.children.length === 0) {
                    filesList.innerHTML = '<p class="text-gray-500 text-center py-4">No hay archivos subidos</p>';
                }
            }
        } else {
            throw new Error(data.error || 'Error al eliminar el archivo');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification(error.message, 'error');
    } finally {
        hideLoader();
    }
};

// Funciones de utilidad
function showLoader() {
    const loader = document.getElementById('loader');
    if (loader) loader.style.display = 'flex';
}

function hideLoader() {
    const loader = document.getElementById('loader');
    if (loader) loader.style.display = 'none';
}

function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `fixed bottom-4 right-4 px-6 py-3 rounded-lg text-white ${
type === 'success' ? 'bg-green-500' : 'bg-red-500'
    }`;
    notification.textContent = message;
    notification.style.zIndex = '9999';

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.opacity = '0';
        notification.style.transition = 'opacity 0.5s ease';
        setTimeout(() => {
            notification.remove();
        }, 500);
    }, 3000);
}

// Función para manejar errores
function handleError(error) {
    console.error('Error:', error);
    showNotification(
        error.message || 'Ha ocurrido un error inesperado',
        'error'
    );
}

// Función para formatear el tamaño del archivo
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

// Función para validar el archivo antes de subirlo
function validateFile(file) {
    // Tamaño máximo (5MB)
    const maxSize = 5 * 1024 * 1024;
    if (file.size > maxSize) {
        throw new Error('El archivo no debe superar los 5MB');
    }

    // Extensiones permitidas
    const allowedExtensions = [
        'pdf', 'doc', 'docx', 'xls', 'xlsx', 
        'jpg', 'jpeg', 'png', 'gif', 'txt'
    ];
    const extension = file.name.split('.').pop().toLowerCase();
    if (!allowedExtensions.includes(extension)) {
        throw new Error('Tipo de archivo no permitido');
    }

    return true;
}

// Función para sanitizar el nombre del archivo
function sanitizeFileName(fileName) {
    // Eliminar caracteres especiales y espacios
    return fileName
        .replace(/[^a-z0-9.]/gi, '_')
        .toLowerCase();
}

// Función para obtener el tipo de icono según la extensión
function getFileIcon(fileType) {
    const icons = {
        'application/pdf': 'fa-file-pdf',
        'application/msword': 'fa-file-word',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'fa-file-word',
        'application/vnd.ms-excel': 'fa-file-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'fa-file-excel',
        'image/jpeg': 'fa-file-image',
        'image/png': 'fa-file-image',
        'image/gif': 'fa-file-image',
        'text/plain': 'fa-file-text'
    };

    return icons[fileType] || 'fa-file';
}

// Validación de tipos MIME
const MIME_TYPES = {
    'application/pdf': ['.pdf'],
    'application/msword': ['.doc'],
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document': ['.docx'],
    'application/vnd.ms-excel': ['.xls'],
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ['.xlsx'],
    'image/jpeg': ['.jpg', '.jpeg'],
    'image/png': ['.png'],
    'image/gif': ['.gif'],
    'text/plain': ['.txt']
};

// Prevenir arrastrar y soltar archivos fuera de la zona designada
document.addEventListener('dragover', function(e) {
    e.preventDefault();
    e.stopPropagation();
});

document.addEventListener('drop', function(e) {
    e.preventDefault();
    e.stopPropagation();
});