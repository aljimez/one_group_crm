<?php
session_start();
require_once 'php/config.php';
require_once 'php/lead_operations.php';
require_once 'php/utils.php';

// Verificación de acceso
if (!isset($_SESSION['user_id'])) {
    header('Location: login.html');
    exit;
}

$leadId = isset($_GET['id']) ? (int)$_GET['id'] : 0;

// Obtener información del lead
try {
    $stmt = $pdo->prepare("
        SELECT l.*, s.name as stage_name, u.name as assigned_to 
        FROM leads l
        LEFT JOIN lead_stages s ON l.stage_id = s.id
        LEFT JOIN users u ON l.user_id = u.id
        WHERE l.id = ?
    ");
    $stmt->execute([$leadId]);
    $lead = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$lead) {
        header('Location: crm_dashboard.html');
        exit;
    }

    // Obtener historial de comunicaciones
    $stmt = $pdo->prepare("
        SELECT ch.*, u.name as user_name
        FROM communication_history ch
        LEFT JOIN users u ON ch.user_id = u.id
        WHERE ch.lead_id = ?
        ORDER BY ch.contact_date DESC
    ");
    $stmt->execute([$leadId]);
    $communications = $stmt->fetchAll(PDO::FETCH_ASSOC);

} catch (Exception $e) {
    error_log('Error en lead_detail.php: ' . $e->getMessage());
    $error = 'Error al cargar los detalles del lead';
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalles del Lead - ONE CLUB GROUP</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/lead_detail.css">
    <link rel="icon" href="favicon.ico" type="image/ico">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

</head>
<body class="bg-gray-100">
    <!-- Header -->
    <nav class="bg-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex">
                    <a href="crm_dashboard.html" class="flex items-center text-gray-700">
                        <i class="fas fa-arrow-left mr-2"></i>
                        Volver al CRM
                    </a>
                </div>
                <div class="flex items-center">
                    <h1 class="text-xl font-semibold">Detalles del Lead</h1>
                </div>
                <div class="flex items-center">
                    <button data-edit-btn class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition">
    <i class="fas fa-edit mr-2"></i>
    Editar
</button>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <?php if (isset($error)): ?>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                <strong class="font-bold">Error!</strong>
                <span class="block sm:inline"><?php echo htmlspecialchars($error); ?></span>
            </div>
        <?php endif; ?>

        <div class="px-4 py-6 sm:px-0">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Información Principal -->
                <div class="bg-white shadow rounded-lg p-6 col-span-2">
                    <h2 class="text-lg font-semibold mb-4">Información Principal</h2>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Nombre:</label>
                            <p class="mt-1 text-sm text-gray-900"><?php echo htmlspecialchars($lead['name']); ?></p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Email:</label>
                            <p class="mt-1 text-sm text-gray-900"><?php echo htmlspecialchars($lead['email']); ?></p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Teléfono:</label>
                            <p class="mt-1 text-sm text-gray-900">
                                <?php echo htmlspecialchars($lead['phone']); ?>
                                <?php if ($lead['phone']): ?>
                                    <a href="https://wa.me/<?php echo str_replace(['+', ' ', '-'], '', $lead['phone']); ?>" 
                                       target="_blank" 
                                       class="ml-2 text-green-600 hover:text-green-800">
                                        <i class="fab fa-whatsapp"></i>
                                    </a>
                                <?php endif; ?>
                            </p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Etapa:</label>
                            <span class="inline-flex items-center px-3 py-0.5 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
                                <?php echo htmlspecialchars($lead['stage_name']); ?>
                            </span>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Fuente:</label>
                            <p class="mt-1 text-sm text-gray-900"><?php echo htmlspecialchars($lead['source']); ?></p>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Asignado a:</label>
                            <p class="mt-1 text-sm text-gray-900"><?php echo htmlspecialchars($lead['assigned_to']); ?></p>
                        </div>
                    </div>
                </div>

                <!-- Notas -->
                <div class="bg-white shadow rounded-lg p-6">
                    <h2 class="text-lg font-semibold mb-4">Notas</h2>
                    <div class="prose max-w-none">
                        <?php echo nl2br(htmlspecialchars($lead['notes'] ?? '')); ?>
                    </div>
                </div>

               <!-- Comunicaciones -->
<div class="bg-white shadow rounded-lg p-6 col-span-2">
    <div class="flex justify-between items-center mb-4">
        <h2 class="text-lg font-semibold">Comunicaciones</h2>
        <button onclick="window.openCommunicationModal()" class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition flex items-center">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 mr-2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
            Nueva Comunicación
        </button>
    </div>
    <div class="space-y-4">
        <?php foreach ($communications as $comm): ?>
            <div class="bg-gray-50 p-4 rounded-lg">
                <div class="flex items-center justify-between mb-2">
                    <span class="text-sm font-medium text-gray-700">
                        <?php echo htmlspecialchars($comm['user_name']); ?>
                    </span>
                    <span class="text-sm text-gray-500">
                        <?php echo date('d/m/Y H:i', strtotime($comm['contact_date'])); ?>
                    </span>
                </div>
                <div class="flex items-start">
                    <div class="flex-shrink-0">
                        <?php 
                        $icon = match($comm['type']) {
                            'call' => '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 0 0 2.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 0 1-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 0 0-1.091-.852H4.5A2.25 2.25 0 0 0 2.25 4.5v2.25Z" />
                            </svg>',
                            
                            'email' => '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
                            </svg>',
                            
                            'whatsapp' => '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 20.25c4.97 0 9-3.694 9-8.25s-4.03-8.25-9-8.25S3 7.444 3 12c0 2.104.859 4.023 2.273 5.48.432.447.74 1.04.586 1.641a4.483 4.483 0 0 1-.923 1.785A5.969 5.969 0 0 0 6 21c1.282 0 2.47-.402 3.445-1.087.81.22 1.668.337 2.555.337Z" />
                            </svg>',
                            
                            'visit' => '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
                            </svg>',
                            
                            default => '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M7.5 8.25h9m-9 3H12m-9.75 1.51c0 1.6 1.123 2.994 2.707 3.227 1.129.166 2.27.293 3.423.379.35.026.67.21.865.501L12 21l2.755-4.133a1.14 1.14 0 0 1 .865-.501 48.172 48.172 0 0 0 3.423-.379c1.584-.233 2.707-1.626 2.707-3.228V6.741c0-1.602-1.123-2.995-2.707-3.228A48.394 48.394 0 0 0 12 3c-2.392 0-4.744.175-7.043.513C3.373 3.746 2.25 5.14 2.25 6.741v6.018Z" />
                            </svg>'
                        };
                        ?>
                        <div class="text-gray-400">
                            <?php echo $icon; ?>
                        </div>
                    </div>
                    <p class="ml-3 text-sm text-gray-700">
                        <?php echo nl2br(htmlspecialchars($comm['description'])); ?>
                    </p>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
</div>


                <!-- Archivos -->
                <div class="bg-white shadow rounded-lg p-6">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-lg font-semibold">Archivos</h2>
                        <button type="button" onclick="window.openFileModal()" class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 transition">
                            <i class="fas fa-upload mr-2"></i>
                            Subir Archivo
                        </button>
                    </div>
                    <div class="files-list space-y-2">
                        <!-- Los archivos se cargarán dinámicamente aquí -->
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Modales -->
    <div id="communicationModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden z-50">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-lg font-medium text-gray-900">Nueva Comunicación</h3>
                    <button onclick="window.closeCommunicationModal()" class="text-gray-400 hover:text-gray-500">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <form id="communicationForm" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Tipo</label>
                        <select name="type" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                            <option value="call">Llamada</option>
                            <option value="email">Email</option>
                            <option value="whatsapp">WhatsApp</option>
                            <option value="visit">Visita</option>
                            <option value="other">Otro</option>
                        </select>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Descripción</label>
                        <textarea name="description" rows="3" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"></textarea>
                    </div>
                    <div class="flex justify-end space-x-3">
                        <button type="button" onclick="window.closeCommunicationModal()" 
                                class="bg-gray-200 px-4 py-2 rounded-md text-gray-700 hover:bg-gray-300">
                            Cancelar
                        </button>
                        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                            Guardar
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal de Archivos -->
    <div id="fileModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden z-50">
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3">
                <div class="flex justify-between items-center mb-4">
                    <h3 class="text-lg font-medium text-gray-900">Subir Archivo</h3>
                    <button onclick="window.closeFileModal()" class="text-gray-400 hover:text-gray-500">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <form id="fileForm" enctype="multipart/form-data" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700">Seleccionar archivo</label>
                        <input type="file" name="file" class="mt-1 block w-full text-sm text-gray-500
                            file:mr-4 file:py-2 file:px-4
                            file:rounded-md file:border-0
                            file:text-sm file:font-semibold
                            file:bg-indigo-50 file:text-indigo-700
                            hover:file:bg-indigo-100" required>
                    </div>
                    <div class="flex justify-end space-x-3 mt-4">
                        <button type="button" onclick="window.closeFileModal()" 
                                class="bg-gray-200 px-4 py-2 rounded-md text-gray-700 hover:bg-gray-300">
                            Cancelar
                        </button>
                        <button type="submit" 
                                class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700">
                            Subir
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Loader -->
    <div id="loader" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-50" style="display: none;">
<div class="animate-spin rounded-full h-32 w-32 border-t-2 border-b-2 border-indigo-500"></div>
    </div>

    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/es.js"></script>
    <script>
        // Funciones para manejar modales
        window.openCommunicationModal = function() {
            document.getElementById('communicationModal').style.display = 'block';
        };

        window.closeCommunicationModal = function() {
            document.getElementById('communicationModal').style.display = 'none';
            document.getElementById('communicationForm').reset();
        };

        window.openFileModal = function() {
            document.getElementById('fileModal').style.display = 'block';
        };

        window.closeFileModal = function() {
            document.getElementById('fileModal').style.display = 'none';
            document.getElementById('fileForm').reset();
        };

        // Funciones para manejar comunicaciones
        document.getElementById('communicationForm')?.addEventListener('submit', async function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            formData.append('leadId', '<?php echo $leadId; ?>');

            try {
                document.getElementById('loader').style.display = 'flex';
                const response = await fetch('php/add_communication.php', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();
                if (data.success) {
                    window.location.reload();
                } else {
                    throw new Error(data.error || 'Error al añadir la comunicación');
                }
            } catch (error) {
                alert(error.message);
            } finally {
                document.getElementById('loader').style.display = 'none';
            }
        });

        // Funciones para manejar archivos
        document.getElementById('fileForm')?.addEventListener('submit', async function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            formData.append('leadId', '<?php echo $leadId; ?>');

            try {
                document.getElementById('loader').style.display = 'flex';
                const response = await fetch('php/upload_file.php', {
                    method: 'POST',
                    body: formData
                });

                const data = await response.json();
                if (data.success) {
                    window.location.reload();
                } else {
                    throw new Error(data.error || 'Error al subir el archivo');
                }
            } catch (error) {
                alert(error.message);
            } finally {
                document.getElementById('loader').style.display = 'none';
            }
        });

        // Cerrar modales al hacer clic fuera
        window.onclick = function(event) {
            const communicationModal = document.getElementById('communicationModal');
            const fileModal = document.getElementById('fileModal');
            
            if (event.target === communicationModal) {
                closeCommunicationModal();
            }
            if (event.target === fileModal) {
                closeFileModal();
            }
        };

        // Formatear fechas
        document.addEventListener('DOMContentLoaded', function() {
            moment.locale('es');
            document.querySelectorAll('.date-format').forEach(function(element) {
                const date = moment(element.textContent);
                if (date.isValid()) {
                    element.textContent = date.format('DD/MM/YYYY HH:mm');
                }
            });

            // Cargar lista de archivos
            loadFiles();
        });

        // Función para cargar archivos
        async function loadFiles() {
            try {
                const response = await fetch('php/get_lead_files.php?leadId=<?php echo $leadId; ?>');
                const data = await response.json();
                const filesList = document.querySelector('.files-list');

                if (data.success && filesList) {
                    if (data.files.length === 0) {
                        filesList.innerHTML = '<p class="text-gray-500 text-center py-4">No hay archivos subidos</p>';
                    } else {
                        filesList.innerHTML = data.files.map(file => createFileHTML(file)).join('');
                    }
                }
            } catch (error) {
                console.error('Error al cargar archivos:', error);
            }
        }

        // Función para crear el HTML de cada archivo
        function createFileHTML(file) {
            let fileIcon = 'fa-file';
            if (file.file_type?.includes('image')) fileIcon = 'fa-file-image';
            else if (file.file_type?.includes('pdf')) fileIcon = 'fa-file-pdf';
            else if (file.file_type?.includes('word')) fileIcon = 'fa-file-word';
            else if (file.file_type?.includes('excel')) fileIcon = 'fa-file-excel';

            const uploadDate = moment(file.upload_date).format('DD/MM/YYYY HH:mm');

            return `
                <div class="flex items-center justify-between p-4 bg-white rounded-lg shadow mb-2">
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
                </div>
            `;
        }

        // Función para descargar archivos
        window.downloadFile = function(filePath, originalName) {
            const link = document.createElement('a');
            link.href = filePath;
            link.download = originalName;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        };

        // Función para eliminar archivos
        window.deleteFile = async function(fileId) {
            if (!confirm('¿Está seguro de que desea eliminar este archivo?')) {
                return;
            }

            try {
                document.getElementById('loader').style.display = 'flex';
                const response = await fetch('php/delete_file.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ fileId })
                });

                const data = await response.json();
                if (data.success) {
                    loadFiles();
                } else {
                    throw new Error(data.error || 'Error al eliminar el archivo');
                }
            } catch (error) {
                alert(error.message);
            } finally {
                document.getElementById('loader').style.display = 'none';
            }
        };

        document.addEventListener('DOMContentLoaded', function() {
    const editBtn = document.querySelector('[data-edit-btn]');
    if (editBtn) {
        editBtn.addEventListener('click', openEditModal);
    }

    const editLeadForm = document.getElementById('editLeadForm');
    if (editLeadForm) {
        editLeadForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            await updateLead();
        });
    }
});

function openEditModal() {
    document.getElementById('editModal').classList.remove('hidden');
}

function closeEditModal() {
    document.getElementById('editModal').classList.add('hidden');
}

async function updateLead() {
    const form = document.getElementById('editLeadForm');
    const formData = new FormData(form);

    try {
        showLoader();
        const response = await fetch('php/edit_lead.php', {
            method: 'POST',
            body: formData
        });

        const data = await response.json();
        
        if (data.success) {
            showNotification('Lead actualizado correctamente', 'success');
            closeEditModal();
            // Reload the page to show updated data
            setTimeout(() => window.location.reload(), 1000);
        } else {
            throw new Error(data.error || 'Error al actualizar el lead');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification(error.message, 'error');
    } finally {
        hideLoader();
    }
}

// Utility functions
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
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.opacity = '0';
        notification.style.transition = 'opacity 0.5s ease';
        setTimeout(() => notification.remove(), 500);
    }, 3000);
}
    </script>

    <!-- Edit Lead Modal -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden z-50">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white max-w-md">
        <div class="mt-3">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-medium">Editar Lead</h3>
                <button onclick="closeEditModal()" class="text-gray-400 hover:text-gray-500">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="editLeadForm" class="space-y-4">
                <input type="hidden" id="editLeadId" name="leadId" value="<?php echo $leadId; ?>">
                
                <div>
                    <label class="block text-sm font-medium text-gray-700">Nombre</label>
                    <input type="text" name="leadName" id="editName" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" required value="<?php echo htmlspecialchars($lead['name']); ?>">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Email</label>
                    <input type="email" name="leadEmail" id="editEmail" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" value="<?php echo htmlspecialchars($lead['email']); ?>">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Teléfono</label>
                    <input type="tel" name="leadPhone" id="editPhone" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" value="<?php echo htmlspecialchars($lead['phone']); ?>">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Fuente</label>
                    <input type="text" name="leadSource" id="editSource" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" value="<?php echo htmlspecialchars($lead['source']); ?>">
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Etapa</label>
                    <select name="leadStage" id="editStage" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" required>
                        <?php
                        $stagesStmt = $pdo->query("SELECT * FROM lead_stages ORDER BY order_num");
                        while ($stage = $stagesStmt->fetch()) {
                            $selected = ($stage['id'] == $lead['stage_id']) ? 'selected' : '';
                            echo "<option value='{$stage['id']}' {$selected}>{$stage['name']}</option>";
                        }
                        ?>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700">Notas</label>
                    <textarea name="leadNotes" id="editNotes" rows="3" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"><?php echo htmlspecialchars($lead['notes']); ?></textarea>
                </div>

                <div class="flex justify-end space-x-3 mt-6">
                    <button type="button" onclick="closeEditModal()" class="bg-gray-200 px-4 py-2 rounded-md text-gray-700 hover:bg-gray-300">
                        Cancelar
                    </button>
                    <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
                        Guardar Cambios
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>