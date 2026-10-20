package handler

import (
	"net/http"

	"fashionhub-backend/internal/service"

	"github.com/gin-gonic/gin"
)

type CheckoutHandler struct {
	service *service.CheckoutService
}

func NewCheckoutHandler(service *service.CheckoutService) *CheckoutHandler {
	return &CheckoutHandler{service: service}
}

// POST /api/v1/checkout
func (h *CheckoutHandler) Checkout(c *gin.Context) {
	sessionID := getSessionID(c)

	var req service.CheckoutRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "Mohon lengkapi seluruh data pemesan, pengiriman, dan pembayaran",
			"error":   err.Error(),
		})
		return
	}

	invoice, err := h.service.ProcessCheckout(sessionID, &req)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Payment successful",
		"data":    invoice,
	})
}
