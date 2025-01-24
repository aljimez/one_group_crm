document.addEventListener('DOMContentLoaded', () => {
    // Referencias a elementos DOM
    const loader = document.getElementById('loader');
    const logoutBtn = document.getElementById('logoutBtn');
    
    // Charts
    let charts = {
        leads: null,
        calls: null,
        funnel: null,
        stage: null,
        source: null,
        performance: null
    };

    // Función principal para cargar datos
    async function loadAnalytics() {
        showLoader();
        try {
            const response = await fetch('php/get_leads_with_history.php');
            const data = await response.json();

            if (data.error) {
                throw new Error(data.error);
            }

            if (!data.leadsWithHistory || !Array.isArray(data.leadsWithHistory)) {
                throw new Error('Invalid data structure');
            }

            updateStats(data.leadsWithHistory);
            updateCharts(data.leadsWithHistory);
        } catch (error) {
            console.error('Error:', error);
            showNotification('Error al cargar los datos', 'error');
        } finally {
            hideLoader();
        }
    }

    // Función para actualizar estadísticas
    function updateStats(leads) {
        const now = new Date();
        const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

        const monthlyLeads = leads.filter(lead => 
            new Date(lead.created_at) >= startOfMonth
        ).length;

        const monthlyContacted = leads.filter(lead => 
            lead.stage_id === 2 &&
            new Date(lead.created_at) >= startOfMonth
        ).length;

        const monthlyCaptured = leads.filter(lead => 
            lead.stage_id === 6 &&
            new Date(lead.created_at) >= startOfMonth
        ).length;

        const conversionRate = monthlyLeads > 0 
            ? ((monthlyCaptured / monthlyLeads) * 100).toFixed(1) 
            : 0;

        document.getElementById('leadsThisMonth').textContent = monthlyLeads;
        document.getElementById('contactedThisMonth').textContent = monthlyContacted;
        document.getElementById('capturedThisMonth').textContent = monthlyCaptured;
        document.getElementById('conversionRate').textContent = `${conversionRate}%`;
    }

    // Función para actualizar todos los gráficos
    function updateCharts(leads) {
        updateLeadsChart(leads);
        updateCallsChart(leads);
        updateFunnelChart(leads);
        updateStageChart(leads);
        updateSourceChart(leads);
        updatePerformanceChart(leads);
    }

    // Funciones individuales para cada gráfico
    function updateLeadsChart(leads) {
        const ctx = document.getElementById('leadsChart').getContext('2d');
        const dates = getLastSevenDays();
        const leadsData = getLeadsPerDay(leads, dates);
        
        if (charts.leads) charts.leads.destroy();
        
        charts.leads = new Chart(ctx, {
            type: 'line',
            data: {
                labels: dates.map(date => {
                    const [year, month, day] = date.split('-');
                    return `${day}/${month}`;
                }),
                datasets: [{
                    label: 'Nuevos Leads',
                    data: leadsData,
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    }

    function updateCallsChart(leads) {
        const ctx = document.getElementById('callsChart').getContext('2d');
        const dates = getLastSevenDays();
        const callsData = getCallsPerDay(leads, dates);
        
        if (charts.calls) charts.calls.destroy();
        
        charts.calls = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: dates.map(date => {
                    const [year, month, day] = date.split('-');
                    return `${day}/${month}`;
                }),
                datasets: [{
                    label: 'Contactos Realizados',
                    data: callsData,
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgb(255, 99, 132)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    }
                }
            }
        });
    }

    function updateFunnelChart(leads) {
        const ctx = document.getElementById('funnelChart').getContext('2d');
        const stages = [
            { id: 1, name: 'Nuevo' },
            { id: 2, name: 'Contactado' },
            { id: 3, name: 'Interesado' },
            { id: 4, name: 'Reunión' },
            { id: 5, name: 'Negociación' },
            { id: 6, name: 'Cliente' }
        ];

        const stageData = stages.map(stage => ({
            stage: stage.name,
            count: leads.filter(lead => lead.stage_id === stage.id).length
        }));

        if (charts.funnel) charts.funnel.destroy();

        charts.funnel = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: stageData.map(d => d.stage),
                datasets: [{
                    data: stageData.map(d => d.count),
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgb(54, 162, 235)',
                    borderWidth: 1
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    }

    function updateStageChart(leads) {
        const ctx = document.getElementById('stageChart').getContext('2d');
        const stagesCount = {};
        
        leads.forEach(lead => {
            stagesCount[lead.stage_name] = (stagesCount[lead.stage_name] || 0) + 1;
        });

        if (charts.stage) charts.stage.destroy();

        charts.stage = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(stagesCount),
                datasets: [{
                    data: Object.values(stagesCount),
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgb(255, 99, 132)',
                        'rgb(54, 162, 235)',
                        'rgb(255, 206, 86)',
                        'rgb(75, 192, 192)',
                        'rgb(153, 102, 255)',
                        'rgb(255, 159, 64)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
            }
        });
    }

    function updateSourceChart(leads) {
        const ctx = document.getElementById('sourceChart').getContext('2d');
        const sourcesCount = {};
        
        leads.forEach(lead => {
            if (lead.source) {
                sourcesCount[lead.source] = (sourcesCount[lead.source] || 0) + 1;
            }
        });

        if (charts.source) charts.source.destroy();

        charts.source = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: Object.keys(sourcesCount),
                datasets: [{
                    data: Object.values(sourcesCount),
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)'
                    ],
                    borderColor: [
                        'rgb(255, 99, 132)',
                        'rgb(54, 162, 235)',
                        'rgb(255, 206, 86)',
                        'rgb(75, 192, 192)',
                        'rgb(153, 102, 255)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
            }
        });
    }

    function updatePerformanceChart(leads) {
        const ctx = document.getElementById('performanceChart').getContext('2d');
        const months = getLastSixMonths();
        const performanceData = months.map(month => {
            const monthStart = new Date(month);
            const monthEnd = new Date(monthStart.getFullYear(), monthStart.getMonth() + 1, 0);
            
            const monthLeads = leads.filter(lead => {
                const leadDate = new Date(lead.created_at);
                return leadDate >= monthStart && leadDate <= monthEnd;
            });

            const captured = monthLeads.filter(lead => lead.stage_id === 6).length;
            return {
                leads: monthLeads.length,
                captured: captured,
                rate: monthLeads.length ? (captured / monthLeads.length) * 100 : 0
            };
        });

        if (charts.performance) charts.performance.destroy();

        charts.performance = new Chart(ctx, {
            type: 'line',
            data: {
                labels: months.map(month => {
                    return new Date(month).toLocaleDateString('es-ES', { month: 'short' });
                }),
                datasets: [
                    {
                        label: 'Leads',
                        data: performanceData.map(d => d.leads),
                        borderColor: 'rgb(75, 192, 192)',
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        yAxisID: 'y'
                    },
                    {
                        label: 'Tasa de Conversión (%)',
                        data: performanceData.map(d => d.rate),
                        borderColor: 'rgb(255, 159, 64)',
                        backgroundColor: 'rgba(255, 159, 64, 0.2)',
                        yAxisID: 'y1'
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        type: 'linear',
                        display: true,
                        position: 'left',
                        title: {
                            display: true,
                            text: 'Número de Leads'
                        }
                    },
                    y1: {
                        type: 'linear',
                        display: true,
                        position: 'right',
                        title: {
                            display: true,
                            text: 'Tasa de Conversión (%)'
                        },
                        grid: {
                            drawOnChartArea: false
                        }
                    }
                }
            }
        });
    }

    // Funciones de utilidad
    function getLastSevenDays() {
        const dates = [];
        for (let i = 6; i >= 0; i--) {
            const date = new Date();
            date.setDate(date.getDate() - i);
            dates.push(date.toISOString().split('T')[0]);
        }
        return dates;
    }

    function getLastSixMonths() {
        const months = [];
        const date = new Date();
        for (let i = 5; i >= 0; i--) {
            const month = new Date(date.getFullYear(), date.getMonth() - i, 1);
            months.push(month.toISOString().split('T')[0]);
        }
        return months;
    }

    function getLeadsPerDay(leads, dates) {
        return dates.map(date => {
            return leads.filter(lead => 
                lead.created_at.split('T')[0] === date
            ).length;
        });
    }

    function getCallsPerDay(leads, dates) {
        return dates.map(date => {
            return leads.filter(lead => 
                lead.history?.some(h => 
                    h.stage_id === 2 && 
                    h.changed_at.split(' ')[0] === date
                )
            ).length;
        });
    }

    function showLoader() {
        loader.style.display = 'flex';
    }

    function hideLoader() {
        loader.style.display = 'none';
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

    // Inicializar la página
    loadAnalytics();

    // Actualizar datos cada 5 minutos
    setInterval(loadAnalytics, 300000);
});