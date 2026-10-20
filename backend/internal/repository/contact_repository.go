package repository

import (
	"fashionhub-backend/internal/model"

	"gorm.io/gorm"
)

type ContactRepository struct {
	db *gorm.DB
}

func NewContactRepository(db *gorm.DB) *ContactRepository {
	return &ContactRepository{db: db}
}

func (r *ContactRepository) Create(msg *model.ContactMessage) error {
	return r.db.Create(msg).Error
}
