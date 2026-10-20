package repository

import (
	"fashionhub-backend/internal/model"

	"gorm.io/gorm"
)

type OrderRepository struct {
	db *gorm.DB
}

func NewOrderRepository(db *gorm.DB) *OrderRepository {
	return &OrderRepository{db: db}
}

func (r *OrderRepository) CreateOrderWithItems(order *model.Order, sessionID string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(order).Error; err != nil {
			return err
		}
		if sessionID != "" {
			if err := tx.Where("session_id = ?", sessionID).Delete(&model.CartItem{}).Error; err != nil {
				return err
			}
		}
		return nil
	})
}

func (r *OrderRepository) CountOrdersToday(datePrefix string) (int64, error) {
	var count int64
	err := r.db.Model(&model.Order{}).
		Where("invoice_number LIKE ?", "INV-"+datePrefix+"-%").
		Count(&count).Error
	return count, err
}
