package repository

import (
	"strings"

	"fashionhub-backend/internal/model"

	"gorm.io/gorm"
)

type ProductRepository struct {
	db *gorm.DB
}

func NewProductRepository(db *gorm.DB) *ProductRepository {
	return &ProductRepository{db: db}
}

func (r *ProductRepository) FindAll(category string, page, limit int, sort string) ([]model.Product, int64, error) {
	var products []model.Product
	var total int64

	query := r.db.Model(&model.Product{}).Preload("Category")

	if category != "" && strings.ToLower(category) != "all" {
		catLower := strings.ToLower(strings.TrimSpace(category))
		query = query.Joins("JOIN categories ON categories.id = products.category_id").
			Where("LOWER(categories.name) = ? OR LOWER(categories.slug) = ?", catLower, catLower)
	}

	if err := query.Count(&total).Error; err != nil {
		return nil, 0, err
	}

	switch sort {
	case "price_asc":
		query = query.Order("products.price ASC")
	case "price_desc":
		query = query.Order("products.price DESC")
	default:
		query = query.Order("products.id ASC")
	}

	offset := (page - 1) * limit
	if err := query.Offset(offset).Limit(limit).Find(&products).Error; err != nil {
		return nil, 0, err
	}

	return products, total, nil
}

func (r *ProductRepository) FindByID(id uint) (*model.Product, error) {
	var product model.Product
	if err := r.db.Preload("Category").First(&product, id).Error; err != nil {
		return nil, err
	}
	return &product, nil
}

func (r *ProductRepository) FindRelated(categoryID, excludeProductID uint, limit int) ([]model.Product, error) {
	var related []model.Product
	err := r.db.Preload("Category").
		Where("category_id = ? AND id <> ?", categoryID, excludeProductID).
		Limit(limit).
		Find(&related).Error
	return related, err
}
