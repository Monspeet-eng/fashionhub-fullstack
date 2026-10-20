package service

import (
	"errors"

	"fashionhub-backend/internal/model"
	"fashionhub-backend/internal/repository"
)

type CartService struct {
	cartRepo    *repository.CartRepository
	productRepo *repository.ProductRepository
}

func NewCartService(cartRepo *repository.CartRepository, productRepo *repository.ProductRepository) *CartService {
	return &CartService{
		cartRepo:    cartRepo,
		productRepo: productRepo,
	}
}

type CartSummaryResponse struct {
	Items        []model.CartItem `json:"items"`
	TotalItems   int              `json:"total_items"`
	Subtotal     int64            `json:"subtotal"`
	FreeShipping bool             `json:"free_shipping"`
}

func (s *CartService) GetCart(sessionID string) (*CartSummaryResponse, error) {
	items, err := s.cartRepo.FindBySession(sessionID)
	if err != nil {
		return nil, err
	}

	var totalItems int
	var subtotal int64

	for i := range items {
		items[i].Subtotal = items[i].Product.Price * int64(items[i].Quantity)
		totalItems += items[i].Quantity
		subtotal += items[i].Subtotal
	}

	return &CartSummaryResponse{
		Items:        items,
		TotalItems:   totalItems,
		Subtotal:     subtotal,
		FreeShipping: true,
	}, nil
}

func (s *CartService) AddToCart(sessionID string, productID uint, quantity int) (*CartSummaryResponse, error) {
	if quantity < 1 {
		quantity = 1
	}

	product, err := s.productRepo.FindByID(productID)
	if err != nil {
		return nil, errors.New("produk tidak ditemukan")
	}

	existing, err := s.cartRepo.FindItem(sessionID, product.ID)
	if err == nil && existing != nil {
		existing.Quantity += quantity
		if err := s.cartRepo.Update(existing); err != nil {
			return nil, err
		}
	} else {
		newItem := &model.CartItem{
			SessionID: sessionID,
			ProductID: product.ID,
			Quantity:  quantity,
		}
		if err := s.cartRepo.Create(newItem); err != nil {
			return nil, err
		}
	}

	return s.GetCart(sessionID)
}

func (s *CartService) UpdateQuantity(sessionID string, cartItemID uint, quantity int) (*CartSummaryResponse, error) {
	item, err := s.cartRepo.FindByID(cartItemID, sessionID)
	if err != nil {
		return nil, errors.New("item keranjang tidak ditemukan")
	}

	if quantity <= 0 {
		if err := s.cartRepo.Delete(cartItemID, sessionID); err != nil {
			return nil, err
		}
		return s.GetCart(sessionID)
	}

	item.Quantity = quantity
	if err := s.cartRepo.Update(item); err != nil {
		return nil, err
	}

	return s.GetCart(sessionID)
}

func (s *CartService) RemoveItem(sessionID string, cartItemID uint) (*CartSummaryResponse, error) {
	if err := s.cartRepo.Delete(cartItemID, sessionID); err != nil {
		return nil, err
	}
	return s.GetCart(sessionID)
}
