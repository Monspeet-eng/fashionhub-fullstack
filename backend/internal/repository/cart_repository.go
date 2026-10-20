package repository

import (
	"fashionhub-backend/internal/model"

	"gorm.io/gorm"
)

type CartRepository struct {
	db *gorm.DB
}

func NewCartRepository(db *gorm.DB) *CartRepository {
	return &CartRepository{db: db}
}

func (r *CartRepository) FindBySession(sessionID string) ([]model.CartItem, error) {
	var items []model.CartItem
	err := r.db.Preload("Product.Category").
		Where("session_id = ?", sessionID).
		Order("id ASC").
		Find(&items).Error
	return items, err
}

func (r *CartRepository) FindItem(sessionID string, productID uint) (*model.CartItem, error) {
	var item model.CartItem
	err := r.db.Where("session_id = ? AND product_id = ?", sessionID, productID).First(&item).Error
	if err != nil {
		return nil, err
	}
	return &item, nil
}

func (r *CartRepository) FindByID(id uint, sessionID string) (*model.CartItem, error) {
	var item model.CartItem
	query := r.db.Preload("Product.Category").Where("id = ?", id)
	if sessionID != "" {
		query = query.Where("session_id = ?", sessionID)
	}
	if err := query.First(&item).Error; err != nil {
		return nil, err
	}
	return &item, nil
}

func (r *CartRepository) Create(item *model.CartItem) error {
	return r.db.Create(item).Error
}

func (r *CartRepository) Update(item *model.CartItem) error {
	return r.db.Save(item).Error
}

func (r *CartRepository) Delete(id uint, sessionID string) error {
	query := r.db.Where("id = ?", id)
	if sessionID != "" {
		query = query.Where("session_id = ?", sessionID)
	}
	return query.Delete(&model.CartItem{}).Error
}

func (r *CartRepository) ClearSessionCart(sessionID string) error {
	return r.db.Where("session_id = ?", sessionID).Delete(&model.CartItem{}).Error
}
