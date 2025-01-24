<!-- Modal de Nueva Comunicación -->
<div id="communicationModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden z-50">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-medium text-gray-900">Nueva Comunicación</h3>
                <button onclick="closeModal('communicationModal')" class="text-gray-400 hover:text-gray-500">
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
                    <button type="button" onclick="closeModal('communicationModal')" 
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
                <button type="button" onclick="closeFileModal()" class="text-gray-400 hover:text-gray-500">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="fileForm" class="space-y-4">
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
                    <button type="button" onclick="closeFileModal()" 
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

<!-- Modal de Edición -->
<div id="editModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full hidden z-50">
    <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
        <div class="mt-3">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-lg font-medium text-gray-900">Editar Lead</h3>
                <button onclick="closeModal('editModal')" class="text-gray-400 hover:text-gray-500">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <form id="editForm" class="space-y-4">
                <!-- Los campos se llenarán dinámicamente -->
            </form>
        </div>
    </div>
</div>

<!-- Template para comunicaciones -->
<template id="communicationTemplate">
    <div class="bg-gray-50 p-4 rounded-lg">
        <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-medium text-gray-700 communication-user"></span>
            <span class="text-sm text-gray-500 communication-date"></span>
        </div>
        <div class="flex items-start">
            <div class="flex-shrink-0 communication-icon"></div>
            <p class="ml-3 text-sm text-gray-700 communication-description"></p>
        </div>
    </div>
</template>

<!-- Template para archivos -->
<template id="fileTemplate">
    <div class="flex items-center justify-between py-2">
        <div class="flex items-center">
            <i class="far fa-file mr-2 text-gray-500"></i>
            <a href="#" class="text-blue-600 hover:text-blue-800 text-sm file-name"></a>
        </div>
        <div class="flex items-center space-x-2">
            <span class="text-xs text-gray-500 file-date"></span>
            <button class="text-red-600 hover:text-red-800 delete-file">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    </div>
</template>