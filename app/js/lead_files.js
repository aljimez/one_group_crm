// Funciones para manejar archivos
document.addEventListener('DOMContentLoaded', function() {
    const fileInput = document.querySelector('input[type="file"]');
    const fileList = document.querySelector('.file-list');
    const uploadForm = document.getElementById('uploadFileForm');
    const leadId = new URLSearchParams(window.location.search).get('id');

    // Cargar archivos existentes
    loadFiles();

    // Manejar subida de archivos
    if (uploadForm) {
        uploadForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const formData = new FormData(uploadForm);
            formData.append('leadId', leadId);

            try {
                const response = await fetch('php/upload_file.php', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();

                if (data.success) {
                    showNotification('Archivo subido correctamente', 'success');
                    loadFiles(); // Recargar lista de archivos
                    uploadForm.reset();
                } else {
                    throw new Error(data.error || 'Error al subir el archivo');
                }
            } catch (error) {
                console.error('Error:', error);
                showNotification(error.message, 'error');
            }
        });
    }

    async function loadFiles() {
        try {
            const response = await fetch(`php/get_lead_files.php?leadId=${leadId}`);
            const data = await response.json();

            if (data.success && fileList) {
                fileList.innerHTML = ''; // Limpiar lista actual

                data.files.forEach(file => {
                    const fileElement = createFileElement(file);
                    fileList.appendChild(fileElement);
                });
            }
        } catch (error) {
            console.error('Error al cargar archivos:', error);
            showNotification('Error al cargar los archivos', 'error');
        }
    }

    function createFileElement(file) {
        const div = document.createElement('div');
        div.className = 'file-item bg-white p-4 rounded-lg shadow flex justify-between items-center';
        
        // Determinar el ícono basado en el tipo de archivo
        let fileIcon = 'fa-file';
        if (file.file_type.includes('image')) fileIcon = 'fa-file-image';
        else if (file.file_type.includes('pdf')) fileIcon = 'fa-file-pdf';
        else if (file.file_type.includes('word')) fileIcon = 'fa-file-word';
        else if (file.file_type.includes('excel')) fileIcon = 'fa-file-excel';

        const uploadDate = new Date(file.upload_date).toLocaleDateString('es-ES');
        
        div.innerHTML = `
            <div class="flex items-center">
                <i class="fas ${fileIcon} text-gray-500 mr-3"></i>
                <div>
                    <a href="${file.file_path}" target="_blank" class="text-blue-600 hover:text-blue-800 font-medium">
                        ${file.original_name}
                    </a>
                    <p class="text-sm text-gray-500">
                        Subido por ${file.uploaded_by_name || 'Usuario'} el ${uploadDate}
                    </p>
                </div>
            </div>
            <div class="flex items-center">
                <button onclick="downloadFile('${file.file_path}', '${file.original_name}')" 
                        class="text-gray-600 hover:text-gray-800 mr-3"
                        title="Descargar">
                    <i class="fas fa-download"></i>
                </button>
                <button onclick="deleteFile(${file.id}, this)" 
                        class="text-red-600 hover:text-red-800"
                        title="Eliminar">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;

        return div;
    }
});

// Función para descargar archivo
function downloadFile(filePath, originalName) {
    const link = document.createElement('a');
    link.href = filePath;
    link.download = originalName;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

// Función para eliminar archivo
async function deleteFile(fileId, button) {
    if (!confirm('¿Está seguro de que desea eliminar este archivo?')) {
        return;
    }

    try {
        const response = await fetch('php/delete_file.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ fileId })
        });

        const data = await response.json();

        if (data.success) {
            const fileItem = button.closest('.file-item');
            fileItem.remove();
            showNotification('Archivo eliminado correctamente', 'success');
        } else {
            throw new Error(data.error || 'Error al eliminar el archivo');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification(error.message, 'error');
    }
}

// Función para mostrar notificaciones
function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `fixed bottom-4 right-4 px-6 py-3 rounded-lg text-white ${
        type === 'success' ? 'bg-green-500' : 'bg-red-500'
    }`;
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(() => {
        notification.remove();
    }, 3000);
}