// Configuration: Change this URL to match your Python backend
const API_BASE_URL = "";

// --- Navigation Logic ---
function showTab(tabId) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.nav-btn').forEach(btn => btn.classList.remove('active'));
    
    // Show selected tab
    document.getElementById(tabId).classList.add('active');
    
    // Highlight button (simple matching logic)
    const btnIndex = ['users-section', 'caregivers-section', 'members-section', 'jobs-section', 'appointments-section'].indexOf(tabId);
    document.querySelectorAll('.nav-btn')[btnIndex].classList.add('active');

    // Load data for that tab
    if(tabId === 'users-section') loadUsers();
    if(tabId === 'jobs-section') loadJobs();
    if(tabId === 'caregivers-section') loadCaregivers();
}

function toggleForm(formId) {
    const form = document.getElementById(formId);
    form.classList.toggle('hidden');
    // Reset form if closing
    if (form.classList.contains('hidden')) {
        form.querySelector('form').reset();
        // Reset hidden ID field
        const idField = form.querySelector('input[type="hidden"]');
        if(idField) idField.value = '';
    }
}

// --- GENERIC FETCH HELPER ---
async function apiRequest(endpoint, method = 'GET', body = null) {

    if (!endpoint.endsWith('/')) {
        endpoint += '/'; 
    }

    const options = {
        method: method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (body) options.body = JSON.stringify(body);

    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
        if (!response.ok) throw new Error('API Error');
        return method === 'GET' ? await response.json() : await response.json(); // Adjust based on your backend response
    } catch (error) {
        console.error("Error:", error);
        alert("Operation failed. Check console.");
    }
}

// ================= USERS LOGIC =================

async function loadUsers() {
    const users = await apiRequest('/users'); // Expects list of dicts
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
                <td>${user.phone_number}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editUser(${JSON.stringify(user)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteUser(${user.user_id})">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

// Handle User Form Submit (Create & Update)
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

    if (id) {
        // Update
        await apiRequest(`/users/${id}`, 'PUT', data);
    } else {
        // Create
        await apiRequest('/users', 'POST', data);
    }

    toggleForm('user-form-container');
    loadUsers();
});

function editUser(user) {
    document.getElementById('user-form-container').classList.remove('hidden');
    document.getElementById('user_id').value = user.user_id;
    document.getElementById('email').value = user.email;
    document.getElementById('given_name').value = user.given_name;
    document.getElementById('surname').value = user.surname;
    document.getElementById('city').value = user.city;
    document.getElementById('phone_number').value = user.phone_number;
    document.getElementById('password').value = user.password; // Might leave blank for security in real app
    document.getElementById('profile_description').value = user.profile_description;
    document.getElementById('user-form-title').innerText = "Edit User";
}

async function deleteUser(id) {
    if(confirm('Are you sure? This will delete related Caregiver/Member profiles too.')) {
        await apiRequest(`/users/${id}`, 'DELETE');
        loadUsers();
    }
}

// ================= JOBS LOGIC =================

async function loadJobs() {
    const jobs = await apiRequest('/jobs');
    const tbody = document.getElementById('jobs-table-body');
    tbody.innerHTML = '';

    if(jobs) {
        jobs.forEach(job => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${job.job_id}</td>
                <td>${job.member_user_id}</td>
                <td>${job.required_caregiving_type}</td>
                <td>${job.date_posted}</td>
                <td>
                    <button class="btn-primary action-btn" onclick='editJob(${JSON.stringify(job)})'>Edit</button>
                    <button class="btn-danger action-btn" onclick="deleteJob(${job.job_id})">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
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

    if (id) {
        await apiRequest(`/jobs/${id}`, 'PUT', data);
    } else {
        await apiRequest('/jobs', 'POST', data);
    }
    toggleForm('job-form-container');
    loadJobs();
});

function editJob(job) {
    document.getElementById('job-form-container').classList.remove('hidden');
    document.getElementById('job_id').value = job.job_id;
    document.getElementById('job_member_id').value = job.member_user_id;
    document.getElementById('required_caregiving_type').value = job.required_caregiving_type;
    document.getElementById('other_requirements').value = job.other_requirements;
    // formatting date for input type=date
    const dateObj = new Date(job.date_posted);
    document.getElementById('date_posted').value = dateObj.toISOString().split('T')[0];
}

async function deleteJob(id) {
    if(confirm('Delete this job advertisement?')) {
        await apiRequest(`/jobs/${id}`, 'DELETE');
        loadJobs();
    }
}

// ================= CAREGIVERS LOGIC (Simple Read) =================
async function loadCaregivers() {
    const caregivers = await apiRequest('/caregivers');
    const tbody = document.getElementById('caregivers-table-body');
    tbody.innerHTML = '';
    if(caregivers) {
        caregivers.forEach(cg => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${cg.caregiver_user_id}</td>
                <td>${cg.caregiving_type}</td>
                <td>$${cg.hourly_rate}</td>
                <td>
                    <button class="btn-danger" onclick="alert('Implement delete logic like User')">Delete</button>
                </td>
            `;
            tbody.appendChild(tr);
        });
    }
}

// Initialize
loadUsers();