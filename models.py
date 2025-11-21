from sqlalchemy import (
    Column, Integer, String, Text, Date, Time, DECIMAL, ForeignKey
)
from sqlalchemy.orm import relationship
from database import Base


class User(Base):
    __tablename__ = "USER"

    user_id = Column(Integer, primary_key=True, index=True)
    email = Column(String(100), unique=True, nullable=False)
    given_name = Column(String(50))
    surname = Column(String(50))
    city = Column(String(50))
    phone_number = Column(String(20))
    profile_description = Column(Text)
    password = Column(String(100))

    caregiver = relationship(
    "Caregiver",
    back_populates="user",
    uselist=False,
    passive_deletes=True
    )

    member = relationship(
    "Member",
    back_populates="user",
    uselist=False,
    passive_deletes=True
    )

class Caregiver(Base):
    __tablename__ = "caregiver"

    caregiver_user_id = Column(Integer, ForeignKey("USER.user_id"), primary_key=True)
    gender = Column(String(10))
    caregiving_type = Column(String(50))
    hourly_rate = Column(DECIMAL(10, 2))

    user = relationship("User", back_populates="caregiver", passive_deletes=True)

class Member(Base):
    __tablename__ = "member"

    member_user_id = Column(Integer, ForeignKey("USER.user_id"), primary_key=True)
    house_rules = Column(Text)
    dependent_description = Column(Text)

    user = relationship("User", back_populates="member", passive_deletes=True)
    address = relationship("Address", back_populates="member", uselist=False, passive_deletes=True)

class Address(Base):
    __tablename__ = "address"

    member_user_id = Column(Integer, ForeignKey("member.member_user_id"), primary_key=True)
    house_number = Column(String(20))
    street = Column(String(100))
    town = Column(String(50))

    member = relationship("Member", back_populates="address", passive_deletes=True)

class Job(Base):
    __tablename__ = "job"

    job_id = Column(Integer, primary_key=True, index=True)
    member_user_id = Column(Integer, ForeignKey("member.member_user_id"))
    required_caregiving_type = Column(String(50))
    other_requirements = Column(Text)
    date_posted = Column(Date)

class JobApplication(Base):
    __tablename__ = "job_application"

    caregiver_user_id = Column(Integer, ForeignKey("caregiver.caregiver_user_id"), primary_key=True)
    job_id = Column(Integer, ForeignKey("job.job_id"), primary_key=True)
    date_applied = Column(Date)
    passive_deletes=True

class Appointment(Base):
    __tablename__ = "appointment"

    appointment_id = Column(Integer, primary_key=True, index=True)
    caregiver_user_id = Column(Integer, ForeignKey("caregiver.caregiver_user_id"))
    member_user_id = Column(Integer, ForeignKey("member.member_user_id"))
    appointment_date = Column(Date)
    appointment_time = Column(Time)
    work_hours = Column(Integer)
    status = Column(String(20))
