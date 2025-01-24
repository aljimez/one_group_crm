document.addEventListener('DOMContentLoaded', () => {
    // Referencias DOM principales
    const leadsGrid = document.getElementById('leadsGrid');
    const filterStage = document.getElementById('filterStage');
    const assignUser = document.getElementById('assignUser');
    const searchInput = document.getElementById('searchInput');
    const filterAssignment = document.getElementById('filterAssignment');
    const selectAll = document.getElementById('selectAll');
    const assignButton = document.getElementById('assignButton');
    const sortSelect = document.getElementById('sortLeads');
    const selectUnassignedBtn = document.getElementById('selectUnassigned');
    const clearSelectionBtn = document.getElementById('clearSelection');
    const confirmationModal = document.getElementById('confirmationModal');
    const confirmAssignBtn = document.getElementById('confirmAssignment');
    const cancelAssignBtn = document.getElementById('cancelAssignment');

    let leads = [];
    let users = [];

    // Cargar leads y configuración inicial
    async function initialize() {
        const loader = document.getElementById('loader');
        if (loader) loader.style.display = 'flex';
        
        const timeoutPromise = new Promise((_, reject) => {
            setTimeout(() => reject(new Error('Timeout')), 10000);
        });

        try {
            const [leadsResponse, usersResponse] = await Promise.race([
                Promise.all([
                    fetch('php/get_leads_with_history.php'),
                    fetch('php/get_users.php')
                ]),
                timeoutPromise
            ]);

            if (!leadsResponse.ok || !usersResponse.ok) {
                throw new Error('Error en la respuesta del servidor');
            }

            const leadsData = await leadsResponse.json();
            const usersData = await usersResponse.json();

            if (leadsData.error || usersData.error) {
                throw new Error(leadsData.error || usersData.error);
            }

            if (leadsData.stages) {
                populateStages(leadsData.stages);
            }

            if (leadsData.leadsWithHistory) {
                leads = leadsData.leadsWithHistory;
                renderLeads(leads);
                updateStats(leads);
            }

            if (usersData.success && Array.isArray(usersData.users)) {
                users = usersData.users;
                populateUsers(users);
                updateDistributionTable(leads, users);
            }

        } catch (error) {
            console.error('Error en la inicialización:', error);
            showNotification('Error al cargar los datos. Por favor, intente de nuevo.', 'error');
        } finally {
            if (loader) loader.style.display = 'none';
        }
    }

    // Funciones de renderizado y población de datos
    function populateStages(stages) {
        filterStage.innerHTML = '<option value="">Todas las etapas</option>';
        stages.forEach(stage => {
            const option = document.createElement('option');
            option.value = stage.id;
            option.textContent = stage.name;
            filterStage.appendChild(option);
        });
    }

    function populateUsers(users) {
        assignUser.innerHTML = '<option value="">Seleccionar usuario</option>';
        users.forEach(user => {
            const option = document.createElement('option');
            option.value = user.id;
            option.textContent = user.name;
            assignUser.appendChild(option);
        });
    }

    function renderLeads(leadsToRender) {
        leadsGrid.innerHTML = '';
        if (!Array.isArray(leadsToRender) || leadsToRender.length === 0) {
            leadsGrid.innerHTML = '<div class="col-span-3 text-center text-gray-500 p-4">No se encontraron leads</div>';
            return;
        }

        leadsToRender.forEach(lead => {
            const leadCard = createLeadElement(lead);
            leadsGrid.appendChild(leadCard);
        });
        
        updateAssignButton();
    }

    function createLeadElement(lead) {
    const div = document.createElement('div');
    div.className = 'relative';
    
    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';
    checkbox.className = 'lead-checkbox absolute top-2 right-2 z-10 w-4 h-4 cursor-pointer';
    checkbox.dataset.leadId = lead.id;
    checkbox.addEventListener('change', updateAssignButton);

    const card = document.createElement('div');
    card.className = `lead-card bg-white p-4 rounded-lg shadow hover:shadow-md transition
                     ${lead.user_id ? 'border-l-4 border-green-500' : 'border-l-4 border-gray-300'}`;
    card.dataset.userId = lead.user_id || '0';

    const createdDate = new Date(lead.created_at).toLocaleString('es-ES', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });

    const lastContactDate = lead.last_contact 
        ? new Date(lead.last_contact).toLocaleString('es-ES', {
            year: 'numeric',
            month: 'short',
            day: 'numeric'
        })
        : 'Sin contacto';

    card.innerHTML = `
        <div class="space-y-2">
            <h3 class="font-semibold text-lg">${lead.name}</h3>
            <div class="grid grid-cols-2 gap-2 text-sm">
                <div class="space-y-1">
                    ${lead.email ? `
                        <p class="text-gray-600">
                            <i class="fas fa-envelope mr-1"></i>
                            ${lead.email}
                        </p>
                    ` : ''}
                    
                    ${lead.phone ? `
                        <p class="text-gray-600">
                            <i class="fas fa-phone mr-1"></i>
                            ${lead.phone}
                        </p>
                    ` : ''}

                    ${lead.source ? `
                        <p class="text-gray-600">
                            <i class="fas fa-share-alt mr-1"></i>
                            ${lead.source}
                        </p>
                    ` : ''}
                </div>
                
                <div class="space-y-1">
                    <p class="text-gray-600">
                        <i class="fas fa-tag mr-1"></i>
                        ${lead.stage_name}
                    </p>
                    
                    <p class="${lead.user_id ? 'text-green-600' : 'text-gray-600'}">
                        <i class="fas fa-user mr-1"></i>
                        ${lead.user_name || 'Sin asignar'}
                    </p>
                </div>
            </div>

            <div class="text-xs text-gray-500 pt-2 border-t">
                <p>
                    <i class="fas fa-clock mr-1"></i>
                    Creado: ${createdDate}
                </p>
                <p>
                    <i class="fas fa-history mr-1"></i>
                    Último contacto: ${lastContactDate}
                </p>
            </div>
        </div>
    `;

    div.appendChild(checkbox);
    div.appendChild(card);
    return div;
}

    function updateDistributionTable(leads, users) {
        const distribution = {};
        users.forEach(user => {
            distribution[user.id] = {
                name: user.name,
                count: 0,              // Leads asignados
                pendingContact: 0,     // Leads pendientes por contactar
                totalSales: 0,         // Ventas totales
                monthlySales: 0,       // Ventas del mes actual
                conversionRate: 0,     // Tasa de conversión
                responseTimes: [],     // Array para almacenar tiempos de respuesta
                avgResponseTime: 0     // Tiempo promedio de respuesta
            };
        });

        const now = new Date();
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        leads.forEach(lead => {
            if (lead.user_id && distribution[lead.user_id]) {
                distribution[lead.user_id].count++;
                
                // Verificar si el lead está pendiente por contactar
                let hasBeenContacted = false;
                if (lead.history && Array.isArray(lead.history)) {
                    hasBeenContacted = lead.history.some(h => h.stage_id === 2); // 2 = Contactado
                }
                
                if (!hasBeenContacted && lead.stage_id === 1) {
                    distribution[lead.user_id].pendingContact++;
                }
                
                // Contar ventas totales (stage_id = 6 es "Cliente")
                if (lead.stage_id === 6) {
                    distribution[lead.user_id].totalSales++;
                    
                    // Contar ventas del mes actual
                    const stageChangeDate = new Date(lead.updated_at);
                    if (stageChangeDate >= startOfMonth) {
                        distribution[lead.user_id].monthlySales++;
                    }
                }

                // Calcular tiempo de respuesta
                if (lead.history && Array.isArray(lead.history)) {
                    const assignmentEvent = lead.history.find(h => h.action_type === 'assignment_change');
                    const firstContactEvent = lead.history.find(h => h.stage_id === 2);

                    if (assignmentEvent && firstContactEvent) {
                        const assignmentDate = new Date(assignmentEvent.changed_at);
                        const contactDate = new Date(firstContactEvent.changed_at);
                        const responseTime = contactDate - assignmentDate;
                        
                        // Solo considerar si el tiempo es positivo y menor a 30 días
                        if (responseTime > 0 && responseTime < 30 * 24 * 60 * 60 * 1000) {
                            distribution[lead.user_id].responseTimes.push(responseTime);
                        }
                    }
                }
            }
        });

        // Calcular tasas de conversión y tiempos promedio de respuesta
        Object.values(distribution).forEach(data => {
            // Calcular tasa de conversión
            data.conversionRate = data.count > 0 ? 
                ((data.totalSales / data.count) * 100).toFixed(1) : 0;
            
            // Calcular tiempo promedio de respuesta
            if (data.responseTimes.length > 0) {
                const avgTime = data.responseTimes.reduce((a, b) => a + b, 0) / data.responseTimes.length;
                data.avgResponseTime = avgTime;
            }
        });

        const tbody = document.querySelector('#assignmentDistribution tbody');
        tbody.innerHTML = '';
        
        Object.values(distribution).forEach(data => {
            const percentage = ((data.count / leads.length) * 100).toFixed(1);
            const row = document.createElement('tr');
            row.className = 'hover:bg-gray-50 transition-colors';
            
            row.innerHTML = `
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                        <div class="flex-shrink-0 h-8 w-8 bg-gray-100 rounded-full flex items-center justify-center">
                            <i class="fas fa-user text-gray-500"></i>
                        </div>
                        <div class="ml-4">
                            <div class="text-sm font-medium text-gray-900">${data.name}</div>
                        </div>
                    </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-900">${data.count}</div>
                    <div class="text-xs text-gray-500">${percentage}%</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                        <div class="text-sm ${data.pendingContact > 0 ? 'text-red-600 font-semibold' : 'text-gray-900'}">${data.pendingContact}</div>
                        ${data.pendingContact > 0 ? `
                            <div class="ml-2 text-xs bg-red-100 text-red-800 px-2 py-1 rounded-full">
                                ¡Pendiente!
                            </div>
                        ` : ''}
                    </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-900">${data.totalSales}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-900">${data.monthlySales}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm ${data.conversionRate > 10 ? 'text-green-600' : 'text-gray-900'}">${data.conversionRate}%</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-900">
                        ${formatResponseTime(data.avgResponseTime)}
                    </div>
                </td>
            `;
            tbody.appendChild(row);
        });

        updateDistributionCharts(distribution);
        updateResponseTimeChart(distribution);
    }

    // Función para formatear el tiempo de respuesta
    function formatResponseTime(ms) {
        if (!ms) return 'N/A';
        
        const minutes = Math.floor(ms / (1000 * 60));
        const hours = Math.floor(minutes / 60);
        const days = Math.floor(hours / 24);

        if (days > 0) {
            return `${days}d ${hours % 24}h`;
        } else if (hours > 0) {
            return `${hours}h ${minutes % 60}m`;
        } else {
            return `${minutes}m`;
        }
    }

    function updateResponseTimeChart(distribution) {
        const responseCtx = document.getElementById('responseTimeChart').getContext('2d');
        new Chart(responseCtx, {
            type: 'bar',
            data: {
                labels: Object.values(distribution).map(d => d.name),
                datasets: [{
                    label: 'Tiempo de Respuesta (horas)',
                    data: Object.values(distribution).map(d => d.avgResponseTime ? d.avgResponseTime / (1000 * 60 * 60) : 0),
                    backgroundColor: '#F87171'
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return formatResponseTime(context.raw * 1000 * 60 * 60);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Horas'
                        }
                    }
                }
            }
        });
    }

    function updateDistributionCharts(distribution) {
        // Gráfico de distribución de leads
        const leadsCtx = document.getElementById('leadsDistributionChart').getContext('2d');
        new Chart(leadsCtx, {
            type: 'pie',
            data: {
                labels: Object.values(distribution).map(d => d.name),
                datasets: [{
                    data: Object.values(distribution).map(d => d.count),
                    backgroundColor: [
                        '#60A5FA', '#34D399', '#F87171', '#FBBF24', '#A78BFA', '#F472B6'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Gráfico de tasa de conversión
        const conversionCtx = document.getElementById('conversionRateChart').getContext('2d');
        new Chart(conversionCtx, {
            type: 'bar',
            data: {
                labels: Object.values(distribution).map(d => d.name),
                datasets: [{
                    label: 'Tasa de Conversión (%)',
                    data: Object.values(distribution).map(d => d.conversionRate),
                    backgroundColor: '#60A5FA'
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: value => value + '%'
                        }
                    }
                }
            }
        });
    }

    // Funciones de filtrado
    function filterLeads() {
        const searchTerm = searchInput.value.toLowerCase();
        const selectedStage = filterStage.value;
        const assignmentFilter = filterAssignment.value;

        let filteredLeads = leads.filter(lead => {
            const matchesSearch = (
                lead.name?.toLowerCase().includes(searchTerm) ||
                lead.email?.toLowerCase().includes(searchTerm) ||
                lead.phone?.toLowerCase().includes(searchTerm)
            );
            
            const matchesStage = !selectedStage || lead.stage_id.toString() === selectedStage;
            
            let assignmentMatch = true;
            if (assignmentFilter === 'unassigned') {
                assignmentMatch = lead.user_id === '0' || lead.user_id === 0;
            } else if (assignmentFilter === 'assigned') {
                assignmentMatch = lead.user_id !== '0' && lead.user_id !== 0;
            }

            return matchesSearch && matchesStage && assignmentMatch;
        });

        filteredLeads = sortLeads(filteredLeads, sortSelect.value);
        renderLeads(filteredLeads);
        updateStats(leads);
    }

    function sortLeads(leadsToSort, sortBy) {
        return [...leadsToSort].sort((a, b) => {
            switch(sortBy) {
                case 'date_desc':
                    return new Date(b.created_at) - new Date(a.created_at);
                case 'date_asc':
                    return new Date(a.created_at) - new Date(b.created_at);
                case 'name_asc':
                    return a.name.localeCompare(b.name);
                case 'name_desc':
                    return b.name.localeCompare(a.name);
                default:
                    return 0;
            }
        });
    }

    // Funciones de asignación
    async function assignSelectedLeads() {
        const selectedLeads = Array.from(document.querySelectorAll('.lead-checkbox:checked'))
            .map(cb => cb.dataset.leadId);
        const selectedUser = assignUser.value;

        if (selectedLeads.length === 0 || !selectedUser) {
            showNotification('Selecciona leads y un usuario para asignar', 'error');
            return;
        }

        showLoader();
        try {
            const promises = selectedLeads.map(leadId => 
                fetch('php/assign_lead.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        leadId: leadId,
                        userId: selectedUser
                    })
                }).then(response => response.json())
            );

            const results = await Promise.all(promises);
            const successCount = results.filter(r => r.success).length;
            
            showNotification(`${successCount} leads asignados correctamente`, 'success');
            await initialize();
            selectAll.checked = false;
            filterLeads();
        } catch (error) {
            console.error('Error en la asignación:', error);
            showNotification('Error al asignar los leads', 'error');
        } finally {
            hideLoader();
        }
    }

    function updateAssignButton() {
        const selectedLeads = document.querySelectorAll('.lead-checkbox:checked');
        const selectedUser = assignUser.value;
        assignButton.disabled = selectedLeads.length === 0 || !selectedUser;
        
        if (assignButton.disabled) {
            assignButton.classList.add('opacity-50', 'cursor-not-allowed');
        } else {
            assignButton.classList.remove('opacity-50', 'cursor-not-allowed');
        }

        document.getElementById('selectedLeadsCount').textContent = selectedLeads.length;
    }

    function updateStats(leads) {
        const unassignedLeads = leads.filter(lead => !lead.user_id || lead.user_id === '0').length;
        const assignedLeads = leads.length - unassignedLeads;

        document.getElementById('unassignedCount').textContent = unassignedLeads;
        document.getElementById('assignedCount').textContent = assignedLeads;
        document.getElementById('totalLeadsCount').textContent = leads.length;
    }

    // Funciones de utilidad
    function showLoader() {
        document.getElementById('loader').classList.remove('hidden');
    }

    function hideLoader() {
        document.getElementById('loader').classList.add('hidden');
    }

    function showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.className = `fixed bottom-4 right-4 px-6 py-3 rounded-lg text-white ${
            type === 'success' ? 'bg-green-500' : 'bg-red-500'
        }`;
        
        notification.innerHTML = `
            <div class="flex items-center">
                <i class="fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} mr-3"></i>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(notification);
        setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transition = 'opacity 0.5s ease';
            setTimeout(() => notification.remove(), 500);
        }, 3000);
    }

    // Event Listeners
    searchInput?.addEventListener('input', filterLeads);
    filterStage?.addEventListener('change', filterLeads);
    filterAssignment?.addEventListener('change', filterLeads);
    assignUser?.addEventListener('change', updateAssignButton);
    sortSelect?.addEventListener('change', filterLeads);
    
    selectAll?.addEventListener('change', (e) => {
        document.querySelectorAll('.lead-checkbox').forEach(checkbox => {
            checkbox.checked = e.target.checked;
        });
        updateAssignButton();
    });

    selectUnassignedBtn?.addEventListener('click', () => {
        document.querySelectorAll('.lead-checkbox').forEach(checkbox => {
            const leadCard = checkbox.closest('div').querySelector('.lead-card');
            if (leadCard && (leadCard.dataset.userId === '0' || leadCard.dataset.userId === 0)) {
                checkbox.checked = true;
            } else {
                checkbox.checked = false;
            }
        });
        updateAssignButton();
        showNotification('Leads sin asignar seleccionados', 'success');
    });

    clearSelectionBtn?.addEventListener('click', () => {
        selectAll.checked = false;
        document.querySelectorAll('.lead-checkbox').forEach(checkbox => {
            checkbox.checked = false;
        });
        updateAssignButton();
        showNotification('Selección limpiada', 'success');
    });

    assignButton?.addEventListener('click', () => {
        const selectedCount = document.querySelectorAll('.lead-checkbox:checked').length;
        document.getElementById('selectedLeadsCount').textContent = selectedCount;
        confirmationModal.classList.remove('hidden');
    });

    confirmAssignBtn?.addEventListener('click', async () => {
        confirmationModal.classList.add('hidden');
        await assignSelectedLeads();
    });

    cancelAssignBtn?.addEventListener('click', () => {
        confirmationModal.classList.add('hidden');
    });

    // Cerrar modal al hacer clic fuera
    window.addEventListener('click', (e) => {
        if (e.target === confirmationModal) {
            confirmationModal.classList.add('hidden');
        }
    });

    // Event listener para teclas
    document.addEventListener('keydown', (e) => {
        // Cerrar modal con Escape
        if (e.key === 'Escape' && !confirmationModal.classList.contains('hidden')) {
            confirmationModal.classList.add('hidden');
        }

        // Ctrl + A para seleccionar todos los leads
        if (e.ctrlKey && e.key === 'a') {
            e.preventDefault();
            selectAll.checked = !selectAll.checked;
            document.querySelectorAll('.lead-checkbox').forEach(checkbox => {
                checkbox.checked = selectAll.checked;
            });
            updateAssignButton();
        }

        // Ctrl + F para focus en búsqueda
        if (e.ctrlKey && e.key === 'f') {
            e.preventDefault();
            searchInput.focus();
        }
    });

    // Event listener para actualizaciones periódicas
    let updateInterval = setInterval(async () => {
        try {
            const response = await fetch('php/get_leads_with_history.php');
            const data = await response.json();
            
            if (data.leadsWithHistory) {
                const newLeads = data.leadsWithHistory;
                // Comparar si hay cambios
                if (JSON.stringify(leads) !== JSON.stringify(newLeads)) {
                    leads = newLeads;
                    filterLeads(); // Aplicar los filtros actuales a los nuevos datos
                    updateStats(leads);
                    updateDistributionTable(leads, users);
                    showNotification('Datos actualizados', 'success');
                }
            }
        } catch (error) {
            console.error('Error en actualización automática:', error);
            clearInterval(updateInterval);
        }
    }, 300000); // Actualizar cada 5 minutos

    // Limpiar interval al salir de la página
    window.addEventListener('beforeunload', () => {
        clearInterval(updateInterval);
    });

    // Inicializar la página
    initialize();
});