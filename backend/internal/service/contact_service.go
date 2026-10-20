package service

import (
	"fashionhub-backend/internal/model"
	"fashionhub-backend/internal/repository"
)

type ContactService struct {
	repo *repository.ContactRepository
}

func NewContactService(repo *repository.ContactRepository) *ContactService {
	return &ContactService{repo: repo}
}

type ContactRequest struct {
	Name    string `json:"name" binding:"required"`
	Email   string `json:"email" binding:"required,email"`
	Phone   string `json:"phone"`
	Message string `json:"message" binding:"required"`
}

func (s *ContactService) SubmitMessage(req *ContactRequest) (*model.ContactMessage, error) {
	msg := &model.ContactMessage{
		Name:    req.Name,
		Email:   req.Email,
		Phone:   req.Phone,
		Message: req.Message,
	}
	if err := s.repo.Create(msg); err != nil {
		return nil, err
	}
	return msg, nil
}
