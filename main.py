from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from fastapi.middleware.cors import CORSMiddleware
from datetime import date
from fastapi.staticfiles import StaticFiles

from database import get_db
import models
import schemas

from fastapi.staticfiles import StaticFiles
app = FastAPI(title="Caregiver Platform API")
app.mount("/static", StaticFiles(directory="static"), name="static")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins (for development)
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (GET, POST, PUT, DELETE)
    allow_headers=["*"],  # Allows all headers
)


@app.post("/users/", response_model=schemas.UserRead)
def create_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    existing = db.query(models.User).filter(models.User.email == user.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already exists")

    db_user = models.User(
        email=user.email,
        given_name=user.given_name,
        surname=user.surname,
        city=user.city,
        phone_number=user.phone_number,
        profile_description=user.profile_description,
        password=user.password,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.get("/users/", response_model=list[schemas.UserRead])
def list_users(db: Session = Depends(get_db)):
    users = db.query(models.User).all()
    return users

@app.get("/users/{user_id}/", response_model=schemas.UserRead)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.put("/users/{user_id}/", response_model=schemas.UserRead)
def update_user(user_id: int, data: schemas.UserUpdate, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    for field, value in data.dict(exclude_unset=True).items():
        setattr(user, field, value)

    db.commit()
    db.refresh(user)
    return user

@app.delete("/users/{user_id}/")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    db.delete(user)
    db.commit()
    return {"detail": "User deleted"}


@app.post("/caregivers/", response_model=schemas.CaregiverRead)
def create_caregiver(cg: schemas.CaregiverCreate, db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.user_id == cg.caregiver_user_id).first()
    if not user:
        raise HTTPException(status_code=400, detail="User does not exist")

    existing = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == cg.caregiver_user_id
    ).first()
    if existing:
        raise HTTPException(
            status_code=400,
            detail="Caregiver profile already exists for this user"
        )

    db_cg = models.Caregiver(
        caregiver_user_id=cg.caregiver_user_id,
        gender=cg.gender,
        caregiving_type=cg.caregiving_type,
        hourly_rate=cg.hourly_rate
    )
    db.add(db_cg)
    db.commit()
    db.refresh(db_cg)
    return db_cg

@app.get("/caregivers/", response_model=list[schemas.CaregiverRead])
def list_caregivers(db: Session = Depends(get_db)):
    return db.query(models.Caregiver).all()

@app.get("/caregivers/{caregiver_user_id}/", response_model=schemas.CaregiverRead)
def get_caregiver(caregiver_user_id: int, db: Session = Depends(get_db)):
    cg = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == caregiver_user_id
    ).first()
    if not cg:
        raise HTTPException(status_code=404, detail="Caregiver not found")
    return cg

@app.put("/caregivers/{caregiver_user_id}/", response_model=schemas.CaregiverRead)
def update_caregiver(caregiver_user_id: int, data: schemas.CaregiverUpdate, db: Session = Depends(get_db)):
    cg = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == caregiver_user_id
    ).first()
    if not cg:
        raise HTTPException(status_code=404, detail="Caregiver not found")

    for field, value in data.dict(exclude_unset=True).items():
        setattr(cg, field, value)

    db.commit()
    db.refresh(cg)
    return cg

@app.delete("/caregivers/{caregiver_user_id}/")
def delete_caregiver(caregiver_user_id: int, db: Session = Depends(get_db)):
    cg = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == caregiver_user_id
    ).first()
    if not cg:
        raise HTTPException(status_code=404, detail="Caregiver not found")

    db.delete(cg)
    db.commit()
    return {"detail": "Caregiver deleted"}


@app.post("/members/", response_model=schemas.MemberRead)
def create_member(member: schemas.MemberCreate, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == member.member_user_id).first()
    if not user:
        raise HTTPException(status_code=400, detail="User does not exist")

    existing = db.query(models.Member).filter(
        models.Member.member_user_id == member.member_user_id
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Member profile already exists for this user")

    db_member = models.Member(
        member_user_id=member.member_user_id,
        house_rules=member.house_rules,
        dependent_description=member.dependent_description
    )
    db.add(db_member)
    db.commit()
    db.refresh(db_member)

    if member.address:
        db_address = models.Address(
            member_user_id=db_member.member_user_id,
            house_number=member.address.house_number,
            street=member.address.street,
            town=member.address.town
        )
        db.add(db_address)
        db.commit()
        db.refresh(db_address)

    return db_member

@app.get("/members/", response_model=list[schemas.MemberRead])
def list_members(db: Session = Depends(get_db)):
    return db.query(models.Member).all()

@app.get("/members/{member_user_id}/", response_model=schemas.MemberRead)
def get_member(member_user_id: int, db: Session = Depends(get_db)):
    m = db.query(models.Member).filter(
        models.Member.member_user_id == member_user_id
    ).first()
    if not m:
        raise HTTPException(status_code=404, detail="Member not found")
    return m

@app.put("/members/{member_user_id}/", response_model=schemas.MemberRead)
def update_member(member_user_id: int, data: schemas.MemberUpdate, db: Session = Depends(get_db)):
    m = db.query(models.Member).filter(
        models.Member.member_user_id == member_user_id
    ).first()
    if not m:
        raise HTTPException(status_code=404, detail="Member not found")

    for field, value in data.dict(exclude_unset=True).items():
        if field != "address":
            setattr(m, field, value)

    if data.address:
        addr = db.query(models.Address).filter(
            models.Address.member_user_id == member_user_id
        ).first()

        if addr:
            for field, value in data.address.dict(exclude_unset=True).items():
                setattr(addr, field, value)
        else:
            new_addr = models.Address(
                member_user_id=member_user_id,
                **data.address.dict(exclude_unset=True)
            )
            db.add(new_addr)

    db.commit()
    db.refresh(m)
    return m

@app.delete("/members/{member_user_id}/")
def delete_member(member_user_id: int, db: Session = Depends(get_db)):
    m = db.query(models.Member).filter(
        models.Member.member_user_id == member_user_id
    ).first()
    if not m:
        raise HTTPException(status_code=404, detail="Member not found")

    db.delete(m)
    db.commit()
    return {"detail": "Member deleted"}

@app.post("/jobs/", response_model=schemas.JobRead)
def create_job(job: schemas.JobCreate, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(
        models.Member.member_user_id == job.member_user_id
    ).first()
    if not member:
        raise HTTPException(status_code=400, detail="Member does not exist")

    db_job = models.Job(
        member_user_id=job.member_user_id,
        required_caregiving_type=job.required_caregiving_type,
        other_requirements=job.other_requirements,
        date_posted=job.date_posted or date.today()
    )
    db.add(db_job)
    db.commit()
    db.refresh(db_job)
    return db_job

@app.get("/jobs/", response_model=list[schemas.JobRead])
def list_jobs(db: Session = Depends(get_db)):
    return db.query(models.Job).all()

@app.get("/jobs/{job_id}/", response_model=schemas.JobRead)
def get_job(job_id: int, db: Session = Depends(get_db)):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    return job

@app.put("/jobs/{job_id}/", response_model=schemas.JobRead)
def update_job(job_id: int, data: schemas.JobUpdate, db: Session = Depends(get_db)):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    for field, value in data.dict(exclude_unset=True).items():
        setattr(job, field, value)

    db.commit()
    db.refresh(job)
    return job


@app.delete("/jobs/{job_id}/")
def delete_job(job_id: int, db: Session = Depends(get_db)):
    job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    db.delete(job)
    db.commit()
    return {"detail": "Job deleted"}


@app.post("/job_applications/", response_model=schemas.JobApplicationRead)
def create_job_application(app_data: schemas.JobApplicationCreate, db: Session = Depends(get_db)):
    cg = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == app_data.caregiver_user_id
    ).first()
    if not cg:
        raise HTTPException(status_code=400, detail="Caregiver does not exist")

    job = db.query(models.Job).filter(
        models.Job.job_id == app_data.job_id
    ).first()
    if not job:
        raise HTTPException(status_code=400, detail="Job does not exist")

    existing = db.query(models.JobApplication).filter(
        models.JobApplication.caregiver_user_id == app_data.caregiver_user_id,
        models.JobApplication.job_id == app_data.job_id
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Already applied to this job")

    db_app = models.JobApplication(
        caregiver_user_id=app_data.caregiver_user_id,
        job_id=app_data.job_id,
        date_applied=app_data.date_applied or date.today()
    )

    db.add(db_app)
    db.commit()
    db.refresh(db_app)
    return db_app

@app.get("/job_applications/", response_model=list[schemas.JobApplicationRead])
def list_job_applications(db: Session = Depends(get_db)):
    return db.query(models.JobApplication).all()

@app.get("/job_applications/{caregiver_user_id}/{job_id}/", response_model=schemas.JobApplicationRead)
def get_job_application(caregiver_user_id: int, job_id: int, db: Session = Depends(get_db)):
    app = db.query(models.JobApplication).filter(
        models.JobApplication.caregiver_user_id == caregiver_user_id,
        models.JobApplication.job_id == job_id
    ).first()
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    return app

@app.put("/job_applications/{caregiver_user_id}/{job_id}/", response_model=schemas.JobApplicationRead)
def update_job_application(caregiver_user_id: int, job_id: int, data: schemas.JobApplicationUpdate,
                           db: Session = Depends(get_db)):
    app = db.query(models.JobApplication).filter(
        models.JobApplication.caregiver_user_id == caregiver_user_id,
        models.JobApplication.job_id == job_id
    ).first()
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")

    for field, value in data.dict(exclude_unset=True).items():
        setattr(app, field, value)

    db.commit()
    db.refresh(app)
    return app

@app.delete("/job_applications/{caregiver_user_id}/{job_id}/")
def delete_job_application(caregiver_user_id: int, job_id: int, db: Session = Depends(get_db)):
    app = db.query(models.JobApplication).filter(
        models.JobApplication.caregiver_user_id == caregiver_user_id,
        models.JobApplication.job_id == job_id
    ).first()
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")

    db.delete(app)
    db.commit()
    return {"detail": "Job application deleted"}


@app.post("/appointments/", response_model=schemas.AppointmentRead)
def create_appointment(ap: schemas.AppointmentCreate, db: Session = Depends(get_db)):
    cg = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == ap.caregiver_user_id
    ).first()
    if not cg:
        raise HTTPException(status_code=400, detail="Caregiver does not exist")

    mem = db.query(models.Member).filter(
        models.Member.member_user_id == ap.member_user_id
    ).first()
    if not mem:
        raise HTTPException(status_code=400, detail="Member does not exist")

    db_ap = models.Appointment(
        caregiver_user_id=ap.caregiver_user_id,
        member_user_id=ap.member_user_id,
        appointment_date=ap.appointment_date,
        appointment_time=ap.appointment_time,
        work_hours=ap.work_hours,
        status=ap.status
    )

    db.add(db_ap)
    db.commit()
    db.refresh(db_ap)
    return db_ap

@app.get("/appointments/", response_model=list[schemas.AppointmentRead])
def list_appointments(db: Session = Depends(get_db)):
    return db.query(models.Appointment).all()

@app.get("/appointments/{appointment_id}/", response_model=schemas.AppointmentRead)
def get_appointment(appointment_id: int, db: Session = Depends(get_db)):
    ap = db.query(models.Appointment).filter(
        models.Appointment.appointment_id == appointment_id
    ).first()
    if not ap:
        raise HTTPException(status_code=404, detail="Appointment not found")
    return ap

@app.put("/appointments/{appointment_id}/", response_model=schemas.AppointmentRead)
def update_appointment(appointment_id: int, data: schemas.AppointmentUpdate, db: Session = Depends(get_db)):
    ap = db.query(models.Appointment).filter(
        models.Appointment.appointment_id == appointment_id
    ).first()
    if not ap:
        raise HTTPException(status_code=404, detail="Appointment not found")

    for field, value in data.dict(exclude_unset=True).items():
        setattr(ap, field, value)

    db.commit()
    db.refresh(ap)
    return ap

@app.delete("/appointments/{appointment_id}/")
def delete_appointment(appointment_id: int, db: Session = Depends(get_db)):
    ap = db.query(models.Appointment).filter(
        models.Appointment.appointment_id == appointment_id
    ).first()
    if not ap:
        raise HTTPException(status_code=404, detail="Appointment not found")

    db.delete(ap)
    db.commit()
    return {"detail": "Appointment deleted"}

app.mount("/", StaticFiles(directory="static", html=True), name="static")
