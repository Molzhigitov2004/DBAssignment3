from pydantic import BaseModel, EmailStr
from datetime import date, time

class UserBase(BaseModel):
    email: EmailStr
    given_name: str | None = None
    surname: str | None = None
    city: str | None = None
    phone_number: str | None = None
    profile_description: str | None = None

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    given_name: str | None = None
    surname: str | None = None
    city: str | None = None
    phone_number: str | None = None
    profile_description: str | None = None

class UserRead(UserBase):
    user_id: int

    class Config:
        orm_mode = True


class CaregiverBase(BaseModel):
    caregiver_user_id: int
    gender: str | None = None
    caregiving_type: str | None = None
    hourly_rate: float | None = None

class CaregiverCreate(CaregiverBase):
    pass

class CaregiverUpdate(BaseModel):
    gender: str | None = None
    caregiving_type: str | None = None
    hourly_rate: float | None = None

class CaregiverRead(CaregiverBase):
    class Config:
        orm_mode = True


class AddressBase(BaseModel):
    house_number: str | None = None
    street: str | None = None
    town: str | None = None

class AddressCreate(AddressBase):
    pass

class AddressRead(AddressBase):
    class Config:
        orm_mode = True


class MemberBase(BaseModel):
    member_user_id: int
    house_rules: str | None = None
    dependent_description: str | None = None

class MemberCreate(MemberBase):
    address: AddressCreate | None = None

class MemberUpdate(BaseModel):
    house_rules: str | None = None
    dependent_description: str | None = None
    address: AddressCreate | None = None

class MemberRead(MemberBase):
    address: AddressRead | None = None

    class Config:
        orm_mode = True


class JobBase(BaseModel):
    member_user_id: int
    required_caregiving_type: str | None = None
    other_requirements: str | None = None
    date_posted: date | None = None

class JobCreate(JobBase):
    pass

class JobUpdate(BaseModel):
    required_caregiving_type: str | None = None
    other_requirements: str | None = None
    date_posted: date | None = None

class JobRead(JobBase):
    job_id: int

    class Config:
        orm_mode = True


class JobApplicationBase(BaseModel):
    caregiver_user_id: int
    job_id: int
    date_applied: date | None = None

class JobApplicationCreate(JobApplicationBase):
    pass

class JobApplicationUpdate(BaseModel):
    date_applied: date | None = None

class JobApplicationRead(JobApplicationBase):
    class Config:
        orm_mode = True


class AppointmentBase(BaseModel):
    caregiver_user_id: int
    member_user_id: int
    appointment_date: date | None = None
    appointment_time: time | None = None
    work_hours: int | None = None
    status: str | None = None

class AppointmentCreate(AppointmentBase):
    pass

class AppointmentUpdate(BaseModel):
    appointment_date: date | None = None
    appointment_time: time | None = None
    work_hours: int | None = None
    status: str | None = None

class AppointmentRead(AppointmentBase):
    appointment_id: int

    class Config:
        orm_mode = True
