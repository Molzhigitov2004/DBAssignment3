// Configuration
const API_BASE_URL = ""; // Empty string allows browser to use relative path

// --- Navigation Logic ---
function showTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.nav-btn').forEach(btn => btn.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    
    const ids = ['users-section', 'caregivers-section', 'members-section', 'jobs-section', 'applications-section', 'appointments-section'];
    const btnIndex = ids.indexOf(tabId);
    if(btnIndex >= 0) document.querySelectorAll('.nav-btn')[btnIndex].classList.add('active');

    if(tabId === 'users-section') loadUsers();
    if(tabId === 'caregivers-section') loadCaregivers();
    if(tabId === 'members-section') loadMembers();
    if(tabId === 'jobs-section') loadJobs();
    if(tabId === 'applications-section') loadApplications();
    if(tabId === 'appointments-section') loadAppointments();
}

// --- Form Helper Functions ---
function openForm(formId) {
    const formContainer = document.getElementById(formId);
    const form = formContainer.querySelector('form');
    form.reset(); // Clear previous data
    
    // Clear all hidden ID inputs
    form.querySelectorAll('input[type="hidden"]').forEach(input => {
        if(input.id.includes('_is_edit')) input.value = 'false';
        else input.value = '';
    });

    formContainer.classList.remove('hidden');
}

function closeForm(formId) {
    document.getElementById(formId).classList.add('hidden');
}

// --- API Helper ---
async function apiRequest(endpoint, method = 'GET', body = null) {
    if (!endpoint.endsWith('/')) endpoint += '/'; 

    const options = {
        method: method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (body) options.body = JSON.stringify(body);

    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
        if (!response.ok) {
            const err = await response.json();
            throw new Error(err.detail || 'API Error');
        }
        return await response.json();
    } catch (error) {
        console.error("Error:", error);
        alert("Error: " + error.message);
    }
}

// ================= 1. USERS (CRUD: Create, Read, Update, Delete) =================
async function loadUsers() {
    const users = await apiRequest('/users');
    const tbody = document.getElementById('users-table-body');
    tbody.innerHTML = '';
    if(users) {
        users.forEach(user => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${user.user_id}</td>
                <td>${user.given_name} ${user.surname}</td>
                <td>${user.email}</td>
                <td>${user.city}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editUser(${JSON.stringify(user)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteItem('/users/${user.user_id}', loadUsers)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

function editUser(user) {
    openForm('user-form-container');
    document.getElementById('user_id').value = user.user_id;
    document.getElementById('email').value = user.email;
    document.getElementById('given_name').value = user.given_name;
    document.getElementById('surname').value = user.surname;
    document.getElementById('city').value = user.city;
    document.getElementById('phone_number').value = user.phone_number;
    document.getElementById('password').value = user.password; 
    document.getElementById('profile_description').value = user.profile_description;
    document.getElementById('user-form-title').innerText = "Edit User (ID: " + user.user_id + ")";
}

document.getElementById('user-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = document.getElementById('user_id').value;
    const data = {
        email: document.getElementById('email').value,
        given_name: document.getElementById('given_name').value,
        surname: document.getElementById('surname').value,
        city: document.getElementById('city').value,
        phone_number: document.getElementById('phone_number').value,
        password: document.getElementById('password').value,
        profile_description: document.getElementById('profile_description').value
    };
    if (id) await apiRequest(`/users/${id}`, 'PUT', data);
    else await apiRequest('/users', 'POST', data);
    closeForm('user-form-container');
    loadUsers();
});

// ================= 2. CAREGIVERS =================
async function loadCaregivers() {
    const data = await apiRequest('/caregivers');
    const tbody = document.getElementById('caregivers-table-body');
    tbody.innerHTML = '';
    if(data) {
        data.forEach(item => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.caregiver_user_id}</td>
                <td>${item.caregiving_type}</td>
                <td>$${item.hourly_rate}</td>
                <td>${item.gender}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editCaregiver(${JSON.stringify(item)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteItem('/caregivers/${item.caregiver_user_id}', loadCaregivers)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

function editCaregiver(item) {
    openForm('caregiver-form-container');
    document.getElementById('cg_is_edit').value = 'true';
    document.getElementById('cg_user_id').value = item.caregiver_user_id;
    document.getElementById('cg_user_id').readOnly = true; // PK cannot be changed on edit
    document.getElementById('cg_type').value = item.caregiving_type;
    document.getElementById('cg_hourly_rate').value = item.hourly_rate;
    document.getElementById('cg_gender').value = item.gender;
}

document.getElementById('caregiver-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = document.getElementById('cg_user_id').value;
    const isEdit = document.getElementById('cg_is_edit').value === 'true';
    const data = {
        caregiver_user_id: id,
        caregiving_type: document.getElementById('cg_type').value,
        hourly_rate: document.getElementById('cg_hourly_rate').value,
        gender: document.getElementById('cg_gender').value,
    };
    
    if(isEdit) await apiRequest(`/caregivers/${id}`, 'PUT', data);
    else await apiRequest('/caregivers', 'POST', data);
    
    closeForm('caregiver-form-container');
    document.getElementById('cg_user_id').readOnly = false;
    loadCaregivers();
});

// ================= 3. MEMBERS =================
async function loadMembers() {
    const data = await apiRequest('/members');
    const tbody = document.getElementById('members-table-body');
    tbody.innerHTML = '';
    if(data) {
        data.forEach(item => {
            let addrStr = item.address ? `${item.address.house_number} ${item.address.street}, ${item.address.town}` : "No Address";
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.member_user_id}</td>
                <td>${item.dependent_description || ''}</td>
                <td>${item.house_rules || ''}</td>
                <td>${addrStr}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editMember(${JSON.stringify(item)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteItem('/members/${item.member_user_id}', loadMembers)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

function editMember(item) {
    openForm('member-form-container');
    document.getElementById('mem_is_edit').value = 'true';
    document.getElementById('mem_user_id').value = item.member_user_id;
    document.getElementById('mem_user_id').readOnly = true; // PK read only
    document.getElementById('mem_desc').value = item.dependent_description;
    document.getElementById('mem_rules').value = item.house_rules;
    
    if(item.address) {
        document.getElementById('addr_house').value = item.address.house_number;
        document.getElementById('addr_street').value = item.address.street;
        document.getElementById('addr_town').value = item.address.town;
    }
}

document.getElementById('member-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = document.getElementById('mem_user_id').value;
    const isEdit = document.getElementById('mem_is_edit').value === 'true';

    let addressObj = null;
    if(document.getElementById('addr_street').value) {
        addressObj = {
            house_number: document.getElementById('addr_house').value,
            street: document.getElementById('addr_street').value,
            town: document.getElementById('addr_town').value
        };
    }

    const data = {
        member_user_id: id,
        house_rules: document.getElementById('mem_rules').value,
        dependent_description: document.getElementById('mem_desc').value,
        address: addressObj
    };

    if(isEdit) await apiRequest(`/members/${id}`, 'PUT', data);
    else await apiRequest('/members', 'POST', data);

    closeForm('member-form-container');
    document.getElementById('mem_user_id').readOnly = false;
    loadMembers();
});

// ================= 4. JOBS =================
async function loadJobs() {
    const data = await apiRequest('/jobs');
    const tbody = document.getElementById('jobs-table-body');
    tbody.innerHTML = '';
    if(data) {
        data.forEach(item => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.job_id}</td>
                <td>${item.member_user_id}</td>
                <td>${item.required_caregiving_type}</td>
                <td>${item.date_posted}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editJob(${JSON.stringify(item)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteItem('/jobs/${item.job_id}', loadJobs)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

function editJob(item) {
    openForm('job-form-container');
    document.getElementById('job_id').value = item.job_id;
    document.getElementById('job_member_id').value = item.member_user_id;
    document.getElementById('required_caregiving_type').value = item.required_caregiving_type;
    document.getElementById('other_requirements').value = item.other_requirements;
    document.getElementById('date_posted').value = item.date_posted;
}

document.getElementById('job-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = document.getElementById('job_id').value;
    const data = {
        member_user_id: document.getElementById('job_member_id').value,
        required_caregiving_type: document.getElementById('required_caregiving_type').value,
        other_requirements: document.getElementById('other_requirements').value,
        date_posted: document.getElementById('date_posted').value
    };
    if(id) await apiRequest(`/jobs/${id}`, 'PUT', data);
    else await apiRequest('/jobs', 'POST', data);
    closeForm('job-form-container');
    loadJobs();
});

// ================= 5. JOB APPLICATIONS (Composite Key) =================
async function loadApplications() {
    const data = await apiRequest('/job_applications');
    const tbody = document.getElementById('applications-table-body');
    tbody.innerHTML = '';
    if(data) {
        data.forEach(item => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.caregiver_user_id}</td>
                <td>${item.job_id}</td>
                <td>${item.date_applied}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editApplication(${JSON.stringify(item)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteItem('/job_applications/${item.caregiver_user_id}/${item.job_id}', loadApplications)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

function editApplication(item) {
    openForm('app-form-container');
    document.getElementById('app_is_edit').value = 'true';
    document.getElementById('app_cg_id').value = item.caregiver_user_id;
    document.getElementById('app_cg_id').readOnly = true;
    document.getElementById('app_job_id').value = item.job_id;
    document.getElementById('app_job_id').readOnly = true;
    document.getElementById('app_date').value = item.date_applied;
}

document.getElementById('application-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const cgId = document.getElementById('app_cg_id').value;
    const jobId = document.getElementById('app_job_id').value;
    const isEdit = document.getElementById('app_is_edit').value === 'true';
    
    const data = {
        caregiver_user_id: cgId,
        job_id: jobId,
        date_applied: document.getElementById('app_date').value
    };
    
    if(isEdit) await apiRequest(`/job_applications/${cgId}/${jobId}`, 'PUT', data);
    else await apiRequest('/job_applications', 'POST', data);

    closeForm('app-form-container');
    document.getElementById('app_cg_id').readOnly = false;
    document.getElementById('app_job_id').readOnly = false;
    loadApplications();
});

// ================= 6. APPOINTMENTS =================
async function loadAppointments() {
    const data = await apiRequest('/appointments');
    const tbody = document.getElementById('appointments-table-body');
    tbody.innerHTML = '';
    if(data) {
        data.forEach(item => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.appointment_id}</td>
                <td>${item.caregiver_user_id}</td>
                <td>${item.member_user_id}</td>
                <td>${item.appointment_date} ${item.appointment_time}</td>
                <td>${item.status}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editAppointment(${JSON.stringify(item)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteItem('/appointments/${item.appointment_id}', loadAppointments)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

function editAppointment(item) {
    openForm('apt-form-container');
    document.getElementById('apt_id').value = item.appointment_id;
    document.getElementById('apt_cg_id').value = item.caregiver_user_id;
    document.getElementById('apt_mem_id').value = item.member_user_id;
    document.getElementById('apt_date').value = item.appointment_date;
    // Helper: Time comes as HH:MM:SS, input accepts HH:MM
    document.getElementById('apt_time').value = item.appointment_time.substring(0,5);
    document.getElementById('apt_hours').value = item.work_hours;
    document.getElementById('apt_status').value = item.status;
}

document.getElementById('appointment-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const id = document.getElementById('apt_id').value;
    let timeVal = document.getElementById('apt_time').value;
    if(timeVal.length === 5) timeVal += ":00"; // Ensure SS

    const data = {
        caregiver_user_id: document.getElementById('apt_cg_id').value,
        member_user_id: document.getElementById('apt_mem_id').value,
        appointment_date: document.getElementById('apt_date').value,
        appointment_time: timeVal,
        work_hours: document.getElementById('apt_hours').value,
        status: document.getElementById('apt_status').value
    };
    
    if(id) await apiRequest(`/appointments/${id}`, 'PUT', data);
    else await apiRequest('/appointments', 'POST', data);
    
    closeForm('apt-form-container');
    loadAppointments();
});

// --- UTILS ---
async function deleteItem(endpoint, refreshCallback) {
    if(confirm('Are you sure you want to delete this item?')) {
        await apiRequest(endpoint, 'DELETE');
        refreshCallback();
    }
}

// Initialize
loadUsers();