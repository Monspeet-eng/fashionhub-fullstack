package handler

import (
	"net/http"
	"strconv"

	"fashionhub-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type CartHandler struct {
	service *service.CartService
}

func NewCartHandler(service *service.CartService) *CartHandler {
	return &CartHandler{service: service}
}

func getSessionID(c *gin.Context) string {
	sessionID := c.GetHeader("X-Session-ID")
	if sessionID == "" {
		sessionID = c.Query("session_id")
	}
	if sessionID == "" {
		sessionID = "guest-session-default"
	}
	return sessionID
}

type addToCartRequest struct {
	ProductID uint `json:"product_id" binding:"required"`
	Quantity  int  `json:"quantity"`
}

type updateCartRequest struct {
	Quantity int `json:"quantity" binding:"required"`
}

// GET /api/v1/cart
func (h *CartHandler) GetCart(c *gin.Context) {
	sessionID := getSessionID(c)
	cart, err := h.service.GetCart(sessionID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Gagal memuat keranjang belanja",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"data":    cart,
	})
}

// POST /api/v1/cart
func (h *CartHandler) AddToCart(c *gin.Context) {
	sessionID := getSessionID(c)
	var req addToCartRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Payload tidak valid: product_id wajib diisi",
		})
		return
	}
	if req.Quantity <= 0 {
		req.Quantity = 1
	}

	cart, err := h.service.AddToCart(sessionID, req.ProductID, req.Quantity)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Produk berhasil ditambahkan ke keranjang",
		"data":    cart,
	})
}

// PUT /api/v1/cart/:id
func (h *CartHandler) UpdateCartItem(c *gin.Context) {
	sessionID := getSessionID(c)
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "ID item keranjang tidak valid",
		})
		return
	}

	var req updateCartRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Kuantitas wajib diisi",
		})
		return
	}

	cart, err := h.service.UpdateQuantity(sessionID, uint(id), req.Quantity)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Kuantitas keranjang diperbarui",
		"data":    cart,
	})
}

// DELETE /api/v1/cart/:id
func (h *CartHandler) DeleteCartItem(c *gin.Context) {
	sessionID := getSessionID(c)
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "ID item keranjang tidak valid",
		})
		return
	}

	cart, err := h.service.RemoveItem(sessionID, uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"message": "Gagal menghapus item dari keranjang",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Item berhasil dihapus dari keranjang",
		"data":    cart,
	})
}
