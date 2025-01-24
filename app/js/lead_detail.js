document.addEventListener('DOMContentLoaded', () => {
    // Referencias a elementos del DOM
    const addCommunicationBtn = document.getElementById('addCommunicationBtn');
    const addFileBtn = document.getElementById('addFileBtn');
    const communicationModal = document.getElementById('communicationModal');
    const fileModal = document.getElementById('fileModal');
    const communicationForm = document.getElementById('communicationForm');
    const fileForm = document.getElementById('fileForm');
    const closeBtns = document.querySelectorAll('.close');

    // Obtener el ID del lead de la URL
    const urlParams = new URLSearchParams(window.location.search);
    const leadId = urlParams.get('id');

    // Funciones de utilidad
    function showModal(modal) {
        modal.style.display = 'block';
    }

    function hideModal(modal) {
        modal.style.display = 'none';
    }

    function showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    // Event Listeners para modales
    addCommunicationBtn?.addEventListener('click', () => showModal(communicationModal));
    addFileBtn?.addEventListener('click', () => showModal(fileModal));

    closeBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            hideModal(btn.closest('.modal'));
        });
    });

    // Cerrar modal al hacer clic fuera
    window.addEventListener('click', (e) => {
        if (e.target.classList.contains('modal')) {
            hideModal(e.target);
        }
    });

    // Manejar envío del formulario de comunicación
    communicationForm?.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const formData = new FormData(communicationForm);
        formData.append('leadId', leadId);

        try {
            const response = await fetch('php/add_communication.php', {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                showNotification('Comunicación registrada correctamente');
                hideModal(communicationModal);
                location.reload(); // Recargar para mostrar la nueva comunicación
            } else {
                throw new Error(data.message || 'Error al registrar la comunicación');
            }
        } catch (error) {
            console.error('Error:', error);
            showNotification(error.message, 'error');
        }
    });

    // Manejar envío del formulario de archivo
    fileForm?.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const formData = new FormData(fileForm);
        formData.append('leadId', leadId);

        try {
            const response = await fetch('php/upload_file.php', {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                showNotification('Archivo subido correctamente');
                hideModal(fileModal);
                location.reload(); // Recargar para mostrar el nuevo archivo
            } else {
                throw new Error(data.message || 'Error al subir el archivo');
            }
        } catch (error) {
            console.error('Error:', error);
            showNotification(error.message, 'error');
        }
    });

    // Manejar el botón de editar
    document.getElementById('editLeadBtn')?.addEventListener('click', () => {
        // Redirigir al CRM con el modal de edición abierto
        window.location.href = `crm_dashboard.html?edit=${leadId}`;
    });
});