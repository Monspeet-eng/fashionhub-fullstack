package service

import (
	"fmt"

	"fashionhub-backend/internal/model"
	"fashionhub-backend/internal/repository"
)

type ProductService struct {
	repo *repository.ProductRepository
}

func NewProductService(repo *repository.ProductRepository) *ProductService {
	return &ProductService{repo: repo}
}

type ProductListResponse struct {
	Products    []model.Product `json:"products"`
	Total       int64           `json:"total"`
	Page        int             `json:"page"`
	Limit       int             `json:"limit"`
	ShowingText string          `json:"showing_text"`
}

type ProductDetailResponse struct {
	Product         *model.Product  `json:"product"`
	RelatedProducts []model.Product `json:"related_products"`
}

func (s *ProductService) GetProducts(category string, page, limit int, sort string) (*ProductListResponse, error) {
	if page < 1 {
		page = 1
	}
	if limit < 1 || limit > 100 {
		limit = 24
	}

	products, total, err := s.repo.FindAll(category, page, limit, sort)
	if err != nil {
		return nil, err
	}

	start := (page-1)*limit + 1
	end := start + len(products) - 1
	if total == 0 || len(products) == 0 {
		start = 0
		end = 0
	}

	showingText := fmt.Sprintf("Showing %d - %d of %d results", start, end, total)

	return &ProductListResponse{
		Products:    products,
		Total:       total,
		Page:        page,
		Limit:       limit,
		ShowingText: showingText,
	}, nil
}

func (s *ProductService) GetProductByID(id uint) (*ProductDetailResponse, error) {
	product, err := s.repo.FindByID(id)
	if err != nil {
		return nil, err
	}

	related, err := s.repo.FindRelated(product.CategoryID, product.ID, 4)
	if err != nil {
		related = []model.Product{}
	}

	return &ProductDetailResponse{
		Product:         product,
		RelatedProducts: related,
	}, nil
}
