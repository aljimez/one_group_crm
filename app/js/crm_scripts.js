document.addEventListener('DOMContentLoaded', () => {
    // Elementos DOM principales
    const crmContainer = document.getElementById('crmContainer');
    const addLeadBtn = document.getElementById('addLeadBtn');
    const addLeadModal = document.getElementById('addLeadModal');
    const addLeadForm = document.getElementById('addLeadForm');
    const logoutBtn = document.getElementById('logoutBtn');
    const closeBtn = document.querySelector('.close');
    const searchInput = document.getElementById('searchInput');
    const filterStage = document.getElementById('filterStage');
    const filterUser = document.getElementById('filterUser');
    const currentUserId = localStorage.getItem('userId') || '0';

    // Variables globales
    let editingLeadId = null;
    let lastLeadId = 0;
    let stages = [];
    let leadsChart, callsChart;

    // Verificar si hay un ID de lead para editar en la URL
    const urlParams = new URLSearchParams(window.location.search);
    const editLeadId = urlParams.get('edit');

    if (editLeadId) {
        // Buscar el lead en los datos cargados
        fetch('php/get_leads.php')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.leads) {
                    const lead = data.leads.find(l => l.id === editLeadId);
                    if (lead) {
                        openEditLeadModal(lead);
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Error al cargar el lead para editar', 'error');
            });

        // Limpiar el parámetro de la URL sin recargar la página
        window.history.replaceState({}, document.title, 'crm_dashboard.html');
    }

    // Función principal para cargar el CRM
     function loadCRM() {
    showLoader();
    fetch('php/get_leads_with_history.php')
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            if (!data.leadsWithHistory || !Array.isArray(data.leadsWithHistory)) {
                throw new Error('Invalid data structure: leadsWithHistory is missing or not an array');
            }
            stages = Array.isArray(data.stages) ? data.stages : [];
            renderCRM(data.leadsWithHistory);
            setupDragAndDrop();
            updateStats(data.leadsWithHistory);
            populateStageFilter(stages);
            populateSourceFilter(data.leadsWithHistory); // Nueva línea
            lastLeadId = Math.max(...data.leadsWithHistory.map(lead => lead.id), 0);
            updateCharts(data.leadsWithHistory);
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Error al cargar el CRM. Por favor, intente de nuevo.', 'error');
        })
        .finally(() => {
            hideLoader();
        });
}

function populateSourceFilter(leads) {
    const filterSource = document.getElementById('filterSource');
    if (!filterSource) return;

    // Obtener fuentes únicas de los leads
    const sources = new Set();
    leads.forEach(lead => {
        if (lead.source) {
            sources.add(lead.source);
        }
    });

    // Limpiar el selector
    filterSource.innerHTML = '<option value="">Todas las fuentes</option>';

    // Añadir cada fuente única como opción
    Array.from(sources).sort().forEach(source => {
        const option = document.createElement('option');
        option.value = source;
        option.textContent = source;
        filterSource.appendChild(option);
    });
}


    // Configuración de drag and drop
    function setupDragAndDrop() {
        document.querySelectorAll('.lead-list').forEach(list => {
            new Sortable(list, {
                group: 'shared',
                animation: 150,
                onEnd: function(evt) {
                    const leadId = evt.item.dataset.leadId;
                    const newStageId = evt.to.dataset.stageId;
                    updateLeadStage(leadId, newStageId);
                }
            });
        });
    }
 // Mostrar/ocultar botón de asignación masiva según el rol de usuario
    const assignPageButton = document.getElementById('assignPageButton');
    
    // Verificar si el usuario es admin al cargar los leads
    fetch('php/check_admin.php')
        .then(response => response.json())
        .then(data => {
            if (data.isAdmin) {
                assignPageButton.style.display = 'flex';
            } else {
                assignPageButton.style.display = 'none';
            }
        })
        .catch(error => {
            console.error('Error verificando admin:', error);
            assignPageButton.style.display = 'none';
        });
    
async function assignLead(leadId, newUserId) {
    showLoader();
    try {
        const response = await fetch('php/assign_lead.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                leadId: leadId,
                userId: newUserId
            })
        });

        const data = await response.json();
        
        if (data.success) {
            // Actualizar solo el lead asignado
            const leadElement = document.querySelector(`[data-lead-id="${leadId}"]`);
            if (leadElement) {
                const userNameElement = leadElement.querySelector('.lead-owner');
                if (userNameElement) {
                    userNameElement.textContent = `🧠 ${data.userName}`;
                }
            }
            
            showNotification('Lead asignado correctamente', 'success');
        } else {
            throw new Error(data.error || 'Error al asignar el lead');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification(error.message, 'error');
    } finally {
        hideLoader();
    }
}


    
async function updateLeadStage(leadId, stageId) {
    showLoader();
    try {
        const response = await fetch('php/update_lead_stage.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ leadId, stageId })
        });

        const data = await response.json();
        
        if (data.success) {
            // No necesitamos recargar todo el CRM, solo actualizar los contadores y estadísticas
            updateLeadCounts();
            updateStats(await getUpdatedLeads());
            updateCharts(await getUpdatedLeads());
            
            showNotification('Lead actualizado con éxito', 'success');
        } else {
            throw new Error(data.error || 'Failed to update lead stage');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification('Error al actualizar el lead: ' + error.message, 'error');
        // Revertir el cambio visual si hubo un error
        loadCRM();
    } finally {
        hideLoader();
    }
}
    // Render del CRM
    function renderCRM(leads) {
        crmContainer.innerHTML = '';
        stages.forEach(stage => {
            const stageColumn = document.createElement('div');
            stageColumn.className = 'stage-column';
            stageColumn.innerHTML = `
                <h2>${stage.name} <span class="lead-count">(0)</span></h2>
                <div class="lead-list" data-stage-id="${stage.id}"></div>
            `;
            crmContainer.appendChild(stageColumn);
        });

        leads.forEach(lead => {
            const leadElement = createLeadElement(lead);
            document.querySelector(`.lead-list[data-stage-id="${lead.stage_id}"]`).appendChild(leadElement);
        });

        updateLeadCounts();
    }

    // Crear elemento de lead
function createLeadElement(lead) {
    const leadElement = document.createElement('div');
    leadElement.className = 'lead-card';
    leadElement.dataset.leadId = lead.id;
    leadElement.dataset.userId = lead.user_id;
    leadElement.dataset.source = lead.source || '';

    // Formatear número de teléfono para WhatsApp
    const formatPhoneNumber = (phone) => {
        if (!phone) return null;
        const cleanedPhone = phone.replace(/\D/g, '');
        return cleanedPhone.startsWith('34') ? cleanedPhone : `34${cleanedPhone}`;
    };

    const whatsappLink = lead.phone 
        ? `https://api.whatsapp.com/send?phone=${formatPhoneNumber(lead.phone)}&text=%C2%A1Hola!`
        : null;

    const mainContent = `
        <div class="lead-main-content">
            <h3>${lead.name}</h3>
            ${lead.user_name ? `<p class="lead-owner">🧠 ${lead.user_name}</p>` : ''}
            <p>${lead.email || ''}</p>
            <p>${lead.phone || ''}</p>
            <div class="lead-actions">
                <button class="edit-lead-btn">✏️ Editar</button>
                            <button onclick="window.location.href='lead_detail.php?id=${lead.id}'" class="details-btn">📋 Detalles</button>

                ${whatsappLink ? `<a href="${whatsappLink}" target="_blank" class="whatsapp-btn">Whats</a>` : ''}
            </div>
        </div>
    `;

    leadElement.innerHTML = mainContent;

    // Event listeners
    leadElement.querySelector('.edit-lead-btn').addEventListener('click', () => openEditLeadModal(lead));

    return leadElement;
}

    // Crear línea de tiempo del historial
    function createHistoryTimeline(lead) {
        if (!lead.history || !Array.isArray(lead.history)) {
            return '<p>No hay historial disponible</p>';
        }

        const sortedHistory = lead.history.sort((a, b) => 
            new Date(b.changed_at) - new Date(a.changed_at)
        );

        const stageNames = {};
        stages.forEach(stage => {
            stageNames[stage.id] = stage.name;
        });

        return sortedHistory.map(entry => {
            const date = new Date(entry.changed_at);
            const formattedDate = date.toLocaleDateString('es-ES', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });

            let actionText = '';
            if (entry.action_type === 'assignment_change') {
                actionText = entry.notes;
            } else {
                actionText = `Cambió a: ${stageNames[entry.stage_id] || 'Desconocido'}`;
            }

            return `
                <div class="history-item">
                    <span class="history-date">${formattedDate}</span>
                    <span class="history-action">${actionText}</span>
                </div>
            `;
        }).join('');
    }

    // Funciones de asignación de leads
    function showAssignModal(lead) {
        const modal = document.createElement('div');
        modal.className = 'modal';
        modal.id = 'assignModal';
        modal.style.display = 'block';
        modal.innerHTML = `
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Asignar Lead: ${lead.name}</h2>
                <form id="assignForm">
                    <div class="form-group">
                        <label for="userId">Asignar a:</label>
                        <select id="userId" name="userId" required>
                            <option value="">Seleccionar usuario</option>
                        </select>
                    </div>
                    <button type="submit" class="submit-btn">Asignar</button>
                </form>
            </div>
        `;

        document.body.appendChild(modal);

        // Cargar usuarios
        const select = modal.querySelector('#userId');
        fetch('php/get_users.php')
            .then(response => response.json())
            .then(data => {
                if (data.success && Array.isArray(data.users)) {
                    data.users.forEach(user => {
                        const option = document.createElement('option');
                        option.value = user.id;
                        option.textContent = user.name;
                        select.appendChild(option);
                    });
                    
                    if (lead.user_id) {
                        select.value = lead.user_id;
                    }
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Error al cargar usuarios', 'error');
            });

        // Event listeners del modal
        const closeBtn = modal.querySelector('.close');
        const form = modal.querySelector('#assignForm');

        closeBtn.onclick = () => modal.remove();
        window.onclick = (event) => {
            if (event.target === modal) modal.remove();
        };

        form.onsubmit = async (e) => {
            e.preventDefault();
            const newUserId = select.value;
            
            if (!newUserId) {
                showNotification('Por favor selecciona un usuario', 'error');
                return;
            }

            try {
                showLoader();
                const response = await fetch('php/assign_lead.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        leadId: lead.id,
                        userId: newUserId
                    })
                });

                const data = await response.json();
                
                if (data.success) {
                    showNotification('Lead asignado correctamente', 'success');
                    modal.remove();
                    loadCRM();
                } else {
                    throw new Error(data.error || 'Error al asignar el lead');
                }
            } catch (error) {
                console.error('Error:', error);
                showNotification(error.message, 'error');
            } finally {
                hideLoader();
            }
        };
    }

    // Funciones de edición y eliminación
function openEditLeadModal(lead) {
    editingLeadId = lead.id;
    document.getElementById('modalTitle').textContent = 'Editar Lead';
    document.getElementById('leadName').value = lead.name;
    document.getElementById('leadEmail').value = lead.email || '';
    document.getElementById('leadPhone').value = lead.phone || '';
    document.getElementById('leadSource').value = lead.source || '';
    
    const stageSelect = document.getElementById('leadStage');
    stageSelect.innerHTML = '';
    stages.forEach(stage => {
        const option = document.createElement('option');
        option.value = stage.id;
        option.textContent = stage.name;
        stageSelect.appendChild(option);
    });
    stageSelect.value = lead.stage_id;
    
    document.getElementById('leadNotes').value = lead.notes || '';
    
    // Actualizar el enlace de ver detalles
    const viewDetailsLink = document.getElementById('viewDetailsLink');
    viewDetailsLink.href = `lead_detail.php?id=${lead.id}`;
    viewDetailsLink.style.display = 'inline-block'; // Mostrar el enlace
    
    openModal();
}
    function deleteLead(leadId) {
        if (confirm('¿Estás seguro de que quieres eliminar este lead?')) {
            showLoader();
            fetch('php/delete_lead.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ leadId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    loadCRM();
                    showNotification('Lead eliminado con éxito', 'success');
                } else {
                    throw new Error('Failed to delete lead');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showNotification('Error al eliminar el lead', 'error');
            })
            .finally(() => {
                hideLoader();
            });
        }
    }

    // Funciones de manejo de modales
    function openModal() {
        addLeadModal.style.display = 'block';
    }

    function closeModal() {
        addLeadModal.style.display = 'none';
        addLeadForm.reset();
        editingLeadId = null;
        document.getElementById('modalTitle').textContent = 'Añadir Nuevo Lead';
        
        // Remover el botón de detalles si existe
        const detailsButton = document.querySelector('.details-button');
        if (detailsButton) {
            detailsButton.remove();
        }
    }

    // Funciones de actualización de contadores
    function updateLeadCount(stageId) {
        const stageColumn = document.querySelector(`.lead-list[data-stage-id="${stageId}"]`);
        if (stageColumn) {
            const countSpan = stageColumn.previousElementSibling.querySelector('.lead-count');
            const currentCount = stageColumn.children.length;
            countSpan.textContent = `(${currentCount})`;
        }
    }

    function updateLeadCounts() {
        document.querySelectorAll('.lead-list').forEach(list => {
            updateLeadCount(list.dataset.stageId);
        });
    }

// Funciones de filtrado
    function populateStageFilter(stages) {
        filterStage.innerHTML = '<option value="">Todas las etapas</option>';
        stages.forEach(stage => {
            const option = document.createElement('option');
            option.value = stage.id;
            option.textContent = stage.name;
            filterStage.appendChild(option);
        });
    }



    function setupUserFilter() {
        if (currentUserId === '0') {
            // Crear y añadir el elemento select para filtrar por usuario
            const userFilterContainer = document.createElement('div');
            userFilterContainer.className = 'user-filter-container';
            
            const userSelect = document.createElement('select');
            userSelect.id = 'filterUser';
            userSelect.className = 'user-filter-select';
            
            // Añadir opción para ver todos los leads
            const allOption = document.createElement('option');
            allOption.value = '';
            allOption.textContent = 'Todos los usuarios';
            userSelect.appendChild(allOption);

            // Añadir opción para ver solo los leads del admin
            const adminOption = document.createElement('option');
            adminOption.value = '0';
            adminOption.textContent = 'Mis leads';
            userSelect.appendChild(adminOption);
            
            // Cargar lista de usuarios
            fetch('php/get_users.php')
                .then(response => response.json())
                .then(data => {
                    if (data.success && Array.isArray(data.users)) {
                        data.users.forEach(user => {
                            const option = document.createElement('option');
                            option.value = user.id;
                            option.textContent = user.name;
                            userSelect.appendChild(option);
                        });
                    }
                })
                .catch(error => console.error('Error cargando usuarios:', error));

            userFilterContainer.appendChild(userSelect);
            
            // Insertar el filtro en la sección de filtros existente
            const filterSection = document.getElementById('filterSection');
            filterSection.insertBefore(userFilterContainer, filterSection.firstChild);
            
            // Añadir event listener para el filtrado
            userSelect.addEventListener('change', filterLeads);
        }
    }


    

    function filterLeads() {
    const searchTerm = searchInput.value.toLowerCase();
    const selectedStage = filterStage.value;
    const selectedSource = document.getElementById('filterSource').value;
    const selectedUser = document.getElementById('filterUser')?.value || '';

    document.querySelectorAll('.lead-card').forEach(leadCard => {
        const leadName = leadCard.querySelector('h3').textContent.toLowerCase();
        const leadEmail = (leadCard.querySelector('p:nth-of-type(1)').textContent || '').toLowerCase();
        const leadPhone = (leadCard.querySelector('p:nth-of-type(2)').textContent || '').toLowerCase();
        const leadStage = leadCard.closest('.lead-list').dataset.stageId;
        const leadSource = leadCard.dataset.source || '';
        const userId = leadCard.dataset.userId;
        
        const nameMatch = leadName.includes(searchTerm);
        const emailMatch = leadEmail.includes(searchTerm);
        const phoneMatch = leadPhone.includes(searchTerm);
        const stageMatch = selectedStage === '' || leadStage === selectedStage;
        const sourceMatch = selectedSource === '' || leadSource === selectedSource;
        const userMatch = selectedUser === '' || userId === selectedUser;

        leadCard.style.display = 
            (nameMatch || emailMatch || phoneMatch) && 
            stageMatch && 
            sourceMatch &&
            userMatch ? 'block' : 'none';
    });

    updateLeadCounts();
}



    // Funciones de estadísticas y gráficos
    function updateStats(leads) {
        const now = new Date();
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        // Filtrar leads del mes actual
        const monthlyLeads = leads.filter(lead => 
            new Date(lead.created_at) >= startOfMonth
        ).length;

        // Contar leads en etapa "Contactado" (stage_id = 2)
        const monthlyContacted = leads.filter(lead => 
            lead.stage_id === 2 &&
            new Date(lead.created_at) >= startOfMonth
        ).length;

        // Contar leads en etapa "Cliente" (stage_id = 6)
        const monthlyCaptured = leads.filter(lead => 
            lead.stage_id === 6 &&
            new Date(lead.created_at) >= startOfMonth
        ).length;

        // Actualizar los elementos del DOM
        const leadsElement = document.getElementById('leadsThisMonth');
        const contactedElement = document.getElementById('contactedThisMonth');
        const capturedElement = document.getElementById('capturedThisMonth');

        if (leadsElement) leadsElement.textContent = monthlyLeads;
        if (contactedElement) contactedElement.textContent = monthlyContacted;
        if (capturedElement) capturedElement.textContent = monthlyCaptured;

        // Actualizar también cuando se mueve un lead
        document.querySelectorAll('.lead-list').forEach(list => {
            const stageId = list.dataset.stageId;
            const leadsInStage = list.children.length;
            
            // Actualizar contadores específicos por etapa
            if (stageId === '2') { // Contactado
                if (contactedElement) contactedElement.textContent = leadsInStage;
            }
            if (stageId === '6') { // Cliente
                if (capturedElement) capturedElement.textContent = leadsInStage;
            }
        });
    }

    function updateCharts(leads) {
        if (Array.isArray(leads) && leads.length > 0) {
            updateLeadsChart(leads);
            updateCallsChart(leads);
        }
    }

    function getLastSevenDays() {
        const dates = [];
        for (let i = 6; i >= 0; i--) {
            const date = new Date();
            date.setDate(date.getDate() - i);
            dates.push(date.toISOString().split('T')[0]);
        }
        return dates;
    }

    function updateLeadsChart(leads) {
        const dateLabels = getLastSevenDays();
        const leadsData = getLeadsPerDay(leads, dateLabels);
        
        const formattedLabels = dateLabels.map(date => {
            const [year, month, day] = date.split('-');
            return `${day}/${month}`;
        });
        
        if (leadsChart) {
            leadsChart.data.labels = formattedLabels;
            leadsChart.data.datasets[0].data = leadsData;
            leadsChart.update();
        } else {
            const ctx = document.getElementById('leadsChart').getContext('2d');
            leadsChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: formattedLabels,
                    datasets: [{
                        label: 'Leads Añadidos por Día',
                        data: leadsData,
                        borderColor: 'rgb(75, 192, 192)',
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        tension: 0.1,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { stepSize: 1 }
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                        }
                    }
                }
            });
        }
    }

    function updateCallsChart(leads) {
        const dateLabels = getLastSevenDays();
        const callsData = getCallsPerDay(leads, dateLabels);
        
        const formattedLabels = dateLabels.map(date => {
            const [year, month, day] = date.split('-');
            return `${day}/${month}`;
        });
        
        if (callsChart) {
            callsChart.data.labels = formattedLabels;
            callsChart.data.datasets[0].data = callsData;
            callsChart.update();
        } else {
            const ctx = document.getElementById('callsChart').getContext('2d');
            callsChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: formattedLabels,
                    datasets: [{
                        label: 'Contactos Realizados por Día',
                        data: callsData,
                        borderColor: 'rgb(255, 99, 132)',
                        backgroundColor: 'rgba(255, 99, 132, 0.2)',
                        tension: 0.1,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { stepSize: 1 }
                        }
                    },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top'
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                        }
                    }
                }
            });
        }
    }

    function getLeadsPerDay(leads, dateLabels) {
        const leadsPerDay = new Array(7).fill(0);
        leads.forEach(lead => {
            const leadDate = new Date(lead.created_at).toISOString().split('T')[0];
            const index = dateLabels.indexOf(leadDate);
            if (index !== -1) {
                leadsPerDay[index]++;
            }
        });
        return leadsPerDay;
    }

    function getCallsPerDay(leads, dateLabels) {
        const callsPerDay = new Array(7).fill(0);
        leads.forEach(lead => {
            if (lead.history && Array.isArray(lead.history)) {
                lead.history.forEach(historyItem => {
                    if (parseInt(historyItem.stage_id) === 2) {
                        const callDate = historyItem.changed_at.split(' ')[0];
                        const index = dateLabels.indexOf(callDate);
                        if (index !== -1) {
                            callsPerDay[index]++;
                        }
                    }
                });
            }
        });
        return callsPerDay;
    }

    // Funciones de utilidad
    function showLoader() {
        document.getElementById('loader').style.display = 'flex';
    }

    function hideLoader() {
        document.getElementById('loader').style.display = 'none';
    }

    function showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.textContent = message;

        notification.style.opacity = 0;
        notification.style.transition = 'opacity 0.5s ease';
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.opacity = 1;
        }, 10);

        setTimeout(() => {
            notification.style.opacity = 0;
            setTimeout(() => notification.remove(), 500);
        }, 3000);
    }

    // Event Listeners
    addLeadBtn?.addEventListener('click', () => {
        editingLeadId = null;
        document.getElementById('modalTitle').textContent = 'Añadir Nuevo Lead';
        addLeadForm.reset();
        
        const stageSelect = document.getElementById('leadStage');
        stageSelect.innerHTML = '';
        stages.forEach(stage => {
            const option = document.createElement('option');
            option.value = stage.id;
            option.textContent = stage.name;
            stageSelect.appendChild(option);
        });
        
        openModal();
    });

    closeBtn?.addEventListener('click', closeModal);

    window.addEventListener('click', (event) => {
        if (event.target === addLeadModal) {
            closeModal();
        }
    });

addLeadForm?.addEventListener('submit', async (e) => {
    e.preventDefault();
    const formData = new FormData(addLeadForm);

    if (editingLeadId) {
        formData.append('leadId', editingLeadId);
    }

    showLoader();
    try {
        const response = await fetch(editingLeadId ? 'php/edit_lead.php' : 'php/add_lead.php', {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        
        if (data.success) {
            closeModal();
            await loadCRM(); // Reload after successful submission
            showNotification(
                editingLeadId ? 'Lead actualizado con éxito' : 'Nuevo lead añadido con éxito',
                'success'
            );
        } else {
            throw new Error(data.error || 'Failed to save lead');
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification(error.message, 'error');
    } finally {
        hideLoader();
    }
});

async function getUpdatedLeads() {
    try {
        const response = await fetch('php/get_leads_with_history.php');
        const data = await response.json();
        return data.success ? data.leadsWithHistory : [];
    } catch (error) {
        console.error('Error al obtener leads actualizados:', error);
        return [];
    }
}

    logoutBtn?.addEventListener('click', () => {
        showLoader();
        fetch('logout.php', {
            method: 'POST'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                window.location.href = 'index.html';
            } else {
                throw new Error('Failed to logout');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Error al cerrar sesión', 'error');
        })
        .finally(() => {
            hideLoader();
        });
    });

    // Event listeners para filtrado
    searchInput?.addEventListener('input', filterLeads);
    filterStage?.addEventListener('change', filterLeads);

    // Toggle modo oscuro
    document.getElementById('darkModeToggle')?.addEventListener('click', () => {
        document.body.classList.toggle('dark-mode');
        localStorage.setItem('darkMode', document.body.classList.contains('dark-mode'));
    });

    // Aplicar modo oscuro si estaba activo
    if (localStorage.getItem('darkMode') === 'true') {
        document.body.classList.add('dark-mode');
    }

    // Inicializar el CRM
    loadCRM();
});