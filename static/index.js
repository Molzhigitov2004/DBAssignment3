// Configuration
const API_BASE_URL = "";

// --- Navigation Logic ---
function showTab(tabId) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.nav-btn').forEach(btn => btn.classList.remove('active'));
    document.getElementById(tabId).classList.add('active');
    
    // Highlight button
    const ids = ['users-section', 'caregivers-section', 'members-section', 'jobs-section', 'applications-section', 'appointments-section'];
    const btnIndex = ids.indexOf(tabId);
    if(btnIndex >= 0) document.querySelectorAll('.nav-btn')[btnIndex].classList.add('active');

    // Load data
    if(tabId === 'users-section') loadUsers();
    if(tabId === 'caregivers-section') loadCaregivers();
    if(tabId === 'members-section') loadMembers();
    if(tabId === 'jobs-section') loadJobs();
    if(tabId === 'applications-section') loadApplications();
    if(tabId === 'appointments-section') loadAppointments();
}

function toggleForm(formId) {
    const form = document.getElementById(formId);
    form.classList.toggle('hidden');
    if (form.classList.contains('hidden')) {
        form.querySelector('form').reset();
        const idField = form.querySelector('input[type="hidden"]');
        if(idField) idField.value = '';
    }
}

// --- GENERIC FETCH HELPER ---
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

// ================= 1. USERS =================
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
    
    toggleForm('user-form-container');
    loadUsers();
});

function editUser(user) {
    toggleForm('user-form-container');
    document.getElementById('user-form-container').classList.remove('hidden'); // Ensure visible
    document.getElementById('user_id').value = user.user_id;
    document.getElementById('email').value = user.email;
    document.getElementById('given_name').value = user.given_name;
    document.getElementById('surname').value = user.surname;
    document.getElementById('city').value = user.city;
    document.getElementById('phone_number').value = user.phone_number;
    document.getElementById('password').value = user.password; 
    document.getElementById('profile_description').value = user.profile_description;
}

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
                <td>${item.hourly_rate}</td>
                <td>${item.gender}</td>
                <td>
                    <button class="btn-danger action-btn" onclick="deleteItem('/caregivers/${item.caregiver_user_id}', loadCaregivers)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

document.getElementById('caregiver-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = {
        caregiver_user_id: document.getElementById('cg_user_id').value,
        caregiving_type: document.getElementById('cg_type').value,
        hourly_rate: document.getElementById('cg_hourly_rate').value,
        gender: document.getElementById('cg_gender').value,
    };
    await apiRequest('/caregivers', 'POST', data);
    toggleForm('caregiver-form-container');
    loadCaregivers();
});

// ================= 3. MEMBERS (AND ADDRESSES) =================
async function loadMembers() {
    const data = await apiRequest('/members');
    const tbody = document.getElementById('members-table-body');
    tbody.innerHTML = '';
    if(data) {
        data.forEach(item => {
            // Check if address exists
            let addrStr = "No Address";
            if(item.address) {
                addrStr = `${item.address.house_number} ${item.address.street}, ${item.address.town}`;
            }

            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${item.member_user_id}</td>
                <td>${item.dependent_description || ''}</td>
                <td>${item.house_rules || ''}</td>
                <td>${addrStr}</td>
                <td>
                    <button class="btn-danger action-btn" onclick="deleteItem('/members/${item.member_user_id}', loadMembers)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

document.getElementById('member-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    // Construct Address Object if fields are filled
    let addressObj = null;
    if(document.getElementById('addr_street').value) {
        addressObj = {
            house_number: document.getElementById('addr_house').value,
            street: document.getElementById('addr_street').value,
            town: document.getElementById('addr_town').value
        };
    }

    const data = {
        member_user_id: document.getElementById('mem_user_id').value,
        house_rules: document.getElementById('mem_rules').value,
        dependent_description: document.getElementById('mem_desc').value,
        address: addressObj
    };

    await apiRequest('/members', 'POST', data);
    toggleForm('member-form-container');
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
                    <button class="btn-danger action-btn" onclick="deleteItem('/jobs/${item.job_id}', loadJobs)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

document.getElementById('job-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = {
        member_user_id: document.getElementById('job_member_id').value,
        required_caregiving_type: document.getElementById('required_caregiving_type').value,
        other_requirements: document.getElementById('other_requirements').value,
        date_posted: document.getElementById('date_posted').value
    };
    await apiRequest('/jobs', 'POST', data);
    toggleForm('job-form-container');
    loadJobs();
});

// ================= 5. JOB APPLICATIONS =================
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
                    <button class="btn-danger action-btn" onclick="deleteItem('/job_applications/${item.caregiver_user_id}/${item.job_id}', loadApplications)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

document.getElementById('application-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = {
        caregiver_user_id: document.getElementById('app_cg_id').value,
        job_id: document.getElementById('app_job_id').value,
        date_applied: document.getElementById('app_date').value
    };
    await apiRequest('/job_applications', 'POST', data);
    toggleForm('app-form-container');
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
                    <button class="btn-danger action-btn" onclick="deleteItem('/appointments/${item.appointment_id}', loadAppointments)">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

document.getElementById('appointment-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    // Format Time to HH:MM:SS if needed, input type="time" gives HH:MM
    let timeVal = document.getElementById('apt_time').value;
    if(timeVal.length === 5) timeVal += ":00";

    const data = {
        caregiver_user_id: document.getElementById('apt_cg_id').value,
        member_user_id: document.getElementById('apt_mem_id').value,
        appointment_date: document.getElementById('apt_date').value,
        appointment_time: timeVal, 
        work_hours: document.getElementById('apt_hours').value,
        status: document.getElementById('apt_status').value
    };
    await apiRequest('/appointments', 'POST', data);
    toggleForm('apt-form-container');
    loadAppointments();
});

// --- HELPER FOR DELETION ---
async function deleteItem(endpoint, refreshCallback) {
    if(confirm('Are you sure you want to delete this item?')) {
        await apiRequest(endpoint, 'DELETE');
        refreshCallback();
    }
}

// Initialize
loadUsers();